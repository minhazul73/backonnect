import 'package:backonnect/core/network/api_client.dart';
import 'package:backonnect/core/storage/local_storage_service.dart';
import 'package:backonnect/features/items/controllers/create_item_controller.dart';
import 'package:backonnect/features/items/controllers/item_detail_controller.dart';
import 'package:backonnect/features/items/controllers/items_controller.dart';
import 'package:backonnect/features/items/data/datasources/items_remote_datasource.dart';
import 'package:backonnect/features/items/data/repositories/items_repository_impl.dart';
import 'package:backonnect/features/items/domain/repositories/items_repository.dart';
import 'package:get/get.dart';

class ItemsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ItemsRemoteDatasource>(
      () => ItemsRemoteDatasourceImpl(apiClient: Get.find<ApiClient>()),
    );
    Get.lazyPut<ItemsRepository>(
      () => ItemsRepositoryImpl(
        remoteDatasource: Get.find<ItemsRemoteDatasource>(),
        localStorageService: Get.find<LocalStorageService>(),
      ),
    );
    Get.lazyPut<ItemsController>(
      () => ItemsController(itemsRepository: Get.find<ItemsRepository>()),
    );
    Get.lazyPut<ItemDetailController>(
      () => ItemDetailController(
          itemsRepository: Get.find<ItemsRepository>()),
    );
    Get.lazyPut<CreateItemController>(
      () => CreateItemController(
          itemsRepository: Get.find<ItemsRepository>()),
    );
  }
}
