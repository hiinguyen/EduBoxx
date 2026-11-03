/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:edubox_server/src/generated/dto/assignment_upsert.dart'
    as _iwwvszbk;
import 'package:edubox_server/src/generated/dto/exercise_upsert.dart'
    as _i2xinucv;
import 'package:edubox_server/src/generated/dto/submitted_answer.dart'
    as _igzhjoza;
import 'package:edubox_server/src/generated/enums/content_type.dart'
    as _ipshz51o;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../assignments/assignments_endpoint.dart' as _i2kr9e0f;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../classes/classes_endpoint.dart' as _iajgymx3;
import '../content/content_endpoint.dart' as _ib9irne6;
import '../diagnostics/diagnostics_endpoint.dart' as _i80y0535;
import '../e2e/e2e_endpoint.dart' as _iy8dln60;
import '../exercises/exercises_endpoint.dart' as _i8cp4vd0;
import '../parent/parent_endpoint.dart' as _iili5bum;
import '../profile/profile_endpoint.dart' as _i6ky944g;
import '../progress/progress_endpoint.dart' as _i88xesu5;
import '../results/results_endpoint.dart' as _i1p0ok5g;
import '../submissions/submissions_endpoint.dart' as _ipv5yf5h;
import '../tests/tests_endpoint.dart' as _ifakpgv7;
import '../tutor/tutor_endpoint.dart' as _i1ivtwaw;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'assignments': _i2kr9e0f.AssignmentsEndpoint()
        ..initialize(
          server,
          'assignments',
          null,
        ),
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'classes': _iajgymx3.ClassesEndpoint()
        ..initialize(
          server,
          'classes',
          null,
        ),
      'content': _ib9irne6.ContentEndpoint()
        ..initialize(
          server,
          'content',
          null,
        ),
      'diagnostics': _i80y0535.DiagnosticsEndpoint()
        ..initialize(
          server,
          'diagnostics',
          null,
        ),
      'e2e': _iy8dln60.E2eEndpoint()
        ..initialize(
          server,
          'e2e',
          null,
        ),
      'exercises': _i8cp4vd0.ExercisesEndpoint()
        ..initialize(
          server,
          'exercises',
          null,
        ),
      'parent': _iili5bum.ParentEndpoint()
        ..initialize(
          server,
          'parent',
          null,
        ),
      'profile': _i6ky944g.ProfileEndpoint()
        ..initialize(
          server,
          'profile',
          null,
        ),
      'progress': _i88xesu5.ProgressEndpoint()
        ..initialize(
          server,
          'progress',
          null,
        ),
      'results': _i1p0ok5g.ResultsEndpoint()
        ..initialize(
          server,
          'results',
          null,
        ),
      'submissions': _ipv5yf5h.SubmissionsEndpoint()
        ..initialize(
          server,
          'submissions',
          null,
        ),
      'tests': _ifakpgv7.TestsEndpoint()
        ..initialize(
          server,
          'tests',
          null,
        ),
      'tutor': _i1ivtwaw.TutorEndpoint()
        ..initialize(
          server,
          'tutor',
          null,
        ),
    };
    connectors['assignments'] = _is.EndpointConnector(
      name: 'assignments',
      endpoint: endpoints['assignments']!,
      methodConnectors: {
        'save': _is.MethodConnector(
          name: 'save',
          params: {
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_iwwvszbk.AssignmentUpsert>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['assignments'] as _i2kr9e0f.AssignmentsEndpoint)
                      .save(
                        session,
                        params['input'],
                      ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'assignmentId': _is.ParameterDescription(
              name: 'assignmentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['assignments'] as _i2kr9e0f.AssignmentsEndpoint)
                      .delete(
                        session,
                        assignmentId: params['assignmentId'],
                      ),
        ),
        'mine': _is.MethodConnector(
          name: 'mine',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['assignments'] as _i2kr9e0f.AssignmentsEndpoint)
                      .mine(session),
        ),
        'listForStudent': _is.MethodConnector(
          name: 'listForStudent',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['assignments'] as _i2kr9e0f.AssignmentsEndpoint)
                      .listForStudent(session),
        ),
        'detailForStudent': _is.MethodConnector(
          name: 'detailForStudent',
          params: {
            'assignmentId': _is.ParameterDescription(
              name: 'assignmentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['assignments'] as _i2kr9e0f.AssignmentsEndpoint)
                      .detailForStudent(
                        session,
                        assignmentId: params['assignmentId'],
                      ),
        ),
      },
    );
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['classes'] = _is.EndpointConnector(
      name: 'classes',
      endpoint: endpoints['classes']!,
      methodConnectors: {
        'mine': _is.MethodConnector(
          name: 'mine',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['classes'] as _iajgymx3.ClassesEndpoint)
                  .mine(session),
        ),
      },
    );
    connectors['content'] = _is.EndpointConnector(
      name: 'content',
      endpoint: endpoints['content']!,
      methodConnectors: {
        'library': _is.MethodConnector(
          name: 'library',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['content'] as _ib9irne6.ContentEndpoint)
                  .library(session),
        ),
        'detail': _is.MethodConnector(
          name: 'detail',
          params: {
            'contentId': _is.ParameterDescription(
              name: 'contentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['content'] as _ib9irne6.ContentEndpoint).detail(
                    session,
                    contentId: params['contentId'],
                  ),
        ),
        'teacherList': _is.MethodConnector(
          name: 'teacherList',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['content'] as _ib9irne6.ContentEndpoint)
                  .teacherList(session),
        ),
        'createUpload': _is.MethodConnector(
          name: 'createUpload',
          params: {
            'classId': _is.ParameterDescription(
              name: 'classId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'type': _is.ParameterDescription(
              name: 'type',
              type: _is.getType<_ipshz51o.ContentType>(),
              nullable: false,
            ),
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'subject': _is.ParameterDescription(
              name: 'subject',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'gradeLevel': _is.ParameterDescription(
              name: 'gradeLevel',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'fileName': _is.ParameterDescription(
              name: 'fileName',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'sizeBytes': _is.ParameterDescription(
              name: 'sizeBytes',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['content'] as _ib9irne6.ContentEndpoint)
                  .createUpload(
                    session,
                    classId: params['classId'],
                    type: params['type'],
                    title: params['title'],
                    subject: params['subject'],
                    gradeLevel: params['gradeLevel'],
                    fileName: params['fileName'],
                    sizeBytes: params['sizeBytes'],
                  ),
        ),
        'completeUpload': _is.MethodConnector(
          name: 'completeUpload',
          params: {
            'contentId': _is.ParameterDescription(
              name: 'contentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['content'] as _ib9irne6.ContentEndpoint)
                  .completeUpload(
                    session,
                    contentId: params['contentId'],
                  ),
        ),
        'approve': _is.MethodConnector(
          name: 'approve',
          params: {
            'contentId': _is.ParameterDescription(
              name: 'contentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['content'] as _ib9irne6.ContentEndpoint).approve(
                    session,
                    contentId: params['contentId'],
                  ),
        ),
        'fileUrl': _is.MethodConnector(
          name: 'fileUrl',
          params: {
            'contentId': _is.ParameterDescription(
              name: 'contentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['content'] as _ib9irne6.ContentEndpoint).fileUrl(
                    session,
                    contentId: params['contentId'],
                  ),
        ),
      },
    );
    connectors['diagnostics'] = _is.EndpointConnector(
      name: 'diagnostics',
      endpoint: endpoints['diagnostics']!,
      methodConnectors: {
        'pingStream': _is.MethodStreamConnector(
          name: 'pingStream',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['diagnostics'] as _i80y0535.DiagnosticsEndpoint)
                  .pingStream(session),
        ),
      },
    );
    connectors['e2e'] = _is.EndpointConnector(
      name: 'e2e',
      endpoint: endpoints['e2e']!,
      methodConnectors: {
        'run': _is.MethodConnector(
          name: 'run',
          params: {
            'token': _is.ParameterDescription(
              name: 'token',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'step': _is.ParameterDescription(
              name: 'step',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'accountKey': _is.ParameterDescription(
              name: 'accountKey',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'role': _is.ParameterDescription(
              name: 'role',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['e2e'] as _iy8dln60.E2eEndpoint).run(
                session,
                token: params['token'],
                step: params['step'],
                accountKey: params['accountKey'],
                role: params['role'],
              ),
        ),
      },
    );
    connectors['exercises'] = _is.EndpointConnector(
      name: 'exercises',
      endpoint: endpoints['exercises']!,
      methodConnectors: {
        'save': _is.MethodConnector(
          name: 'save',
          params: {
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_i2xinucv.ExerciseUpsert>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['exercises'] as _i8cp4vd0.ExercisesEndpoint).save(
                    session,
                    params['input'],
                  ),
        ),
        'detail': _is.MethodConnector(
          name: 'detail',
          params: {
            'exerciseId': _is.ParameterDescription(
              name: 'exerciseId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['exercises'] as _i8cp4vd0.ExercisesEndpoint)
                  .detail(
                    session,
                    exerciseId: params['exerciseId'],
                  ),
        ),
        'mine': _is.MethodConnector(
          name: 'mine',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['exercises'] as _i8cp4vd0.ExercisesEndpoint)
                  .mine(session),
        ),
      },
    );
    connectors['parent'] = _is.EndpointConnector(
      name: 'parent',
      endpoint: endpoints['parent']!,
      methodConnectors: {
        'summary': _is.MethodConnector(
          name: 'summary',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['parent'] as _iili5bum.ParentEndpoint)
                  .summary(session),
        ),
        'chats': _is.MethodConnector(
          name: 'chats',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['parent'] as _iili5bum.ParentEndpoint)
                  .chats(session),
        ),
        'chat': _is.MethodConnector(
          name: 'chat',
          params: {
            'chatId': _is.ParameterDescription(
              name: 'chatId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['parent'] as _iili5bum.ParentEndpoint).chat(
                session,
                chatId: params['chatId'],
              ),
        ),
      },
    );
    connectors['profile'] = _is.EndpointConnector(
      name: 'profile',
      endpoint: endpoints['profile']!,
      methodConnectors: {
        'me': _is.MethodConnector(
          name: 'me',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['profile'] as _i6ky944g.ProfileEndpoint).me(
                session,
              ),
        ),
      },
    );
    connectors['progress'] = _is.EndpointConnector(
      name: 'progress',
      endpoint: endpoints['progress']!,
      methodConnectors: {
        'markComplete': _is.MethodConnector(
          name: 'markComplete',
          params: {
            'contentId': _is.ParameterDescription(
              name: 'contentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['progress'] as _i88xesu5.ProgressEndpoint)
                  .markComplete(
                    session,
                    contentId: params['contentId'],
                  ),
        ),
        'mine': _is.MethodConnector(
          name: 'mine',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['progress'] as _i88xesu5.ProgressEndpoint)
                  .mine(session),
        ),
      },
    );
    connectors['results'] = _is.EndpointConnector(
      name: 'results',
      endpoint: endpoints['results']!,
      methodConnectors: {
        'classResults': _is.MethodConnector(
          name: 'classResults',
          params: {
            'classId': _is.ParameterDescription(
              name: 'classId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['results'] as _i1p0ok5g.ResultsEndpoint)
                  .classResults(
                    session,
                    classId: params['classId'],
                  ),
        ),
      },
    );
    connectors['submissions'] = _is.EndpointConnector(
      name: 'submissions',
      endpoint: endpoints['submissions']!,
      methodConnectors: {
        'submit': _is.MethodConnector(
          name: 'submit',
          params: {
            'assignmentId': _is.ParameterDescription(
              name: 'assignmentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'clientSubmissionId': _is.ParameterDescription(
              name: 'clientSubmissionId',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'answers': _is.ParameterDescription(
              name: 'answers',
              type: _is.getType<List<_igzhjoza.SubmittedAnswer>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['submissions'] as _ipv5yf5h.SubmissionsEndpoint)
                      .submit(
                        session,
                        assignmentId: params['assignmentId'],
                        clientSubmissionId: params['clientSubmissionId'],
                        answers: params['answers'],
                      ),
        ),
        'forAssignment': _is.MethodConnector(
          name: 'forAssignment',
          params: {
            'assignmentId': _is.ParameterDescription(
              name: 'assignmentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['submissions'] as _ipv5yf5h.SubmissionsEndpoint)
                      .forAssignment(
                        session,
                        assignmentId: params['assignmentId'],
                      ),
        ),
        'regrade': _is.MethodConnector(
          name: 'regrade',
          params: {
            'submissionId': _is.ParameterDescription(
              name: 'submissionId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['submissions'] as _ipv5yf5h.SubmissionsEndpoint)
                      .regrade(
                        session,
                        submissionId: params['submissionId'],
                      ),
        ),
      },
    );
    connectors['tests'] = _is.EndpointConnector(
      name: 'tests',
      endpoint: endpoints['tests']!,
      methodConnectors: {
        'start': _is.MethodConnector(
          name: 'start',
          params: {
            'assignmentId': _is.ParameterDescription(
              name: 'assignmentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'clientSubmissionId': _is.ParameterDescription(
              name: 'clientSubmissionId',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['tests'] as _ifakpgv7.TestsEndpoint).start(
                session,
                assignmentId: params['assignmentId'],
                clientSubmissionId: params['clientSubmissionId'],
              ),
        ),
        'active': _is.MethodConnector(
          name: 'active',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['tests'] as _ifakpgv7.TestsEndpoint).active(
                session,
              ),
        ),
      },
    );
    connectors['tutor'] = _is.EndpointConnector(
      name: 'tutor',
      endpoint: endpoints['tutor']!,
      methodConnectors: {
        'state': _is.MethodConnector(
          name: 'state',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['tutor'] as _i1ivtwaw.TutorEndpoint).state(
                session,
              ),
        ),
        'chats': _is.MethodConnector(
          name: 'chats',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['tutor'] as _i1ivtwaw.TutorEndpoint).chats(
                session,
              ),
        ),
        'chat': _is.MethodConnector(
          name: 'chat',
          params: {
            'chatId': _is.ParameterDescription(
              name: 'chatId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['tutor'] as _i1ivtwaw.TutorEndpoint).chat(
                session,
                chatId: params['chatId'],
              ),
        ),
        'classChats': _is.MethodConnector(
          name: 'classChats',
          params: {
            'studentId': _is.ParameterDescription(
              name: 'studentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['tutor'] as _i1ivtwaw.TutorEndpoint).classChats(
                    session,
                    studentId: params['studentId'],
                  ),
        ),
        'classChat': _is.MethodConnector(
          name: 'classChat',
          params: {
            'chatId': _is.ParameterDescription(
              name: 'chatId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['tutor'] as _i1ivtwaw.TutorEndpoint).classChat(
                    session,
                    chatId: params['chatId'],
                  ),
        ),
        'ask': _is.MethodStreamConnector(
          name: 'ask',
          params: {
            'subject': _is.ParameterDescription(
              name: 'subject',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'message': _is.ParameterDescription(
              name: 'message',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'chatId': _is.ParameterDescription(
              name: 'chatId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['tutor'] as _i1ivtwaw.TutorEndpoint).ask(
                session,
                subject: params['subject'],
                message: params['message'],
                chatId: params['chatId'],
              ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }
}
