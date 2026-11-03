import 'learning_repositories.dart';
import 'repositories.dart';

/// The single seam every contract test and feature screen depends on.
///
/// The fake implements it now; the real generated-client binding plugs in at
/// phase 5 without changing a screen or a test.
abstract interface class EduBoxBackend {
  AuthRepository get auth;
  ProfileRepository get profile;
  ClassesRepository get classes;
  LibraryRepository get library;
  ParentRepository get parent;
  ContentRepository get content;
  AssignmentRepository get assignments;
  TutorRepository get tutor;
  DiagnosticsRepository get diagnostics;

  Future<void> dispose();
}
