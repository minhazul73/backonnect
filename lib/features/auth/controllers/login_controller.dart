import 'package:backonnect/app/routes/app_routes.dart';
import 'package:backonnect/core/auth/supabase_session_service.dart';
import 'package:backonnect/core/exceptions/app_exceptions.dart';
import 'package:backonnect/core/utils/dialogs/app_snackbars.dart';
import 'package:backonnect/features/auth/controllers/auth_controller.dart';
import 'package:backonnect/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository;

  LoginController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;
    try {
      isLoading.value = true;
      await _authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final sessionService = Get.find<SupabaseSessionService>();
      if (!sessionService.hasSession) {
        AppSnackbars.showError('Sign in failed. Please try again.');
        return;
      }
      // Mark user as logged in
      if (Get.isRegistered<AuthController>()) {
        await Get.find<AuthController>().fetchCurrentUser();
      }
      Get.offAllNamed<void>(AppRoutes.itemsList);
    } on AuthException catch (e) {
      AppSnackbars.showError(e.message);
    } on AppException catch (e) {
      AppSnackbars.showError(e.message);
    } catch (_) {
      AppSnackbars.showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) return;
    try {
      isLoading.value = true;
      await _authRepository.register(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final sessionService = Get.find<SupabaseSessionService>();
      if (!sessionService.hasSession) {
        // Likely email confirmation is required.
        AppSnackbars.showInfo('Check your email to confirm your account.');
        Get.offAllNamed<void>(AppRoutes.login);
        return;
      }
      if (Get.isRegistered<AuthController>()) {
        await Get.find<AuthController>().fetchCurrentUser();
      }
      Get.offAllNamed<void>(AppRoutes.itemsList);
    } on AuthException catch (e) {
      AppSnackbars.showError(e.message);
    } on AppException catch (e) {
      AppSnackbars.showError(e.message);
    } catch (_) {
      AppSnackbars.showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      await _authRepository.signInWithGoogle();

      final sessionService = Get.find<SupabaseSessionService>();
      if (!sessionService.hasSession) {
        // Cancelled or failed silently.
        return;
      }

      if (Get.isRegistered<AuthController>()) {
        await Get.find<AuthController>().fetchCurrentUser();
      }
      Get.offAllNamed<void>(AppRoutes.itemsList);
    } on AuthException catch (e) {
      AppSnackbars.showError(e.message);
    } catch (_) {
      AppSnackbars.showError('Google sign-in failed. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
