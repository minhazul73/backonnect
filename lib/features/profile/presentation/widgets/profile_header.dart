import 'package:backonnect/app/theme/app_colors.dart';
import 'package:backonnect/app/theme/app_text_styles.dart';
import 'package:backonnect/features/auth/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final UserEntity user;

  const ProfileHeader({super.key, required this.user});

  String get _initials {
    final email = user.email;
    if (email.isEmpty) return '?';
    final parts = email.split('@');
    final name = parts.first;
    if (name.length >= 2) {
      return name.substring(0, 2).toUpperCase();
    }
    return name.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              _initials,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          user.email,
          style: AppTextStyles.bodyL.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          'ID: #${user.id}',
          style: AppTextStyles.bodyS.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: 20),
        const Divider(height: 1, color: AppColors.divider),
      ],
    );
  }
}
