// import 'package:flutter/material.dart';
// import 'package:fsc_management/models/token_order.dart';
// import 'package:fsc_management/screens/tokenbilling.dart';
// import 'package:fsc_management/widgets/custom_button.dart';
// import 'package:fsc_management/widgets/custom_navBar.dart';

// class Tokenlistpage extends StatefulWidget {
//   State<Tokenlistpage> createState() => _TokenListPageState();
// }

// class _TokenListPageState extends State<Tokenlistpage> {
//   List<TokenOrder> _tokens = [];
//   int _nextToken = 1;

//   void _createNewToken() {
//     setState(() {
//       _tokens.add(TokenOrder(token: _nextToken, items: []));
//       _nextToken++;
//     });
//   }

//   void _openBilling(TokenOrder order) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => TokenBillingPage(tokenOrder: order)),
//     );

//     // Remove token from the list if paid
//     if (result == true) {
//       setState(() {
//         _tokens.remove(order);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: CustomNavbar(),
//       body: ListView.builder(
//         itemCount: _tokens.length,
//         itemBuilder: (_, index) {
//           final token = _tokens[index];
//           return ListTile(
//             title: Text("Token: ${token.token}"),
//             subtitle: Text("Items: ${token.items.length}"),
//             trailing: Icon(Icons.arrow_forward),
//             onTap: () => _openBilling(token),
//           );
//         },
//       ),
//       floatingActionButton: CustomButton(
//         icon: Icons.add,
//         onPressed: _createNewToken,
//       ),
//     );
//   }
// }
