import 'package:backonnect/app/theme/app_colors.dart';
import 'package:backonnect/app/theme/app_text_styles.dart';
import 'package:backonnect/core/utils/dialogs/app_dialogs.dart';
import 'package:backonnect/features/profile/controllers/profile_controller.dart';
import 'package:backonnect/features/profile/presentation/widgets/profile_header.dart';
import 'package:backonnect/features/profile/presentation/widgets/user_info_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(color: AppColors.onSurface),
        title: const Text('Profile'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: Obx(() {
        final user = controller.currentUser.value;

        if (user == null) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          );
        }

        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ProfileHeader(user: user),
                      ),
                      const SizedBox(height: 8),

                      // Info section
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Column(
                          children: [
                            UserInfoTile(label: 'Email', value: user.email),
                            UserInfoTile(
                              label: 'Account ID',
                              value: '#${user.id}',
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // Logout button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: OutlinedButton(
                  onPressed: () async {
                    final confirmed = await AppDialogs.showConfirmDialog(
                      title: 'Log Out',
                      message: 'Are you sure you want to log out?',
                      confirmText: 'Log Out',
                    );
                    if (confirmed) {
                      await controller.logout();
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Log Out',
                    style: AppTextStyles.button
                        .copyWith(color: AppColors.error),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
