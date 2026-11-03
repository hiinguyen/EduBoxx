import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:video_player/video_player.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../app/app_scope.dart';
import '../../contract/backend_result.dart';
import '../../features/learning/learning_ui.dart';
import '../../shell/block_states.dart';
import '../../theme/tokens.dart';
import 'video_controller.dart';

/// The e-book reader: a receded 56dp bar with the back action and the title,
/// the PDF filling the canvas, and a page indicator in mono.
class EbookReaderScreen extends StatefulWidget {
  const EbookReaderScreen({
    super.key,
    required this.contentId,
    required this.title,
    this.knownPageCount,
  });

  final int contentId;
  final String title;
  final int? knownPageCount;

  @override
  State<EbookReaderScreen> createState() => _EbookReaderScreenState();
}

class _EbookReaderScreenState extends State<EbookReaderScreen> {
  String? _path;
  String? _url;
  BackendError? _error;
  bool _loading = true;
  int? _page;
  int? _total;

  @override
  void initState() {
    super.initState();
    _total = widget.knownPageCount;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_load());
    });
  }

  Future<void> _load() async {
    final backend = AppScope.of(context).services.backend;
    final local = await backend.content.localPath(widget.contentId);
    if (local != null) {
      if (!mounted) return;
      setState(() {
        _path = local;
        _loading = false;
      });
      return;
    }
    if (!kIsWeb) {
      final result = await backend.content.download(widget.contentId);
      if (!mounted) return;
      if (result.isOk) {
        setState(() {
          _path = result.valueOrNull;
          _loading = false;
        });
        return;
      }
    }
    // Browser builds stream the signed URL instead of writing a file.
    final signed = await backend.content.fileUrl(widget.contentId);
    if (!mounted) return;
    setState(() {
      _url = signed.valueOrNull?.url;
      _error = signed.errorOrNull;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        title: Text(widget.title),
        actions: [
          if (_path != null || _url != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: EduSpace.s16),
              child: Center(
                child: Text(
                  l10n.ebookPageIndicator(_page ?? 1, _total ?? 1),
                  style: TextStyle(
                    fontFamily: 'IBMPlexMono',
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _body(l10n),
    );
  }

  Widget _body(AppLocalizations l10n) {
    if (_loading) {
      return Center(child: Text(l10n.ebookLoading));
    }
    if (_path == null && _url == null) {
      return Padding(
        padding: const EdgeInsets.all(EduSpace.s24),
        child: BlockMessage(
          tone: BlockTone.offline,
          message: _error is BackendUnreachableError
              ? l10n.contentNeedsInternet
              : l10n.ebookError,
          action: _error is BackendUnreachableError
              ? null
              : RetryButton(onPressed: () => unawaited(_load())),
        ),
      );
    }
    final params = PdfViewerParams(
      backgroundColor: Theme.of(context).colorScheme.surface,
      onPageChanged: (page) {
        if (!mounted) return;
        setState(() => _page = page);
      },
      onViewerReady: (document, controller) {
        if (!mounted) return;
        setState(() {
          _page = controller.pageNumber;
          _total = document.pages.length;
        });
      },
    );
    if (_path != null) {
      return PdfViewer.file(_path!, params: params);
    }
    return PdfViewer.uri(Uri.parse(_url!), params: params);
  }
}

/// Placeholder type kept so `ContentViewerScreen` can name it without
/// pulling video code into reader tests.
class VideoLessonScreen extends StatefulWidget {
  const VideoLessonScreen({
    super.key,
    required this.contentId,
    required this.title,
  });

  final int contentId;
  final String title;

  @override
  State<VideoLessonScreen> createState() => _VideoLessonScreenState();
}

class _VideoLessonScreenState extends State<VideoLessonScreen> {
  String? _path;
  Uri? _url;
  BackendError? _error;
  bool _loading = true;
  bool _playing = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  Timer? _timer;
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_load());
    });
  }

  Future<void> _load() async {
    final backend = AppScope.of(context).services.backend;
    final path = await backend.content.localPath(widget.contentId);
    if (path != null) {
      if (!mounted) return;
      setState(() {
        _path = path;
        _loading = false;
      });
      return;
    }
    final result = await backend.content.fileUrl(widget.contentId);
    if (!mounted) return;
    setState(() {
      _url = result.valueOrNull == null
          ? null
          : Uri.tryParse(result.valueOrNull!.url);
      _error = result.errorOrNull;
      _loading = false;
    });
  }

  Future<void> _startPlayback() async {
    final controller = _controller;
    if (controller == null) return;
    await controller.initialize();
    _duration = controller.value.duration;
    _timer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (!mounted) return;
      setState(() => _position = controller.value.position);
    });
    await controller.play();
    setState(() => _playing = true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), toolbarHeight: 56),
      body: _loading
          ? Center(child: Text(l10n.videoLoading))
          : _path == null && _url == null
          ? Padding(
              padding: const EdgeInsets.all(EduSpace.s24),
              child: BlockMessage(
                tone: BlockTone.offline,
                message: _error is BackendUnreachableError
                    ? l10n.contentNeedsInternet
                    : l10n.videoError,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: Center(
                    child: _controller == null
                        ? FilledButton(
                            onPressed: () async {
                              final controller = createVideoController(
                                localPath: _path,
                                networkUrl: _url!,
                              );
                              _controller = controller;
                              await _startPlayback();
                            },
                            child: Text(l10n.videoPlay),
                          )
                        : AspectRatio(
                            aspectRatio: 16 / 9,
                            child: VideoPlayer(_controller!),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(EduSpace.s16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _controller == null
                            ? null
                            : () async {
                                if (_playing) {
                                  await _controller!.pause();
                                } else {
                                  await _controller!.play();
                                }
                                setState(() => _playing = !_playing);
                              },
                        icon: Icon(
                          _playing ? Icons.pause : Icons.play_arrow,
                        ),
                        tooltip: _playing ? l10n.videoPause : l10n.videoPlay,
                      ),
                      Text(
                        l10n.videoPosition(
                          learningDuration(_position),
                          learningDuration(_duration),
                        ),
                        style: const TextStyle(
                          fontFamily: 'IBMPlexMono',
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
