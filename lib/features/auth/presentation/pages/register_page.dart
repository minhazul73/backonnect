import 'package:backonnect/app/theme/app_colors.dart';
import 'package:backonnect/app/theme/app_text_styles.dart';
import 'package:backonnect/core/utils/validators/input_validators.dart';
import 'package:backonnect/features/auth/controllers/login_controller.dart';
import 'package:backonnect/features/auth/presentation/widgets/auth_button.dart';
import 'package:backonnect/features/auth/presentation/widgets/auth_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends GetView<LoginController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(color: AppColors.onSurface),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text('Create account', style: AppTextStyles.headingXL),
              const SizedBox(height: 6),
              const Text(
                'Join Backonnect today',
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: 36),
              Form(
                key: controller.registerFormKey,
                child: Column(
                  children: [
                    AuthTextField(
                      controller: controller.emailController,
                      label: 'Email',
                      hintText: 'you@example.com',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: InputValidators.validateEmail,
                      autofocus: true,
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => AuthTextField(
                        controller: controller.passwordController,
                        label: 'Password',
                        obscureText: !controller.isPasswordVisible.value,
                        textInputAction: TextInputAction.next,
                        validator: InputValidators.validatePassword,
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
                    const SizedBox(height: 16),
                    Obx(
                      () => AuthTextField(
                        controller: controller.confirmPasswordController,
                        label: 'Confirm Password',
                        obscureText:
                            !controller.isConfirmPasswordVisible.value,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => controller.register(),
                        validator: (value) =>
                            InputValidators.validateConfirmPassword(
                          value,
                          controller.passwordController.text,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isConfirmPasswordVisible.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textMuted,
                            size: 20,
                          ),
                          onPressed:
                              controller.toggleConfirmPasswordVisibility,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Obx(
                      () => AuthButton(
                        label: 'Create Account',
                        isLoading: controller.isLoading.value,
                        onPressed: controller.register,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => Get.back<void>(),
                  child: const Text('Already have an account? Sign in'),
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
