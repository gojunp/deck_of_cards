import 'package:deck_of_cards/custom_button.dart';
import 'package:flutter/material.dart';

import 'random_cart_page.dart';

// Home Page widget
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F4F7), // Set background color
      appBar: AppBar(
        backgroundColor: Color(0xFFF3F4F7), // Set background color
        title: Text('Deck Of Cards', style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the PNG image
            Image.asset('assets/home.png'), // Update with your image path
            SizedBox(height: 20), // Space between image and button
            CustomButton(
              onPressed: () {
                // Navigate to RandomCardPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RandomCardPage()),
                );
              },
              text: 'START',
            ),
          ],
        ),
      ),
    );
  }
}
