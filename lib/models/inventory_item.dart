class InventoryItem {
  final int? id;
  final String name;
  final double price;
  final int stock;
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
}
