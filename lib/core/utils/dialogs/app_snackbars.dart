import 'package:backonnect/app/theme/app_colors.dart';
import 'package:backonnect/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbars {
  AppSnackbars._();

  static void showError(String message) {
    _show(
      title: 'Error',
      message: message,
      backgroundColor: AppColors.error,
    );
  }

  static void showSuccess(String message) {
    _show(
      title: 'Success',
      message: message,
      backgroundColor: AppColors.success,
    );
  }

  static void showInfo(String message) {
    _show(
      title: 'Info',
      message: message,
      backgroundColor: AppColors.primary,
    );
  }

  static void _show({
    required String title,
    required String message,
    required Color backgroundColor,
  }) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration:
          const Duration(seconds: AppConstants.snackbarDurationSeconds),
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 16),
      borderRadius: 8,
      titleText: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
        ),
      ),
    );
  }
}
