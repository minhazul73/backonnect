class ItemEntity {
  final int id;
  final String name;
  final String? description;
  final double price;
  final double? tax;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ItemEntity({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.tax,
    required this.createdAt,
    required this.updatedAt,
  });

  double get totalPrice => price + (tax ?? 0.0);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  ItemEntity copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    double? tax,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ItemEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      tax: tax ?? this.tax,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
