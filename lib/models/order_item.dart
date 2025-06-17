class OrderItem {
  final String name;
  int quantity;
  double price;

  OrderItem({required this.name, required this.quantity, required this.price});

  double get total => quantity * price;
}
