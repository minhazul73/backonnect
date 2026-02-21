import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;

/// Detects slow requests (Render.com cold-start) and shows a friendly banner
/// after [_threshold] seconds. Dismissed automatically when a response arrives.
class ColdStartInterceptor extends Interceptor {
  /// How long to wait before assuming the server is cold-starting.
  static const Duration _threshold = Duration(seconds: 8);

  int _pendingCount = 0;
  Timer? _timer;
  bool _snackbarShowing = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _pendingCount++;
    // Start the cold-start timer only for the first in-flight request.
    if (_pendingCount == 1) {
      _timer = Timer(_threshold, _showColdStartBanner);
    }
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _onRequestFinished();
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _onRequestFinished();
    handler.next(err);
  }

  void _onRequestFinished() {
    _pendingCount = (_pendingCount - 1).clamp(0, 999);
    if (_pendingCount == 0) {
      _timer?.cancel();
      _timer = null;
      _dismissBanner();
    }
  }

  void _dismissBanner() {
    if (!_snackbarShowing) return;
    _snackbarShowing = false;
    // Small delay so users can read "Connected!" before it closes.
    Future<void>.delayed(const Duration(milliseconds: 400), () {
      if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    });
  }

  void _showColdStartBanner() {
    // Request may have completed exactly when the timer fired.
    if (_pendingCount == 0) return;
    _snackbarShowing = true;

    Get.rawSnackbar(
      title: 'Server is waking up ☁️',
      message:
          'The backend is starting after being idle.\nThis usually takes up to a minute — hang tight!',
      backgroundColor: const Color(0xFF1D4ED8), // deep blue, distinct from errors
      borderRadius: 12,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      snackStyle: SnackStyle.FLOATING,
      snackPosition: SnackPosition.BOTTOM,
      // Long enough to survive the full cold-start; dismissed programmatically.
      duration: const Duration(seconds: 90),
      isDismissible: false,
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.white24,
      progressIndicatorValueColor:
          const AlwaysStoppedAnimation<Color>(Colors.white),
    );
  }
}
