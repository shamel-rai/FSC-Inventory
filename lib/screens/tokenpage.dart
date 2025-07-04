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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Token Order"), centerTitle: true),
      body: Column(
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
                    title: Text('Token #$token'),
                    trailing: Icon(Icons.arrow_forward),
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
        ],
      ),
    );
  }
}
