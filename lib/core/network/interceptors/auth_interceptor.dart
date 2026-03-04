import 'dart:async';

import 'package:backonnect/app/routes/app_routes.dart';
import 'package:backonnect/core/auth/supabase_session_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

class AuthInterceptor extends Interceptor {
  final SupabaseSessionService sessionService;
  bool _isRefreshing = false;
  final List<Completer<String>> _pendingQueue = [];

  AuthInterceptor({required this.sessionService});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = sessionService.cachedAccessToken ??
        await sessionService.getAccessToken();
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
        final response = await Dio(BaseOptions(baseUrl: opts.baseUrl)).fetch(opts);
        return handler.resolve(response);
      } catch (_) {
        return handler.next(err);
      }
    }

    _isRefreshing = true;
    try {
      final newAccessToken = await sessionService.refreshSession();
      if (newAccessToken == null || newAccessToken.isEmpty) {
        await sessionService.signOut();
        _logoutUser(handler, err);
        return;
      }

      // Resolve all queued requests
      for (final completer in _pendingQueue) {
        completer.complete(newAccessToken);
      }
      _pendingQueue.clear();

      // Retry original request
      final opts = err.requestOptions;
      opts.headers['Authorization'] = 'Bearer $newAccessToken';
      final response = await Dio(BaseOptions(baseUrl: opts.baseUrl)).fetch(opts);
      return handler.resolve(response);
    } catch (_) {
      for (final completer in _pendingQueue) {
        completer.completeError('Refresh failed');
      }
      _pendingQueue.clear();
      await sessionService.signOut();
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
