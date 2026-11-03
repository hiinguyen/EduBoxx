import 'dart:async';

import 'package:edubox_client/edubox_client.dart'
    show
        AssignmentType,
        StudentAssignmentDetail,
        StudentAssignmentState,
        TestStartResult;
import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../app/app_scope.dart';
import '../../contract/backend_result.dart';
import '../../features/learning/learning_ui.dart';
import '../../shell/block_states.dart';
import '../../theme/theme_extensions.dart';
import '../../theme/tokens.dart';
import '../content/content_viewer_screen.dart';
import 'student_exercise_screen.dart';
import 'student_result_screen.dart';

class StudentAssignmentDetailScreen extends StatefulWidget {
  const StudentAssignmentDetailScreen({super.key, required this.assignmentId});

  final int assignmentId;

  @override
  State<StudentAssignmentDetailScreen> createState() =>
      _StudentAssignmentDetailScreenState();
}

class _StudentAssignmentDetailScreenState
    extends State<StudentAssignmentDetailScreen> {
  StudentAssignmentDetail? _detail;
  BackendError? _error;
  bool _busy = false;
  TestStartResult? _activeTest;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_load());
    });
  }

  Future<void> _load() async {
    final backend = AppScope.of(context).services.backend;
    final result = await backend.assignments.studentAssignment(
      widget.assignmentId,
    );
    TestStartResult? active;
    if (result.valueOrNull?.assignment.type == AssignmentType.test) {
      active = (await backend.assignments.activeTest()).valueOrNull;
      if (active?.assignmentId != widget.assignmentId) active = null;
    }
    if (!mounted) return;
    setState(() {
      _detail = result.valueOrNull;
      _error = result.errorOrNull;
      _activeTest = active;
    });
  }

  Future<void> _markComplete(int contentId) async {
    final l10n = AppLocalizations.of(context);
    final backend = AppScope.of(context).services.backend;
    setState(() => _busy = true);
    final result = await backend.assignments.markLessonComplete(contentId);
    if (!mounted) return;
    setState(() => _busy = false);
    if (result.isOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.lessonCompletedSnack)),
      );
      unawaited(_load());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.lessonError)),
      );
    }
  }

  Future<void> _startPractice() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => StudentExerciseScreen(
          assignmentId: widget.assignmentId,
        ),
      ),
    );
    if (mounted) unawaited(_load());
  }

  Future<void> _startTest() async {
    final l10n = AppLocalizations.of(context);
    final backend = AppScope.of(context).services.backend;
    var start = _activeTest;
    if (start == null) {
      setState(() => _busy = true);
      final result = await backend.assignments.startTest(widget.assignmentId);
      if (!mounted) return;
      setState(() => _busy = false);
      start = result.valueOrNull;
      if (start == null) {
        final error = result.errorOrNull;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error is BackendUnreachableError
                  ? l10n.testNeedsInternet
                  : l10n.testStartFailed,
            ),
          ),
        );
        return;
      }
    }
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => StudentExerciseScreen(
          assignmentId: widget.assignmentId,
          testStart: start,
        ),
      ),
    );
    if (mounted) unawaited(_load());
  }

  Future<void> _openResult() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => StudentResultScreen(
          assignmentId: widget.assignmentId,
          title: _detail!.assignment.title,
        ),
      ),
    );
    if (mounted) unawaited(_load());
  }

  Future<void> _openLesson(int contentId) async {
    final backend = AppScope.of(context).services.backend;
    final detail = await backend.content.detail(contentId);
    if (!mounted) return;
    final value = detail.valueOrNull;
    if (value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).lessonError)),
      );
      return;
    }
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => ContentViewerScreen(
          contentId: value.id,
          title: value.title,
          type: value.type,
          pageCount: value.pageCount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final detail = _detail;
    return Scaffold(
      appBar: AppBar(
        title: Text(detail?.assignment.title ?? l10n.assignmentsTitle),
      ),
      body: LearningPage(
        title: detail?.assignment.title ?? l10n.assignmentsTitle,
        children: [
          if (detail == null && _error == null)
            const LearningPanel(child: SkeletonBar(width: double.infinity))
          else if (detail == null)
            BlockMessage(
              tone: _error is OfflineNoCacheError
                  ? BlockTone.offline
                  : BlockTone.error,
              message: _error is OfflineNoCacheError
                  ? l10n.exerciseOfflineNoData
                  : l10n.exerciseScreenError,
              action: _error is OfflineNoCacheError
                  ? null
                  : RetryButton(onPressed: () => unawaited(_load())),
            )
          else ...[
            LearningPanel(
              title: l10n.assignmentsTitle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    [
                      detail.assignment.className,
                      detail.assignment.type == AssignmentType.test
                          ? l10n.assignmentTypeTest
                          : l10n.assignmentTypePractice,
                      if (detail.assignment.dueAt != null)
                        l10n.assignmentsDue(
                          learningDate(detail.assignment.dueAt),
                        ),
                    ].join(' · '),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: EduPalette.of(context).muted,
                    ),
                  ),
                  const SizedBox(height: EduSpace.s8),
                  Text(
                    l10n.exerciseQuestionsCount(
                      detail.exercise.questions.length,
                    ),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (detail.assignment.score != null) ...[
                    const SizedBox(height: EduSpace.s12),
                    Text(
                      l10n.assignmentsScore(
                        _figure(detail.assignment.score!),
                        _figure(detail.assignment.maxScore ?? 10),
                      ),
                      style: EduTypeExtras.of(context).figure,
                    ),
                  ],
                  const SizedBox(height: EduSpace.s24),
                  if (detail.assignment.state ==
                          StudentAssignmentState.graded ||
                      detail.assignment.state ==
                          StudentAssignmentState.submitted ||
                      detail.assignment.state ==
                          StudentAssignmentState.gradingFailed) ...[
                    FilledButton(
                      onPressed: () => unawaited(_openResult()),
                      child: Text(l10n.resultTitle),
                    ),
                    if (detail.assignment.type == AssignmentType.practice) ...[
                      const SizedBox(height: EduSpace.s8),
                      OutlinedButton(
                        onPressed: () => unawaited(_startPractice()),
                        child: Text(l10n.exerciseRetry),
                      ),
                    ],
                  ] else if (detail.assignment.type == AssignmentType.test) ...[
                    if (!AppScope.of(context).connectivity.isOnline &&
                        _activeTest == null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: EduSpace.s8),
                        child: BlockMessage(
                          tone: BlockTone.offline,
                          message: l10n.testNeedsInternet,
                        ),
                      ),
                    FilledButton(
                      onPressed:
                          _busy ||
                              (!AppScope.of(context).connectivity.isOnline &&
                                  _activeTest == null)
                          ? null
                          : () => unawaited(_startTest()),
                      child: _busy
                          ? BusyLabel(label: l10n.testStarting)
                          : Text(
                              detail.assignment.state ==
                                          StudentAssignmentState.inProgress ||
                                      _activeTest != null
                                  ? l10n.assignmentsContinue
                                  : l10n.testStart,
                            ),
                    ),
                  ] else
                    FilledButton(
                      onPressed: () => unawaited(_startPractice()),
                      child: Text(l10n.exerciseStart),
                    ),
                ],
              ),
            ),
            if (detail.assignment.lessonContentId != null) ...[
              const SizedBox(height: EduSpace.s16),
              LearningPanel(
                title: l10n.lessonTitle,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      detail.assignment.lessonTitle ?? l10n.lessonTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: EduSpace.s12),
                    Wrap(
                      spacing: EduSpace.s8,
                      runSpacing: EduSpace.s8,
                      children: [
                        if (detail.lessonCompleted)
                          StatusStamp(
                            label: l10n.lessonCompleted,
                            tone: StatusTone.positive,
                            icon: Icons.check,
                          ),
                        OutlinedButton(
                          onPressed: () => unawaited(
                            _openLesson(detail.assignment.lessonContentId!),
                          ),
                          child: Text(l10n.lessonOpen),
                        ),
                        if (!detail.lessonCompleted)
                          FilledButton(
                            onPressed: _busy
                                ? null
                                : () => unawaited(
                                    _markComplete(
                                      detail.assignment.lessonContentId!,
                                    ),
                                  ),
                            child: Text(l10n.lessonMarkComplete),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  static String _figure(double value) => value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1).replaceAll('.', ',');
}
