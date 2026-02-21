import 'package:backonnect/app/routes/app_routes.dart';
import 'package:backonnect/app/theme/app_colors.dart';
import 'package:backonnect/app/theme/app_text_styles.dart';
import 'package:backonnect/core/extensions/date_extensions.dart';
import 'package:backonnect/core/utils/dialogs/app_dialogs.dart';
import 'package:backonnect/core/utils/formatters/date_formatters.dart';
import 'package:backonnect/features/items/controllers/item_detail_controller.dart';
import 'package:backonnect/features/items/controllers/items_controller.dart';
import 'package:backonnect/features/items/domain/entities/item_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemDetailPage extends GetView<ItemDetailController> {
  const ItemDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(color: AppColors.onSurface),
        title: Obx(() {
          return Text(
            controller.item.value?.name ?? 'Item Detail',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }),
        actions: [
          // Edit
          Obx(() {
            if (controller.item.value == null) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              tooltip: 'Edit',
              onPressed: () async {
                final result = await Get.toNamed<dynamic>(
                  AppRoutes.editItem,
                  arguments: controller.item.value,
                );
                if (result is ItemEntity) {
                  controller.item.value = result;
                }
              },
            );
          }),
          // Delete
          Obx(() {
            if (controller.item.value == null) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(
                Icons.delete_outline,
                size: 20,
                color: AppColors.error,
              ),
              tooltip: 'Delete',
              onPressed: () async {
                final confirmed = await AppDialogs.showConfirmDialog(
                  title: 'Delete Item',
                  message:
                      'Delete "${controller.item.value!.name}"? This cannot be undone.',
                  confirmText: 'Delete',
                );
                if (confirmed) {
                  if (Get.isRegistered<ItemsController>()) {
                    await Get.find<ItemsController>()
                        .deleteItem(controller.item.value!.id);
                  }
                  Get.back<void>();
                }
              },
            );
          }),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          );
        }

        final item = controller.item.value;
        if (item == null) {
          return const Center(
            child: Text('Item not found', style: AppTextStyles.bodyM),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: AppTextStyles.headingL),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          DateFormatters.formatCurrency(item.price),
                          style: AppTextStyles.priceLarge,
                        ),
                        if (item.tax != null) ...[
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '+${DateFormatters.formatCurrency(item.tax!)} tax',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (item.tax != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Total: ${DateFormatters.formatCurrency(item.totalPrice)}',
                        style: AppTextStyles.bodyS
                            .copyWith(color: AppColors.textMuted),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Description
              if (item.description != null &&
                  item.description!.isNotEmpty) ...[
                _sectionTitle('Description'),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Text(item.description!, style: AppTextStyles.bodyM),
                ),
                const SizedBox(height: 16),
              ],

              // Metadata
              _sectionTitle('Details'),
              const SizedBox(height: 8),
              _detailRow('ID', '#${item.id}'),
              const Divider(height: 1, color: AppColors.divider),
              _detailRow('Price', DateFormatters.formatCurrency(item.price)),
              if (item.tax != null) ...[
                const Divider(height: 1, color: AppColors.divider),
                _detailRow('Tax', DateFormatters.formatCurrency(item.tax!)),
                const Divider(height: 1, color: AppColors.divider),
                _detailRow(
                  'Total',
                  DateFormatters.formatCurrency(item.totalPrice),
                ),
              ],
              const Divider(height: 1, color: AppColors.divider),
              _detailRow('Created', item.createdAt.formatted),
              const Divider(height: 1, color: AppColors.divider),
              _detailRow('Last Updated', item.updatedAt.timeAgo),

              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: AppTextStyles.label,
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyS.copyWith(color: AppColors.textMuted)),
          Text(
            value,
            style:
                AppTextStyles.bodyS.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
