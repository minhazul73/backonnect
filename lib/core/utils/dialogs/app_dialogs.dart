import 'package:backonnect/app/theme/app_colors.dart';
import 'package:backonnect/core/utils/dialogs/app_snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialogs {
  AppDialogs._();

  static Future<void> showLoading({String message = 'Loading...'}) {
    return Get.dialog<void>(
      PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hideLoading() {
    if (Get.isDialogOpen == true) Get.back<void>();
  }

  static Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color confirmColor = AppColors.error,
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back<bool>(result: false),
            child: Text(
              cancelText,
              style: const TextStyle(color: AppColors.textMuted),
            ),
          ),
          TextButton(
            onPressed: () => Get.back<bool>(result: true),
            child: Text(
              confirmText,
              style: TextStyle(
                color: confirmColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static void showError(String message) => AppSnackbars.showError(message);
  static void showSuccess(String message) => AppSnackbars.showSuccess(message);
}
