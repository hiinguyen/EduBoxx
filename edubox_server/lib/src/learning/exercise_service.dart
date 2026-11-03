import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../storage/object_store.dart';
import 'grading.dart';

/// A question with its options and (server-only) correct positions.
class LoadedQuestion {
  const LoadedQuestion({
    required this.row,
    required this.options,
    required this.correctPositions,
  });

  final ExerciseQuestion row;
  final List<ExerciseOption> options;
  final Set<int> correctPositions;

  int get id => row.id!;
  bool get multiSelect => row.multiSelect;
}

/// Loads an exercise with its questions, options and answer keys. The answer
/// keys are returned only to server code; no DTO builder here puts them in a
/// student model.
abstract final class ExerciseQueries {
  static Future<List<LoadedQuestion>> questions(
    Session session,
    int exerciseId,
  ) async {
    final rows = await ExerciseQuestion.db.find(
      session,
      where: (t) => t.exerciseId.equals(exerciseId),
      orderByList: (t) => [t.position.asc()],
    );
    if (rows.isEmpty) return const [];
    final ids = rows.map((row) => row.id!).toSet();
    final options = await ExerciseOption.db.find(
      session,
      where: (t) => t.questionId.inSet(ids),
      orderByList: (t) => [t.position.asc()],
    );
    final keys = await ExerciseAnswerKey.db.find(
      session,
      where: (t) => t.questionId.inSet(ids),
    );
    return [
      for (final row in rows)
        LoadedQuestion(
          row: row,
          options: [
            for (final option in options)
              if (option.questionId == row.id) option,
          ],
          correctPositions: {
            for (final key in keys)
              if (key.questionId == row.id) key.correctPosition,
          },
        ),
    ];
  }

  static List<GradeQuestion> gradeQuestions(List<LoadedQuestion> questions) => [
    for (final question in questions)
      GradeQuestion(
        questionId: question.id,
        multiSelect: question.multiSelect,
        correctPositions: question.correctPositions,
      ),
  ];

  static Future<StudentExerciseDetail> studentDetail(
    Session session, {
    required Exercise exercise,
    required ContentRecord content,
    required ObjectStore? store,
    ContentRecord? lesson,
    String? imageBaseUrl,
  }) async {
    final questions = await ExerciseQueries.questions(session, exercise.id!);
    final signedImages = <int, String>{};
    if (store != null) {
      for (final question in questions) {
        final path = question.row.imagePath;
        if (path == null || path.isEmpty) continue;
        signedImages[question.id] = (await store.signedGetUrl(
          session,
          path,
          expiresIn: const Duration(minutes: 30),
        )).toString();
      }
    }
    return StudentExerciseDetail(
      id: exercise.id!,
      contentId: content.id!,
      title: content.title,
      subject: content.subject,
      gradeLevel: content.gradeLevel,
      lessonContentId: exercise.lessonContentId,
      lessonTitle: lesson?.title,
      questions: [
        for (final question in questions)
          StudentQuestion(
            id: question.id,
            position: question.row.position,
            stem: question.row.stem,
            multiSelect: question.multiSelect,
            imageUrl: signedImages[question.id],
            options: [
              for (final option in question.options)
                StudentOption(
                  id: option.id!,
                  position: option.position,
                  text: option.text,
                ),
            ],
          ),
      ],
    );
  }

  static Future<TeacherExerciseDetail> teacherDetail(
    Session session, {
    required Exercise exercise,
    required ContentRecord content,
  }) async {
    final questions = await ExerciseQueries.questions(session, exercise.id!);
    return TeacherExerciseDetail(
      id: exercise.id!,
      contentId: content.id!,
      title: content.title,
      subject: content.subject,
      gradeLevel: content.gradeLevel,
      lessonContentId: exercise.lessonContentId,
      updatedAt: exercise.updatedAt,
      questions: [
        for (final question in questions)
          ExerciseQuestionInput(
            id: question.id,
            position: question.row.position,
            stem: question.row.stem,
            multiSelect: question.multiSelect,
            imagePath: question.row.imagePath,
            options: [for (final option in question.options) option.text],
            correctPositions: question.correctPositions.toList()..sort(),
          ),
      ],
    );
  }
}
