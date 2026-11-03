import 'dart:async';

import 'package:edubox_client/edubox_client.dart'
    show
        ClassSummary,
        ContentDetail,
        ContentType,
        IngestStatus,
        TeacherContentItem;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../app/app_scope.dart';
import '../../app/loadable.dart';
import '../../contract/backend_result.dart';
import '../../features/learning/learning_ui.dart';
import '../../shell/block_states.dart';
import '../../theme/theme_extensions.dart';
import '../../theme/tokens.dart';
import '../content/content_viewer_screen.dart';

abstract final class TeacherContentKeys {
  static const screen = Key('screen.teacherContent');
  static const upload = Key('teacherContent.upload');
  static const list = Key('teacherContent.list');
}

class TeacherContentScreen extends StatefulWidget {
  const TeacherContentScreen({super.key});

  @override
  State<TeacherContentScreen> createState() => _TeacherContentScreenState();
}

class _TeacherContentScreenState extends State<TeacherContentScreen> {
  Loadable<List<TeacherContentItem>>? _content;
  late AppScope _scope;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scope = AppScope.of(context);
    if (_content == null) {
      final content = Loadable<List<TeacherContentItem>>(
        _scope.services.backend.content.teacherList,
      )..addListener(_onContent);
      _content = content;
      _scope.connectivity.register(content.load);
      unawaited(content.load());
    }
  }

  void _onContent() {
    if (_content!.error is SessionExpiredError) {
      unawaited(_scope.session.expire());
    }
  }

  @override
  void dispose() {
    final content = _content!;
    _scope.connectivity.unregister(content.load);
    content
      ..removeListener(_onContent)
      ..dispose();
    super.dispose();
  }

  Future<void> _openUpload() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => const TeacherContentUploadScreen()),
    );
    if (mounted) unawaited(_content!.load());
  }

  Future<void> _approve(TeacherContentItem item) async {
    final l10n = AppLocalizations.of(context);
    final result = await _scope.services.backend.content.approve(item.id);
    if (!mounted) return;
    if (result.isOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.teacherContentApprovedSnack)),
      );
      unawaited(_content!.load());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.contentDetailError)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final content = _content!;
    return ListenableBuilder(
      listenable: content,
      builder: (context, _) {
        final value = content.value;
        return LearningPage(
          key: TeacherContentKeys.screen,
          title: l10n.teacherContentTitle,
          capped: false,
          action: FilledButton.icon(
            key: TeacherContentKeys.upload,
            onPressed: _openUpload,
            icon: const Icon(Icons.upload_file_outlined),
            label: Text(l10n.teacherContentUpload),
          ),
          subtitle: value == null ? null : l10n.libraryTotal(value.length),
          children: [
            if (value == null && content.error == null)
              _Loading()
            else if (value == null)
              _Error(
                error: content.error,
                onRetry: content.load,
              )
            else if (value.isEmpty)
              EmptySentence(l10n.teacherContentEmpty)
            else
              LearningPanel(
                title: l10n.teacherContentTitle,
                child: Column(
                  key: TeacherContentKeys.list,
                  children: [
                    for (final item in value)
                      _TeacherContentRow(
                        item: item,
                        onApprove: () => _approve(item),
                        onOpen: () => Navigator.of(context).push<void>(
                          MaterialPageRoute(
                            builder: (_) => TeacherContentDetailScreen(
                              contentId: item.id,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LearningPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < 4; i++)
            const Padding(
              padding: EdgeInsets.only(bottom: EduSpace.s16),
              child: SkeletonBar(width: double.infinity, height: 24),
            ),
        ],
      ),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.error, required this.onRetry});

  final BackendError? error;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (error is OfflineNoCacheError) {
      return BlockMessage(
        tone: BlockTone.offline,
        message: l10n.teacherContentOfflineNoData,
      );
    }
    return BlockMessage(
      tone: BlockTone.error,
      message: l10n.teacherContentError,
      action: RetryButton(onPressed: () => unawaited(onRetry())),
    );
  }
}

class _TeacherContentRow extends StatelessWidget {
  const _TeacherContentRow({
    required this.item,
    required this.onApprove,
    required this.onOpen,
  });

  final TeacherContentItem item;
  final VoidCallback onApprove;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = EduPalette.of(context);
    final text = Theme.of(context).textTheme;
    final ready = item.ingestStatus == IngestStatus.ready;
    final rejected = item.ingestStatus == IngestStatus.rejected;
    final canApprove = ready && item.status.name == 'draft';
    return InkWell(
      onTap: onOpen,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: EduSpace.s12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: text.titleSmall),
                      const SizedBox(height: 2),
                      Text(
                        [
                          _typeLabel(l10n, item.type),
                          if (item.classNames.isNotEmpty)
                            item.classNames.join(', '),
                          if (item.ingestStatus == IngestStatus.processing)
                            l10n.contentIngestProcessing,
                        ].join(' · '),
                        style: text.bodySmall!.copyWith(color: palette.muted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: EduSpace.s12),
                _ContentStatus(item: item),
              ],
            ),
            if (rejected && item.ingestReason != null) ...[
              const SizedBox(height: EduSpace.s8),
              BlockMessage(
                tone: BlockTone.error,
                message: l10n.contentUploadRejected(item.ingestReason!),
                action: TextButton(
                  onPressed: onOpen,
                  child: Text(l10n.contentReplaceFile),
                ),
              ),
            ],
            if (canApprove) ...[
              const SizedBox(height: EduSpace.s8),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: FilledButton(
                  onPressed: onApprove,
                  child: Text(l10n.teacherContentApprove),
                ),
              ),
            ],
            const Divider(height: EduSpace.s24, color: EduColors.rule),
          ],
        ),
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

class _ContentStatus extends StatelessWidget {
  const _ContentStatus({required this.item});

  final TeacherContentItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (item.ingestStatus) {
      IngestStatus.processing => StatusStamp(
        label: l10n.statusProcessing,
        icon: Icons.hourglass_empty,
      ),
      IngestStatus.rejected => StatusStamp(
        label: l10n.statusRejected,
        tone: StatusTone.negative,
        icon: Icons.error_outline,
      ),
      IngestStatus.ready =>
        item.status.name == 'approved'
            ? StatusStamp(
                label: l10n.statusApproved,
                tone: StatusTone.positive,
                icon: Icons.check,
              )
            : StatusStamp(
                label: l10n.statusAwaitingApproval,
                tone: StatusTone.notice,
              ),
    };
  }
}

class TeacherContentUploadScreen extends StatefulWidget {
  const TeacherContentUploadScreen({super.key});

  @override
  State<TeacherContentUploadScreen> createState() =>
      _TeacherContentUploadScreenState();
}

class _TeacherContentUploadScreenState
    extends State<TeacherContentUploadScreen> {
  final _title = TextEditingController();
  final _subject = TextEditingController();
  String? _fileName;
  List<int>? _bytes;
  ContentType? _type;
  ClassSummary? _class;
  List<ClassSummary>? _classes;
  bool _busy = false;
  String? _message;
  bool _rejected = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_loadClasses());
    });
  }

  Future<void> _loadClasses() async {
    final backend = AppScope.of(context).services.backend;
    final result = await backend.classes.mine();
    if (!mounted) return;
    setState(() => _classes = result.valueOrNull ?? const []);
  }

  @override
  void dispose() {
    _title.dispose();
    _subject.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final l10n = AppLocalizations.of(context);
    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'mp4'],
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      final extension = (file.extension ?? '').toLowerCase();
      if (extension != 'pdf' && extension != 'mp4') {
        setState(() {
          _message = l10n.contentUploadFileRequired;
          _rejected = true;
        });
        return;
      }
      setState(() {
        _fileName = file.name;
        _bytes = bytes;
        _type = extension == 'pdf' ? ContentType.ebook : ContentType.video;
        _message = null;
        _rejected = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _message = l10n.contentUploadFileRequired;
        _rejected = true;
      });
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final backend = AppScope.of(context).services.backend;
    final title = _title.text.trim();
    final subject = _subject.text.trim();
    if (_bytes == null || _fileName == null || _type == null) {
      setState(() => _message = l10n.contentUploadFileRequired);
      return;
    }
    if (title.isEmpty) {
      setState(() => _message = l10n.contentUploadTitleRequired);
      return;
    }
    if (subject.isEmpty) {
      setState(() => _message = l10n.contentUploadSubjectRequired);
      return;
    }
    final schoolClass = _class;
    if (schoolClass == null) {
      setState(() => _message = l10n.contentUploadClassRequired);
      return;
    }
    setState(() {
      _busy = true;
      _message = null;
      _rejected = false;
    });
    final result = await backend.content.upload(
      classId: schoolClass.id,
      type: _type!,
      title: title,
      subject: subject,
      gradeLevel: schoolClass.gradeLevel,
      fileName: _fileName!,
      bytes: _bytes!,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case BackendOk(:final value):
        if (value.ingestStatus == IngestStatus.rejected) {
          setState(() {
            _rejected = true;
            _message = l10n.contentUploadRejected(
              value.ingestReason ?? l10n.contentUploadFailed,
            );
          });
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.contentUploadSuccess)),
        );
        Navigator.of(context).pop();
      case BackendFailure(:final error):
        setState(() {
          _rejected = true;
          _message = error is BackendUnreachableError
              ? l10n.backendUnreachable
              : l10n.contentUploadFailed;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final classes = _classes;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.contentUploadTitle)),
      body: LearningPage(
        title: l10n.contentUploadTitle,
        children: [
          LearningPanel(
            title: l10n.contentFileInfo,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton.icon(
                  onPressed: _busy ? null : _pick,
                  icon: const Icon(Icons.attach_file_outlined),
                  label: Text(_fileName ?? l10n.contentUploadPickFile),
                ),
                if (_fileName != null) ...[
                  const SizedBox(height: EduSpace.s8),
                  Text(
                    _type == ContentType.ebook
                        ? l10n.contentTypeEbook
                        : l10n.contentTypeVideo,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: EduSpace.s8),
                Text(
                  l10n.contentUploadHint,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: EduPalette.of(context).muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: EduSpace.s16),
          LearningPanel(
            title: l10n.contentPreview,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LearningField(
                  label: l10n.contentUploadFormTitle,
                  child: TextField(
                    controller: _title,
                    enabled: !_busy,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(height: EduSpace.s16),
                LearningField(
                  label: l10n.contentUploadSubject,
                  child: TextField(
                    controller: _subject,
                    enabled: !_busy,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(height: EduSpace.s16),
                LearningField(
                  label: l10n.contentUploadClass,
                  child: DropdownButtonFormField<ClassSummary>(
                    initialValue: _class,
                    items: [
                      for (final item in classes ?? const <ClassSummary>[])
                        DropdownMenuItem(value: item, child: Text(item.name)),
                    ],
                    onChanged: _busy
                        ? null
                        : (value) => setState(() => _class = value),
                  ),
                ),
                if (_message != null) ...[
                  const SizedBox(height: EduSpace.s16),
                  BlockMessage(
                    tone: BlockTone.error,
                    message: _message!,
                    action: _rejected
                        ? TextButton(
                            onPressed: _busy
                                ? null
                                : () => setState(() {
                                    _message = null;
                                    _rejected = false;
                                  }),
                            child: Text(l10n.retry),
                          )
                        : null,
                  ),
                ],
                const SizedBox(height: EduSpace.s24),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: FilledButton(
                    onPressed: _busy ? null : () => unawaited(_submit()),
                    child: _busy
                        ? BusyLabel(label: l10n.contentUploadingSimple)
                        : Text(l10n.contentUploadSubmit),
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

class TeacherContentDetailScreen extends StatefulWidget {
  const TeacherContentDetailScreen({super.key, required this.contentId});

  final int contentId;

  @override
  State<TeacherContentDetailScreen> createState() =>
      _TeacherContentDetailScreenState();
}

class _TeacherContentDetailScreenState
    extends State<TeacherContentDetailScreen> {
  ContentDetail? _detail;
  BackendError? _error;
  bool _busy = false;

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
    if (!mounted) return;
    setState(() {
      _detail = result.valueOrNull;
      _error = result.errorOrNull;
    });
  }

  Future<void> _approve() async {
    final l10n = AppLocalizations.of(context);
    final backend = AppScope.of(context).services.backend;
    setState(() => _busy = true);
    final result = await backend.content.approve(widget.contentId);
    if (!mounted) return;
    setState(() => _busy = false);
    if (result.isOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.teacherContentApprovedSnack)),
      );
      unawaited(_load());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final detail = _detail;
    return Scaffold(
      appBar: AppBar(title: Text(detail?.title ?? l10n.contentPreview)),
      body: LearningPage(
        title: detail?.title ?? l10n.contentPreview,
        children: [
          if (detail == null && _error == null)
            const LearningPanel(child: SkeletonBar(width: double.infinity))
          else if (detail == null)
            BlockMessage(
              tone: BlockTone.error,
              message: l10n.contentDetailError,
              action: RetryButton(onPressed: () => unawaited(_load())),
            )
          else ...[
            LearningPanel(
              title: l10n.contentFileInfo,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    [
                      _type(l10n, detail),
                      if (detail.pageCount != null)
                        l10n.contentPageCount(detail.pageCount!),
                      if (detail.durationSeconds != null)
                        l10n.videoDuration(
                          learningDuration(
                            Duration(seconds: detail.durationSeconds!),
                          ),
                        ),
                    ].join(' · '),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: EduSpace.s16),
                  if (!detail.hasFile)
                    Text(l10n.contentFileUnavailable)
                  else
                    FilledButton(
                      onPressed: () => _openReader(context, detail),
                      child: Text(l10n.contentOpen),
                    ),
                  const SizedBox(height: EduSpace.s16),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: FilledButton(
                      onPressed: _busy ? null : () => unawaited(_approve()),
                      child: _busy
                          ? BusyLabel(label: l10n.retry)
                          : Text(l10n.teacherContentApprove),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _type(AppLocalizations l10n, ContentDetail detail) =>
      switch (detail.type) {
        ContentType.ebook => l10n.contentTypeEbook,
        ContentType.video => l10n.contentTypeVideo,
        ContentType.exercise => l10n.contentTypeExercise,
      };

  static void _openReader(BuildContext context, ContentDetail detail) {
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
}
