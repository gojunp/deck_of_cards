import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // Allow for nullable onPressed

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // Uses onPressed which could be null or valid
      style: ElevatedButton.styleFrom(
        backgroundColor:
            const Color.fromARGB(255, 68, 165, 255), // Violet/Blue background
        foregroundColor: Colors.white, // White text
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4), // Small border radius
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        disabledBackgroundColor: Colors.blueGrey, // Greyed out when disabled
        disabledForegroundColor: Colors.white70, // Lighter text when disabled
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
