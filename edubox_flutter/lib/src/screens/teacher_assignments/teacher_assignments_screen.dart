import 'dart:async';

import 'package:edubox_client/edubox_client.dart'
    show
        AssignmentType,
        AssignmentUpsert,
        ClassSummary,
        ContentType,
        ExerciseQuestionInput,
        ExerciseUpsert,
        TeacherAssignmentItem,
        TeacherContentItem,
        TeacherExerciseDetail,
        TeacherExerciseSummary;
import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../app/app_scope.dart';
import '../../app/loadable.dart';
import '../../contract/backend_result.dart';
import '../../features/learning/learning_ui.dart';
import '../../shell/block_states.dart';
import '../../theme/theme_extensions.dart';
import '../../theme/tokens.dart';

abstract final class TeacherAssignmentsKeys {
  static const screen = Key('screen.teacherAssignments');
  static const list = Key('teacherAssignments.list');
  static const newAssignment = Key('teacherAssignments.newAssignment');
  static const newExercise = Key('teacherAssignments.newExercise');
}

class TeacherAssignmentsScreen extends StatefulWidget {
  const TeacherAssignmentsScreen({super.key});

  @override
  State<TeacherAssignmentsScreen> createState() =>
      _TeacherAssignmentsScreenState();
}

class _TeacherAssignmentsScreenState extends State<TeacherAssignmentsScreen> {
  Loadable<List<TeacherAssignmentItem>>? _assignments;
  Loadable<List<TeacherExerciseSummary>>? _exercises;
  late AppScope _scope;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scope = AppScope.of(context);
    if (_assignments == null) {
      _assignments = Loadable(
        _scope.services.backend.assignments.teacherAssignments,
      )..addListener(_onError);
      _exercises = Loadable(
        _scope.services.backend.assignments.teacherExercises,
      )..addListener(_onError);
      _scope.connectivity
        ..register(_assignments!.load)
        ..register(_exercises!.load);
      unawaited(_assignments!.load());
      unawaited(_exercises!.load());
    }
  }

  void _onError() {
    if (_assignments!.error is SessionExpiredError) {
      unawaited(_scope.session.expire());
    }
  }

  @override
  void dispose() {
    _scope.connectivity
      ..unregister(_assignments!.load)
      ..unregister(_exercises!.load);
    _assignments!
      ..removeListener(_onError)
      ..dispose();
    _exercises!
      ..removeListener(_onError)
      ..dispose();
    super.dispose();
  }

  Future<void> _openAssignmentEditor() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => const AssignmentEditorScreen()),
    );
    if (mounted) unawaited(_assignments!.load());
  }

  Future<void> _openExerciseEditor([TeacherExerciseSummary? exercise]) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => ExerciseEditorScreen(exerciseId: exercise?.id),
      ),
    );
    if (mounted) {
      unawaited(_exercises!.load());
      unawaited(_assignments!.load());
    }
  }

  Future<void> _delete(TeacherAssignmentItem item) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.assignmentDeleteConfirmTitle),
        content: Text(l10n.assignmentDeleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final result = await _scope.services.backend.assignments.deleteAssignment(
      item.id,
    );
    if (!mounted) return;
    if (result.isOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.assignmentDeleted)),
      );
      unawaited(_assignments!.load());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final assignments = _assignments!;
    final exercises = _exercises!;
    return ListenableBuilder(
      listenable: Listenable.merge([assignments, exercises]),
      builder: (context, _) {
        final assignmentRows = assignments.value;
        final exerciseRows = exercises.value;
        return LearningPage(
          key: TeacherAssignmentsKeys.screen,
          title: l10n.assignmentsTitle,
          capped: false,
          action: FilledButton.icon(
            key: TeacherAssignmentsKeys.newAssignment,
            onPressed: _openAssignmentEditor,
            icon: const Icon(Icons.add),
            label: Text(l10n.assignmentNew),
          ),
          children: [
            LearningPanel(
              title: l10n.assignmentTeacherTitle,
              child: assignmentRows == null
                  ? _loading(assignments.error, assignments.load)
                  : assignmentRows.isEmpty
                  ? EmptySentence(l10n.assignmentEmpty)
                  : Column(
                      key: TeacherAssignmentsKeys.list,
                      children: [
                        for (final item in assignmentRows)
                          _AssignmentRow(
                            item: item,
                            onDelete: () => unawaited(_delete(item)),
                          ),
                      ],
                    ),
            ),
            const SizedBox(height: EduSpace.s16),
            LearningPanel(
              title: l10n.exercisesTitle,
              action: FilledButton.tonalIcon(
                key: TeacherAssignmentsKeys.newExercise,
                onPressed: () => unawaited(_openExerciseEditor()),
                icon: const Icon(Icons.add),
                label: Text(l10n.exerciseNew),
              ),
              child: exerciseRows == null
                  ? _loading(exercises.error, exercises.load)
                  : exerciseRows.isEmpty
                  ? EmptySentence(l10n.exerciseEmpty)
                  : Column(
                      children: [
                        for (final item in exerciseRows)
                          InkWell(
                            onTap: () => unawaited(_openExerciseEditor(item)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: EduSpace.s12,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleSmall,
                                        ),
                                        Text(
                                          l10n.exerciseRowMeta(
                                            item.subject,
                                            l10n.exerciseQuestionsCount(
                                              item.questionCount,
                                            ),
                                          ),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                color: EduPalette.of(
                                                  context,
                                                ).muted,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        unawaited(_openExerciseEditor(item)),
                                    child: Text(l10n.exerciseEdit),
                                  ),
                                ],
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

  Widget _loading(BackendError? error, Future<void> Function() retry) {
    final l10n = AppLocalizations.of(context);
    if (error == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: EduSpace.s16),
        child: SkeletonBar(width: double.infinity),
      );
    }
    return BlockMessage(
      tone: error is OfflineNoCacheError ? BlockTone.offline : BlockTone.error,
      message: error is OfflineNoCacheError
          ? l10n.assignmentOfflineNoData
          : l10n.assignmentError,
      action: error is OfflineNoCacheError
          ? null
          : RetryButton(onPressed: () => unawaited(retry())),
    );
  }
}

class _AssignmentRow extends StatelessWidget {
  const _AssignmentRow({required this.item, required this.onDelete});

  final TeacherAssignmentItem item;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = EduPalette.of(context);
    final text = Theme.of(context).textTheme;
    return Padding(
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
                    Text(
                      [
                        item.className,
                        item.type == AssignmentType.test
                            ? l10n.assignmentTypeTest
                            : l10n.assignmentTypePractice,
                        if (item.dueAt != null)
                          l10n.assignmentDueAt(learningDate(item.dueAt))
                        else
                          l10n.assignmentNoDueAt,
                      ].join(' · '),
                      style: text.bodySmall!.copyWith(color: palette.muted),
                    ),
                    Text(
                      l10n.assignmentCounts(
                        l10n.assignmentSubmissions(item.submissionCount),
                        l10n.assignmentGradedCount(item.gradedCount),
                      ),
                      style: text.bodySmall!.copyWith(color: palette.muted),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
                tooltip: l10n.assignmentDelete,
              ),
            ],
          ),
          const Divider(height: EduSpace.s24, color: EduColors.rule),
        ],
      ),
    );
  }
}

class AssignmentEditorScreen extends StatefulWidget {
  const AssignmentEditorScreen({super.key});

  @override
  State<AssignmentEditorScreen> createState() => _AssignmentEditorScreenState();
}

class _AssignmentEditorScreenState extends State<AssignmentEditorScreen> {
  final _title = TextEditingController();
  final _timeLimit = TextEditingController();
  List<ClassSummary> _classes = const [];
  List<TeacherExerciseSummary> _exercises = const [];
  ClassSummary? _class;
  TeacherExerciseSummary? _exercise;
  AssignmentType _type = AssignmentType.practice;
  DateTime? _dueAt;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final backend = AppScope.of(context).services.backend;
    final classes = await backend.classes.mine();
    final exercises = await backend.assignments.teacherExercises();
    if (!mounted) return;
    setState(() {
      _classes = classes.valueOrNull ?? const [];
      _exercises = exercises.valueOrNull ?? const [];
      _class ??= _classes.isEmpty ? null : _classes.first;
      _exercise ??= _exercises.isEmpty ? null : _exercises.first;
    });
  }

  @override
  void dispose() {
    _title.dispose();
    _timeLimit.dispose();
    super.dispose();
  }

  Future<void> _pickDue() async {
    final now = AppScope.of(context).services.clock();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueAt ?? now.add(const Duration(days: 3)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _dueAt = picked);
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final backend = AppScope.of(context).services.backend;
    if (_title.text.trim().isEmpty || _class == null || _exercise == null) {
      setState(() => _error = l10n.exerciseValidation);
      return;
    }
    int? timeLimit;
    if (_type == AssignmentType.test) {
      final minutes = int.tryParse(_timeLimit.text.trim());
      if (minutes == null || minutes <= 0) {
        setState(() => _error = l10n.assignmentTimeLimitInvalid);
        return;
      }
      timeLimit = minutes * 60;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await backend.assignments.saveAssignment(
      AssignmentUpsert(
        classId: _class!.id,
        exerciseId: _exercise!.id,
        type: _type,
        title: _title.text.trim(),
        dueAt: _dueAt,
        timeLimitSec: timeLimit,
      ),
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (result.isOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.assignmentSaved)),
      );
      Navigator.of(context).pop();
    } else {
      setState(() => _error = l10n.assignmentError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.assignmentEditorTitle)),
      body: LearningPage(
        title: l10n.assignmentEditorTitle,
        capped: false,
        children: [
          LearningPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LearningField(
                  label: l10n.exerciseTitleField,
                  child: TextField(controller: _title),
                ),
                const SizedBox(height: EduSpace.s16),
                LearningField(
                  label: l10n.assignmentClass,
                  child: DropdownButtonFormField<ClassSummary>(
                    initialValue: _class,
                    items: [
                      for (final item in _classes)
                        DropdownMenuItem(value: item, child: Text(item.name)),
                    ],
                    onChanged: (value) => setState(() => _class = value),
                  ),
                ),
                const SizedBox(height: EduSpace.s16),
                LearningField(
                  label: l10n.assignmentExercise,
                  child: DropdownButtonFormField<TeacherExerciseSummary>(
                    initialValue: _exercise,
                    items: [
                      for (final item in _exercises)
                        DropdownMenuItem(value: item, child: Text(item.title)),
                    ],
                    onChanged: (value) => setState(() => _exercise = value),
                  ),
                ),
                const SizedBox(height: EduSpace.s16),
                LearningField(
                  label: l10n.assignmentType,
                  child: DropdownButtonFormField<AssignmentType>(
                    initialValue: _type,
                    items: [
                      DropdownMenuItem(
                        value: AssignmentType.practice,
                        child: Text(l10n.assignmentTypePractice),
                      ),
                      DropdownMenuItem(
                        value: AssignmentType.test,
                        child: Text(l10n.assignmentTypeTest),
                      ),
                    ],
                    onChanged: (value) => setState(
                      () => _type = value ?? AssignmentType.practice,
                    ),
                  ),
                ),
                if (_type == AssignmentType.test) ...[
                  const SizedBox(height: EduSpace.s16),
                  LearningField(
                    label: l10n.assignmentTimeLimit,
                    child: TextField(
                      controller: _timeLimit,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
                const SizedBox(height: EduSpace.s16),
                LearningField(
                  label: l10n.assignmentDue,
                  child: OutlinedButton(
                    onPressed: () => unawaited(_pickDue()),
                    child: Text(
                      _dueAt == null
                          ? l10n.assignmentNoDue
                          : learningDate(_dueAt),
                    ),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: EduSpace.s16),
                  BlockMessage(tone: BlockTone.error, message: _error!),
                ],
                const SizedBox(height: EduSpace.s24),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: FilledButton(
                    onPressed: _busy ? null : () => unawaited(_save()),
                    child: _busy
                        ? BusyLabel(label: l10n.retrying)
                        : Text(l10n.assignmentAssign),
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

/// The teacher exercise editor: question stems, options, the answer key and
/// an optional linked lesson.
class ExerciseEditorScreen extends StatefulWidget {
  const ExerciseEditorScreen({super.key, this.exerciseId});

  final int? exerciseId;

  @override
  State<ExerciseEditorScreen> createState() => _ExerciseEditorScreenState();
}

class _QuestionDraft {
  _QuestionDraft() : options = List.generate(4, (_) => TextEditingController());

  final stem = TextEditingController();
  final List<TextEditingController> options;
  final Set<int> correct = {};
  bool multiSelect = false;

  void dispose() {
    stem.dispose();
    for (final controller in options) {
      controller.dispose();
    }
  }
}

class _ExerciseEditorScreenState extends State<ExerciseEditorScreen> {
  final _title = TextEditingController();
  final _subject = TextEditingController();
  final List<_QuestionDraft> _questions = [_QuestionDraft()];
  List<ClassSummary> _classes = const [];
  List<TeacherContentItem> _lessons = const [];
  ClassSummary? _class;
  int? _lessonId;
  bool _busy = false;
  String? _error;
  int? _contentId;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final backend = AppScope.of(context).services.backend;
    final classes = await backend.classes.mine();
    final content = await backend.content.teacherList();
    TeacherExerciseDetail? detail;
    if (widget.exerciseId != null) {
      detail = (await backend.assignments.teacherExercise(
        widget.exerciseId!,
      )).valueOrNull;
    }
    if (!mounted) return;
    setState(() {
      _classes = classes.valueOrNull ?? const [];
      _lessons = (content.valueOrNull ?? const [])
          .where(
            (item) =>
                item.type != ContentType.exercise &&
                item.status.name == 'approved',
          )
          .toList();
      _class = _classes.isEmpty ? null : _classes.first;
      if (detail != null) {
        _title.text = detail.title;
        _subject.text = detail.subject;
        _lessonId = detail.lessonContentId;
        _contentId = detail.contentId;
        _questions
          ..clear()
          ..addAll([
            for (final question in detail.questions)
              _QuestionDraft()
                ..stem.text = question.stem
                ..multiSelect = question.multiSelect
                ..correct.addAll(question.correctPositions)
                ..options.asMap().entries.forEach((entry) {
                  if (entry.key < question.options.length) {
                    entry.value.text = question.options[entry.key];
                  }
                }),
          ]);
      }
    });
  }

  @override
  void dispose() {
    _title.dispose();
    _subject.dispose();
    for (final question in _questions) {
      question.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final backend = AppScope.of(context).services.backend;
    if (_title.text.trim().isEmpty || _subject.text.trim().isEmpty) {
      setState(() => _error = l10n.exerciseValidation);
      return;
    }
    final inputs = <ExerciseQuestionInput>[];
    for (final (index, question) in _questions.indexed) {
      final options = [
        for (final controller in question.options)
          if (controller.text.trim().isNotEmpty) controller.text.trim(),
      ];
      final correct =
          question.correct
              .where((position) => position < options.length)
              .toList()
            ..sort();
      if (question.stem.text.trim().isEmpty ||
          options.length < 2 ||
          correct.isEmpty ||
          (!question.multiSelect && correct.length > 1)) {
        setState(() => _error = l10n.exerciseValidation);
        return;
      }
      inputs.add(
        ExerciseQuestionInput(
          position: index,
          stem: question.stem.text.trim(),
          multiSelect: question.multiSelect,
          options: options,
          correctPositions: correct,
        ),
      );
    }
    if (inputs.isEmpty || _class == null) {
      setState(() => _error = l10n.exerciseValidation);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await backend.assignments.saveExercise(
      ExerciseUpsert(
        contentId: _contentId,
        classId: _class!.id,
        title: _title.text.trim(),
        subject: _subject.text.trim(),
        gradeLevel: _class!.gradeLevel,
        lessonContentId: _lessonId,
        questions: inputs,
      ),
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (result.isOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.exerciseSaved)),
      );
      Navigator.of(context).pop();
    } else {
      setState(() => _error = l10n.exerciseError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.exerciseId == null
              ? l10n.exerciseEditorTitle
              : l10n.exerciseEdit,
        ),
      ),
      body: LearningPage(
        title: widget.exerciseId == null
            ? l10n.exerciseEditorTitle
            : l10n.exerciseEdit,
        capped: false,
        children: [
          LearningPanel(
            title: l10n.exerciseNew,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LearningField(
                  label: l10n.exerciseTitleField,
                  child: TextField(controller: _title),
                ),
                const SizedBox(height: EduSpace.s16),
                LearningField(
                  label: l10n.exerciseSubjectField,
                  child: TextField(controller: _subject),
                ),
                const SizedBox(height: EduSpace.s16),
                LearningField(
                  label: l10n.exerciseClassField,
                  child: DropdownButtonFormField<ClassSummary>(
                    initialValue: _class,
                    items: [
                      for (final item in _classes)
                        DropdownMenuItem(value: item, child: Text(item.name)),
                    ],
                    onChanged: (value) => setState(() => _class = value),
                  ),
                ),
                const SizedBox(height: EduSpace.s16),
                LearningField(
                  label: l10n.exerciseLessonField,
                  child: DropdownButtonFormField<int?>(
                    initialValue: _lessonId,
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text(l10n.exerciseNoneLesson),
                      ),
                      for (final item in _lessons)
                        DropdownMenuItem(
                          value: item.id,
                          child: Text(item.title),
                        ),
                    ],
                    onChanged: (value) => setState(() => _lessonId = value),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: EduSpace.s16),
          for (final (index, question) in _questions.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: EduSpace.s16),
              child: _QuestionEditor(
                number: index + 1,
                draft: question,
                canRemove: _questions.length > 1,
                onRemove: () {
                  setState(() {
                    _questions.removeAt(index);
                  });
                  question.dispose();
                },
              ),
            ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: OutlinedButton.icon(
              onPressed: () => setState(() => _questions.add(_QuestionDraft())),
              icon: const Icon(Icons.add),
              label: Text(l10n.exerciseAddQuestion),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: EduSpace.s16),
            BlockMessage(tone: BlockTone.error, message: _error!),
          ],
          const SizedBox(height: EduSpace.s24),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton(
              onPressed: _busy ? null : () => unawaited(_save()),
              child: _busy
                  ? BusyLabel(label: l10n.retrying)
                  : Text(l10n.exerciseSave),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionEditor extends StatefulWidget {
  const _QuestionEditor({
    required this.number,
    required this.draft,
    required this.canRemove,
    required this.onRemove,
  });

  final int number;
  final _QuestionDraft draft;
  final bool canRemove;
  final VoidCallback onRemove;

  @override
  State<_QuestionEditor> createState() => _QuestionEditorState();
}

class _QuestionEditorState extends State<_QuestionEditor> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final draft = widget.draft;
    return LearningPanel(
      title: l10n.exerciseQuestion(widget.number),
      action: widget.canRemove
          ? TextButton(
              onPressed: widget.onRemove,
              child: Text(l10n.exerciseRemoveQuestion),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LearningField(
            label: l10n.exerciseStem,
            child: TextField(controller: draft.stem, maxLines: 2),
          ),
          const SizedBox(height: EduSpace.s16),
          CheckboxListTile(
            value: draft.multiSelect,
            onChanged: (value) =>
                setState(() => draft.multiSelect = value ?? false),
            title: Text(l10n.exerciseMulti),
            contentPadding: EdgeInsets.zero,
          ),
          for (final (index, controller) in draft.options.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: EduSpace.s8),
              child: Row(
                children: [
                  Checkbox(
                    value: draft.correct.contains(index),
                    onChanged: (value) => setState(() {
                      if (value == true) {
                        if (!draft.multiSelect) draft.correct.clear();
                        draft.correct.add(index);
                      } else {
                        draft.correct.remove(index);
                      }
                    }),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: l10n.exerciseOption(
                          String.fromCharCode(65 + index),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Text(
            l10n.exerciseAnswerKeyHint,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: EduPalette.of(context).muted,
            ),
          ),
        ],
      ),
    );
  }
}
