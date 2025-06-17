import 'package:flutter/material.dart';
import 'package:fsc_management/models/token_order.dart';
import 'package:fsc_management/screens/homepage.dart';

void main() {
  runApp(MyApp());
}

List<TokenOrder> allTokens = [];

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Homepage());
  }
}
