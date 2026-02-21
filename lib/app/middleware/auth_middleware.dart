import 'package:backonnect/app/routes/app_routes.dart';
import 'package:backonnect/core/storage/token_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final tokenService = Get.find<TokenStorageService>();
    if (!tokenService.hasToken) {
      return const RouteSettings(name: AppRoutes.login);
    }
    return null;
  }
}
