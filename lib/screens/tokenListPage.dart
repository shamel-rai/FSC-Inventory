import 'package:flutter/material.dart';
import 'package:fsc_management/models/token_order.dart';
import 'package:fsc_management/main.dart';
import 'package:fsc_management/screens/billingpage.dart';

class TokenListPage extends StatefulWidget {
  @override
  _TokenListPageState createState() => _TokenListPageState();
}

class _TokenListPageState extends State<TokenListPage> {
  int tokenCounter = 1;

  void createNewToken() {
    setState(() {
      allTokens.add(TokenOrder(tokenNumber: tokenCounter++, items: []));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Restaurant Tokens")),
      body: ListView.builder(
        itemCount: allTokens.length,
        itemBuilder: (context, index) {
          final token = allTokens[index];
          return ListTile(
            title: Text("Token ${token.tokenNumber}"),
            subtitle: Text("Total: \$${token.total.toStringAsFixed(2)}"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BillingPage(tokenOrder: token),
                ),
              ).then((_) => setState(() {})); // Refresh on return
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewToken,
        child: Icon(Icons.add),
        tooltip: "Create New Token",
      ),
    );
  }
}
