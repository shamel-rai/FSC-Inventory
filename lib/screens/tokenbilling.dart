// import 'package:flutter/material.dart';
// import 'package:fsc_management/database/db_helper.dart';
// import 'package:fsc_management/models/order_item.dart';
// import 'package:fsc_management/models/token_order.dart';
// import 'package:fsc_management/screens/addorderitem.dart';
// import 'package:fsc_management/widgets/custom_navBar.dart';

// class TokenBillingPage extends StatefulWidget {
//   final TokenOrder tokenOrder;

//   TokenBillingPage({super.key, required this.tokenOrder});

//   @override
//   State<TokenBillingPage> createState() => _TokenBillingPageState();
// }

// class _TokenBillingPageState extends State<TokenBillingPage> {
//   List<OrderItem> get items => widget.tokenOrder.items;

//   void _addItem() async {
//     final result = await showDialog<OrderItem>(
//       context: context,
//       builder: (context) => AddOrderItem(),
//     );

//     if (result != null) {
//       setState(() {
//         widget.tokenOrder.items.add(result);
//       });

//       final inventory = await DbHelper().getItemByName(result.name);
//       if (inventory != null) {
//         inventory.stock -= result.quantity;
//         await DbHelper().updateInventoryItem(inventory);
//       }
//     }
//   }

//   void _editItem(int index) async {
//     final currentItem = items[index];
//     final updatedItem = await showDialog<OrderItem>(
//       context: context,
//       builder: (context) => AddOrderItem(existing: currentItem),
//     );

//     if (updatedItem != null) {
//       setState(() {
//         items[index] = updatedItem;
//       });
//     }
//   }

//   void _deleteItem(int index) {
//     setState(() {
//       items.removeAt(index);
//     });
//   }

//   void _payNow() async {
//     final token = widget.tokenOrder.token;
//     final date = DateTime.now().toIso8601String().split("T")[0];
//     final total = widget.tokenOrder.total;
//     final itemMap = items.map((e) => e.toMap()).toList();

//     await DbHelper().insertPaidOrder(
//       token: token,
//       items: itemMap,
//       total: total,
//       date: date,
//     );
//     Navigator.pop(context, true);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomNavbar(),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: items.length,
//               itemBuilder: (context, index) {
//                 final item = items[index];
//                 return ListTile(
//                   title: Text(item.name),
//                   subtitle: Text('Quantity: ${item.quantity}'),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         onPressed: () => _editItem(index),
//                         icon: Icon(Icons.edit),
//                       ),
//                       IconButton(
//                         onPressed: () => _deleteItem(index),
//                         icon: Icon(Icons.delete),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           Divider(),
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Total: ${widget.tokenOrder.total.toStringAsFixed(2)}",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Row(
//                   children: [
//                     ElevatedButton(
//                       onPressed: _addItem,
//                       child: Text("Add Item"),
//                     ),
//                     SizedBox(width: 10),
//                     ElevatedButton(onPressed: _payNow, child: Text("Pay")),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
