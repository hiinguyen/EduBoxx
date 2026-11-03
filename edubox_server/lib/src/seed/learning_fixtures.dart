import 'dart:typed_data';

import 'package:edubox_fixtures/edubox_fixtures.dart';
import 'package:serverpod/serverpod.dart';

import '../content/content_ingest.dart';
import '../generated/protocol.dart';
import '../storage/object_store.dart';
import 'fixture_files.dart';
import 'fixture_loader.dart';

/// The stable keys of the seeded learning data.
abstract final class LearningFixtureKeys {
  static const fractions = 'fractions';
  static const practice = 'practice';
  static const test = 'test';
  static const attempt = 'attempt';
  static const tutorChat = 'tutor_chat';
}

/// Adds the phase 2-6 demo data on top of the phase 1 fixture set: real
/// files for the e-books/videos, one exercise with an answer key, a practice
/// assignment, a short test, one graded attempt, and a tutor transcript.
///
/// The exercise and assignments are created for class 7A, so the seeded
/// student An has a complete learning loop immediately after `reset`.
Future<void> loadLearningFixtures(
  Session session,
  SeededFixtures seeded, {
  ObjectStore? store,
}) async {
  final now = DateTime.now().toUtc();
  await _attachFixtureFiles(session, seeded, store);
  final exercise = await _exercise(session, seeded);
  final assignments = await _assignments(
    session,
    seeded,
    exerciseId: exercise.exerciseId,
    questionIds: exercise.questionIds,
    now: now,
  );
  seeded.exerciseIds[LearningFixtureKeys.fractions] = exercise.exerciseId;
  seeded.assignmentIds[LearningFixtureKeys.practice] = assignments.practiceId;
  seeded.assignmentIds[LearningFixtureKeys.test] = assignments.testId;
  final submissionId = await _gradedAttempt(
    session,
    seeded,
    assignmentId: assignments.practiceId,
    questionIds: exercise.questionIds,
    now: now,
  );
  if (submissionId != null) {
    seeded.submissionIds[LearningFixtureKeys.attempt] = submissionId;
  }
  final chatId = await _tutorChat(session, seeded, now: now);
  if (chatId != null) {
    seeded.chatIds[LearningFixtureKeys.tutorChat] = chatId;
  }
}

/// Sets the file metadata even when [store] is null (tests that only check
/// metadata). The object is uploaded only when a store is supplied.
Future<void> _attachFixtureFiles(
  Session session,
  SeededFixtures seeded,
  ObjectStore? store,
) async {
  for (final fixture in seeded.fixtures.content) {
    if (fixture.type == FixtureContentType.exercise) continue;
    final bytes = fixture.type == FixtureContentType.ebook
        ? samplePdf()
        : sampleMp4();
    final extension = fixture.type == FixtureContentType.ebook ? 'pdf' : 'mp4';
    final path = 'seed/${fixture.key}.$extension';
    if (store != null) {
      await store.put(
        session,
        path,
        ByteData.sublistView(Uint8List.fromList(bytes)),
        contentType: fixture.type == FixtureContentType.ebook
            ? 'application/pdf'
            : 'video/mp4',
      );
    }
    final row = await ContentRecord.db.findById(
      session,
      seeded.contentIds[fixture.key]!,
    );
    if (row == null) continue;
    await ContentRecord.db.updateRow(
      session,
      row.copyWith(
        storagePath: path,
        originalFileName: fixture.key,
        mimeType: fixture.type == FixtureContentType.ebook
            ? 'application/pdf'
            : 'video/mp4',
        sizeBytes: bytes.length,
        pageCount: fixture.type == FixtureContentType.ebook
            ? ContentIngest.pdfPageCount(bytes)
            : null,
        durationSeconds: fixture.type == FixtureContentType.video
            ? ContentIngest.mp4DurationSeconds(bytes)
            : null,
        ingestStatus: IngestStatus.ready,
      ),
    );
  }
}

Future<({int exerciseId, List<int> questionIds})> _exercise(
  Session session,
  SeededFixtures seeded,
) async {
  final contentId = seeded.contentIds[FixtureKeys.exerciseFractions]!;
  final existing = await Exercise.db.findFirstRow(
    session,
    where: (t) => t.contentId.equals(contentId),
  );
  if (existing != null) {
    final questions = await ExerciseQuestion.db.find(
      session,
      where: (t) => t.exerciseId.equals(existing.id!),
      orderByList: (t) => [t.position.asc()],
    );
    return (
      exerciseId: existing.id!,
      questionIds: [for (final question in questions) question.id!],
    );
  }
  final now = DateTime.now().toUtc();
  final exercise = await Exercise.db.insertRow(
    session,
    Exercise(
      contentId: contentId,
      ownerTeacherId: seeded.userIds[FixtureKeys.teacherLan]!,
      lessonContentId: seeded.contentIds[FixtureKeys.ebookFractions],
      answerKeyVersion: 1,
      createdAt: now,
      updatedAt: now,
    ),
  );
  final questions = [
    ('1/2 + 1/4 = ?', false, ['1/6', '3/4', '2/6', '1/8'], [1]),
    ('2/3 + 1/6 = ?', false, ['3/9', '5/6', '1/3', '3/6'], [1]),
    ('Phân số nào bằng 1/2?', true, ['2/4', '3/6', '2/3', '4/8'], [0, 1, 3]),
  ];
  final ids = <int>[];
  for (final (position, question) in questions.indexed) {
    final row = await ExerciseQuestion.db.insertRow(
      session,
      ExerciseQuestion(
        exerciseId: exercise.id!,
        position: position,
        stem: question.$1,
        multiSelect: question.$2,
      ),
    );
    ids.add(row.id!);
    for (final (optionIndex, text) in question.$3.indexed) {
      await ExerciseOption.db.insertRow(
        session,
        ExerciseOption(
          questionId: row.id!,
          position: optionIndex,
          text: text,
        ),
      );
    }
    for (final correct in question.$4) {
      await ExerciseAnswerKey.db.insertRow(
        session,
        ExerciseAnswerKey(
          questionId: row.id!,
          correctPosition: correct,
        ),
      );
    }
  }
  return (exerciseId: exercise.id!, questionIds: ids);
}

Future<({int practiceId, int testId})> _assignments(
  Session session,
  SeededFixtures seeded, {
  required int exerciseId,
  required List<int> questionIds,
  required DateTime now,
}) async {
  final existing = await Assignment.db.find(
    session,
    where: (t) =>
        t.classId.equals(seeded.classIds[FixtureKeys.class7A]!) &
        t.exerciseId.equals(exerciseId),
    orderByList: (t) => [t.createdAt.asc()],
  );
  if (existing.length >= 2) {
    return (practiceId: existing.first.id!, testId: existing.last.id!);
  }
  if (existing.length == 1) {
    final test = await Assignment.db.insertRow(
      session,
      Assignment(
        classId: seeded.classIds[FixtureKeys.class7A]!,
        teacherId: seeded.userIds[FixtureKeys.teacherLan]!,
        exerciseId: exerciseId,
        type: AssignmentType.test,
        title: 'Kiểm tra nhanh: Phân số',
        dueAt: now.add(const Duration(days: 5)),
        timeLimitSec: 120,
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
    );
    return (practiceId: existing.first.id!, testId: test.id!);
  }
  final teacherId = seeded.userIds[FixtureKeys.teacherLan]!;
  final classId = seeded.classIds[FixtureKeys.class7A]!;
  final practice = await Assignment.db.insertRow(
    session,
    Assignment(
      classId: classId,
      teacherId: teacherId,
      exerciseId: exerciseId,
      type: AssignmentType.practice,
      title: 'Luyện tập: Phép cộng phân số',
      dueAt: now.add(const Duration(days: 3)),
      createdAt: now.subtract(const Duration(hours: 1)),
      updatedAt: now.subtract(const Duration(hours: 1)),
    ),
  );
  final test = await Assignment.db.insertRow(
    session,
    Assignment(
      classId: classId,
      teacherId: teacherId,
      exerciseId: exerciseId,
      type: AssignmentType.test,
      title: 'Kiểm tra nhanh: Phân số',
      dueAt: now.add(const Duration(days: 5)),
      timeLimitSec: 120,
      createdAt: now.subtract(const Duration(hours: 2)),
      updatedAt: now.subtract(const Duration(hours: 2)),
    ),
  );
  return (practiceId: practice.id!, testId: test.id!);
}

Future<int?> _gradedAttempt(
  Session session,
  SeededFixtures seeded, {
  required int assignmentId,
  required List<int> questionIds,
  required DateTime now,
}) async {
  final studentId = seeded.userIds[FixtureKeys.studentAn]!;
  final existing = await Submission.db.findFirstRow(
    session,
    where: (t) =>
        t.assignmentId.equals(assignmentId) & t.studentId.equals(studentId),
  );
  if (existing != null) return existing.id;
  final questions = await ExerciseQueriesBridge.questions(
    session,
    seeded.exerciseIds[LearningFixtureKeys.fractions] ??
        (await Exercise.db.findFirstRow(
          session,
          where: (t) => t.contentId.equals(
            seeded.contentIds[FixtureKeys.exerciseFractions]!,
          ),
        ))!.id!,
  );
  final snapshot = questions;
  final row = await Submission.db.insertRow(
    session,
    Submission(
      assignmentId: assignmentId,
      studentId: studentId,
      clientSubmissionId: 'seed-practice-attempt',
      status: SubmissionStatus.graded,
      answersJson:
          '{"${questionIds[0]}":[1],"${questionIds[1]}":[1],'
          '"${questionIds[2]}":[0,1,3]}',
      answerKeySnapshotJson: snapshot,
      answerKeyVersion: 1,
      score: 10,
      maxScore: 10,
      late: false,
      submittedAt: now.subtract(const Duration(hours: 2)),
      gradedAt: now.subtract(const Duration(hours: 2)),
      gradedBy: GradedBy.auto,
      createdAt: now.subtract(const Duration(hours: 2)),
      updatedAt: now.subtract(const Duration(hours: 2)),
    ),
  );
  return row.id;
}

Future<int?> _tutorChat(
  Session session,
  SeededFixtures seeded, {
  required DateTime now,
}) async {
  final studentId = seeded.userIds[FixtureKeys.studentAn]!;
  final existing = await AiChat.db.findFirstRow(
    session,
    where: (t) => t.studentId.equals(studentId),
  );
  if (existing != null) return existing.id;
  final chat = await AiChat.db.insertRow(
    session,
    AiChat(
      studentId: studentId,
      subject: 'Toán',
      classId: seeded.classIds[FixtureKeys.class7A]!,
      title: 'Cách cộng hai phân số khác mẫu',
      createdAt: now.subtract(const Duration(days: 1)),
      updatedAt: now.subtract(const Duration(days: 1)),
    ),
  );
  await AiMessage.db.insert(session, [
    AiMessage(
      chatId: chat.id!,
      role: ChatRole.student,
      content: 'Làm sao để cộng 1/2 và 1/4 ạ?',
      position: 0,
      createdAt: now.subtract(const Duration(days: 1)),
    ),
    AiMessage(
      chatId: chat.id!,
      role: ChatRole.tutor,
      content:
          'Em quy đồng mẫu số: 1/2 = 2/4, rồi cộng 2/4 + 1/4 = 3/4. '
          'Em thử tự làm một ví dụ khác nhé.',
      position: 1,
      createdAt: now.subtract(const Duration(days: 1)),
    ),
  ]);
  return chat.id;
}

/// A tiny indirection so this seed file does not import the whole exercise
/// query service just to snapshot the key.
abstract final class ExerciseQueriesBridge {
  static Future<String?> questions(Session session, int exerciseId) async {
    final rows = await ExerciseQuestion.db.find(
      session,
      where: (t) => t.exerciseId.equals(exerciseId),
      orderByList: (t) => [t.position.asc()],
    );
    if (rows.isEmpty) return null;
    final ids = rows.map((row) => row.id!).toSet();
    final keys = await ExerciseAnswerKey.db.find(
      session,
      where: (t) => t.questionId.inSet(ids),
    );
    return '{"questions":{${[
      for (final row in rows) '"${row.id}":[${[
          for (final key in keys)
            if (key.questionId == row.id) '${key.correctPosition}',
        ].join(',')}]',
    ].join(',')}}}';
  }
}
