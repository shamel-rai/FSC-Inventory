// This represents each product with stock, price, and how many the user picked.
class Product {
  String name;
  int stock;
  double price;
  int selectedQuantity;

  Product({
    required this.name,
    required this.stock,
    required this.price,
    this.selectedQuantity = 0,
  });
}
