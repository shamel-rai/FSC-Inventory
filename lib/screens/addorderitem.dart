import 'package:flutter/material.dart';
import 'package:fsc_management/database/db_helper.dart';
import 'package:fsc_management/models/inventory_item.dart';
import 'package:fsc_management/models/order_item.dart';

class AddOrderItem extends StatefulWidget {
  final OrderItem? existing;

  AddOrderItem({this.existing});

  @override
  State<AddOrderItem> createState() => _AddOrderItemDialogState();
}

class _AddOrderItemDialogState extends State<AddOrderItem> {
  List<InventoryItem> _inventory = [];
  InventoryItem? _selectedItem;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _loadInventory();

    if (widget.existing != null) {
      _quantity = widget.existing!.quantity;
    }
  }

  Future<void> _loadInventory() async {
    final items = await DbHelper().getAllIventoryItems();
    setState(() {
      _inventory = items;
    });

    if (widget.existing != null) {
      _selectedItem = _inventory.firstWhere(
        (item) => item.name == widget.existing!.name,
        orElse: () => _inventory.first,
      );
    }
  }

  void _submit() {
    if (_selectedItem == null ||
        _quantity <= 0 ||
        _quantity > _selectedItem!.stock)
      return;

    final orderItem = OrderItem(
      name: _selectedItem!.name,
      quantity: _quantity,
      price: _selectedItem!.price,
    );

    Navigator.of(context).pop(orderItem);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? "Add Item" : "Edit Item"),
      content: _inventory.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<InventoryItem>(
                  value: _selectedItem,
                  items: _inventory.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text('${item.name} (${item.price})'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedItem = value;
                    });
                  },
                  decoration: InputDecoration(labelText: "Product"),
                ),
                TextFormField(
                  initialValue: _quantity.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Quantity"),
                  onChanged: (value) {
                    setState(() {
                      _quantity = int.tryParse(value) ?? 1;
                    });
                  },
                ),
                if (_selectedItem != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text("Available Stock ${_selectedItem!.stock}"),
                  ),
              ],
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(onPressed: _submit, child: Text('Save')),
      ],
    );
  }
}
