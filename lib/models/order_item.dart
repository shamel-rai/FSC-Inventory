class OrderItem {
  final String name;
  int quantity;
  double price;

  OrderItem({required this.name, required this.quantity, required this.price});

  double get total => quantity * price;

  Map<String, dynamic> toMap() => {
    'name': name,
    'quantity': quantity,
    'price': price,
  };

  static OrderItem fromMap(Map<String, dynamic> map) => OrderItem(
    name: map['name'],
    quantity: map['quantity'],
    price: map['price'],
  );
}
