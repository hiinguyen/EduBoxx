import 'dart:async';

import 'package:edubox_client/edubox_client.dart'
    show ContentDetail, ContentType;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../app/app_scope.dart';
import '../../contract/backend_result.dart';
import '../../features/learning/learning_ui.dart';
import '../../shell/block_states.dart';
import '../../theme/theme_extensions.dart';
import '../../theme/tokens.dart';
import '../content/content_viewer_screen.dart';

/// Opens the student content detail from any catalogue row.
void openStudentContent(BuildContext context, int contentId) {
  Navigator.of(context).push<void>(
    MaterialPageRoute(
      builder: (_) => StudentContentDetailScreen(contentId: contentId),
    ),
  );
}

/// `student-content-detail`: can I open this now, here? The title, cover,
/// availability stamp and one open action; download progress replaces the
/// stamp while a file is coming down.
class StudentContentDetailScreen extends StatefulWidget {
  const StudentContentDetailScreen({super.key, required this.contentId});

  final int contentId;

  @override
  State<StudentContentDetailScreen> createState() =>
      _StudentContentDetailScreenState();
}

class _StudentContentDetailScreenState
    extends State<StudentContentDetailScreen> {
  ContentDetail? _detail;
  BackendError? _error;
  bool _downloading = false;
  bool _downloaded = false;
  String? _downloadError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_load());
    });
  }

  Future<void> _load() async {
    final backend = AppScope.of(context).services.backend;
    final result = await backend.content.detail(widget.contentId);
    final downloaded = await backend.content.isDownloaded(widget.contentId);
    if (!mounted) return;
    setState(() {
      _detail = result.valueOrNull;
      _error = result.errorOrNull;
      _downloaded = downloaded;
    });
  }

  Future<void> _download() async {
    final l10n = AppLocalizations.of(context);
    final backend = AppScope.of(context).services.backend;
    setState(() {
      _downloading = true;
      _downloadError = null;
    });
    final result = await backend.content.download(widget.contentId);
    if (!mounted) return;
    setState(() {
      _downloading = false;
      _downloaded = result.isOk;
      _downloadError = result.isOk ? null : l10n.contentDownloadFailed;
    });
  }

  void _open(ContentDetail detail) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => ContentViewerScreen(
          contentId: detail.id,
          title: detail.title,
          type: detail.type,
          pageCount: detail.pageCount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final detail = _detail;
    return Scaffold(
      appBar: AppBar(title: Text(detail?.title ?? l10n.contentDetailLoading)),
      body: LearningPage(
        title: detail?.title ?? l10n.contentDetailLoading,
        children: [
          if (detail == null && _error == null)
            const LearningPanel(child: SkeletonBar(width: double.infinity))
          else if (detail == null)
            BlockMessage(
              tone: _error is BackendUnreachableError
                  ? BlockTone.offline
                  : BlockTone.error,
              message: _error is BackendUnreachableError
                  ? l10n.contentDetailOffline
                  : l10n.contentDetailError,
              action: _error is BackendUnreachableError
                  ? null
                  : RetryButton(onPressed: () => unawaited(_load())),
            )
          else ...[
            LearningPanel(
              title: l10n.contentFileInfo,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    spacing: EduSpace.s8,
                    runSpacing: EduSpace.s8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        _typeLabel(l10n, detail.type),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      if (_downloaded)
                        StatusStamp(
                          label: l10n.contentAvailableOffline,
                          tone: StatusTone.positive,
                          icon: Icons.download_done,
                        ),
                      if (!detail.hasFile)
                        StatusStamp(label: l10n.contentFileUnavailable),
                    ],
                  ),
                  if (detail.pageCount != null) ...[
                    const SizedBox(height: EduSpace.s8),
                    Text(
                      l10n.contentPageCount(detail.pageCount!),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: EduPalette.of(context).muted,
                      ),
                    ),
                  ],
                  if (detail.durationSeconds != null) ...[
                    const SizedBox(height: EduSpace.s8),
                    Text(
                      l10n.videoDuration(
                        learningDuration(
                          Duration(seconds: detail.durationSeconds!),
                        ),
                      ),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: EduPalette.of(context).muted,
                      ),
                    ),
                  ],
                  if (_downloadError != null) ...[
                    const SizedBox(height: EduSpace.s16),
                    BlockMessage(
                      tone: BlockTone.error,
                      message: _downloadError!,
                      action: RetryButton(
                        onPressed: () => unawaited(_download()),
                      ),
                    ),
                  ],
                  const SizedBox(height: EduSpace.s24),
                  if (detail.type != ContentType.exercise && detail.hasFile)
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: () => _open(detail),
                            child: Text(l10n.contentOpen),
                          ),
                        ),
                        const SizedBox(width: EduSpace.s12),
                        if (!kIsWeb)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _downloading
                                  ? null
                                  : () => unawaited(_download()),
                              child: _downloading
                                  ? BusyLabel(
                                      label: l10n.contentDownloadingSimple,
                                    )
                                  : Text(
                                      _downloaded
                                          ? l10n.contentDownloaded
                                          : l10n.contentDownload,
                                    ),
                            ),
                          ),
                      ],
                    )
                  else if (!detail.hasFile)
                    Text(l10n.contentNeedsInternet)
                  else
                    Text(
                      l10n.contentTypeExercise,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _typeLabel(AppLocalizations l10n, ContentType type) =>
      switch (type) {
        ContentType.ebook => l10n.contentTypeEbook,
        ContentType.video => l10n.contentTypeVideo,
        ContentType.exercise => l10n.contentTypeExercise,
      };
}
