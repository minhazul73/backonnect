import 'package:backonnect/app/theme/app_colors.dart';
import 'package:backonnect/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class UserInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const UserInfoTile({
    super.key,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style:
                    AppTextStyles.bodyS.copyWith(color: AppColors.textMuted),
              ),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.bodyS
                      .copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, color: AppColors.divider),
      ],
    );
  }
}
