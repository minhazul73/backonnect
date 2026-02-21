import 'package:backonnect/core/exceptions/app_exceptions.dart';
import 'package:backonnect/core/utils/dialogs/app_snackbars.dart';
import 'package:backonnect/core/utils/logger/app_logger.dart';
import 'package:backonnect/features/items/domain/entities/item_entity.dart';
import 'package:backonnect/features/items/domain/repositories/items_repository.dart';
import 'package:get/get.dart';

class ItemDetailController extends GetxController {
  final ItemsRepository _itemsRepository;

  ItemDetailController({required ItemsRepository itemsRepository})
      : _itemsRepository = itemsRepository;

  final Rx<ItemEntity?> item = Rx<ItemEntity?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Item can be passed as argument or fetched by ID
    final args = Get.arguments;
    if (args is ItemEntity) {
      item.value = args;
    } else if (args is int) {
      fetchItem(args);
    } else if (args is Map<String, dynamic>) {
      final id = args['id'] as int?;
      final preloaded = args['item'] as ItemEntity?;
      if (preloaded != null) {
        item.value = preloaded;
      } else if (id != null) {
        fetchItem(id);
      }
    }
  }

  Future<void> fetchItem(int id) async {
    try {
      isLoading.value = true;
      final entity = await _itemsRepository.getItemById(id);
      item.value = entity;
    } on AppException catch (e) {
      AppSnackbars.showError(e.message);
    } catch (e) {
      AppLogger.error('Error fetching item detail', error: e);
      AppSnackbars.showError('Failed to load item');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    item.close();
    isLoading.close();
    super.onClose();
  }
}
