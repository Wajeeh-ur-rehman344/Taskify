import 'package:flutter/material.dart';
import 'TaskDetailScreen.dart'; // Import the TaskDetailScreen

class TaskHistory extends StatelessWidget {
  final List<Map<String, String>> _completedTasks = [
    {
      "name": "Plumbing Work",
      "date": "2024-01-25",
      "status": "Completed",
      "bid": "500",
      "description": "Fixing the leaky faucet",
      "middleman": "Saad",
      "time": "10:30 AM"
    },
    {
      "name": "House Cleaning",
      "date": "2024-01-20",
      "status": "Completed",
      "bid": "300",
      "description": "Full house cleaning including kitchen",
      "middleman": "Farwa",
      "time": "2:00 PM"
    },
    {
      "name": "Car Repair",
      "date": "2024-01-18",
      "status": "Completed",
      "bid": "1500",
      "description": "Engine repair and oil change",
      "middleman": "Jamal",
      "time": "11:15 AM"
    },
    {
      "name": "Gardening Service",
      "date": "2024-01-15",
      "status": "Completed",
      "bid": "250",
      "description": "Lawn mowing and plant care",
      "middleman": "Ali",
      "time": "9:45 AM"
    },
    {
      "name": "Electrical Fixing",
      "date": "2024-01-10",
      "status": "Completed",
      "bid": "400",
      "description": "Fixing electrical wiring in the living room",
      "middleman": "Saad",
      "time": "4:30 PM"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task History', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Color(0xFF800000),
        elevation: 0,
      ),
      backgroundColor: Color(0xFFF6F0F0),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _completedTasks.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskDetailScreen(
                      taskName: _completedTasks[index]["name"]!,
                      bidAmount: _completedTasks[index]["bid"]!,
                      description: _completedTasks[index]["description"]!,
                      middleman: _completedTasks[index]["middleman"]!,
                      time: _completedTasks[index]["time"]!,
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 16.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _completedTasks[index]["name"]!,
                          style: TextStyle(
                            color: Color(0xFF800000),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Completed on ${_completedTasks[index]["date"]}',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.check_circle, color: Colors.green, size: 30),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
