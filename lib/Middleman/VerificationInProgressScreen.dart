import 'package:flutter/material.dart';
import 'MiddlemanHomeScreen.dart'; // Import your HomeScreen widget (adjust the name as needed)

class VerificationInProgressScreen extends StatelessWidget {
  const VerificationInProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a custom maroon color
    final maroonColor = Color(0xFF800000); // Maroon color code

    return Scaffold(
      body: Container(
        color: Colors.white, // Set the background to white
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // CircularProgressIndicator with a larger, custom style
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(maroonColor), // Use the custom maroon color
                strokeWidth: 8.0, // Slightly thicker for better visibility
              ),
              SizedBox(height: 30), // Added more space between spinner and text
              // Title Text - Centered and Bold
              Text(
                'Verification in Progress...',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: maroonColor, // Use the custom maroon color
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(2, 2),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              // Subtitle Text with a smaller size and subtle styling
              Text(
                'Please wait while we verify your details.',
                style: TextStyle(
                  fontSize: 18,
                  color: maroonColor.withOpacity(0.7), // Lighter shade of maroon for contrast
                  fontStyle: FontStyle.italic,
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(1, 1),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40), // Space before any possible action button
              // Retry Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
