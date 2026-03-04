import 'package:backonnect/app/routes/app_routes.dart';
import 'package:backonnect/app/theme/app_colors.dart';
import 'package:backonnect/app/theme/app_text_styles.dart';
import 'package:backonnect/core/utils/validators/input_validators.dart';
import 'package:backonnect/features/auth/controllers/login_controller.dart';
import 'package:backonnect/features/auth/presentation/widgets/auth_button.dart';
import 'package:backonnect/features/auth/presentation/widgets/auth_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 64),
              // Header
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.link_rounded,
                      color: AppColors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('Backonnect', style: AppTextStyles.headingM),
                ],
              ),
              const SizedBox(height: 40),
              const Text('Welcome back', style: AppTextStyles.headingXL),
              const SizedBox(height: 6),
              const Text(
                'Sign in to continue',
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: 36),
              // Form
              Form(
                key: controller.loginFormKey,
                child: Column(
                  children: [
                    AuthTextField(
                      controller: controller.emailController,
                      label: 'Email',
                      hintText: 'you@example.com',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: InputValidators.validateEmail,
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => AuthTextField(
                        controller: controller.passwordController,
                        label: 'Password',
                        obscureText: !controller.isPasswordVisible.value,
                        textInputAction: TextInputAction.done,
                        validator: InputValidators.validatePassword,
                        onFieldSubmitted: (_) => controller.login(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textMuted,
                            size: 20,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Obx(
                      () => AuthButton(
                        label: 'Sign In',
                        isLoading: controller.isLoading.value,
                        onPressed: controller.login,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Divider
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.divider)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'or',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textMuted),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.divider)),
                ],
              ),
              const SizedBox(height: 24),
              // Google sign-in
              Obx(
                () => AuthButton(
                  label: 'Continue with Google',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.signInWithGoogle,
                ),
              ),
              const SizedBox(height: 16),
              // Register button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => Get.toNamed<void>(AppRoutes.register),
                  child: const Text('Create an account'),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
