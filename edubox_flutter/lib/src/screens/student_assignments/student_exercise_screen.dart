import 'dart:async';

import 'package:edubox_client/edubox_client.dart'
    show
        StudentAssignmentDetail,
        StudentQuestion,
        SubmittedAnswer,
        TestStartResult;
import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../app/app_scope.dart';
import '../../contract/backend_result.dart';
import '../../features/learning/learning_ui.dart';
import '../../shell/block_states.dart';
import '../../theme/theme_extensions.dart';
import '../../theme/tokens.dart';
import 'student_result_screen.dart';

/// One exercise screen, also used as the timed test room. In test mode the
/// countdown is derived from the server's `startedAt`/deadline, never a
/// running counter, and expiry auto-submits.
class StudentExerciseScreen extends StatefulWidget {
  const StudentExerciseScreen({
    super.key,
    required this.assignmentId,
    this.testStart,
  });

  final int assignmentId;
  final TestStartResult? testStart;

  @override
  State<StudentExerciseScreen> createState() => _StudentExerciseScreenState();
}

class _StudentExerciseScreenState extends State<StudentExerciseScreen> {
  StudentAssignmentDetail? _detail;
  BackendError? _error;
  final Map<int, Set<int>> _answers = {};
  bool _busy = false;
  Timer? _timer;
  Duration _remaining = Duration.zero;

  bool get _isTest => widget.testStart != null;

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
    if (!mounted) return;
    setState(() {
      _detail = result.valueOrNull;
      _error = result.errorOrNull;
    });
    if (_detail != null && _isTest) {
      final stored = await backend.assignments.loadTestAnswers(
        widget.assignmentId,
      );
      if (!mounted) return;
      setState(() {
        for (final answer in stored) {
          _answers[answer.questionId] = answer.selectedPositions.toSet();
        }
      });
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    void tick() {
      if (!mounted) return;
      final now = AppScope.of(context).services.clock().toUtc();
      final remaining = widget.testStart!.deadline.difference(now);
      final clamped = remaining.isNegative ? Duration.zero : remaining;
      setState(() => _remaining = clamped);
      if (clamped == Duration.zero) {
        _timer?.cancel();
        unawaited(_submit(auto: true));
      }
    }

    tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggle(StudentQuestion question, int position) {
    setState(() {
      final selected = _answers[question.id] ?? <int>{};
      if (question.multiSelect) {
        if (!selected.add(position)) selected.remove(position);
      } else {
        selected
          ..clear()
          ..add(position);
      }
      _answers[question.id] = selected;
    });
    if (_isTest) {
      final list = _answerList();
      unawaited(
        AppScope.of(context).services.backend.assignments.saveTestAnswers(
          widget.assignmentId,
          list,
        ),
      );
    }
  }

  List<SubmittedAnswer> _answerList() => [
    for (final entry in _answers.entries)
      SubmittedAnswer(
        questionId: entry.key,
        selectedPositions: entry.value.toList()..sort(),
      ),
  ];

  int get _unanswered => _detail!.exercise.questions
      .where((question) => (_answers[question.id] ?? const {}).isEmpty)
      .length;

  Future<void> _submit({bool auto = false}) async {
    if (_busy || _detail == null) return;
    final l10n = AppLocalizations.of(context);
    if (!auto && _unanswered > 0) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.exerciseConfirmTitle),
          content: Text(l10n.exerciseConfirmBody(_unanswered)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.exerciseConfirmSubmit),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    if (!mounted) return;
    setState(() => _busy = true);
    final backend = AppScope.of(context).services.backend;
    final result = await backend.assignments.submit(
      assignmentId: widget.assignmentId,
      answers: _answerList(),
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (result.isOk) {
      if (auto) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.testAutoSubmitted)),
        );
      }
      await Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute(
          builder: (_) => StudentResultScreen(
            assignmentId: widget.assignmentId,
            title: _detail!.assignment.title,
          ),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.exerciseScreenError)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final detail = _detail;
    return Scaffold(
      appBar: AppBar(
        title: Text(detail?.assignment.title ?? l10n.exerciseScreenLoading),
        actions: [
          if (_isTest && detail != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: EduSpace.s16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    l10n.testRemaining,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    learningDuration(_remaining),
                    style: TextStyle(
                      fontFamily: EduFonts.mono,
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: _remaining.inMinutes < 1
                          ? EduPalette.of(context).notice
                          : EduPalette.of(context).ink,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: detail == null
          ? Padding(
              padding: const EdgeInsets.all(EduSpace.s24),
              child: _error == null
                  ? Text(l10n.exerciseScreenLoading)
                  : BlockMessage(
                      tone: BlockTone.error,
                      message: l10n.exerciseScreenError,
                      action: RetryButton(onPressed: () => unawaited(_load())),
                    ),
            )
          : LearningPage(
              title: detail.exercise.title,
              subtitle: l10n.exerciseQuestionsCount(
                detail.exercise.questions.length,
              ),
              children: [
                if (_isTest && _remaining.inMinutes < 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: EduSpace.s16),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: StatusStamp(
                        label: l10n.testUnderMinute,
                        tone: StatusTone.notice,
                        icon: Icons.timer_outlined,
                      ),
                    ),
                  ),
                for (final (index, question)
                    in detail.exercise.questions.indexed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: EduSpace.s16),
                    child: _QuestionCard(
                      number: index + 1,
                      question: question,
                      selected: _answers[question.id] ?? const {},
                      onSelect: (position) => _toggle(question, position),
                    ),
                  ),
                const SizedBox(height: EduSpace.s16),
                FilledButton(
                  onPressed: _busy ? null : () => unawaited(_submit()),
                  child: _busy
                      ? BusyLabel(label: l10n.exerciseSubmitting)
                      : Text(l10n.exerciseSubmit),
                ),
              ],
            ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.number,
    required this.question,
    required this.selected,
    required this.onSelect,
  });

  final int number;
  final StudentQuestion question;
  final Set<int> selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = EduPalette.of(context);
    final text = Theme.of(context).textTheme;
    return LearningPanel(
      title: l10n.exerciseQuestion(number),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(question.stem, style: text.bodyLarge),
          const SizedBox(height: EduSpace.s4),
          Text(
            question.multiSelect
                ? l10n.exerciseQuestionMultiHint
                : l10n.exerciseOptionsHint,
            style: text.bodySmall!.copyWith(color: palette.muted),
          ),
          const SizedBox(height: EduSpace.s12),
          for (final option in question.options)
            Padding(
              padding: const EdgeInsets.only(bottom: EduSpace.s8),
              child: _AnswerOption(
                letter: String.fromCharCode(65 + option.position),
                text: option.text,
                selected: selected.contains(option.position),
                onTap: () => onSelect(option.position),
                semanticsLabel: l10n.exerciseOptionsSemantics(
                  number,
                  String.fromCharCode(65 + option.position),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    required this.letter,
    required this.text,
    required this.selected,
    required this.onTap,
    required this.semanticsLabel,
  });

  final String letter;
  final String text;
  final bool selected;
  final VoidCallback onTap;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final palette = EduPalette.of(context);
    return Semantics(
      button: true,
      selected: selected,
      label: semanticsLabel,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(EduRadius.control),
        child: Container(
          constraints: const BoxConstraints(minHeight: 64),
          padding: const EdgeInsets.symmetric(
            horizontal: EduSpace.s16,
            vertical: EduSpace.s12,
          ),
          decoration: BoxDecoration(
            color: selected ? palette.active : palette.sheet,
            border: Border.all(
              color: selected ? palette.accent : palette.control,
              width: selected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(EduRadius.control),
          ),
          child: Row(
            children: [
              Text(
                letter,
                style: TextStyle(
                  fontFamily: EduFonts.mono,
                  fontWeight: FontWeight.w500,
                  color: selected ? palette.accent : palette.muted,
                ),
              ),
              const SizedBox(width: EduSpace.s12),
              Expanded(
                child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
              ),
              if (selected) Icon(Icons.check, size: 18, color: palette.accent),
            ],
          ),
        ),
      ),
    );
  }
}
