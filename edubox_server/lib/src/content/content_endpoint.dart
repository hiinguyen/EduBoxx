import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../authz/edubox_endpoint.dart';
import '../authz/guard.dart';
import '../classes/class_queries.dart';
import '../generated/protocol.dart';
import '../learning/access.dart';
import '../storage/object_store.dart';
import '../services/edubox_services.dart';
import 'content_ingest.dart';

/// Content, from the student's and the teacher's sides.
class ContentEndpoint extends EduboxEndpoint {
  /// The calling student's classes and the `approved` content scoped to at
  /// least one of them, newest first. Draft content and other classes'
  /// content are never returned.
  ///
  /// Allowed: student. Denied: teacher, parent, not set up, unauthenticated.
  Future<StudentLibrary> library(Session session) async {
    final caller = await requireRole(session, UserRole.student);
    final memberships = await ClassMember.db.find(
      session,
      where: (t) => t.studentId.equals(caller.userId),
    );
    final classIds = memberships.map((m) => m.classId).toSet();
    if (classIds.isEmpty) {
      return StudentLibrary(classes: const [], items: const []);
    }
    final classes = await SchoolClass.db.find(
      session,
      where: (t) => t.id.inSet(classIds),
      orderByList: (t) => [t.gradeLevel.asc(), t.name.asc()],
    );
    final subjects = await subjectsByClass(session, classIds);
    final scope = await ContentClass.db.find(
      session,
      where: (t) => t.classId.inSet(classIds),
    );
    final contentIds = scope.map((s) => s.contentId).toSet();
    final items = contentIds.isEmpty
        ? const <ContentRecord>[]
        : await ContentRecord.db.find(
            session,
            where: (t) =>
                t.id.inSet(contentIds) &
                t.status.equals(ContentStatus.approved),
            orderByList: (t) => [
              t.createdAt.desc(),
              t.id.desc(),
            ],
          );
    return StudentLibrary(
      classes: [
        for (final c in classes)
          StudentClass(
            id: c.id!,
            name: c.name,
            gradeLevel: c.gradeLevel,
            subjects: subjects[c.id!] ?? const [],
          ),
      ],
      items: [
        for (final item in items)
          LibraryItem(
            id: item.id!,
            type: item.type,
            title: item.title,
            subject: item.subject,
            gradeLevel: item.gradeLevel,
            createdAt: item.createdAt,
            hasFile: item.storagePath != null && item.storagePath!.isNotEmpty,
            mimeType: item.mimeType,
            sizeBytes: item.sizeBytes,
            pageCount: item.pageCount,
            durationSeconds: item.durationSeconds,
          ),
      ],
    );
  }

  /// One content item's metadata. A student may read only approved content of
  /// their classes; a teacher only their own content.
  ///
  /// Allowed: student, teacher. Denied: parent, not set up, unauthenticated.
  Future<ContentDetail> detail(
    Session session, {
    required int contentId,
  }) async {
    final caller = await requireCaller(
      session,
      allowedRoles: {UserRole.student, UserRole.teacher},
    );
    final content = await ContentRecord.db.findById(session, contentId);
    if (content == null) {
      throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
    }
    final allowed = switch (caller.role) {
      UserRole.teacher => content.ownerTeacherId == caller.userId,
      UserRole.student => await LearningAccess.studentSeesContent(
        session,
        studentId: caller.userId,
        content: content,
      ),
      _ => false,
    };
    if (!allowed) {
      throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
    }
    final completed = await ProgressEntry.db.findFirstRow(
      session,
      where: (t) =>
          t.studentId.equals(caller.userId) & t.contentId.equals(content.id!),
    );
    return ContentDetail(
      id: content.id!,
      type: content.type,
      title: content.title,
      subject: content.subject,
      gradeLevel: content.gradeLevel,
      hasFile: content.storagePath != null && content.storagePath!.isNotEmpty,
      mimeType: content.mimeType,
      sizeBytes: content.sizeBytes,
      pageCount: content.pageCount,
      durationSeconds: content.durationSeconds,
      createdAt: content.createdAt,
      lessonCompleted: completed != null,
    );
  }

  /// The teacher's own content, newest first. Exercises appear with their
  /// exercise id so the assignment editor can link them.
  ///
  /// Allowed: teacher. Denied: student, parent, not set up, unauthenticated.
  Future<List<TeacherContentItem>> teacherList(Session session) async {
    final caller = await requireRole(session, UserRole.teacher);
    final rows = await ContentRecord.db.find(
      session,
      where: (t) => t.ownerTeacherId.equals(caller.userId),
      orderByList: (t) => [t.createdAt.desc(), t.id.desc()],
    );
    if (rows.isEmpty) return const [];
    final ids = rows.map((row) => row.id!).toSet();
    final scope = await ContentClass.db.find(
      session,
      where: (t) => t.contentId.inSet(ids),
    );
    final classIds = scope.map((row) => row.classId).toSet();
    final classes = classIds.isEmpty
        ? const <SchoolClass>[]
        : await SchoolClass.db.find(
            session,
            where: (t) => t.id.inSet(classIds),
          );
    final classNames = {for (final c in classes) c.id!: c.name};
    final exercises = await Exercise.db.find(
      session,
      where: (t) => t.contentId.inSet(ids),
    );
    final exerciseIdByContent = {
      for (final exercise in exercises) exercise.contentId: exercise.id!,
    };
    return [
      for (final row in rows)
        StudentContentMapper.teacherItem(
          row,
          classNames: [
            for (final entry in scope)
              if (entry.contentId == row.id) ?classNames[entry.classId],
          ],
          exerciseId: exerciseIdByContent[row.id!],
        ),
    ];
  }

  /// Creates a draft content row and a direct-to-storage upload ticket.
  /// The file is not trusted until [completeUpload] validates it.
  ///
  /// Allowed: teacher. Denied: student, parent, not set up, unauthenticated.
  Future<UploadTicket> createUpload(
    Session session, {
    required int classId,
    required ContentType type,
    required String title,
    required String subject,
    required int gradeLevel,
    required String fileName,
    required int sizeBytes,
  }) async {
    final caller = await requireRole(session, UserRole.teacher);
    if (type == ContentType.exercise) {
      throw ArgumentError.value(type, 'type', 'Exercises have no upload');
    }
    if (await LearningAccess.teacherClass(
          session,
          teacherId: caller.userId,
          classId: classId,
        ) ==
        null) {
      throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
    }
    final cleanTitle = title.trim();
    if (cleanTitle.isEmpty) {
      throw ArgumentError.value(title, 'title', 'Required');
    }
    if (gradeLevel < 1 || gradeLevel > 12) {
      throw ArgumentError.value(gradeLevel, 'gradeLevel', 'Must be 1-12');
    }
    final config = EduboxServices.configFor(session);
    final maxBytes = type == ContentType.ebook
        ? config.learning.maxEbookBytes
        : config.learning.maxVideoBytes;
    if (sizeBytes <= 0 || sizeBytes > maxBytes) {
      throw ArgumentError.value(sizeBytes, 'sizeBytes', 'Outside the limit');
    }
    final extension = _extensionOf(fileName, type);
    final path =
        'content/${caller.userId}/$classId/'
        '${const Uuid().v4()}.$extension';
    final row = await ContentRecord.db.insertRow(
      session,
      ContentRecord(
        ownerTeacherId: caller.userId,
        type: type,
        subject: subject.trim(),
        gradeLevel: gradeLevel,
        title: cleanTitle,
        storagePath: path,
        originalFileName: fileName,
        sizeBytes: sizeBytes,
        ingestStatus: IngestStatus.processing,
        status: ContentStatus.draft,
        createdAt: EduboxServices.now(),
      ),
    );
    await ContentClass.db.insertRow(
      session,
      ContentClass(contentId: row.id!, classId: classId),
    );
    try {
      final url = await EduboxServices.storageFor(session).signedPutUrl(
        session,
        path,
        expiresIn: const Duration(minutes: 15),
      );
      return UploadTicket(
        contentId: row.id!,
        url: url.toString(),
        method: 'PUT',
        headers: const {'Content-Type': 'application/octet-stream'},
        expiresAt: EduboxServices.now().add(const Duration(minutes: 15)),
      );
    } catch (_) {
      // Do not leave an unusable draft behind when the store cannot issue
      // an upload ticket.
      await ContentClass.db.deleteWhere(
        session,
        where: (t) => t.contentId.equals(row.id!),
      );
      await ContentRecord.db.deleteRow(session, row);
      rethrow;
    }
  }

  /// Verifies and ingests a file uploaded through [createUpload]. Marks the
  /// content `ready` with normalized metadata, or `rejected` with a reason.
  ///
  /// Allowed: the owning teacher. Denied: every other caller.
  Future<TeacherContentItem> completeUpload(
    Session session, {
    required int contentId,
  }) async {
    final caller = await requireRole(session, UserRole.teacher);
    final content = await LearningAccess.ownedContent(
      session,
      teacherId: caller.userId,
      contentId: contentId,
    );
    if (content == null) {
      throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
    }
    final path = content.storagePath;
    if (path == null || path.isEmpty) {
      throw StateError('Content $contentId has no storage path');
    }
    final store = EduboxServices.storageFor(session);
    final ByteData bytes;
    try {
      bytes = await store.get(session, path);
    } on ObjectNotFoundException {
      final rejected = await ContentRecord.db.updateRow(
        session,
        content.copyWith(
          ingestStatus: IngestStatus.rejected,
          ingestReason: 'Không tìm thấy tệp đã tải lên.',
        ),
      );
      return StudentContentMapper.teacherItem(
        rejected,
        classNames: await _classNamesOf(session, contentId),
      );
    }
    final config = EduboxServices.configFor(session);
    try {
      final ingest = ContentIngest.validate(
        type: content.type,
        bytes: FixtureBytes.from(bytes),
        fileName: content.originalFileName ?? path,
        limits: config.learning,
      );
      final updated = await ContentRecord.db.updateRow(
        session,
        content.copyWith(
          ingestStatus: IngestStatus.ready,
          ingestReason: null,
          mimeType: ingest.mimeType,
          sizeBytes: ingest.sizeBytes,
          pageCount: ingest.pageCount,
          durationSeconds: ingest.durationSeconds,
        ),
      );
      return StudentContentMapper.teacherItem(
        updated,
        classNames: await _classNamesOf(session, contentId),
        exerciseId: null,
      );
    } on IngestRejected catch (error) {
      try {
        await store.deletePrefix(session, path);
      } catch (_) {
        // A rejected object left behind is invisible to students.
      }
      final rejected = await ContentRecord.db.updateRow(
        session,
        content.copyWith(
          ingestStatus: IngestStatus.rejected,
          ingestReason: error.reason,
          storagePath: null,
        ),
      );
      return StudentContentMapper.teacherItem(
        rejected,
        classNames: await _classNamesOf(session, contentId),
      );
    }
  }

  /// Moves the owning teacher's ready content from draft to approved.
  ///
  /// Allowed: the owning teacher. Denied: every other caller.
  Future<TeacherContentItem> approve(
    Session session, {
    required int contentId,
  }) async {
    final caller = await requireRole(session, UserRole.teacher);
    final content = await LearningAccess.ownedContent(
      session,
      teacherId: caller.userId,
      contentId: contentId,
    );
    if (content == null) {
      throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
    }
    final ingest = content.ingestStatus ?? IngestStatus.ready;
    if (content.type != ContentType.exercise && ingest != IngestStatus.ready) {
      throw StateError('Content is not ready to approve');
    }
    final updated = await ContentRecord.db.updateRow(
      session,
      content.copyWith(
        status: ContentStatus.approved,
        approvedBy: caller.userId,
      ),
    );
    final exercise = await Exercise.db.findFirstRow(
      session,
      where: (t) => t.contentId.equals(contentId),
    );
    return StudentContentMapper.teacherItem(
      updated,
      classNames: await _classNamesOf(session, contentId),
      exerciseId: exercise?.id,
    );
  }

  /// A short-lived signed URL for the content file. Only the owning teacher
  /// or a student of a class the approved content belongs to may read it.
  ///
  /// Allowed: student, teacher. Denied: parent, not set up, unauthenticated.
  Future<SignedFileUrl> fileUrl(
    Session session, {
    required int contentId,
  }) async {
    final caller = await requireCaller(
      session,
      allowedRoles: {UserRole.student, UserRole.teacher},
    );
    final content = await ContentRecord.db.findById(session, contentId);
    if (content == null ||
        content.storagePath == null ||
        content.storagePath!.isEmpty) {
      throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
    }
    if (content.type == ContentType.exercise ||
        (content.ingestStatus ?? IngestStatus.ready) != IngestStatus.ready) {
      throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
    }
    final allowed = await LearningAccess.canReadFile(
      session,
      caller: EduboxCallerView(userId: caller.userId, role: caller.role),
      content: content,
    );
    if (!allowed) {
      throw AccessDeniedException(reason: AccessDeniedReason.wrongRole);
    }
    final expiresIn = const Duration(minutes: 20);
    final url = await EduboxServices.storageFor(session).signedGetUrl(
      session,
      content.storagePath!,
      expiresIn: expiresIn,
    );
    return SignedFileUrl(
      url: url.toString(),
      expiresAt: EduboxServices.now().add(expiresIn),
    );
  }

  Future<List<String>> _classNamesOf(Session session, int contentId) async {
    final scope = await ContentClass.db.find(
      session,
      where: (t) => t.contentId.equals(contentId),
    );
    if (scope.isEmpty) return const [];
    final ids = scope.map((row) => row.classId).toSet();
    final classes = await SchoolClass.db.find(
      session,
      where: (t) => t.id.inSet(ids),
      orderByList: (t) => [t.name.asc()],
    );
    return [for (final row in classes) row.name];
  }

  static String _extensionOf(String fileName, ContentType type) {
    final dot = fileName.lastIndexOf('.');
    final raw = dot < 0 ? '' : fileName.substring(dot + 1).toLowerCase();
    if (type == ContentType.ebook && raw == 'pdf') return 'pdf';
    if (type == ContentType.video && raw == 'mp4') return 'mp4';
    throw ArgumentError.value(
      fileName,
      'fileName',
      type == ContentType.ebook ? 'Must be a PDF' : 'Must be an MP4',
    );
  }
}

/// Shared DTO mapping for content rows.
abstract final class StudentContentMapper {
  static TeacherContentItem teacherItem(
    ContentRecord row, {
    required List<String> classNames,
    int? exerciseId,
  }) => TeacherContentItem(
    id: row.id!,
    type: row.type,
    title: row.title,
    subject: row.subject,
    gradeLevel: row.gradeLevel,
    status: row.status,
    ingestStatus: row.ingestStatus ?? IngestStatus.ready,
    ingestReason: row.ingestReason,
    originalFileName: row.originalFileName,
    mimeType: row.mimeType,
    sizeBytes: row.sizeBytes,
    pageCount: row.pageCount,
    durationSeconds: row.durationSeconds,
    createdAt: row.createdAt,
    classNames: classNames,
    exerciseId: exerciseId,
  );
}
