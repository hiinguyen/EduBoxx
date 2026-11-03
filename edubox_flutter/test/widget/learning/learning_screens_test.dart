import 'package:edubox_fixtures/edubox_fixtures.dart';
import 'package:edubox_flutter/src/screens/student_assignments/student_assignments_screen.dart';
import 'package:edubox_flutter/src/screens/student_tutor/student_tutor_screen.dart';
import 'package:edubox_flutter/src/screens/teacher_assignments/teacher_assignments_screen.dart';
import 'package:edubox_flutter/src/screens/teacher_assignments/teacher_results_screen.dart';
import 'package:edubox_flutter/src/screens/teacher_content/teacher_content_screen.dart';
import 'package:edubox_flutter/src/shell/role_shell.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/app_harness.dart';

void main() {
  testWidgets('student reaches assignments and the AI tutor', (tester) async {
    await pumpEduApp(tester, signedInAs: FixtureKeys.studentAn);

    await tester.tap(find.byKey(RoleShellKeys.destinationPill(2)));
    await tester.pumpAndSettle();
    expect(find.byKey(StudentAssignmentsKeys.screen), findsOneWidget);
    expect(find.text('Luyện tập: Phép cộng phân số'), findsOneWidget);
    expect(find.text('Kiểm tra nhanh: Phân số'), findsOneWidget);

    await tester.tap(find.byKey(RoleShellKeys.destinationPill(3)));
    await tester.pumpAndSettle();
    expect(find.byKey(StudentTutorKeys.screen), findsOneWidget);
    expect(find.text(vi.tutorTitle), findsWidgets);
    expect(find.byKey(StudentTutorKeys.composer), findsOneWidget);
  });

  testWidgets('teacher reaches content, assignments, results and AI review', (
    tester,
  ) async {
    await pumpEduApp(tester, signedInAs: FixtureKeys.teacherLan);

    await tester.tap(find.byKey(RoleShellKeys.destinationPill(1)));
    await tester.pumpAndSettle();
    expect(find.byKey(TeacherContentKeys.screen), findsOneWidget);
    expect(find.text('Phân số và số thập phân'), findsOneWidget);

    await tester.tap(find.byKey(RoleShellKeys.destinationPill(2)));
    await tester.pumpAndSettle();
    expect(find.byKey(TeacherAssignmentsKeys.screen), findsOneWidget);
    expect(find.text(vi.assignmentTeacherTitle), findsOneWidget);

    await tester.tap(find.byKey(RoleShellKeys.destinationPill(3)));
    await tester.pumpAndSettle();
    expect(find.byKey(TeacherResultsKeys.screen), findsOneWidget);
    expect(find.text(vi.resultsTitle), findsWidgets);

    await tester.tap(find.byKey(RoleShellKeys.destinationPill(4)));
    await tester.pumpAndSettle();
    expect(find.text(vi.teacherChatReviewTitle), findsWidgets);
  });

  testWidgets('parent opens the read-only summary from the record card', (
    tester,
  ) async {
    await pumpEduApp(tester, signedInAs: FixtureKeys.parentBinh);
    await tester.tap(find.text('Nguyễn Minh An'));
    await tester.pumpAndSettle();
    expect(find.text(vi.parentSummaryTitle), findsWidgets);
    expect(find.text(vi.parentResults), findsOneWidget);
    expect(find.text(vi.parentAiChats), findsOneWidget);
  });
}
