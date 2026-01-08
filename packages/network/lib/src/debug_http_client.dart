import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'network_interceptor.dart';

/// A wrapper around http.Client that intercepts all requests for debugging
class DebugHttpClient extends http.BaseClient {
  final http.Client _inner;
  final NetworkInterceptor _interceptor = NetworkInterceptor();

  DebugHttpClient([http.Client? client]) : _inner = client ?? http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final stopwatch = Stopwatch()..start();
    
    // Capture request
    String? requestBody;
    if (request is http.Request) {
      requestBody = request.body;
    }

    final requestId = _interceptor.captureRequest(
      url: request.url.toString(),
      method: request.method,
      headers: request.headers,
      body: requestBody,
    );

    try {
      final response = await _inner.send(request);
      
      // Read response body
      final responseBytes = await response.stream.toBytes();
      final responseBody = utf8.decode(responseBytes);
      
      stopwatch.stop();

      // Capture response
      _interceptor.captureResponse(
        id: requestId,
        statusCode: response.statusCode,
        responseBody: responseBody,
        responseHeaders: response.headers,
        duration: stopwatch.elapsed,
      );

      // Return a new response with the consumed body
      return http.StreamedResponse(
        Stream.value(responseBytes),
        response.statusCode,
        contentLength: responseBytes.length,
        request: response.request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );
    } catch (e) {
      stopwatch.stop();
      
      _interceptor.captureResponse(
        id: requestId,
        error: e.toString(),
        duration: stopwatch.elapsed,
      );
      
      rethrow;
    }
  }

  @override
  void close() {
    _inner.close();
  }
}

