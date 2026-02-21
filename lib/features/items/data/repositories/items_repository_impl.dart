import 'dart:convert';

import 'package:backonnect/core/exceptions/app_exceptions.dart';
import 'package:backonnect/core/network/models/pagination_model.dart';
import 'package:backonnect/core/storage/local_storage_service.dart';
import 'package:backonnect/core/utils/logger/app_logger.dart';
import 'package:backonnect/features/items/data/datasources/items_remote_datasource.dart';
import 'package:backonnect/features/items/data/models/item_create_model.dart';
import 'package:backonnect/features/items/data/models/item_model.dart';
import 'package:backonnect/features/items/data/models/item_update_model.dart';
import 'package:backonnect/features/items/domain/entities/item_entity.dart';
import 'package:backonnect/features/items/domain/repositories/items_repository.dart';

class ItemsRepositoryImpl implements ItemsRepository {
  final ItemsRemoteDatasource remoteDatasource;
  final LocalStorageService localStorageService;

  static const String _cacheKey = 'cached_items_page_1';

  ItemsRepositoryImpl({
    required this.remoteDatasource,
    required this.localStorageService,
  });

  @override
  Future<PaginatedResponse<ItemEntity>> getItems({
    required int page,
    required int perPage,
  }) async {
    try {
      final response = await remoteDatasource.getItems(
        page: page,
        perPage: perPage,
      );
      final entities = response.items.map((m) => m.toEntity()).toList();

      // Cache first page only
      if (page == 1) {
        await localStorageService.write<String>(
          _cacheKey,
          jsonEncode(response.items.map((e) => e.toJson()).toList()),
        );
      }

      return PaginatedResponse<ItemEntity>(
        items: entities,
        pagination: response.pagination,
      );
    } catch (e) {
      AppLogger.warning('Failed to fetch items from remote', error: e);
      // Fall back to local cache for page 1
      if (page == 1) {
        final cached = localStorageService.read<String>(_cacheKey);
        if (cached != null) {
          final list = (jsonDecode(cached) as List<dynamic>)
              .map((e) => ItemModel.fromJson(e as Map<String, dynamic>).toEntity())
              .toList();
          return PaginatedResponse<ItemEntity>(
            items: list,
            pagination: PaginationModel(
              currentPage: 1,
              perPage: perPage,
              lastPage: 1,
              total: list.length,
            ),
          );
        }
      }
      rethrow;
    }
  }

  @override
  Future<ItemEntity> getItemById(int id) async {
    final model = await remoteDatasource.getItemById(id);
    return model.toEntity();
  }

  @override
  Future<ItemEntity> createItem(ItemCreateEntity itemCreate) async {
    final model = await remoteDatasource.createItem(
      ItemCreateModel.fromEntity(itemCreate),
    );
    return model.toEntity();
  }

  @override
  Future<List<ItemEntity>> bulkCreateItems(
    List<ItemCreateEntity> items,
  ) async {
    final models = await remoteDatasource.bulkCreateItems(
      items.map((e) => ItemCreateModel.fromEntity(e)).toList(),
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<ItemEntity> updateItem(int id, ItemUpdateEntity itemUpdate) async {
    final model = await remoteDatasource.updateItem(
      id,
      ItemUpdateModel.fromEntity(itemUpdate),
    );
    return model.toEntity();
  }

  @override
  Future<void> deleteItem(int id) async {
    if (id <= 0) throw const BadRequestException('Invalid item ID');
    await remoteDatasource.deleteItem(id);
  }
}
