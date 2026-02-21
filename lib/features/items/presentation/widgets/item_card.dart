import 'package:backonnect/app/theme/app_colors.dart';
import 'package:backonnect/app/theme/app_text_styles.dart';
import 'package:backonnect/core/extensions/date_extensions.dart';
import 'package:backonnect/core/extensions/string_extensions.dart';
import 'package:backonnect/core/utils/formatters/date_formatters.dart';
import 'package:backonnect/features/items/domain/entities/item_entity.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final ItemEntity item;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ItemCard({
    super.key,
    required this.item,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Price badge
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  '\$${item.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
              const SizedBox(width: 14),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: AppTextStyles.bodyL.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.description != null &&
                        item.description!.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        item.description!.truncate(72),
                        style: AppTextStyles.bodyS.copyWith(
                          color: AppColors.textMuted,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          DateFormatters.formatCurrency(item.price),
                          style: AppTextStyles.pricePrimary,
                        ),
                        if (item.tax != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            '+${DateFormatters.formatCurrency(item.tax!)} tax',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Updated ${item.updatedAt.timeAgo}',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              // Actions
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: AppColors.textMuted,
                      ),
                      onPressed: onEdit,
                      splashRadius: 18,
                      padding: const EdgeInsets.all(6),
                      constraints: const BoxConstraints(),
                      tooltip: 'Edit',
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: AppColors.error,
                      ),
                      onPressed: onDelete,
                      splashRadius: 18,
                      padding: const EdgeInsets.all(6),
                      constraints: const BoxConstraints(),
                      tooltip: 'Delete',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
