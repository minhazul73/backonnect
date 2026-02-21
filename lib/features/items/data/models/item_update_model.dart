import 'package:backonnect/features/items/domain/repositories/items_repository.dart';

class ItemUpdateModel {
  final String? name;
  final String? description;
  final double? price;
  final double? tax;

  const ItemUpdateModel({
    this.name,
    this.description,
    this.price,
    this.tax,
  });

  factory ItemUpdateModel.fromEntity(ItemUpdateEntity entity) {
    return ItemUpdateModel(
      name: entity.name,
      description: entity.description,
      price: entity.price,
      tax: entity.tax,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name != null) map['name'] = name;
    if (description != null) map['description'] = description;
    if (price != null) map['price'] = price;
    if (tax != null) map['tax'] = tax;
    return map;
  }
}
