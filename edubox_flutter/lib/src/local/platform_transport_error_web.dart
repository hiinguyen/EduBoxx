/// Browsers raise `http.ClientException` (and Serverpod's own connection
/// exceptions) instead of `dart:io` errors, so there is no extra platform
/// transport type to recognize here.
bool isPlatformNetworkError(Object error) => false;
