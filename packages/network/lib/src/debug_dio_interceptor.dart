import 'dart:convert';
import 'package:dio/dio.dart';
import 'network_interceptor.dart';

/// Dio interceptor for debugging network requests
class DebugDioInterceptor extends Interceptor {
  final NetworkInterceptor _interceptor = NetworkInterceptor();
  final Map<RequestOptions, String> _requestIds = {};
  final Map<RequestOptions, DateTime> _requestTimes = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
    final requestId = _interceptor.captureRequest(
      url: options.uri.toString(),
      method: options.method,
      headers: options.headers.map((key, value) => MapEntry(key, value.toString())),
      body: options.data,
    );
    _requestIds[options] = requestId;
    _requestTimes[options] = DateTime.now();
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    final requestId = _requestIds[response.requestOptions];
    final requestTime = _requestTimes[response.requestOptions];
    if (requestId != null && requestTime != null) {
      final duration = DateTime.now().difference(requestTime);
      final requestOptions = response.requestOptions;
      _interceptor.updateRequest(
        id: requestId,
        method: requestOptions.method,
        headers: requestOptions.headers.map((key, value) => MapEntry(key, value.toString())),
        body: requestOptions.data,
      );
      _interceptor.captureResponse(
        id: requestId,
        statusCode: response.statusCode,
        responseBody: response.data,
        responseHeaders: response.headers.map.map(
          (key, value) => MapEntry(key, value.join(', ')),
        ),
        duration: duration,
      );

      _requestIds.remove(response.requestOptions);
      _requestTimes.remove(response.requestOptions);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    final requestId = _requestIds[err.requestOptions];
    final requestTime = _requestTimes[err.requestOptions];
    if (requestId != null && requestTime != null) {
      final duration = DateTime.now().difference(requestTime);
      final requestOptions = err.response?.requestOptions;
      _interceptor.updateRequest(
        id: requestId,
        method: requestOptions?.method ?? '',
        headers: requestOptions?.headers.map((key, value) => MapEntry(key, value.toString())),
        body: requestOptions?.data,
      );
      _interceptor.captureResponse(
        id: requestId,
        statusCode: err.response?.statusCode,
        responseBody: err.response?.data,
        responseHeaders: err.response?.headers.map.map(
          (key, value) => MapEntry(key, value.join(', ')),
        ),
        duration: duration,
        error: err.message ?? err.toString(),
      );

      _requestIds.remove(err.requestOptions);
      _requestTimes.remove(err.requestOptions);
    }
  }
}

