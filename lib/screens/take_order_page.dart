import 'package:flutter/material.dart';
import 'package:fsc_management/database/db_helper.dart';
import 'package:fsc_management/models/inventory_item.dart';
import 'dart:io';

class TakeOrderPage extends StatefulWidget {
  final int token;
  const TakeOrderPage({super.key, required this.token});

  @override
  State<TakeOrderPage> createState() => _TakeOrderPageState();
}

class _TakeOrderPageState extends State<TakeOrderPage> {
  final db = DbHelper();
  List<InventoryItem> items = [];
  Map<int, int> quantities = {}; // productId => qty

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    items = await db.getallInventoryItems();
    setState(() {});
  }

  void updateQty(int id, int delta) {
    setState(() {
      final current = quantities[id] ?? 0;
      final newQty = (current + delta).clamp(0, 999);
      if (newQty == 0) {
        quantities.remove(id);
      } else {
        quantities[id] = newQty;
      }
    });
  }

  Future<void> submitOrder() async {
    final orderId = await db.createOrder(token: widget.token);
    for (var entry in quantities.entries) {
      final product = items.firstWhere((e) => e.id == entry.key);
      await db.insertOrderProduct(
        orderId: orderId,
        productId: product.id!,
        quantity: entry.value,
        priceAtOrder: product.price,
      );
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Order has been placed for Token: ${widget.token}"),
      ),
    );
  }

  Widget _buildImage(String? path) {
    if (path == null || path.isEmpty) {
      return Icon(Icons.image_not_supported, size: 60, color: Colors.grey);
    }

    final file = File(path);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Icon(Icons.broken_image, size: 60, color: Colors.grey),
      );
    } else {
      return Icon(Icons.broken_image, size: 60, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Take Order for Token ${widget.token}")),

      body: items.isEmpty
          ? Center(child: Text("No inventory items found."))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, index) {
                final item = items[index];
                final qty = quantities[item.id!] ?? 0;

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildImage(item.imagePath),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Rs: ${item.price} | Stock : ${item.stock}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => updateQty(item.id!, -1),
                              icon: Icon(Icons.remove),
                            ),
                            Text('$qty', style: TextStyle(fontSize: 16)),
                            IconButton(
                              onPressed: () => updateQty(item.id!, 1),
                              icon: Icon(Icons.add),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: quantities.isEmpty ? null : submitOrder,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
          ),
          child: Text("Submit Order", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
