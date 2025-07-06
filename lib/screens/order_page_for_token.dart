import 'package:flutter/material.dart';
import 'package:fsc_management/database/db_helper.dart';
import 'package:fsc_management/screens/take_order_page.dart';
import 'dart:io';

class OrderPageForToken extends StatefulWidget {
  final int token;
  const OrderPageForToken({super.key, required this.token});

  @override
  State<OrderPageForToken> createState() => _OrderPageForTokenState();
}

class _OrderPageForTokenState extends State<OrderPageForToken> {
  final db = DbHelper();
  List<Map<String, dynamic>> orderedItems = [];

  @override
  void initState() {
    super.initState();
    loadOrderedItems();
  }

  Future<void> loadOrderedItems() async {
    final result = await db.getOrderedItemByToken(widget.token);
    setState(() {
      orderedItems = result;
    });
  }

  //
  Widget _buildImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Icon(Icons.image_not_supported, size: 60);
    }

    final file = File(imagePath);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Icon(Icons.broken_image_outlined, size: 60),
      );
    } else {
      return Icon(Icons.broken_image, size: 60);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Token #${widget.token} Orders")),
      body: orderedItems.isEmpty
          ? Center(child: Text("No items ordered yet."))
          : ListView.builder(
              itemCount: orderedItems.length,
              itemBuilder: (_, index) {
                final item = orderedItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildImage(item['product_image']),
                      ),
                      title: Text(item['product_name']),
                      subtitle: Text(
                        "Qty: ${item['quantity']} | Rs. ${item['price_at_order']}",
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton.icon(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TakeOrderPage(token: widget.token),
              ),
            );
            await loadOrderedItems(); // Refresh after return
          },
          icon: Icon(Icons.add_shopping_cart),
          label: Text("Take Order"),
        ),
      ),
    );
  }
}
