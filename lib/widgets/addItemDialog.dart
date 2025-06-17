import 'package:flutter/material.dart';
import 'package:fsc_management/models/order_item.dart';

class AddItemDialog extends StatefulWidget {
  final OrderItem? existing;

  AddItemDialog({this.existing});

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  late TextEditingController nameCtrl;
  late TextEditingController qtyCtrl;
  late TextEditingController priceCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.existing?.name ?? "");
    qtyCtrl = TextEditingController(
      text: widget.existing?.quantity.toString() ?? "1",
    );
    priceCtrl = TextEditingController(
      text: widget.existing?.price.toString() ?? "0.0",
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? "Add Item" : "Edit Item"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameCtrl,
            decoration: InputDecoration(labelText: "Item Name"),
          ),
          TextField(
            controller: qtyCtrl,
            decoration: InputDecoration(labelText: "Quantity"),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: priceCtrl,
            decoration: InputDecoration(labelText: "Price"),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            final item = OrderItem(
              name: nameCtrl.text.trim(),
              quantity: int.tryParse(qtyCtrl.text) ?? 1,
              price: double.tryParse(priceCtrl.text) ?? 0.0,
            );
            Navigator.pop(context, item);
          },
          child: Text("Save"),
        ),
      ],
    );
  }
}
