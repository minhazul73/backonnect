import 'package:backonnect/core/constants/app_constants.dart';
import 'package:backonnect/core/exceptions/app_exceptions.dart';
import 'package:backonnect/core/utils/dialogs/app_snackbars.dart';
import 'package:backonnect/core/utils/logger/app_logger.dart';
import 'package:backonnect/features/items/domain/entities/item_entity.dart';
import 'package:backonnect/features/items/domain/repositories/items_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemsController extends GetxController {
  final ItemsRepository _itemsRepository;

  ItemsController({required ItemsRepository itemsRepository})
      : _itemsRepository = itemsRepository;

  final RxList<ItemEntity> items = <ItemEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalItems = 0.obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    fetchItems();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    final maxScroll = scrollController.position.maxScrollExtent;
    final current = scrollController.position.pixels;
    const threshold = AppConstants.infiniteScrollThreshold;

    if (maxScroll - current <= threshold &&
        !isLoadingMore.value &&
        !isLoading.value &&
        currentPage.value < totalPages.value) {
      loadMore();
    }
  }

  Future<void> fetchItems() async {
    try {
      hasError.value = false;
      isLoading.value = true;
      currentPage.value = 1;

      final result = await _itemsRepository.getItems(
        page: 1,
        perPage: AppConstants.defaultPerPage,
      );

      items.assignAll(result.items);
      totalPages.value = result.pagination.lastPage;
      totalItems.value = result.pagination.total;
    } on AppException catch (e) {
      hasError.value = true;
      errorMessage.value = e.message;
      AppSnackbars.showError(e.message);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load items';
      AppLogger.error('Unexpected error fetching items', error: e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || currentPage.value >= totalPages.value) return;

    final nextPage = currentPage.value + 1;
    try {
      isLoadingMore.value = true;
      final result = await _itemsRepository.getItems(
        page: nextPage,
        perPage: AppConstants.defaultPerPage,
      );
      items.addAll(result.items);
      currentPage.value = nextPage;
    } on AppException catch (e) {
      AppSnackbars.showError(e.message);
    } catch (e) {
      AppLogger.error('Error loading more items', error: e);
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshItems() async {
    // Scroll back to top before refreshing
    if (scrollController.hasClients) {
      await scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
    await fetchItems();
  }

  Future<void> deleteItem(int id) async {
    try {
      await _itemsRepository.deleteItem(id);
      items.removeWhere((item) => item.id == id);
      totalItems.value = (totalItems.value - 1).clamp(0, double.maxFinite).toInt();
      AppSnackbars.showSuccess('Item deleted');
    } on AppException catch (e) {
      AppSnackbars.showError(e.message);
    } catch (e) {
      AppLogger.error('Error deleting item', error: e);
      AppSnackbars.showError('Failed to delete item');
    }
  }

  void addItemLocally(ItemEntity item) {
    items.insert(0, item);
    totalItems.value++;
  }

  void updateItemLocally(ItemEntity updated) {
    final idx = items.indexWhere((i) => i.id == updated.id);
    if (idx >= 0) items[idx] = updated;
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }
}
