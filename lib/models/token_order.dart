import 'package:fsc_management/models/order_item.dart';

class TokenOrder {
  final int tokenNumber;
  List<OrderItem> items;

  TokenOrder({required this.tokenNumber, required this.items});

  double get total => items.fold(0, (sum, item) => sum + item.total);
}
