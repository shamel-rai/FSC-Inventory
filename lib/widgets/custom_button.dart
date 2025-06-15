import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: FloatingActionButton(
        onPressed: onPressed,
        child: Icon(icon, size: 18),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        elevation: 2,
        heroTag: null, // Prevents tag conflict inside ListView
      ),
    );
  }
}
