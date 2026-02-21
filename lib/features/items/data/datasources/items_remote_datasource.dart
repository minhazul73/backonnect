import 'package:backonnect/core/network/api_client.dart';
import 'package:backonnect/core/network/api_endpoint.dart';
import 'package:backonnect/core/network/models/pagination_model.dart';
import 'package:backonnect/features/items/data/models/item_create_model.dart';
import 'package:backonnect/features/items/data/models/item_model.dart';
import 'package:backonnect/features/items/data/models/item_update_model.dart';

abstract class ItemsRemoteDatasource {
  Future<PaginatedResponse<ItemModel>> getItems({
    required int page,
    required int perPage,
  });

  Future<ItemModel> getItemById(int id);

  Future<ItemModel> createItem(ItemCreateModel item);

  Future<List<ItemModel>> bulkCreateItems(List<ItemCreateModel> items);

  Future<ItemModel> updateItem(int id, ItemUpdateModel update);

  Future<void> deleteItem(int id);
}

class ItemsRemoteDatasourceImpl implements ItemsRemoteDatasource {
  final ApiClient apiClient;

  ItemsRemoteDatasourceImpl({required this.apiClient});

  @override
  Future<PaginatedResponse<ItemModel>> getItems({
    required int page,
    required int perPage,
  }) async {
    final response = await apiClient.get(
      ApiEndpoint.items,
      queryParameters: {'page_no': page, 'per_page': perPage},
    );
    final body = response.data as Map<String, dynamic>;
    final rawList = body['data'] as List<dynamic>;
    final items = rawList
        .map((e) => ItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final pagination = PaginationModel.fromJson(
      body['pagination'] as Map<String, dynamic>,
    );
    return PaginatedResponse<ItemModel>(items: items, pagination: pagination);
  }

  @override
  Future<ItemModel> getItemById(int id) async {
    final response = await apiClient.get(ApiEndpoint.itemById(id));
    final data = (response.data as Map<String, dynamic>)['data']
        as Map<String, dynamic>;
    return ItemModel.fromJson(data);
  }

  @override
  Future<ItemModel> createItem(ItemCreateModel item) async {
    final response = await apiClient.post(
      ApiEndpoint.items,
      data: item.toJson(),
    );
    final data = (response.data as Map<String, dynamic>)['data']
        as Map<String, dynamic>;
    return ItemModel.fromJson(data);
  }

  @override
  Future<List<ItemModel>> bulkCreateItems(List<ItemCreateModel> items) async {
    final response = await apiClient.post(
      ApiEndpoint.itemsBulkImport,
      data: items.map((e) => e.toJson()).toList(),
    );
    final rawList =
        (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
    return rawList
        .map((e) => ItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ItemModel> updateItem(int id, ItemUpdateModel update) async {
    final response = await apiClient.put(
      ApiEndpoint.itemById(id),
      data: update.toJson(),
    );
    final data = (response.data as Map<String, dynamic>)['data']
        as Map<String, dynamic>;
    return ItemModel.fromJson(data);
  }

  @override
  Future<void> deleteItem(int id) async {
    await apiClient.delete(ApiEndpoint.itemById(id));
  }
}
