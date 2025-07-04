import 'package:flutter/material.dart';
import 'package:fsc_management/models/product.dart';

class Orderitem extends StatefulWidget {
  const Orderitem({super.key});

  @override
  State<Orderitem> createState() => _OrderitemState();
}

class _OrderitemState extends State<Orderitem> {
  List<Product> products = [
    Product(name: 'Apple', stock: 10, price: 1.5),
    Product(name: 'Banana', stock: 8, price: 0.9),
    Product(name: 'Orange', stock: 5, price: 1.2),
  ];

  String paymentMethod = 'cash';

  double get totalAmount {
    return products
        .where((p) => p.selectedQuantity > 0)
        .fold(0, (sum, p) => sum + p.selectedQuantity * p.price);
  }

  void confirmOrder() {
    if (totalAmount == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("No Item has been selected")));
      return;
    }

    // update stock
    setState(() {
      for (var product in products) {
        if (product.selectedQuantity > 0) {
          product.stock -= product.selectedQuantity;
          product.selectedQuantity = 0;
        }
      }
    });

    // show recept
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Receipt"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...products
                .where((p) => p.selectedQuantity > 0)
                .map((p) => Text('${p.name} x ${p.selectedQuantity}')),
            Divider(),
            Text("Payment: $paymentMethod"),
            Text('Total: Rs ${totalAmount.toStringAsFixed(2)}'),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Products"),
            SizedBox(height: 10),
            ...products.map(
              (product) => ProductRow(
                product: product,
                onChanged: () => setState(() {}),
              ),
            ),

            Divider(height: 30),

            Text("Order Summary"),
            ...products
                .where((p) => p.selectedQuantity > 0)
                .map(
                  (p) => ListTile(
                    title: Text('${p.name} x${p.selectedQuantity}'),
                    subtitle: Text('\$${p.price.toStringAsFixed(2)} each'),
                    trailing: Text(
                      '\$${(p.price * p.selectedQuantity).toStringAsFixed(2)}',
                    ),
                  ),
                ),
            SizedBox(height: 10),
            Text(
              'Total: \$${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(height: 30),
            Text("💳 Payment Method"),
            ListTile(
              title: Text("Cash"),
              leading: Radio<String>(
                value: 'Cash',
                groupValue: paymentMethod,
                onChanged: (value) {
                  setState(() {
                    paymentMethod = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: Text("QR"),
              leading: Radio<String>(
                value: 'QR',
                groupValue: paymentMethod,
                onChanged: (value) {
                  setState(() {
                    paymentMethod = value!;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: confirmOrder,
              icon: Icon(Icons.check),
              label: Text('Confirm & Pay'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductRow extends StatelessWidget {
  final Product product;
  final VoidCallback onChanged;

  const ProductRow({required this.product, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('In Stock: ${product.stock}'),
                  Text('\$${product.price.toStringAsFixed(2)}'),
                ],
              ),
            ),
            IconButton(
              onPressed: product.selectedQuantity > 0
                  ? () {
                      product.selectedQuantity--;
                      onChanged();
                    }
                  : null,
              icon: Icon(Icons.remove_circle_outline),
            ),
            Text('${product.selectedQuantity}'),
            IconButton(
              onPressed: product.selectedQuantity < product.stock
                  ? () {
                      product.selectedQuantity++;
                      onChanged();
                    }
                  : null,
              icon: Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ),
    );
  }
}
