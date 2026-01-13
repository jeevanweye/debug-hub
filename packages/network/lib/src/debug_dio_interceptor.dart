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
    final id = '${DateTime.now().millisecondsSinceEpoch}_${options.uri.toString().hashCode}';
    _requestIds[options] = id;
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
      _interceptor.captureNetworkData(
        id: requestId,
        url: requestOptions.uri.toString(),
        method: requestOptions.method,
        requestHeaders: requestOptions.headers.map((key, value) =>
            MapEntry(key, value.toString())),
        requestBody: requestOptions.data,
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
    if (requestId != null && requestTime != null && err.response != null) {
      final duration = DateTime.now().difference(requestTime);
      final requestOptions = err.response!.requestOptions;
      _interceptor.captureNetworkData(
        id: requestId,
        url: requestOptions.uri.toString(),
        method: requestOptions.method,
        requestHeaders: requestOptions.headers.map((key, value) =>
            MapEntry(key, value.toString())),
        requestBody: requestOptions.data,
        statusCode: err.response!.statusCode,
        responseBody: err.response!.data,
        responseHeaders: err.response!.headers.map.map(
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

