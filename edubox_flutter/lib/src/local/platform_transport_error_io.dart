import 'dart:io';

/// Socket and HTTP failures from the native network stack mean the server is
/// unreachable (contract.md section 2.4).
bool isPlatformNetworkError(Object error) =>
    error is SocketException || error is HttpException;
