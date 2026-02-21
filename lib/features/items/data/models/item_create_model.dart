import 'package:backonnect/features/items/domain/repositories/items_repository.dart';

class ItemCreateModel {
  final String name;
  final String? description;
  final double price;
  final double? tax;

  const ItemCreateModel({
    required this.name,
    this.description,
    required this.price,
    this.tax,
  });

  factory ItemCreateModel.fromEntity(ItemCreateEntity entity) {
    return ItemCreateModel(
      name: entity.name,
      description: entity.description,
      price: entity.price,
      tax: entity.tax,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null) 'description': description,
      'price': price,
      if (tax != null) 'tax': tax,
    };
  }
}
