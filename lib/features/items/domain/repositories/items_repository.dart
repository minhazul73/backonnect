import 'package:backonnect/core/network/models/pagination_model.dart';
import 'package:backonnect/features/items/domain/entities/item_entity.dart';

class ItemCreateEntity {
  final String name;
  final String? description;
  final double price;
  final double? tax;

  const ItemCreateEntity({
    required this.name,
    this.description,
    required this.price,
    this.tax,
  });
}

class ItemUpdateEntity {
  final String? name;
  final String? description;
  final double? price;
  final double? tax;

  const ItemUpdateEntity({
    this.name,
    this.description,
    this.price,
    this.tax,
  });
}

abstract class ItemsRepository {
  Future<PaginatedResponse<ItemEntity>> getItems({
    required int page,
    required int perPage,
  });

  Future<ItemEntity> getItemById(int id);

  Future<ItemEntity> createItem(ItemCreateEntity itemCreate);

  Future<List<ItemEntity>> bulkCreateItems(List<ItemCreateEntity> items);

  Future<ItemEntity> updateItem(int id, ItemUpdateEntity itemUpdate);

  Future<void> deleteItem(int id);
}
