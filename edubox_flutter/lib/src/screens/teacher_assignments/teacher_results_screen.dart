import 'dart:async';

import 'package:edubox_client/edubox_client.dart'
    show
        ClassResults,
        ClassSummary,
        ResultCell,
        SubmissionStatus,
        TutorChatDetail,
        TutorChatSummary;
import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../app/app_scope.dart';
import '../../contract/backend_result.dart';
import '../../features/learning/learning_ui.dart';
import '../../shell/block_states.dart';
import '../../theme/tokens.dart';

abstract final class TeacherResultsKeys {
  static const screen = Key('screen.teacherResults');
  static const table = Key('teacherResults.table');
}

class TeacherResultsScreen extends StatefulWidget {
  const TeacherResultsScreen({super.key});

  @override
  State<TeacherResultsScreen> createState() => _TeacherResultsScreenState();
}

class _TeacherResultsScreenState extends State<TeacherResultsScreen> {
  List<ClassSummary> _classes = const [];
  ClassSummary? _class;
  ClassResults? _results;
  BackendError? _error;
  bool _loading = true;

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
    final classes = result.valueOrNull ?? const [];
    setState(() {
      _classes = classes;
      _class = classes.isEmpty ? null : classes.first;
    });
    if (_class != null) await _loadResults();
  }

  Future<void> _loadResults() async {
    if (_class == null) return;
    setState(() => _loading = true);
    final backend = AppScope.of(context).services.backend;
    final result = await backend.assignments.classResults(_class!.id);
    if (!mounted) return;
    setState(() {
      _results = result.valueOrNull;
      _loading = false;
    });
  }

  Future<void> _regrade(int submissionId) async {
    final l10n = AppLocalizations.of(context);
    final backend = AppScope.of(context).services.backend;
    final result = await backend.assignments.regrade(submissionId);
    if (!mounted) return;
    if (result.isOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.resultsRegraded)),
      );
      unawaited(_loadResults());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final results = _results;
    final submitted =
        results?.cells.where((cell) => cell.status != null).length ?? 0;
    final late = results?.cells.where((cell) => cell.late).length ?? 0;
    final total =
        (results?.students.length ?? 0) * (results?.assignments.length ?? 0);
    return LearningPage(
      key: TeacherResultsKeys.screen,
      title: l10n.resultsTitle,
      capped: false,
      children: [
        LearningPanel(
          title: l10n.resultsClass,
          child: DropdownButtonFormField<ClassSummary>(
            initialValue: _class,
            items: [
              for (final item in _classes)
                DropdownMenuItem(value: item, child: Text(item.name)),
            ],
            onChanged: (value) {
              setState(() => _class = value);
              unawaited(_loadResults());
            },
          ),
        ),
        const SizedBox(height: EduSpace.s16),
        if (_loading)
          const LearningPanel(child: SkeletonBar(width: double.infinity))
        else if (results == null)
          BlockMessage(
            tone: _error is OfflineNoCacheError
                ? BlockTone.offline
                : BlockTone.error,
            message: _error is OfflineNoCacheError
                ? l10n.resultError
                : l10n.resultsError,
            action: _error is OfflineNoCacheError
                ? null
                : RetryButton(onPressed: () => unawaited(_loadResults())),
          )
        else ...[
          Text(
            l10n.resultsSummary(submitted, total, late),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: EduSpace.s16),
          LearningPanel(
            title: results.className,
            child: results.students.isEmpty || results.assignments.isEmpty
                ? EmptySentence(l10n.resultsEmpty)
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      key: TeacherResultsKeys.table,
                      columns: [
                        const DataColumn(label: SizedBox.shrink()),
                        for (final assignment in results.assignments)
                          DataColumn(
                            label: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(assignment.title),
                                Text(
                                  assignment.dueAt == null
                                      ? l10n.assignmentNoDue
                                      : learningDate(assignment.dueAt),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                      ],
                      rows: [
                        for (final student in results.students)
                          DataRow(
                            cells: [
                              DataCell(Text(student.name)),
                              for (final assignment in results.assignments)
                                DataCell(
                                  _cell(
                                    l10n,
                                    results.cells.firstWhere(
                                      (cell) =>
                                          cell.studentId == student.id &&
                                          cell.assignmentId == assignment.id,
                                      orElse: () => ResultCell(
                                        studentId: student.id,
                                        assignmentId: assignment.id,
                                        late: false,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
          ),
          if (results.cells.any(
            (cell) => cell.status == SubmissionStatus.gradingFailed,
          )) ...[
            const SizedBox(height: EduSpace.s16),
            LearningPanel(
              title: l10n.statusGradingFailed,
              child: Column(
                children: [
                  for (final cell in results.cells)
                    if (cell.status == SubmissionStatus.gradingFailed &&
                        cell.submissionId != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                l10n.assignmentsScore(
                                  cell.score?.toString() ?? '–',
                                  cell.maxScore?.toString() ?? '10',
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  unawaited(_regrade(cell.submissionId!)),
                              child: Text(l10n.resultsRegrade),
                            ),
                          ],
                        ),
                      ),
                ],
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _cell(AppLocalizations l10n, ResultCell cell) {
    if (cell.status == null) return Text(l10n.resultsCellNoSubmission);
    if (cell.status == SubmissionStatus.graded) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(cell.score?.toString() ?? l10n.resultsCellNoSubmission),
          if (cell.late) ...[
            const SizedBox(width: 4),
            StatusStamp(label: l10n.statusLate, tone: StatusTone.negative),
          ],
        ],
      );
    }
    return switch (cell.status) {
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
      SubmissionStatus.graded => const SizedBox.shrink(),
      null => const SizedBox.shrink(),
    };
  }
}

/// Teacher AI chat review: pick a class, then a student, then read all logged
/// tutor transcripts read-only.
class TeacherChatReviewScreen extends StatefulWidget {
  const TeacherChatReviewScreen({super.key});

  @override
  State<TeacherChatReviewScreen> createState() =>
      _TeacherChatReviewScreenState();
}

class _TeacherChatReviewScreenState extends State<TeacherChatReviewScreen> {
  List<ClassSummary> _classes = const [];
  ClassSummary? _class;
  ClassResults? _roster;
  int? _studentId;
  List<TutorChatSummary> _chats = const [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_loadClasses());
    });
  }

  Future<void> _loadClasses() async {
    final backend = AppScope.of(context).services.backend;
    final classes = await backend.classes.mine();
    if (!mounted) return;
    final rows = classes.valueOrNull ?? const [];
    setState(() {
      _classes = rows;
      _class = rows.isEmpty ? null : rows.first;
    });
    if (_class != null) await _loadRoster();
  }

  Future<void> _loadRoster() async {
    if (_class == null) return;
    final backend = AppScope.of(context).services.backend;
    final roster = await backend.assignments.classResults(_class!.id);
    if (!mounted) return;
    final results = roster.valueOrNull;
    setState(() {
      _roster = results;
      _studentId = results?.students.isEmpty ?? true
          ? null
          : results!.students.first.id;
    });
    if (_studentId != null) await _loadChats();
  }

  Future<void> _loadChats() async {
    if (_studentId == null) return;
    setState(() {
      _loading = true;
    });
    final backend = AppScope.of(context).services.backend;
    final result = await backend.tutor.classChats(_studentId!);
    if (!mounted) return;
    setState(() {
      _chats = result.valueOrNull ?? const [];
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return LearningPage(
      title: l10n.teacherChatReviewTitle,
      capped: false,
      children: [
        LearningPanel(
          title: l10n.teacherChatReviewHint,
          child: Column(
            children: [
              DropdownButtonFormField<ClassSummary>(
                initialValue: _class,
                items: [
                  for (final item in _classes)
                    DropdownMenuItem(value: item, child: Text(item.name)),
                ],
                onChanged: (value) {
                  setState(() => _class = value);
                  unawaited(_loadRoster());
                },
              ),
              const SizedBox(height: EduSpace.s16),
              DropdownButtonFormField<int>(
                initialValue: _studentId,
                items: [
                  for (final student in _roster?.students ?? const [])
                    DropdownMenuItem(
                      value: student.id,
                      child: Text(student.name),
                    ),
                ],
                onChanged: (value) {
                  setState(() => _studentId = value);
                  unawaited(_loadChats());
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: EduSpace.s16),
        if (_loading)
          const LearningPanel(child: SkeletonBar(width: double.infinity))
        else if (_chats.isEmpty)
          EmptySentence(l10n.tutorNoChatsForStudent)
        else
          LearningPanel(
            title: l10n.tutorConversations,
            child: Column(
              children: [
                for (final chat in _chats)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(chat.title),
                    subtitle: Text(
                      l10n.chatRowMeta(
                        chat.subject,
                        learningDate(chat.updatedAt),
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push<void>(
                      MaterialPageRoute(
                        builder: (_) => TeacherChatTranscriptScreen(
                          chatId: chat.id,
                          studentName: chat.studentName,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class TeacherChatTranscriptScreen extends StatefulWidget {
  const TeacherChatTranscriptScreen({
    super.key,
    required this.chatId,
    this.studentName,
  });

  final int chatId;
  final String? studentName;

  @override
  State<TeacherChatTranscriptScreen> createState() =>
      _TeacherChatTranscriptScreenState();
}

class _TeacherChatTranscriptScreenState
    extends State<TeacherChatTranscriptScreen> {
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
    final result = await backend.tutor.classChat(widget.chatId);
    if (!mounted) return;
    setState(() {
      _chat = result.valueOrNull;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.studentName ?? l10n.teacherChatReviewTitle),
      ),
      body: LearningPage(
        title: _chat?.subject ?? l10n.teacherChatReviewTitle,
        subtitle: l10n.teacherChatReviewHint,
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
                  title: message.role.name == 'student'
                      ? l10n.tutorStudentLabel
                      : l10n.tutorTutorLabel,
                  child: Text(message.content),
                ),
              ),
        ],
      ),
    );
  }
}
