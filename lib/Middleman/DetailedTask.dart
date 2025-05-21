import 'package:flutter/material.dart';
import 'RatingFeedback.dart'; // Import the RatingsFeedbackScreen

class DetailedTask extends StatelessWidget {
  final String taskTitle;
  final String customerName;
  final String taskDate;
  final String taskTime;
  final String bidAmount;
  final String customerProfileUrl; // Add a customer profile image URL

  DetailedTask({
    required this.taskTitle,
    required this.customerName,
    required this.taskDate,
    required this.taskTime,
    required this.bidAmount,
    required this.customerProfileUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Details", style: TextStyle(color: const Color.fromARGB(255, 242, 241, 241),fontWeight: FontWeight.bold),),
        backgroundColor: Color(0xFF800000), // Maroon color for AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task title
                  Text(
                    taskTitle,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF800000), // Maroon color
                    ),
                  ),
                  SizedBox(height: 10),

                  // Customer details
                  Row(
                    children: [
                      // Customer profile picture
                      CircleAvatar(
                        radius: 30.0,
                        backgroundImage: NetworkImage(customerProfileUrl),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Customer name
                          Text(
                            customerName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF800000),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Task Date and Time
                  Text(
                    'Task Date: $taskDate',
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18, color: const Color.fromARGB(255, 14, 14, 14)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Task Time: $taskTime',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: const Color.fromARGB(255, 14, 13, 13)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Bid Amount: $bidAmount',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 12, 12, 12)),
                  ),
                  SizedBox(height: 20),

                  // Task Details
                  Text(
                    'Task Details:',
                    style: TextStyle(
                        fontSize: 22,
                        
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF800000)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'This is a detailed description of the task, including specifics like task requirements, deadlines, and additional information.',
                    style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 15, 14, 14)),
                  ),
                  SizedBox(height: 30),

                  // Green Button for Rating and Feedback
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to Rating and Feedback Screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RatingFeedback(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Fixed error here
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                      ),
                      child: Text(
                        'View Rating and Feedback',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 243, 239, 239),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
