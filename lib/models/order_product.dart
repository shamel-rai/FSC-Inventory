// ignore_for_file: public_member_api_docs, sort_constructors_first
class OrderProduct {
  final int? id;
  final int orderId;
  final int productId;
  final int quantity;
  final double priceAtOrder;

  OrderProduct({
    this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.priceAtOrder,
  });

  Map<String, dynamic> toMap() {
    return {
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
      'price_at_order': priceAtOrder,
    };
  }

  factory OrderProduct.fromMap(Map<String, dynamic> map) {
    return OrderProduct(
      id: map['order_product_id'],
      orderId: map['order_id'],
      productId: map['product_id'],
      quantity: map['quantity'],
      priceAtOrder: map['price_at_order'],
    );
  }
}
