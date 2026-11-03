import 'dart:async';

import 'package:edubox_client/edubox_client.dart'
    show
        AssignmentType,
        ChatRole,
        ParentResultEntry,
        ParentSummary,
        SubmissionStatus,
        TutorChatDetail;
import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../app/app_scope.dart';
import '../../contract/backend_result.dart';
import '../../features/learning/learning_ui.dart';
import '../../shell/block_states.dart';
import '../../theme/theme_extensions.dart';
import '../../theme/tokens.dart';

class ParentSummaryScreen extends StatefulWidget {
  const ParentSummaryScreen({super.key});

  @override
  State<ParentSummaryScreen> createState() => _ParentSummaryScreenState();
}

class _ParentSummaryScreenState extends State<ParentSummaryScreen> {
  ParentSummary? _summary;
  BackendError? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_load());
    });
  }

  Future<void> _load() async {
    final backend = AppScope.of(context).services.backend;
    final result = await backend.parent.summary();
    if (!mounted) return;
    setState(() {
      _summary = result.valueOrNull;
      _error = result.errorOrNull;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final summary = _summary;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.parentSummaryTitle)),
      body: LearningPage(
        title: l10n.parentSummaryTitle,
        children: [
          if (_loading)
            const LearningPanel(child: SkeletonBar(width: double.infinity))
          else if (summary == null)
            BlockMessage(
              tone: _error is OfflineNoCacheError
                  ? BlockTone.offline
                  : BlockTone.error,
              message: _error is OfflineNoCacheError
                  ? l10n.parentSummaryOfflineNoData
                  : l10n.parentSummaryError,
              action: _error is OfflineNoCacheError
                  ? null
                  : RetryButton(onPressed: () => unawaited(_load())),
            )
          else ...[
            LearningPanel(
              title: l10n.parentResults,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    [
                      summary.linkedStudentName ?? '',
                      summary.className ?? '',
                    ].where((value) => value.isNotEmpty).join(' · '),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: EduSpace.s12),
                  if (summary.results.isEmpty)
                    EmptySentence(l10n.parentNoResults)
                  else
                    for (final entry in summary.results)
                      _ResultEntry(entry: entry),
                ],
              ),
            ),
            const SizedBox(height: EduSpace.s16),
            LearningPanel(
              title: l10n.parentAiChats,
              child: summary.chats.isEmpty
                  ? EmptySentence(l10n.parentNoChats)
                  : Column(
                      children: [
                        for (final chat in summary.chats)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(chat.title),
                            subtitle: Text(
                              l10n.chatRowMeta(
                                chat.subject,
                                learningDate(chat.updatedAt),
                              ),
                            ),
                            trailing: Text(
                              l10n.parentReadOnly,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            onTap: () => Navigator.of(context).push<void>(
                              MaterialPageRoute(
                                builder: (_) => ParentChatScreen(
                                  chatId: chat.id,
                                  studentName: summary.linkedStudentName,
                                ),
                              ),
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
}

class _ResultEntry extends StatelessWidget {
  const _ResultEntry({required this.entry});

  final ParentResultEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final palette = EduPalette.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: EduSpace.s8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.title, style: text.titleSmall),
                Text(
                  [
                    entry.type == AssignmentType.test
                        ? l10n.assignmentTypeTest
                        : l10n.assignmentTypePractice,
                    if (entry.submittedAt != null)
                      learningDate(entry.submittedAt),
                  ].join(' · '),
                  style: text.bodySmall!.copyWith(color: palette.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: EduSpace.s12),
          if (entry.score != null)
            Text(
              l10n.assignmentsScore(
                _figure(entry.score!),
                _figure(entry.maxScore ?? 10),
              ),
              style: EduTypeExtras.of(context).figure,
            ),
          const SizedBox(width: EduSpace.s8),
          if (entry.late)
            StatusStamp(
              label: l10n.statusLate,
              tone: StatusTone.negative,
              icon: Icons.schedule,
            )
          else
            _status(l10n, entry.status),
        ],
      ),
    );
  }

  Widget _status(AppLocalizations l10n, SubmissionStatus? status) =>
      switch (status) {
        SubmissionStatus.graded => StatusStamp(
          label: l10n.statusGraded,
          tone: StatusTone.positive,
          icon: Icons.check,
        ),
        SubmissionStatus.gradingFailed => StatusStamp(
          label: l10n.statusGradingFailed,
          tone: StatusTone.negative,
        ),
        SubmissionStatus.submitted => StatusStamp(
          label: l10n.statusSubmittedAwaitingGrade,
        ),
        SubmissionStatus.inProgress => StatusStamp(
          label: l10n.statusInProgress,
        ),
        null => const SizedBox.shrink(),
      };

  static String _figure(double value) => value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1).replaceAll('.', ',');
}

class ParentChatScreen extends StatefulWidget {
  const ParentChatScreen({
    super.key,
    required this.chatId,
    this.studentName,
  });

  final int chatId;
  final String? studentName;

  @override
  State<ParentChatScreen> createState() => _ParentChatScreenState();
}

class _ParentChatScreenState extends State<ParentChatScreen> {
  TutorChatDetail? _chat;
  BackendError? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_load());
    });
  }

  Future<void> _load() async {
    final backend = AppScope.of(context).services.backend;
    final result = await backend.parent.chat(widget.chatId);
    if (!mounted) return;
    setState(() {
      _chat = result.valueOrNull;
      _error = result.errorOrNull;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.parentChatTitle)),
      body: LearningPage(
        title: _chat?.subject ?? l10n.parentChatTitle,
        subtitle: widget.studentName,
        children: [
          if (_chat == null && _error == null)
            const LearningPanel(child: SkeletonBar(width: double.infinity))
          else if (_chat == null)
            RetryButton(onPressed: () => unawaited(_load()))
          else
            for (final message in _chat!.messages)
              Padding(
                padding: const EdgeInsets.only(bottom: EduSpace.s12),
                child: LearningPanel(
                  title: message.role == ChatRole.student
                      ? widget.studentName ?? l10n.tutorStudentLabel
                      : l10n.tutorTutorLabel,
                  child: Text(message.content),
                ),
              ),
        ],
      ),
    );
  }
}
