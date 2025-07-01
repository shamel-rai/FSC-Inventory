class InventoryItem {
  final int? id;
  final String name;
  final double price;
  int stock;
  final String? imagePath;

  InventoryItem({
    this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'product_id': id,
      'product_name': name,
      'product_price': price,
      'product_stock': stock,
      'product_image': imagePath,
    };
  }

  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
      id: map['product_id'],
      name: map['product_name'],
      price: map['product_price'],
      stock: map['product_stock'],
      imagePath: map['product_image'],
    );
  }

  InventoryItem copyWith({
    int? id,
    String? name,
    double? price,
    int? stock,
    String? imagePath,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
