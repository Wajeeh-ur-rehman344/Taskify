import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 92, 13, 8), // Maroon color
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white, // Set title text color to white
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Set icon color to white
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 246, 240, 240), // Background color matching the previous screen
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildNotificationCard(
              context,
              'John accepted your task',
              '2 hours ago',
              'Task Accepted',
            ),
            SizedBox(height: 10),
            _buildNotificationCard(
              context,
              'Your task was completed',
              '1 day ago',
              'Task Completed',
            ),
            SizedBox(height: 10),
            _buildNotificationCard(
              context,
              'Task posted successfully',
              '3 days ago',
              'Task Posted',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    String message,
    String time,
    String title,
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      color: Colors.white.withOpacity(0.9), // Light transparent background for a clean look
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and time on top-right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFF6D1B1B), // Maroon color for title
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            // Notification details
            Text(
              message,
              style: TextStyle(
                color: Colors.black87, // Darker text for message
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
