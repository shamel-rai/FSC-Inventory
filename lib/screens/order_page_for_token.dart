import 'package:flutter/material.dart';
import 'package:fsc_management/database/db_helper.dart';

class OrderPageForToken extends StatelessWidget {
  final int token;
  const OrderPageForToken({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    final db = DbHelper();

    return Scaffold(
      appBar: AppBar(title: Text('Orders for Token #$token')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: db.getOrdersByToken(token),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Text("Order ID: ${order['order_id']}"),
                subtitle: Text("Paid: ${order['paid'] == 1 ? 'Yes' : 'No'}"),
              );
            },
          );
        },
      ),
    );
  }
}
