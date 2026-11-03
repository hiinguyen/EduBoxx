import 'package:serverpod/serverpod.dart';

import '../authz/edubox_endpoint.dart';
import '../authz/guard.dart';
import '../generated/protocol.dart';
import '../learning/access.dart';
import '../learning/assignment_service.dart';
import '../learning/exercise_service.dart';
import '../services/edubox_services.dart';

/// Teacher assignment authoring and the student's assignment list.
class AssignmentsEndpoint extends EduboxEndpoint {
  /// Creates or updates an assignment for one of the teacher's classes.
  ///
  /// Allowed: teacher. Denied: student, parent, not set up, unauthenticated.
  Future<TeacherAssignmentItem> save(
    Session session,
    AssignmentUpsert input,
  ) async {
    final caller = await requireRole(session, UserRole.teacher);
    final schoolClass = await LearningAccess.teacherClass(
      session,
      teacherId: caller.userId,
      classId: input.classId,
    );
    if (schoolClass == null) {
      throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
    }
    final exercise = await Exercise.db.findById(session, input.exerciseId);
    if (exercise == null || exercise.ownerTeacherId != caller.userId) {
      throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
    }
    if (input.title.trim().isEmpty) {
      throw ArgumentError.value(input.title, 'title', 'Required');
    }
    if (input.type == AssignmentType.test) {
      final limit = input.timeLimitSec;
      if (limit == null || limit <= 0) {
        throw ArgumentError.value(
          input.timeLimitSec,
          'timeLimitSec',
          'A test needs a positive time limit',
        );
      }
    } else if (input.timeLimitSec != null) {
      throw ArgumentError.value(
        input.timeLimitSec,
        'timeLimitSec',
        'A practice assignment has no time limit',
      );
    }
    final now = EduboxServices.now();
    Assignment assignment;
    if (input.id == null) {
      assignment = await Assignment.db.insertRow(
        session,
        Assignment(
          classId: input.classId,
          teacherId: caller.userId,
          exerciseId: input.exerciseId,
          type: input.type,
          title: input.title.trim(),
          dueAt: input.dueAt,
          timeLimitSec: input.timeLimitSec,
          createdAt: now,
          updatedAt: now,
        ),
      );
    } else {
      final existing = await Assignment.db.findById(session, input.id!);
      if (existing == null ||
          existing.teacherId != caller.userId ||
          existing.classId != input.classId) {
        throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
      }
      assignment = await Assignment.db.updateRow(
        session,
        existing.copyWith(
          exerciseId: input.exerciseId,
          type: input.type,
          title: input.title.trim(),
          dueAt: input.dueAt,
          timeLimitSec: input.timeLimitSec,
          updatedAt: now,
        ),
      );
    }
    final content = (await ContentRecord.db.findById(
      session,
      exercise.contentId,
    ))!;
    final submissions = await Submission.db.count(
      session,
      where: (t) => t.assignmentId.equals(assignment.id!),
    );
    final graded = await Submission.db.count(
      session,
      where: (t) =>
          t.assignmentId.equals(assignment.id!) &
          t.status.equals(SubmissionStatus.graded),
    );
    return TeacherAssignmentItem(
      id: assignment.id!,
      classId: assignment.classId,
      className: schoolClass.name,
      exerciseId: exercise.id!,
      exerciseTitle: content.title,
      type: assignment.type,
      title: assignment.title,
      dueAt: assignment.dueAt,
      timeLimitSec: assignment.timeLimitSec,
      submissionCount: submissions,
      gradedCount: graded,
      createdAt: assignment.createdAt,
    );
  }

  /// Deletes one of the teacher's own assignments (its submissions cascade).
  ///
  /// Allowed: the owning teacher. Denied: every other caller.
  Future<void> delete(Session session, {required int assignmentId}) async {
    final caller = await requireRole(session, UserRole.teacher);
    final assignment = await Assignment.db.findById(session, assignmentId);
    if (assignment == null || assignment.teacherId != caller.userId) {
      throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
    }
    await Assignment.db.deleteRow(session, assignment);
  }

  /// The teacher's assignments across their classes, newest first.
  ///
  /// Allowed: teacher. Denied: student, parent, not set up, unauthenticated.
  Future<List<TeacherAssignmentItem>> mine(Session session) async {
    final caller = await requireRole(session, UserRole.teacher);
    final assignments = await Assignment.db.find(
      session,
      where: (t) => t.teacherId.equals(caller.userId),
      orderByList: (t) => [t.createdAt.desc(), t.id.desc()],
    );
    if (assignments.isEmpty) return const [];
    final classIds = assignments.map((a) => a.classId).toSet();
    final classes = await SchoolClass.db.find(
      session,
      where: (t) => t.id.inSet(classIds),
    );
    final classById = {for (final c in classes) c.id!: c};
    final exerciseIds = assignments.map((a) => a.exerciseId).toSet();
    final exercises = await Exercise.db.find(
      session,
      where: (t) => t.id.inSet(exerciseIds),
    );
    final exerciseById = {for (final e in exercises) e.id!: e};
    final contentIds = exercises.map((e) => e.contentId).toSet();
    final contents = contentIds.isEmpty
        ? const <ContentRecord>[]
        : await ContentRecord.db.find(
            session,
            where: (t) => t.id.inSet(contentIds),
          );
    final contentById = {for (final c in contents) c.id!: c};
    final assignmentIds = assignments.map((a) => a.id!).toSet();
    final submissions = await Submission.db.find(
      session,
      where: (t) => t.assignmentId.inSet(assignmentIds),
    );
    return [
      for (final assignment in assignments)
        if (classById[assignment.classId] case final schoolClass?)
          if (exerciseById[assignment.exerciseId] case final exercise?)
            if (contentById[exercise.contentId] case final content?)
              TeacherAssignmentItem(
                id: assignment.id!,
                classId: assignment.classId,
                className: schoolClass.name,
                exerciseId: exercise.id!,
                exerciseTitle: content.title,
                type: assignment.type,
                title: assignment.title,
                dueAt: assignment.dueAt,
                timeLimitSec: assignment.timeLimitSec,
                submissionCount: submissions
                    .where((s) => s.assignmentId == assignment.id)
                    .length,
                gradedCount: submissions
                    .where(
                      (s) =>
                          s.assignmentId == assignment.id &&
                          s.status == SubmissionStatus.graded,
                    )
                    .length,
                createdAt: assignment.createdAt,
              ),
    ];
  }

  /// The student's assignments for their own classes.
  ///
  /// Allowed: student. Denied: teacher, parent, not set up, unauthenticated.
  Future<StudentAssignmentList> listForStudent(Session session) async {
    final caller = await requireRole(session, UserRole.student);
    final memberships = await ClassMember.db.find(
      session,
      where: (t) => t.studentId.equals(caller.userId),
    );
    final classIds = memberships.map((m) => m.classId).toSet();
    if (classIds.isEmpty) {
      return StudentAssignmentList(assignments: const []);
    }
    final assignments = await Assignment.db.find(
      session,
      where: (t) => t.classId.inSet(classIds),
      orderByList: (t) => [t.dueAt.asc(), t.id.desc()],
    );
    if (assignments.isEmpty) {
      return StudentAssignmentList(assignments: const []);
    }
    final classes = await SchoolClass.db.find(
      session,
      where: (t) => t.id.inSet(classIds),
    );
    final classById = {for (final c in classes) c.id!: c};
    final exerciseIds = assignments.map((a) => a.exerciseId).toSet();
    final exercises = await Exercise.db.find(
      session,
      where: (t) => t.id.inSet(exerciseIds),
    );
    final exerciseById = {for (final e in exercises) e.id!: e};
    final contentIds = exercises.map((e) => e.contentId).toSet();
    final contents = await ContentRecord.db.find(
      session,
      where: (t) => t.id.inSet(contentIds),
    );
    final contentById = {for (final c in contents) c.id!: c};
    final lessonIds = exercises
        .map((e) => e.lessonContentId)
        .whereType<int>()
        .toSet();
    final lessons = lessonIds.isEmpty
        ? const <ContentRecord>[]
        : await ContentRecord.db.find(
            session,
            where: (t) => t.id.inSet(lessonIds),
          );
    final lessonById = {for (final c in lessons) c.id!: c};
    final submissions = await AssignmentQueries.latestSubmissions(
      session,
      studentId: caller.userId,
      assignmentIds: assignments.map((a) => a.id!).toSet(),
    );
    final items = <StudentAssignmentItem>[];
    for (final assignment in assignments) {
      final exercise = exerciseById[assignment.exerciseId];
      final content = exercise == null ? null : contentById[exercise.contentId];
      final schoolClass = classById[assignment.classId];
      if (exercise == null || content == null || schoolClass == null) continue;
      items.add(
        await AssignmentQueries.itemFor(
          session,
          assignment: assignment,
          exercise: exercise,
          content: content,
          schoolClass: schoolClass,
          submission: submissions[assignment.id],
          lesson: exercise.lessonContentId == null
              ? null
              : lessonById[exercise.lessonContentId],
        ),
      );
    }
    items.sort((a, b) {
      final aDue = a.dueAt;
      final bDue = b.dueAt;
      if (aDue == null && bDue == null) return b.id.compareTo(a.id);
      if (aDue == null) return 1;
      if (bDue == null) return -1;
      return aDue.compareTo(bDue);
    });
    return StudentAssignmentList(assignments: items);
  }

  /// One assignment with its exercise and lesson state, for the student's
  /// lesson-and-exercise screen.
  ///
  /// Allowed: a student of the assignment's class. Denied: every other caller.
  Future<StudentAssignmentDetail> detailForStudent(
    Session session, {
    required int assignmentId,
  }) async {
    final caller = await requireRole(session, UserRole.student);
    final assignment = await Assignment.db.findById(session, assignmentId);
    if (assignment == null ||
        !await LearningAccess.studentInClass(
          session,
          studentId: caller.userId,
          classId: assignment.classId,
        )) {
      throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
    }
    final exercise = (await Exercise.db.findById(
      session,
      assignment.exerciseId,
    ))!;
    final content = (await ContentRecord.db.findById(
      session,
      exercise.contentId,
    ))!;
    final schoolClass = (await SchoolClass.db.findById(
      session,
      assignment.classId,
    ))!;
    final lesson = exercise.lessonContentId == null
        ? null
        : await ContentRecord.db.findById(session, exercise.lessonContentId!);
    final submission = await Submission.db.findFirstRow(
      session,
      where: (t) =>
          t.assignmentId.equals(assignmentId) &
          t.studentId.equals(caller.userId),
      orderByList: (t) => [t.updatedAt.desc()],
    );
    final progress = lesson == null
        ? null
        : await ProgressEntry.db.findFirstRow(
            session,
            where: (t) =>
                t.studentId.equals(caller.userId) &
                t.contentId.equals(lesson.id!),
          );
    final item = await AssignmentQueries.itemFor(
      session,
      assignment: assignment,
      exercise: exercise,
      content: content,
      schoolClass: schoolClass,
      submission: submission,
      lesson: lesson,
    );
    return StudentAssignmentDetail(
      assignment: item,
      exercise: await ExerciseQueries.studentDetail(
        session,
        exercise: exercise,
        content: content,
        store: EduboxServices.storageFor(session),
        lesson: lesson,
      ),
      lessonCompleted: progress != null,
    );
  }
}
