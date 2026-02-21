import 'dart:async';

import 'package:backonnect/app/routes/app_routes.dart';
import 'package:backonnect/core/constants/api_constants.dart';
import 'package:backonnect/core/storage/token_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

class AuthInterceptor extends Interceptor {
  final TokenStorageService tokenService;
  bool _isRefreshing = false;
  final List<Completer<String>> _pendingQueue = [];

  AuthInterceptor({required this.tokenService});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      return _handle401(err, handler);
    }
    return handler.next(err);
  }

  Future<void> _handle401(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_isRefreshing) {
      // Queue this request and wait for the refresh to complete
      final completer = Completer<String>();
      _pendingQueue.add(completer);
      try {
        final newToken = await completer.future;
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $newToken';
        final response = await Dio().fetch(opts);
        return handler.resolve(response);
      } catch (_) {
        return handler.next(err);
      }
    }

    _isRefreshing = true;
    try {
      final refreshToken = await tokenService.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        _logoutUser(handler, err);
        return;
      }

      final refreshDio = Dio(
        BaseOptions(
          baseUrl: '${ApiConstants.baseUrl}${ApiConstants.apiPrefix}',
          connectTimeout:
              const Duration(milliseconds: ApiConstants.connectTimeoutMs),
          receiveTimeout:
              const Duration(milliseconds: ApiConstants.receiveTimeoutMs),
        ),
      );

      final refreshResponse = await refreshDio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final data = refreshResponse.data['data'];
      final newAccessToken = data['access_token'] as String;
      final newRefreshToken = data['refresh_token'] as String;

      await tokenService.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );

      // Resolve all queued requests
      for (final completer in _pendingQueue) {
        completer.complete(newAccessToken);
      }
      _pendingQueue.clear();

      // Retry original request
      final opts = err.requestOptions;
      opts.headers['Authorization'] = 'Bearer $newAccessToken';
      final response = await Dio(
        BaseOptions(
          baseUrl: '${ApiConstants.baseUrl}${ApiConstants.apiPrefix}',
        ),
      ).fetch(opts);
      return handler.resolve(response);
    } catch (_) {
      for (final completer in _pendingQueue) {
        completer.completeError('Refresh failed');
      }
      _pendingQueue.clear();
      await tokenService.clearTokens();
      _logoutUser(handler, err);
    } finally {
      _isRefreshing = false;
    }
  }

  void _logoutUser(ErrorInterceptorHandler handler, DioException err) {
    Get.offAllNamed(AppRoutes.login);
    handler.next(err);
  }
}
