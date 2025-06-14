import 'package:flutter/material.dart';
import 'package:fsc_management/widgets/custom_bottomNav.dart';
import 'package:fsc_management/widgets/custom_navBar.dart';

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Welcome to Homepage", style: TextStyle(color: Colors.black)),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [HomeContent()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavbar(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomnav(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex:
            index;
          });
        },
      ),
    );
  }
}
