import 'package:flutter/material.dart';
import 'package:fsc_management/models/order_item.dart';
import 'package:fsc_management/models/token_order.dart';
import 'package:fsc_management/widgets/addItemDialog.dart';

class BillingPage extends StatefulWidget {
  final TokenOrder tokenOrder;

  BillingPage({required this.tokenOrder});

  @override
  _BillingPageState createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  void addItem() async {
    final item = await showDialog<OrderItem>(
      context: context,
      builder: (_) => AddItemDialog(),
    );

    if (item != null) {
      setState(() {
        widget.tokenOrder.items.add(item);
      });
    }
  }

  void deleteItem(int index) {
    setState(() {
      widget.tokenOrder.items.removeAt(index);
    });
  }

  void editItem(int index) async {
    final current = widget.tokenOrder.items[index];
    final updated = await showDialog<OrderItem>(
      context: context,
      builder: (_) => AddItemDialog(existing: current),
    );

    if (updated != null) {
      setState(() {
        widget.tokenOrder.items[index] = updated;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = widget.tokenOrder;

    return Scaffold(
      appBar: AppBar(title: Text("Token ${token.token}")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: token.items.length,
              itemBuilder: (_, index) {
                final item = token.items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text("Qty: ${item.quantity} × \$${item.price}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => editItem(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteItem(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: \$${token.total.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 20),
                ),
                ElevatedButton(onPressed: addItem, child: Text("Add Item")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
