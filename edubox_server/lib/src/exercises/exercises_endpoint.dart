import 'package:serverpod/serverpod.dart';

import '../authz/edubox_endpoint.dart';
import '../authz/guard.dart';
import '../generated/protocol.dart';
import '../learning/access.dart';
import '../learning/exercise_service.dart';
import '../services/edubox_services.dart';

/// Exercise authoring (teacher) and reading (teacher).
class ExercisesEndpoint extends EduboxEndpoint {
  /// Creates or replaces an exercise and its questions. Editing bumps the
  /// answer-key version; submissions keep the snapshot they started with.
  ///
  /// Allowed: teacher. Denied: student, parent, not set up, unauthenticated.
  Future<TeacherExerciseDetail> save(
    Session session,
    ExerciseUpsert input,
  ) async {
    final caller = await requireRole(session, UserRole.teacher);
    final teacherClass = await LearningAccess.teacherClass(
      session,
      teacherId: caller.userId,
      classId: input.classId,
    );
    if (teacherClass == null) {
      throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
    }
    _validate(input);
    if (input.lessonContentId != null) {
      final lesson = await LearningAccess.ownedContent(
        session,
        teacherId: caller.userId,
        contentId: input.lessonContentId!,
      );
      if (lesson == null ||
          lesson.type == ContentType.exercise ||
          lesson.status != ContentStatus.approved) {
        throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
      }
    }
    final now = EduboxServices.now();
    ContentRecord? existingContent;
    Exercise? existingExercise;
    List<ExerciseQuestion> oldQuestions = const [];
    if (input.contentId != null) {
      existingContent = await LearningAccess.ownedContent(
        session,
        teacherId: caller.userId,
        contentId: input.contentId!,
      );
      if (existingContent == null ||
          existingContent.type != ContentType.exercise) {
        throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
      }
      existingExercise = await Exercise.db.findFirstRow(
        session,
        where: (t) => t.contentId.equals(existingContent!.id!),
      );
      if (existingExercise == null) {
        throw StateError('Exercise row missing for content ${input.contentId}');
      }
      oldQuestions = await ExerciseQuestion.db.find(
        session,
        where: (t) => t.exerciseId.equals(existingExercise!.id!),
      );
    }
    final contentId = await session.db.transaction((transaction) async {
      ContentRecord content;
      Exercise exercise;
      if (existingContent == null) {
        content = await ContentRecord.db.insertRow(
          session,
          ContentRecord(
            ownerTeacherId: caller.userId,
            type: ContentType.exercise,
            subject: input.subject.trim(),
            gradeLevel: input.gradeLevel,
            title: input.title.trim(),
            ingestStatus: IngestStatus.ready,
            status: ContentStatus.approved,
            approvedBy: caller.userId,
            createdAt: now,
          ),
          transaction: transaction,
        );
        await ContentClass.db.insertRow(
          session,
          ContentClass(contentId: content.id!, classId: input.classId),
          transaction: transaction,
        );
        exercise = await Exercise.db.insertRow(
          session,
          Exercise(
            contentId: content.id!,
            ownerTeacherId: caller.userId,
            lessonContentId: input.lessonContentId,
            answerKeyVersion: 1,
            createdAt: now,
            updatedAt: now,
          ),
          transaction: transaction,
        );
      } else {
        content = await ContentRecord.db.updateRow(
          session,
          existingContent.copyWith(
            title: input.title.trim(),
            subject: input.subject.trim(),
            gradeLevel: input.gradeLevel,
          ),
          transaction: transaction,
        );
        await ContentClass.db.deleteWhere(
          session,
          where: (t) => t.contentId.equals(content.id!),
          transaction: transaction,
        );
        await ContentClass.db.insertRow(
          session,
          ContentClass(contentId: content.id!, classId: input.classId),
          transaction: transaction,
        );
        exercise = await Exercise.db.updateRow(
          session,
          existingExercise!.copyWith(
            lessonContentId: input.lessonContentId,
            answerKeyVersion: existingExercise.answerKeyVersion + 1,
            updatedAt: now,
          ),
          transaction: transaction,
        );
        final oldIds = oldQuestions.map((q) => q.id!).toSet();
        if (oldIds.isNotEmpty) {
          await ExerciseAnswerKey.db.deleteWhere(
            session,
            where: (t) => t.questionId.inSet(oldIds),
            transaction: transaction,
          );
          await ExerciseOption.db.deleteWhere(
            session,
            where: (t) => t.questionId.inSet(oldIds),
            transaction: transaction,
          );
          await ExerciseQuestion.db.deleteWhere(
            session,
            where: (t) => t.id.inSet(oldIds),
            transaction: transaction,
          );
        }
      }
      for (final (index, question) in input.questions.indexed) {
        final row = await ExerciseQuestion.db.insertRow(
          session,
          ExerciseQuestion(
            exerciseId: exercise.id!,
            position: index,
            stem: question.stem.trim(),
            multiSelect: question.multiSelect,
            imagePath: question.imagePath,
          ),
          transaction: transaction,
        );
        for (final (optionIndex, text) in question.options.indexed) {
          await ExerciseOption.db.insertRow(
            session,
            ExerciseOption(
              questionId: row.id!,
              position: optionIndex,
              text: text.trim(),
            ),
            transaction: transaction,
          );
        }
        for (final position in question.correctPositions) {
          await ExerciseAnswerKey.db.insertRow(
            session,
            ExerciseAnswerKey(
              questionId: row.id!,
              correctPosition: position,
            ),
            transaction: transaction,
          );
        }
      }
      return content.id!;
    });
    final content = (await ContentRecord.db.findById(session, contentId))!;
    final exercise = (await Exercise.db.findFirstRow(
      session,
      where: (t) => t.contentId.equals(contentId),
    ))!;
    return ExerciseQueries.teacherDetail(
      session,
      exercise: exercise,
      content: content,
    );
  }

  /// One of the teacher's own exercises, with its answer key.
  ///
  /// Allowed: the owning teacher. Denied: every other caller.
  Future<TeacherExerciseDetail> detail(
    Session session, {
    required int exerciseId,
  }) async {
    final caller = await requireRole(session, UserRole.teacher);
    final exercise = await Exercise.db.findById(session, exerciseId);
    if (exercise == null || exercise.ownerTeacherId != caller.userId) {
      throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
    }
    final content = (await ContentRecord.db.findById(
      session,
      exercise.contentId,
    ))!;
    return ExerciseQueries.teacherDetail(
      session,
      exercise: exercise,
      content: content,
    );
  }

  /// The teacher's exercises for the assignment editor.
  ///
  /// Allowed: teacher. Denied: student, parent, not set up, unauthenticated.
  Future<List<TeacherExerciseSummary>> mine(Session session) async {
    final caller = await requireRole(session, UserRole.teacher);
    final exercises = await Exercise.db.find(
      session,
      where: (t) => t.ownerTeacherId.equals(caller.userId),
      orderByList: (t) => [t.updatedAt.desc()],
    );
    if (exercises.isEmpty) return const [];
    final contentIds = exercises.map((e) => e.contentId).toSet();
    final contents = await ContentRecord.db.find(
      session,
      where: (t) => t.id.inSet(contentIds),
    );
    final contentById = {for (final c in contents) c.id!: c};
    final exerciseIds = exercises.map((e) => e.id!).toSet();
    final questions = await ExerciseQuestion.db.find(
      session,
      where: (t) => t.exerciseId.inSet(exerciseIds),
    );
    return [
      for (final exercise in exercises)
        if (contentById[exercise.contentId] case final content?)
          TeacherExerciseSummary(
            id: exercise.id!,
            contentId: content.id!,
            title: content.title,
            subject: content.subject,
            gradeLevel: content.gradeLevel,
            questionCount: questions
                .where((q) => q.exerciseId == exercise.id)
                .length,
            updatedAt: exercise.updatedAt,
          ),
    ];
  }

  static void _validate(ExerciseUpsert input) {
    if (input.title.trim().isEmpty) {
      throw ArgumentError.value(input.title, 'title', 'Required');
    }
    if (input.questions.isEmpty) {
      throw ArgumentError.value(input.questions, 'questions', 'Required');
    }
    if (input.questions.length > 100) {
      throw ArgumentError.value(input.questions, 'questions', 'Too many');
    }
    for (final question in input.questions) {
      if (question.stem.trim().isEmpty) {
        throw ArgumentError.value(question.stem, 'stem', 'Required');
      }
      if (question.options.length < 2 || question.options.length > 6) {
        throw ArgumentError.value(
          question.options,
          'options',
          'Must have 2-6 options',
        );
      }
      if (question.options.any((option) => option.trim().isEmpty)) {
        throw ArgumentError.value(question.options, 'options', 'Empty option');
      }
      final correct = question.correctPositions.toSet();
      if (correct.isEmpty ||
          correct.length != question.correctPositions.length) {
        throw ArgumentError.value(
          question.correctPositions,
          'correctPositions',
          'Must be non-empty and unique',
        );
      }
      if (correct.any(
        (index) => index < 0 || index >= question.options.length,
      )) {
        throw ArgumentError.value(
          question.correctPositions,
          'correctPositions',
          'Out of range',
        );
      }
      if (!question.multiSelect && correct.length > 1) {
        throw ArgumentError.value(
          question.correctPositions,
          'correctPositions',
          'Single-select question cannot have several answers',
        );
      }
    }
  }
}
