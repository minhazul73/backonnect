import 'package:backonnect/app/routes/app_routes.dart';
import 'package:backonnect/core/exceptions/app_exceptions.dart';
import 'package:backonnect/core/utils/dialogs/app_snackbars.dart';
import 'package:backonnect/core/utils/logger/app_logger.dart';
import 'package:backonnect/features/items/controllers/items_controller.dart';
import 'package:backonnect/features/items/domain/entities/item_entity.dart';
import 'package:backonnect/features/items/domain/repositories/items_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateItemController extends GetxController {
  final ItemsRepository _itemsRepository;

  CreateItemController({required ItemsRepository itemsRepository})
      : _itemsRepository = itemsRepository;

  final RxBool isLoading = false.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController taxController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Set when editing an existing item
  ItemEntity? _editingItem;
  bool get isEditMode => _editingItem != null;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ItemEntity) {
      _editingItem = args;
      _prefill(args);
    }
  }

  void _prefill(ItemEntity item) {
    nameController.text = item.name;
    descriptionController.text = item.description ?? '';
    priceController.text = item.price.toString();
    taxController.text = item.tax?.toString() ?? '';
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    if (isEditMode) {
      await _updateItem();
    } else {
      await _createItem();
    }
  }

  Future<void> _createItem() async {
    try {
      isLoading.value = true;
      final entity = await _itemsRepository.createItem(
        ItemCreateEntity(
          name: nameController.text.trim(),
          description: descriptionController.text.trim().isEmpty
              ? null
              : descriptionController.text.trim(),
          price: double.parse(priceController.text.trim()),
          tax: taxController.text.trim().isEmpty
              ? null
              : double.tryParse(taxController.text.trim()),
        ),
      );

      // Refresh items list if controller exists
      if (Get.isRegistered<ItemsController>()) {
        Get.find<ItemsController>().addItemLocally(entity);
      }

      AppSnackbars.showSuccess('Item created successfully');
      Get.offNamed<void>(AppRoutes.itemsList);
    } on ValidationException catch (e) {
      AppSnackbars.showError(e.message);
    } on AppException catch (e) {
      AppSnackbars.showError(e.message);
    } catch (e) {
      AppLogger.error('Error creating item', error: e);
      AppSnackbars.showError('Failed to create item');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _updateItem() async {
    if (_editingItem == null) return;
    try {
      isLoading.value = true;
      final updated = await _itemsRepository.updateItem(
        _editingItem!.id,
        ItemUpdateEntity(
          name: nameController.text.trim(),
          description: descriptionController.text.trim().isEmpty
              ? null
              : descriptionController.text.trim(),
          price: double.parse(priceController.text.trim()),
          tax: taxController.text.trim().isEmpty
              ? null
              : double.tryParse(taxController.text.trim()),
        ),
      );

      if (Get.isRegistered<ItemsController>()) {
        Get.find<ItemsController>().updateItemLocally(updated);
      }

      AppSnackbars.showSuccess('Item updated successfully');
      Get.back<ItemEntity>(result: updated);
    } on ValidationException catch (e) {
      AppSnackbars.showError(e.message);
    } on AppException catch (e) {
      AppSnackbars.showError(e.message);
    } catch (e) {
      AppLogger.error('Error updating item', error: e);
      AppSnackbars.showError('Failed to update item');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    taxController.dispose();
    super.onClose();
  }
}
