/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:edubox_client/src/protocol/dto/class_summary.dart' as _i80od7do;
import 'package:edubox_client/src/protocol/dto/progress_result.dart'
    as _i11ejrv7;
import 'package:edubox_client/src/protocol/dto/submitted_answer.dart'
    as _io53xjb9;
import 'package:edubox_client/src/protocol/dto/teacher_assignment_item.dart'
    as _itougsx7;
import 'package:edubox_client/src/protocol/dto/teacher_content_item.dart'
    as _izomhfjr;
import 'package:edubox_client/src/protocol/dto/teacher_exercise_summary.dart'
    as _iftr0d72;
import 'package:edubox_client/src/protocol/dto/tutor_chat_summary.dart'
    as _ihm7r1k6;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'dto/assignment_upsert.dart' as _ilrtqfj0;
import 'dto/class_results.dart' as _iy9qtwy4;
import 'dto/class_summary.dart' as _i1stsozf;
import 'dto/content_detail.dart' as _iebek2xe;
import 'dto/exercise_question_input.dart' as _ikj3zmpk;
import 'dto/exercise_upsert.dart' as _in4yn11g;
import 'dto/library_item.dart' as _ihvkgxwr;
import 'dto/parent_result_entry.dart' as _isak0kfx;
import 'dto/parent_summary.dart' as _igu8af9e;
import 'dto/ping_message.dart' as _iptwwf38;
import 'dto/profile.dart' as _i803mohe;
import 'dto/profile_result.dart' as _iiofgk2r;
import 'dto/progress_result.dart' as _ibmdw918;
import 'dto/result_assignment.dart' as _ibb2ip4j;
import 'dto/result_cell.dart' as _is11re4g;
import 'dto/result_student.dart' as _iaswcu9m;
import 'dto/signed_file_url.dart' as _ixafgrmq;
import 'dto/student_assignment_detail.dart' as _i0ni6ynn;
import 'dto/student_assignment_item.dart' as _iot34355;
import 'dto/student_assignment_list.dart' as _imkl6zsy;
import 'dto/student_class.dart' as _iv0apgib;
import 'dto/student_exercise_detail.dart' as _izb82juv;
import 'dto/student_library.dart' as _ie4th1ag;
import 'dto/student_option.dart' as _iqaa7rqp;
import 'dto/student_question.dart' as _ikionxl4;
import 'dto/submission_result.dart' as _ihxhpwjy;
import 'dto/submitted_answer.dart' as _i9j3sp9i;
import 'dto/teacher_assignment_item.dart' as _ix70iekx;
import 'dto/teacher_content_item.dart' as _i1k72nx5;
import 'dto/teacher_exercise_detail.dart' as _ipp52eov;
import 'dto/teacher_exercise_summary.dart' as _imb6rg4j;
import 'dto/test_start_result.dart' as _izs6o63f;
import 'dto/tutor_chat_detail.dart' as _i9ctzt5y;
import 'dto/tutor_chat_summary.dart' as _ihsvl4pu;
import 'dto/tutor_event.dart' as _i1ghq353;
import 'dto/tutor_message.dart' as _ia4zizgj;
import 'dto/tutor_state.dart' as _im2pl4mj;
import 'dto/tutor_subject.dart' as _i54cvqa7;
import 'dto/upload_ticket.dart' as _i0ulrzc8;
import 'enums/access_denied_reason.dart' as _ivmxmlsf;
import 'enums/assignment_type.dart' as _i1qp8rh1;
import 'enums/chat_role.dart' as _i4c9wzoy;
import 'enums/content_status.dart' as _ihs3uvql;
import 'enums/content_type.dart' as _ilnr5g4x;
import 'enums/graded_by.dart' as _imu90gv5;
import 'enums/ingest_status.dart' as _iy9800h1;
import 'enums/profile_status.dart' as _i4pxzrse;
import 'enums/student_assignment_state.dart' as _i7hodpmp;
import 'enums/submission_reject_reason.dart' as _ih6fn0zh;
import 'enums/submission_status.dart' as _iw6m0r5b;
import 'enums/tutor_error_code.dart' as _it20dd5v;
import 'enums/tutor_event_type.dart' as _ing6hz3i;
import 'enums/user_role.dart' as _iez5w9yk;
import 'exceptions/access_denied_exception.dart' as _iiozc5q0;
import 'exceptions/submission_rejected_exception.dart' as _iltb9h0s;
export 'dto/assignment_upsert.dart';
export 'dto/class_results.dart';
export 'dto/class_summary.dart';
export 'dto/content_detail.dart';
export 'dto/exercise_question_input.dart';
export 'dto/exercise_upsert.dart';
export 'dto/library_item.dart';
export 'dto/parent_result_entry.dart';
export 'dto/parent_summary.dart';
export 'dto/ping_message.dart';
export 'dto/profile.dart';
export 'dto/profile_result.dart';
export 'dto/progress_result.dart';
export 'dto/result_assignment.dart';
export 'dto/result_cell.dart';
export 'dto/result_student.dart';
export 'dto/signed_file_url.dart';
export 'dto/student_assignment_detail.dart';
export 'dto/student_assignment_item.dart';
export 'dto/student_assignment_list.dart';
export 'dto/student_class.dart';
export 'dto/student_exercise_detail.dart';
export 'dto/student_library.dart';
export 'dto/student_option.dart';
export 'dto/student_question.dart';
export 'dto/submission_result.dart';
export 'dto/submitted_answer.dart';
export 'dto/teacher_assignment_item.dart';
export 'dto/teacher_content_item.dart';
export 'dto/teacher_exercise_detail.dart';
export 'dto/teacher_exercise_summary.dart';
export 'dto/test_start_result.dart';
export 'dto/tutor_chat_detail.dart';
export 'dto/tutor_chat_summary.dart';
export 'dto/tutor_event.dart';
export 'dto/tutor_message.dart';
export 'dto/tutor_state.dart';
export 'dto/tutor_subject.dart';
export 'dto/upload_ticket.dart';
export 'enums/access_denied_reason.dart';
export 'enums/assignment_type.dart';
export 'enums/chat_role.dart';
export 'enums/content_status.dart';
export 'enums/content_type.dart';
export 'enums/graded_by.dart';
export 'enums/ingest_status.dart';
export 'enums/profile_status.dart';
export 'enums/student_assignment_state.dart';
export 'enums/submission_reject_reason.dart';
export 'enums/submission_status.dart';
export 'enums/tutor_error_code.dart';
export 'enums/tutor_event_type.dart';
export 'enums/user_role.dart';
export 'exceptions/access_denied_exception.dart';
export 'exceptions/submission_rejected_exception.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _ilrtqfj0.AssignmentUpsert) {
      return _ilrtqfj0.AssignmentUpsert.fromJson(data) as T;
    }
    if (t == _iy9qtwy4.ClassResults) {
      return _iy9qtwy4.ClassResults.fromJson(data) as T;
    }
    if (t == _i1stsozf.ClassSummary) {
      return _i1stsozf.ClassSummary.fromJson(data) as T;
    }
    if (t == _iebek2xe.ContentDetail) {
      return _iebek2xe.ContentDetail.fromJson(data) as T;
    }
    if (t == _ikj3zmpk.ExerciseQuestionInput) {
      return _ikj3zmpk.ExerciseQuestionInput.fromJson(data) as T;
    }
    if (t == _in4yn11g.ExerciseUpsert) {
      return _in4yn11g.ExerciseUpsert.fromJson(data) as T;
    }
    if (t == _ihvkgxwr.LibraryItem) {
      return _ihvkgxwr.LibraryItem.fromJson(data) as T;
    }
    if (t == _isak0kfx.ParentResultEntry) {
      return _isak0kfx.ParentResultEntry.fromJson(data) as T;
    }
    if (t == _igu8af9e.ParentSummary) {
      return _igu8af9e.ParentSummary.fromJson(data) as T;
    }
    if (t == _iptwwf38.PingMessage) {
      return _iptwwf38.PingMessage.fromJson(data) as T;
    }
    if (t == _i803mohe.Profile) {
      return _i803mohe.Profile.fromJson(data) as T;
    }
    if (t == _iiofgk2r.ProfileResult) {
      return _iiofgk2r.ProfileResult.fromJson(data) as T;
    }
    if (t == _ibmdw918.ProgressResult) {
      return _ibmdw918.ProgressResult.fromJson(data) as T;
    }
    if (t == _ibb2ip4j.ResultAssignment) {
      return _ibb2ip4j.ResultAssignment.fromJson(data) as T;
    }
    if (t == _is11re4g.ResultCell) {
      return _is11re4g.ResultCell.fromJson(data) as T;
    }
    if (t == _iaswcu9m.ResultStudent) {
      return _iaswcu9m.ResultStudent.fromJson(data) as T;
    }
    if (t == _ixafgrmq.SignedFileUrl) {
      return _ixafgrmq.SignedFileUrl.fromJson(data) as T;
    }
    if (t == _i0ni6ynn.StudentAssignmentDetail) {
      return _i0ni6ynn.StudentAssignmentDetail.fromJson(data) as T;
    }
    if (t == _iot34355.StudentAssignmentItem) {
      return _iot34355.StudentAssignmentItem.fromJson(data) as T;
    }
    if (t == _imkl6zsy.StudentAssignmentList) {
      return _imkl6zsy.StudentAssignmentList.fromJson(data) as T;
    }
    if (t == _iv0apgib.StudentClass) {
      return _iv0apgib.StudentClass.fromJson(data) as T;
    }
    if (t == _izb82juv.StudentExerciseDetail) {
      return _izb82juv.StudentExerciseDetail.fromJson(data) as T;
    }
    if (t == _ie4th1ag.StudentLibrary) {
      return _ie4th1ag.StudentLibrary.fromJson(data) as T;
    }
    if (t == _iqaa7rqp.StudentOption) {
      return _iqaa7rqp.StudentOption.fromJson(data) as T;
    }
    if (t == _ikionxl4.StudentQuestion) {
      return _ikionxl4.StudentQuestion.fromJson(data) as T;
    }
    if (t == _ihxhpwjy.SubmissionResult) {
      return _ihxhpwjy.SubmissionResult.fromJson(data) as T;
    }
    if (t == _i9j3sp9i.SubmittedAnswer) {
      return _i9j3sp9i.SubmittedAnswer.fromJson(data) as T;
    }
    if (t == _ix70iekx.TeacherAssignmentItem) {
      return _ix70iekx.TeacherAssignmentItem.fromJson(data) as T;
    }
    if (t == _i1k72nx5.TeacherContentItem) {
      return _i1k72nx5.TeacherContentItem.fromJson(data) as T;
    }
    if (t == _ipp52eov.TeacherExerciseDetail) {
      return _ipp52eov.TeacherExerciseDetail.fromJson(data) as T;
    }
    if (t == _imb6rg4j.TeacherExerciseSummary) {
      return _imb6rg4j.TeacherExerciseSummary.fromJson(data) as T;
    }
    if (t == _izs6o63f.TestStartResult) {
      return _izs6o63f.TestStartResult.fromJson(data) as T;
    }
    if (t == _i9ctzt5y.TutorChatDetail) {
      return _i9ctzt5y.TutorChatDetail.fromJson(data) as T;
    }
    if (t == _ihsvl4pu.TutorChatSummary) {
      return _ihsvl4pu.TutorChatSummary.fromJson(data) as T;
    }
    if (t == _i1ghq353.TutorEvent) {
      return _i1ghq353.TutorEvent.fromJson(data) as T;
    }
    if (t == _ia4zizgj.TutorMessage) {
      return _ia4zizgj.TutorMessage.fromJson(data) as T;
    }
    if (t == _im2pl4mj.TutorState) {
      return _im2pl4mj.TutorState.fromJson(data) as T;
    }
    if (t == _i54cvqa7.TutorSubject) {
      return _i54cvqa7.TutorSubject.fromJson(data) as T;
    }
    if (t == _i0ulrzc8.UploadTicket) {
      return _i0ulrzc8.UploadTicket.fromJson(data) as T;
    }
    if (t == _ivmxmlsf.AccessDeniedReason) {
      return _ivmxmlsf.AccessDeniedReason.fromJson(data) as T;
    }
    if (t == _i1qp8rh1.AssignmentType) {
      return _i1qp8rh1.AssignmentType.fromJson(data) as T;
    }
    if (t == _i4c9wzoy.ChatRole) {
      return _i4c9wzoy.ChatRole.fromJson(data) as T;
    }
    if (t == _ihs3uvql.ContentStatus) {
      return _ihs3uvql.ContentStatus.fromJson(data) as T;
    }
    if (t == _ilnr5g4x.ContentType) {
      return _ilnr5g4x.ContentType.fromJson(data) as T;
    }
    if (t == _imu90gv5.GradedBy) {
      return _imu90gv5.GradedBy.fromJson(data) as T;
    }
    if (t == _iy9800h1.IngestStatus) {
      return _iy9800h1.IngestStatus.fromJson(data) as T;
    }
    if (t == _i4pxzrse.ProfileStatus) {
      return _i4pxzrse.ProfileStatus.fromJson(data) as T;
    }
    if (t == _i7hodpmp.StudentAssignmentState) {
      return _i7hodpmp.StudentAssignmentState.fromJson(data) as T;
    }
    if (t == _ih6fn0zh.SubmissionRejectReason) {
      return _ih6fn0zh.SubmissionRejectReason.fromJson(data) as T;
    }
    if (t == _iw6m0r5b.SubmissionStatus) {
      return _iw6m0r5b.SubmissionStatus.fromJson(data) as T;
    }
    if (t == _it20dd5v.TutorErrorCode) {
      return _it20dd5v.TutorErrorCode.fromJson(data) as T;
    }
    if (t == _ing6hz3i.TutorEventType) {
      return _ing6hz3i.TutorEventType.fromJson(data) as T;
    }
    if (t == _iez5w9yk.UserRole) {
      return _iez5w9yk.UserRole.fromJson(data) as T;
    }
    if (t == _iiozc5q0.AccessDeniedException) {
      return _iiozc5q0.AccessDeniedException.fromJson(data) as T;
    }
    if (t == _iltb9h0s.SubmissionRejectedException) {
      return _iltb9h0s.SubmissionRejectedException.fromJson(data) as T;
    }
    if (t == _isc.getType<_ilrtqfj0.AssignmentUpsert?>()) {
      return (data != null ? _ilrtqfj0.AssignmentUpsert.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iy9qtwy4.ClassResults?>()) {
      return (data != null ? _iy9qtwy4.ClassResults.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i1stsozf.ClassSummary?>()) {
      return (data != null ? _i1stsozf.ClassSummary.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iebek2xe.ContentDetail?>()) {
      return (data != null ? _iebek2xe.ContentDetail.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ikj3zmpk.ExerciseQuestionInput?>()) {
      return (data != null
              ? _ikj3zmpk.ExerciseQuestionInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_in4yn11g.ExerciseUpsert?>()) {
      return (data != null ? _in4yn11g.ExerciseUpsert.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ihvkgxwr.LibraryItem?>()) {
      return (data != null ? _ihvkgxwr.LibraryItem.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_isak0kfx.ParentResultEntry?>()) {
      return (data != null ? _isak0kfx.ParentResultEntry.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_igu8af9e.ParentSummary?>()) {
      return (data != null ? _igu8af9e.ParentSummary.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iptwwf38.PingMessage?>()) {
      return (data != null ? _iptwwf38.PingMessage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i803mohe.Profile?>()) {
      return (data != null ? _i803mohe.Profile.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iiofgk2r.ProfileResult?>()) {
      return (data != null ? _iiofgk2r.ProfileResult.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ibmdw918.ProgressResult?>()) {
      return (data != null ? _ibmdw918.ProgressResult.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ibb2ip4j.ResultAssignment?>()) {
      return (data != null ? _ibb2ip4j.ResultAssignment.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_is11re4g.ResultCell?>()) {
      return (data != null ? _is11re4g.ResultCell.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iaswcu9m.ResultStudent?>()) {
      return (data != null ? _iaswcu9m.ResultStudent.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ixafgrmq.SignedFileUrl?>()) {
      return (data != null ? _ixafgrmq.SignedFileUrl.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i0ni6ynn.StudentAssignmentDetail?>()) {
      return (data != null
              ? _i0ni6ynn.StudentAssignmentDetail.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iot34355.StudentAssignmentItem?>()) {
      return (data != null
              ? _iot34355.StudentAssignmentItem.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_imkl6zsy.StudentAssignmentList?>()) {
      return (data != null
              ? _imkl6zsy.StudentAssignmentList.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iv0apgib.StudentClass?>()) {
      return (data != null ? _iv0apgib.StudentClass.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_izb82juv.StudentExerciseDetail?>()) {
      return (data != null
              ? _izb82juv.StudentExerciseDetail.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ie4th1ag.StudentLibrary?>()) {
      return (data != null ? _ie4th1ag.StudentLibrary.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iqaa7rqp.StudentOption?>()) {
      return (data != null ? _iqaa7rqp.StudentOption.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ikionxl4.StudentQuestion?>()) {
      return (data != null ? _ikionxl4.StudentQuestion.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ihxhpwjy.SubmissionResult?>()) {
      return (data != null ? _ihxhpwjy.SubmissionResult.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i9j3sp9i.SubmittedAnswer?>()) {
      return (data != null ? _i9j3sp9i.SubmittedAnswer.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ix70iekx.TeacherAssignmentItem?>()) {
      return (data != null
              ? _ix70iekx.TeacherAssignmentItem.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i1k72nx5.TeacherContentItem?>()) {
      return (data != null ? _i1k72nx5.TeacherContentItem.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ipp52eov.TeacherExerciseDetail?>()) {
      return (data != null
              ? _ipp52eov.TeacherExerciseDetail.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_imb6rg4j.TeacherExerciseSummary?>()) {
      return (data != null
              ? _imb6rg4j.TeacherExerciseSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_izs6o63f.TestStartResult?>()) {
      return (data != null ? _izs6o63f.TestStartResult.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i9ctzt5y.TutorChatDetail?>()) {
      return (data != null ? _i9ctzt5y.TutorChatDetail.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ihsvl4pu.TutorChatSummary?>()) {
      return (data != null ? _ihsvl4pu.TutorChatSummary.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i1ghq353.TutorEvent?>()) {
      return (data != null ? _i1ghq353.TutorEvent.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ia4zizgj.TutorMessage?>()) {
      return (data != null ? _ia4zizgj.TutorMessage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_im2pl4mj.TutorState?>()) {
      return (data != null ? _im2pl4mj.TutorState.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i54cvqa7.TutorSubject?>()) {
      return (data != null ? _i54cvqa7.TutorSubject.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i0ulrzc8.UploadTicket?>()) {
      return (data != null ? _i0ulrzc8.UploadTicket.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ivmxmlsf.AccessDeniedReason?>()) {
      return (data != null ? _ivmxmlsf.AccessDeniedReason.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i1qp8rh1.AssignmentType?>()) {
      return (data != null ? _i1qp8rh1.AssignmentType.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i4c9wzoy.ChatRole?>()) {
      return (data != null ? _i4c9wzoy.ChatRole.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ihs3uvql.ContentStatus?>()) {
      return (data != null ? _ihs3uvql.ContentStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ilnr5g4x.ContentType?>()) {
      return (data != null ? _ilnr5g4x.ContentType.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_imu90gv5.GradedBy?>()) {
      return (data != null ? _imu90gv5.GradedBy.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iy9800h1.IngestStatus?>()) {
      return (data != null ? _iy9800h1.IngestStatus.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i4pxzrse.ProfileStatus?>()) {
      return (data != null ? _i4pxzrse.ProfileStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i7hodpmp.StudentAssignmentState?>()) {
      return (data != null
              ? _i7hodpmp.StudentAssignmentState.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ih6fn0zh.SubmissionRejectReason?>()) {
      return (data != null
              ? _ih6fn0zh.SubmissionRejectReason.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iw6m0r5b.SubmissionStatus?>()) {
      return (data != null ? _iw6m0r5b.SubmissionStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_it20dd5v.TutorErrorCode?>()) {
      return (data != null ? _it20dd5v.TutorErrorCode.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ing6hz3i.TutorEventType?>()) {
      return (data != null ? _ing6hz3i.TutorEventType.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iez5w9yk.UserRole?>()) {
      return (data != null ? _iez5w9yk.UserRole.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iiozc5q0.AccessDeniedException?>()) {
      return (data != null
              ? _iiozc5q0.AccessDeniedException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iltb9h0s.SubmissionRejectedException?>()) {
      return (data != null
              ? _iltb9h0s.SubmissionRejectedException.fromJson(data)
              : null)
          as T;
    }
    if (t == List<_iaswcu9m.ResultStudent>) {
      return (data as List)
              .map((e) => deserialize<_iaswcu9m.ResultStudent>(e))
              .toList()
          as T;
    }
    if (t == List<_ibb2ip4j.ResultAssignment>) {
      return (data as List)
              .map((e) => deserialize<_ibb2ip4j.ResultAssignment>(e))
              .toList()
          as T;
    }
    if (t == List<_is11re4g.ResultCell>) {
      return (data as List)
              .map((e) => deserialize<_is11re4g.ResultCell>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_ikj3zmpk.ExerciseQuestionInput>) {
      return (data as List)
              .map((e) => deserialize<_ikj3zmpk.ExerciseQuestionInput>(e))
              .toList()
          as T;
    }
    if (t == List<_isak0kfx.ParentResultEntry>) {
      return (data as List)
              .map((e) => deserialize<_isak0kfx.ParentResultEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_ihsvl4pu.TutorChatSummary>) {
      return (data as List)
              .map((e) => deserialize<_ihsvl4pu.TutorChatSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_iot34355.StudentAssignmentItem>) {
      return (data as List)
              .map((e) => deserialize<_iot34355.StudentAssignmentItem>(e))
              .toList()
          as T;
    }
    if (t == List<_ikionxl4.StudentQuestion>) {
      return (data as List)
              .map((e) => deserialize<_ikionxl4.StudentQuestion>(e))
              .toList()
          as T;
    }
    if (t == List<_iv0apgib.StudentClass>) {
      return (data as List)
              .map((e) => deserialize<_iv0apgib.StudentClass>(e))
              .toList()
          as T;
    }
    if (t == List<_ihvkgxwr.LibraryItem>) {
      return (data as List)
              .map((e) => deserialize<_ihvkgxwr.LibraryItem>(e))
              .toList()
          as T;
    }
    if (t == List<_iqaa7rqp.StudentOption>) {
      return (data as List)
              .map((e) => deserialize<_iqaa7rqp.StudentOption>(e))
              .toList()
          as T;
    }
    if (t == List<_i9j3sp9i.SubmittedAnswer>) {
      return (data as List)
              .map((e) => deserialize<_i9j3sp9i.SubmittedAnswer>(e))
              .toList()
          as T;
    }
    if (t == List<_ia4zizgj.TutorMessage>) {
      return (data as List)
              .map((e) => deserialize<_ia4zizgj.TutorMessage>(e))
              .toList()
          as T;
    }
    if (t == List<_i54cvqa7.TutorSubject>) {
      return (data as List)
              .map((e) => deserialize<_i54cvqa7.TutorSubject>(e))
              .toList()
          as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    if (t == List<_itougsx7.TeacherAssignmentItem>) {
      return (data as List)
              .map((e) => deserialize<_itougsx7.TeacherAssignmentItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i80od7do.ClassSummary>) {
      return (data as List)
              .map((e) => deserialize<_i80od7do.ClassSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_izomhfjr.TeacherContentItem>) {
      return (data as List)
              .map((e) => deserialize<_izomhfjr.TeacherContentItem>(e))
              .toList()
          as T;
    }
    if (t == List<_iftr0d72.TeacherExerciseSummary>) {
      return (data as List)
              .map((e) => deserialize<_iftr0d72.TeacherExerciseSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_ihm7r1k6.TutorChatSummary>) {
      return (data as List)
              .map((e) => deserialize<_ihm7r1k6.TutorChatSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i11ejrv7.ProgressResult>) {
      return (data as List)
              .map((e) => deserialize<_i11ejrv7.ProgressResult>(e))
              .toList()
          as T;
    }
    if (t == List<_io53xjb9.SubmittedAnswer>) {
      return (data as List)
              .map((e) => deserialize<_io53xjb9.SubmittedAnswer>(e))
              .toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ilrtqfj0.AssignmentUpsert => 'AssignmentUpsert',
      _iy9qtwy4.ClassResults => 'ClassResults',
      _i1stsozf.ClassSummary => 'ClassSummary',
      _iebek2xe.ContentDetail => 'ContentDetail',
      _ikj3zmpk.ExerciseQuestionInput => 'ExerciseQuestionInput',
      _in4yn11g.ExerciseUpsert => 'ExerciseUpsert',
      _ihvkgxwr.LibraryItem => 'LibraryItem',
      _isak0kfx.ParentResultEntry => 'ParentResultEntry',
      _igu8af9e.ParentSummary => 'ParentSummary',
      _iptwwf38.PingMessage => 'PingMessage',
      _i803mohe.Profile => 'Profile',
      _iiofgk2r.ProfileResult => 'ProfileResult',
      _ibmdw918.ProgressResult => 'ProgressResult',
      _ibb2ip4j.ResultAssignment => 'ResultAssignment',
      _is11re4g.ResultCell => 'ResultCell',
      _iaswcu9m.ResultStudent => 'ResultStudent',
      _ixafgrmq.SignedFileUrl => 'SignedFileUrl',
      _i0ni6ynn.StudentAssignmentDetail => 'StudentAssignmentDetail',
      _iot34355.StudentAssignmentItem => 'StudentAssignmentItem',
      _imkl6zsy.StudentAssignmentList => 'StudentAssignmentList',
      _iv0apgib.StudentClass => 'StudentClass',
      _izb82juv.StudentExerciseDetail => 'StudentExerciseDetail',
      _ie4th1ag.StudentLibrary => 'StudentLibrary',
      _iqaa7rqp.StudentOption => 'StudentOption',
      _ikionxl4.StudentQuestion => 'StudentQuestion',
      _ihxhpwjy.SubmissionResult => 'SubmissionResult',
      _i9j3sp9i.SubmittedAnswer => 'SubmittedAnswer',
      _ix70iekx.TeacherAssignmentItem => 'TeacherAssignmentItem',
      _i1k72nx5.TeacherContentItem => 'TeacherContentItem',
      _ipp52eov.TeacherExerciseDetail => 'TeacherExerciseDetail',
      _imb6rg4j.TeacherExerciseSummary => 'TeacherExerciseSummary',
      _izs6o63f.TestStartResult => 'TestStartResult',
      _i9ctzt5y.TutorChatDetail => 'TutorChatDetail',
      _ihsvl4pu.TutorChatSummary => 'TutorChatSummary',
      _i1ghq353.TutorEvent => 'TutorEvent',
      _ia4zizgj.TutorMessage => 'TutorMessage',
      _im2pl4mj.TutorState => 'TutorState',
      _i54cvqa7.TutorSubject => 'TutorSubject',
      _i0ulrzc8.UploadTicket => 'UploadTicket',
      _ivmxmlsf.AccessDeniedReason => 'AccessDeniedReason',
      _i1qp8rh1.AssignmentType => 'AssignmentType',
      _i4c9wzoy.ChatRole => 'ChatRole',
      _ihs3uvql.ContentStatus => 'ContentStatus',
      _ilnr5g4x.ContentType => 'ContentType',
      _imu90gv5.GradedBy => 'GradedBy',
      _iy9800h1.IngestStatus => 'IngestStatus',
      _i4pxzrse.ProfileStatus => 'ProfileStatus',
      _i7hodpmp.StudentAssignmentState => 'StudentAssignmentState',
      _ih6fn0zh.SubmissionRejectReason => 'SubmissionRejectReason',
      _iw6m0r5b.SubmissionStatus => 'SubmissionStatus',
      _it20dd5v.TutorErrorCode => 'TutorErrorCode',
      _ing6hz3i.TutorEventType => 'TutorEventType',
      _iez5w9yk.UserRole => 'UserRole',
      _iiozc5q0.AccessDeniedException => 'AccessDeniedException',
      _iltb9h0s.SubmissionRejectedException => 'SubmissionRejectedException',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('edubox.', '');
    }

    switch (data) {
      case _ilrtqfj0.AssignmentUpsert():
        return 'AssignmentUpsert';
      case _iy9qtwy4.ClassResults():
        return 'ClassResults';
      case _i1stsozf.ClassSummary():
        return 'ClassSummary';
      case _iebek2xe.ContentDetail():
        return 'ContentDetail';
      case _ikj3zmpk.ExerciseQuestionInput():
        return 'ExerciseQuestionInput';
      case _in4yn11g.ExerciseUpsert():
        return 'ExerciseUpsert';
      case _ihvkgxwr.LibraryItem():
        return 'LibraryItem';
      case _isak0kfx.ParentResultEntry():
        return 'ParentResultEntry';
      case _igu8af9e.ParentSummary():
        return 'ParentSummary';
      case _iptwwf38.PingMessage():
        return 'PingMessage';
      case _i803mohe.Profile():
        return 'Profile';
      case _iiofgk2r.ProfileResult():
        return 'ProfileResult';
      case _ibmdw918.ProgressResult():
        return 'ProgressResult';
      case _ibb2ip4j.ResultAssignment():
        return 'ResultAssignment';
      case _is11re4g.ResultCell():
        return 'ResultCell';
      case _iaswcu9m.ResultStudent():
        return 'ResultStudent';
      case _ixafgrmq.SignedFileUrl():
        return 'SignedFileUrl';
      case _i0ni6ynn.StudentAssignmentDetail():
        return 'StudentAssignmentDetail';
      case _iot34355.StudentAssignmentItem():
        return 'StudentAssignmentItem';
      case _imkl6zsy.StudentAssignmentList():
        return 'StudentAssignmentList';
      case _iv0apgib.StudentClass():
        return 'StudentClass';
      case _izb82juv.StudentExerciseDetail():
        return 'StudentExerciseDetail';
      case _ie4th1ag.StudentLibrary():
        return 'StudentLibrary';
      case _iqaa7rqp.StudentOption():
        return 'StudentOption';
      case _ikionxl4.StudentQuestion():
        return 'StudentQuestion';
      case _ihxhpwjy.SubmissionResult():
        return 'SubmissionResult';
      case _i9j3sp9i.SubmittedAnswer():
        return 'SubmittedAnswer';
      case _ix70iekx.TeacherAssignmentItem():
        return 'TeacherAssignmentItem';
      case _i1k72nx5.TeacherContentItem():
        return 'TeacherContentItem';
      case _ipp52eov.TeacherExerciseDetail():
        return 'TeacherExerciseDetail';
      case _imb6rg4j.TeacherExerciseSummary():
        return 'TeacherExerciseSummary';
      case _izs6o63f.TestStartResult():
        return 'TestStartResult';
      case _i9ctzt5y.TutorChatDetail():
        return 'TutorChatDetail';
      case _ihsvl4pu.TutorChatSummary():
        return 'TutorChatSummary';
      case _i1ghq353.TutorEvent():
        return 'TutorEvent';
      case _ia4zizgj.TutorMessage():
        return 'TutorMessage';
      case _im2pl4mj.TutorState():
        return 'TutorState';
      case _i54cvqa7.TutorSubject():
        return 'TutorSubject';
      case _i0ulrzc8.UploadTicket():
        return 'UploadTicket';
      case _ivmxmlsf.AccessDeniedReason():
        return 'AccessDeniedReason';
      case _i1qp8rh1.AssignmentType():
        return 'AssignmentType';
      case _i4c9wzoy.ChatRole():
        return 'ChatRole';
      case _ihs3uvql.ContentStatus():
        return 'ContentStatus';
      case _ilnr5g4x.ContentType():
        return 'ContentType';
      case _imu90gv5.GradedBy():
        return 'GradedBy';
      case _iy9800h1.IngestStatus():
        return 'IngestStatus';
      case _i4pxzrse.ProfileStatus():
        return 'ProfileStatus';
      case _i7hodpmp.StudentAssignmentState():
        return 'StudentAssignmentState';
      case _ih6fn0zh.SubmissionRejectReason():
        return 'SubmissionRejectReason';
      case _iw6m0r5b.SubmissionStatus():
        return 'SubmissionStatus';
      case _it20dd5v.TutorErrorCode():
        return 'TutorErrorCode';
      case _ing6hz3i.TutorEventType():
        return 'TutorEventType';
      case _iez5w9yk.UserRole():
        return 'UserRole';
      case _iiozc5q0.AccessDeniedException():
        return 'AccessDeniedException';
      case _iltb9h0s.SubmissionRejectedException():
        return 'SubmissionRejectedException';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AssignmentUpsert') {
      return deserialize<_ilrtqfj0.AssignmentUpsert>(data['data']);
    }
    if (dataClassName == 'ClassResults') {
      return deserialize<_iy9qtwy4.ClassResults>(data['data']);
    }
    if (dataClassName == 'ClassSummary') {
      return deserialize<_i1stsozf.ClassSummary>(data['data']);
    }
    if (dataClassName == 'ContentDetail') {
      return deserialize<_iebek2xe.ContentDetail>(data['data']);
    }
    if (dataClassName == 'ExerciseQuestionInput') {
      return deserialize<_ikj3zmpk.ExerciseQuestionInput>(data['data']);
    }
    if (dataClassName == 'ExerciseUpsert') {
      return deserialize<_in4yn11g.ExerciseUpsert>(data['data']);
    }
    if (dataClassName == 'LibraryItem') {
      return deserialize<_ihvkgxwr.LibraryItem>(data['data']);
    }
    if (dataClassName == 'ParentResultEntry') {
      return deserialize<_isak0kfx.ParentResultEntry>(data['data']);
    }
    if (dataClassName == 'ParentSummary') {
      return deserialize<_igu8af9e.ParentSummary>(data['data']);
    }
    if (dataClassName == 'PingMessage') {
      return deserialize<_iptwwf38.PingMessage>(data['data']);
    }
    if (dataClassName == 'Profile') {
      return deserialize<_i803mohe.Profile>(data['data']);
    }
    if (dataClassName == 'ProfileResult') {
      return deserialize<_iiofgk2r.ProfileResult>(data['data']);
    }
    if (dataClassName == 'ProgressResult') {
      return deserialize<_ibmdw918.ProgressResult>(data['data']);
    }
    if (dataClassName == 'ResultAssignment') {
      return deserialize<_ibb2ip4j.ResultAssignment>(data['data']);
    }
    if (dataClassName == 'ResultCell') {
      return deserialize<_is11re4g.ResultCell>(data['data']);
    }
    if (dataClassName == 'ResultStudent') {
      return deserialize<_iaswcu9m.ResultStudent>(data['data']);
    }
    if (dataClassName == 'SignedFileUrl') {
      return deserialize<_ixafgrmq.SignedFileUrl>(data['data']);
    }
    if (dataClassName == 'StudentAssignmentDetail') {
      return deserialize<_i0ni6ynn.StudentAssignmentDetail>(data['data']);
    }
    if (dataClassName == 'StudentAssignmentItem') {
      return deserialize<_iot34355.StudentAssignmentItem>(data['data']);
    }
    if (dataClassName == 'StudentAssignmentList') {
      return deserialize<_imkl6zsy.StudentAssignmentList>(data['data']);
    }
    if (dataClassName == 'StudentClass') {
      return deserialize<_iv0apgib.StudentClass>(data['data']);
    }
    if (dataClassName == 'StudentExerciseDetail') {
      return deserialize<_izb82juv.StudentExerciseDetail>(data['data']);
    }
    if (dataClassName == 'StudentLibrary') {
      return deserialize<_ie4th1ag.StudentLibrary>(data['data']);
    }
    if (dataClassName == 'StudentOption') {
      return deserialize<_iqaa7rqp.StudentOption>(data['data']);
    }
    if (dataClassName == 'StudentQuestion') {
      return deserialize<_ikionxl4.StudentQuestion>(data['data']);
    }
    if (dataClassName == 'SubmissionResult') {
      return deserialize<_ihxhpwjy.SubmissionResult>(data['data']);
    }
    if (dataClassName == 'SubmittedAnswer') {
      return deserialize<_i9j3sp9i.SubmittedAnswer>(data['data']);
    }
    if (dataClassName == 'TeacherAssignmentItem') {
      return deserialize<_ix70iekx.TeacherAssignmentItem>(data['data']);
    }
    if (dataClassName == 'TeacherContentItem') {
      return deserialize<_i1k72nx5.TeacherContentItem>(data['data']);
    }
    if (dataClassName == 'TeacherExerciseDetail') {
      return deserialize<_ipp52eov.TeacherExerciseDetail>(data['data']);
    }
    if (dataClassName == 'TeacherExerciseSummary') {
      return deserialize<_imb6rg4j.TeacherExerciseSummary>(data['data']);
    }
    if (dataClassName == 'TestStartResult') {
      return deserialize<_izs6o63f.TestStartResult>(data['data']);
    }
    if (dataClassName == 'TutorChatDetail') {
      return deserialize<_i9ctzt5y.TutorChatDetail>(data['data']);
    }
    if (dataClassName == 'TutorChatSummary') {
      return deserialize<_ihsvl4pu.TutorChatSummary>(data['data']);
    }
    if (dataClassName == 'TutorEvent') {
      return deserialize<_i1ghq353.TutorEvent>(data['data']);
    }
    if (dataClassName == 'TutorMessage') {
      return deserialize<_ia4zizgj.TutorMessage>(data['data']);
    }
    if (dataClassName == 'TutorState') {
      return deserialize<_im2pl4mj.TutorState>(data['data']);
    }
    if (dataClassName == 'TutorSubject') {
      return deserialize<_i54cvqa7.TutorSubject>(data['data']);
    }
    if (dataClassName == 'UploadTicket') {
      return deserialize<_i0ulrzc8.UploadTicket>(data['data']);
    }
    if (dataClassName == 'AccessDeniedReason') {
      return deserialize<_ivmxmlsf.AccessDeniedReason>(data['data']);
    }
    if (dataClassName == 'AssignmentType') {
      return deserialize<_i1qp8rh1.AssignmentType>(data['data']);
    }
    if (dataClassName == 'ChatRole') {
      return deserialize<_i4c9wzoy.ChatRole>(data['data']);
    }
    if (dataClassName == 'ContentStatus') {
      return deserialize<_ihs3uvql.ContentStatus>(data['data']);
    }
    if (dataClassName == 'ContentType') {
      return deserialize<_ilnr5g4x.ContentType>(data['data']);
    }
    if (dataClassName == 'GradedBy') {
      return deserialize<_imu90gv5.GradedBy>(data['data']);
    }
    if (dataClassName == 'IngestStatus') {
      return deserialize<_iy9800h1.IngestStatus>(data['data']);
    }
    if (dataClassName == 'ProfileStatus') {
      return deserialize<_i4pxzrse.ProfileStatus>(data['data']);
    }
    if (dataClassName == 'StudentAssignmentState') {
      return deserialize<_i7hodpmp.StudentAssignmentState>(data['data']);
    }
    if (dataClassName == 'SubmissionRejectReason') {
      return deserialize<_ih6fn0zh.SubmissionRejectReason>(data['data']);
    }
    if (dataClassName == 'SubmissionStatus') {
      return deserialize<_iw6m0r5b.SubmissionStatus>(data['data']);
    }
    if (dataClassName == 'TutorErrorCode') {
      return deserialize<_it20dd5v.TutorErrorCode>(data['data']);
    }
    if (dataClassName == 'TutorEventType') {
      return deserialize<_ing6hz3i.TutorEventType>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_iez5w9yk.UserRole>(data['data']);
    }
    if (dataClassName == 'AccessDeniedException') {
      return deserialize<_iiozc5q0.AccessDeniedException>(data['data']);
    }
    if (dataClassName == 'SubmissionRejectedException') {
      return deserialize<_iltb9h0s.SubmissionRejectedException>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('edubox', this);
    _iacc.Protocol().registerHostProtocol('edubox', this);
  }

  @override
  String getModuleName() => 'edubox';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
