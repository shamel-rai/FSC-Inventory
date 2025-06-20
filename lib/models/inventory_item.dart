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
      'id': id,
      'name': name,
      'price': price,
      'stock': stock,
      'imagePath': imagePath,
    };
  }

  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      stock: map['stock'],
      imagePath: map['imagePath'],
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
