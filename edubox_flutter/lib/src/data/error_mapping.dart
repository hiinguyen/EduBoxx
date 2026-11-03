import 'dart:async';

import 'package:edubox_client/edubox_client.dart'
    show
        AccessDeniedException,
        AccessDeniedReason,
        MethodStreamException,
        OpenMethodStreamException,
        OpenMethodStreamResponseType,
        ServerpodClientException,
        ServerpodClientForbidden,
        ServerpodClientNetworkException,
        ServerpodClientUnauthorized,
        SubmissionRejectedException;
import 'package:http/http.dart' show ClientException;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    show
        AuthUserBlockedException,
        EmailAccountLoginException,
        EmailAccountLoginExceptionReason,
        RefreshTokenExpiredException,
        RefreshTokenInvalidSecretException,
        RefreshTokenMalformedException,
        RefreshTokenNotFoundException;

import '../contract/backend_result.dart';
import 'platform_transport_error_io.dart'
    if (dart.library.js_interop) 'platform_transport_error_web.dart';

/// Maps a server or transport exception to the contract's typed error
/// (contract.md section 2.4). Never throws.
BackendError mapApiError(Object error) {
  if (isPlatformNetworkError(error)) return const BackendUnreachableError();
  return switch (error) {
    BackendException(:final error) => error,
    EmailAccountLoginException(:final reason) => switch (reason) {
      EmailAccountLoginExceptionReason.invalidCredentials =>
        const WrongCredentialsError(),
      EmailAccountLoginExceptionReason.tooManyAttempts =>
        const TooManyAttemptsError(),
      _ => UnexpectedBackendError(error),
    },
    AuthUserBlockedException() => const AccountDisabledError(),
    AccessDeniedException(:final reason) => switch (reason) {
      AccessDeniedReason.notSetUp => const NotSetUpError(),
      AccessDeniedReason.wrongRole => const PermissionDeniedError(),
      AccessDeniedReason.unauthenticated => const SessionExpiredError(),
    },
    SubmissionRejectedException(:final reason) => SubmissionRejectedError(
      reason,
    ),
    OpenMethodStreamException(:final responseType) => switch (responseType) {
      OpenMethodStreamResponseType.authenticationFailed =>
        const SessionExpiredError(),
      OpenMethodStreamResponseType.authorizationDeclined =>
        const PermissionDeniedError(),
      _ => UnexpectedBackendError(error),
    },
    // Every other MethodStreamException is a broken transport: the WebSocket
    // failed to connect, timed out, closed, or stopped listening.
    MethodStreamException() => const BackendUnreachableError(),
    ServerpodClientUnauthorized() ||
    RefreshTokenExpiredException() ||
    RefreshTokenInvalidSecretException() ||
    RefreshTokenMalformedException() ||
    RefreshTokenNotFoundException() => const SessionExpiredError(),
    ServerpodClientForbidden() => const PermissionDeniedError(),
    // Browser transport (package:http BrowserClient) and native timeouts both
    // mean the server did not answer.
    ServerpodClientNetworkException() ||
    ClientException() ||
    TimeoutException() => const BackendUnreachableError(),
    ServerpodClientException() => UnexpectedBackendError(error),
    _ => UnexpectedBackendError(error),
  };
}
