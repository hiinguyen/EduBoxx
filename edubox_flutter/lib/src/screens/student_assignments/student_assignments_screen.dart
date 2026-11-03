import 'dart:async';

import 'package:edubox_client/edubox_client.dart'
    show
        AssignmentType,
        StudentAssignmentItem,
        StudentAssignmentList,
        StudentAssignmentState;
import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../app/app_scope.dart';
import '../../app/loadable.dart';
import '../../contract/backend_result.dart';
import '../../features/learning/learning_ui.dart';
import '../../shell/block_states.dart';
import '../../theme/theme_extensions.dart';
import '../../theme/tokens.dart';
import 'student_assignment_detail_screen.dart';

abstract final class StudentAssignmentsKeys {
  static const screen = Key('screen.studentAssignments');
  static const list = Key('studentAssignments.list');
}

class StudentAssignmentsScreen extends StatefulWidget {
  const StudentAssignmentsScreen({super.key});

  @override
  State<StudentAssignmentsScreen> createState() =>
      _StudentAssignmentsScreenState();
}

class _StudentAssignmentsScreenState extends State<StudentAssignmentsScreen> {
  Loadable<StudentAssignmentList>? _assignments;
  late AppScope _scope;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scope = AppScope.of(context);
    if (_assignments == null) {
      final assignments = Loadable<StudentAssignmentList>(
        _scope.services.backend.assignments.studentAssignments,
      )..addListener(_onAssignments);
      _assignments = assignments;
      _scope.connectivity.register(assignments.load);
      unawaited(assignments.load());
    }
  }

  void _onAssignments() {
    if (_assignments!.error is SessionExpiredError) {
      unawaited(_scope.session.expire());
    }
  }

  @override
  void dispose() {
    final assignments = _assignments!;
    _scope.connectivity.unregister(assignments.load);
    assignments
      ..removeListener(_onAssignments)
      ..dispose();
    super.dispose();
  }

  Future<void> _open(StudentAssignmentItem item) async {
    final loader =
        item.type == AssignmentType.test &&
            (item.state == StudentAssignmentState.toDo ||
                item.state == StudentAssignmentState.inProgress)
        ? _openTest(item)
        : _openDetail(item);
    await loader;
    if (mounted) unawaited(_assignments!.load());
  }

  Future<void> _openDetail(StudentAssignmentItem item) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => StudentAssignmentDetailScreen(assignmentId: item.id),
      ),
    );
  }

  Future<void> _openTest(StudentAssignmentItem item) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => StudentAssignmentDetailScreen(assignmentId: item.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final assignments = _assignments!;
    return ListenableBuilder(
      listenable: assignments,
      builder: (context, _) {
        final value = assignments.value;
        final items = [...?value?.assignments]..sort(_compareAssignments);
        return LearningPage(
          key: StudentAssignmentsKeys.screen,
          title: l10n.assignmentsTitle,
          subtitle: value == null ? null : l10n.libraryTotal(items.length),
          children: [
            if (value == null && assignments.error == null)
              const _AssignmentsLoading()
            else if (value == null)
              _AssignmentsError(
                error: assignments.error,
                onRetry: assignments.load,
              )
            else if (items.isEmpty)
              EmptySentence(l10n.assignmentsEmpty)
            else
              LearningPanel(
                title: l10n.assignmentsNeedsAction,
                child: Column(
                  key: StudentAssignmentsKeys.list,
                  children: [
                    for (final item in items)
                      _AssignmentRow(
                        item: item,
                        onTap: () => unawaited(_open(item)),
                        pending: _scope.services.backend.assignments
                            .hasPendingSubmission(item.id),
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  static int _compareAssignments(
    StudentAssignmentItem a,
    StudentAssignmentItem b,
  ) {
    final aDone = a.state == StudentAssignmentState.graded;
    final bDone = b.state == StudentAssignmentState.graded;
    if (aDone != bDone) return aDone ? 1 : -1;
    final aDue = a.dueAt;
    final bDue = b.dueAt;
    if (aDue == null && bDue == null) return a.id.compareTo(b.id);
    if (aDue == null) return 1;
    if (bDue == null) return -1;
    return aDue.compareTo(bDue);
  }
}

class _AssignmentsLoading extends StatelessWidget {
  const _AssignmentsLoading();

  @override
  Widget build(BuildContext context) {
    return LearningPanel(
      child: Column(
        children: [
          for (var i = 0; i < 3; i++)
            const Padding(
              padding: EdgeInsets.only(bottom: EduSpace.s16),
              child: SkeletonBar(width: double.infinity, height: 28),
            ),
        ],
      ),
    );
  }
}

class _AssignmentsError extends StatelessWidget {
  const _AssignmentsError({required this.error, required this.onRetry});

  final BackendError? error;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (error is OfflineNoCacheError) {
      return BlockMessage(
        tone: BlockTone.offline,
        message: l10n.assignmentsOfflineNoData,
      );
    }
    return BlockMessage(
      tone: BlockTone.error,
      message: l10n.assignmentsError,
      action: RetryButton(onPressed: () => unawaited(onRetry())),
    );
  }
}

class _AssignmentRow extends StatelessWidget {
  const _AssignmentRow({
    required this.item,
    required this.onTap,
    required this.pending,
  });

  final StudentAssignmentItem item;
  final VoidCallback onTap;
  final Future<bool> pending;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = EduPalette.of(context);
    final text = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
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
                      Text(item.title, style: text.titleMedium),
                      const SizedBox(height: 2),
                      Text(
                        [
                          item.className,
                          item.type == AssignmentType.test
                              ? l10n.assignmentTypeTest
                              : l10n.assignmentTypePractice,
                          if (item.dueAt != null)
                            l10n.assignmentsDue(
                              learningDate(item.dueAt),
                            ),
                        ].join(' · '),
                        style: text.bodySmall!.copyWith(color: palette.muted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: EduSpace.s12),
                FutureBuilder<bool>(
                  future: pending,
                  builder: (context, snapshot) {
                    if (snapshot.data == true &&
                        item.state != StudentAssignmentState.graded) {
                      return StatusStamp(
                        label: l10n.statusPendingSync,
                        tone: StatusTone.notice,
                        icon: Icons.cloud_upload_outlined,
                      );
                    }
                    return _stateStamp(l10n, item);
                  },
                ),
              ],
            ),
            if (item.score != null) ...[
              const SizedBox(height: EduSpace.s8),
              Text(
                l10n.assignmentsScore(
                  _figure(item.score!),
                  _figure(item.maxScore ?? 10),
                ),
                style: EduTypeExtras.of(context).figure,
              ),
            ],
            const Divider(height: EduSpace.s24, color: EduColors.rule),
          ],
        ),
      ),
    );
  }

  static String _figure(double value) {
    final rounded = value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(1).replaceAll('.', ',');
    return rounded;
  }

  static Widget _stateStamp(
    AppLocalizations l10n,
    StudentAssignmentItem item,
  ) => switch (item.state) {
    StudentAssignmentState.toDo => StatusStamp(label: l10n.statusToDo),
    StudentAssignmentState.inProgress => StatusStamp(
      label: l10n.statusInProgress,
      icon: Icons.timer_outlined,
    ),
    StudentAssignmentState.submitted => StatusStamp(
      label: l10n.statusSubmittedAwaitingGrade,
      icon: Icons.schedule,
    ),
    StudentAssignmentState.graded => StatusStamp(
      label: l10n.statusGraded,
      tone: StatusTone.positive,
      icon: Icons.check,
    ),
    StudentAssignmentState.gradingFailed => StatusStamp(
      label: l10n.statusGradingFailed,
      tone: StatusTone.negative,
      icon: Icons.error_outline,
    ),
  };
}
