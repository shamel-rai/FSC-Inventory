import 'package:flutter/material.dart';
import 'package:fsc_management/database/db_helper.dart';
import 'package:fsc_management/screens/order_page_for_token.dart';

class Tokenpage extends StatefulWidget {
  const Tokenpage({super.key});

  @override
  State<Tokenpage> createState() => _TokenpageState();
}

class _TokenpageState extends State<Tokenpage> {
  List<Map<String, dynamic>> tokens = [];
  String searchText = "";
  final db = DbHelper();

  @override
  void initState() {
    super.initState();
    loadTokens();
  }

  Future<void> loadTokens() async {
    final result = searchText.isEmpty
        ? await db.getAllTokens()
        : await db.searchTokens(searchText);
    setState(() {
      tokens = result;
    });
  }

  void _confirmDeleteToken(int token) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Token $token'),
        content: Text(
          'This will delete all orders and related data. Are you sure? ',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await db.deletToken(token);
              await loadTokens();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Token $token deleted')));
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Token Order"), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search token',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() => searchText = value);
                  loadTokens();
                },
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: tokens.length,
                itemBuilder: (context, index) {
                  final token = tokens[index]['token'];
                  return Card(
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),

                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Token: $token',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () => _confirmDeleteToken(token),
                        icon: Icon(Icons.delete_forever),
                        iconSize: 30,
                        color: Colors.black,
                      ),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OrderPageForToken(token: token),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final nextToken = await db.getNextToken();
                    await db.createOrder(token: nextToken);
                    await loadTokens();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Text $nextToken created")),
                    );
                  },
                  label: Text("Create Token", style: TextStyle(fontSize: 23)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
