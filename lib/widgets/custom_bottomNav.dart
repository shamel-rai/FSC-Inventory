import 'package:flutter/material.dart';

class CustomBottomnav extends StatelessWidget {
  final currentIndex;
  final Function(int) onTap;
  const CustomBottomnav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      indicatorColor: Colors.amber,
      destinations: const [
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: "Home",
        ),
        NavigationDestination(
          icon: Icon(Icons.production_quantity_limits_rounded),
          label: "Inventory",
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.money_off_csred),
          icon: Icon(Icons.attach_money_outlined),
          label: "Billing",
        ),
      ],
    );
  }
}
