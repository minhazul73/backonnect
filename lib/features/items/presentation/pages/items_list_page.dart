import 'package:backonnect/app/routes/app_routes.dart';
import 'package:backonnect/app/theme/app_colors.dart';
import 'package:backonnect/app/theme/app_text_styles.dart';
import 'package:backonnect/core/constants/app_constants.dart';
import 'package:backonnect/core/utils/dialogs/app_dialogs.dart';
import 'package:backonnect/features/items/controllers/items_controller.dart';
import 'package:backonnect/features/items/presentation/widgets/item_card.dart';
import 'package:backonnect/features/items/presentation/widgets/shimmer_item_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemsListPage extends GetView<ItemsController> {
  const ItemsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Icon(
                Icons.link_rounded,
                color: AppColors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            const Text(AppConstants.appName),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, size: 22),
            onPressed: () => Get.toNamed<void>(AppRoutes.profile),
            tooltip: 'Profile',
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const ShimmerItemList();
        }

        if (controller.hasError.value && controller.items.isEmpty) {
          return _buildErrorState();
        }

        if (controller.items.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.refreshItems,
          child: Column(
            children: [
              // Item count header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  children: [
                    Text(
                      '${controller.totalItems.value} items',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: controller.items.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.items.length) {
                      return Obx(() {
                        if (controller.isLoadingMore.value) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          );
                        }
                        return const SizedBox(height: 8);
                      });
                    }

                    final item = controller.items[index];
                    return ItemCard(
                      item: item,
                      onTap: () => Get.toNamed<void>(
                        AppRoutes.itemDetail,
                        arguments: item,
                      ),
                      onEdit: () => Get.toNamed<void>(
                        AppRoutes.editItem,
                        arguments: item,
                      ),
                      onDelete: () async {
                        final confirmed = await AppDialogs.showConfirmDialog(
                          title: 'Delete Item',
                          message:
                              'Delete "${item.name}"? This cannot be undone.',
                          confirmText: 'Delete',
                        );
                        if (confirmed) {
                          await controller.deleteItem(item.id);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed<void>(AppRoutes.createItem),
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 52,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            const Text(
              'No items yet',
              style: AppTextStyles.headingM,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the + button to add your first item.',
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 160,
              child: ElevatedButton(
                onPressed: () => Get.toNamed<void>(AppRoutes.createItem),
                child: const Text('Add Item'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_outlined,
              size: 52,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load items',
              style: AppTextStyles.headingM,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                controller.errorMessage.value,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 160,
              child: ElevatedButton(
                onPressed: controller.fetchItems,
                child: const Text('Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
