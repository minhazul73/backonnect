import 'package:backonnect/features/items/domain/entities/item_entity.dart';

class ItemModel {
  final int id;
  final String name;
  final String? description;
  final double price;
  final double? tax;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ItemModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.tax,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      tax: json['tax'] != null ? (json['tax'] as num).toDouble() : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'tax': tax,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ItemEntity toEntity() {
    return ItemEntity(
      id: id,
      name: name,
      description: description,
      price: price,
      tax: tax,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
