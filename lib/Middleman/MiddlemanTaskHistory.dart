import 'package:flutter/material.dart';
import 'DetailedTask.dart'; // Ensure this import is correct

class MiddlemanTaskHistory extends StatelessWidget {
  final List<Map<String, String>> taskData = [
    {
      'taskTitle': 'Grocery',
      'customerName': 'Farwa',
      'taskDate': '2025-02-01',
    },
    {
      'taskTitle': 'Plumbing',
      'customerName': 'Jamal',
      'taskDate': '2025-02-03',
    },
    {
      'taskTitle': 'Pharmacy',
      'customerName': 'Saad',
      'taskDate': '2025-02-05',
    },
  ]; // Example task data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task History",style: TextStyle(color: const Color.fromARGB(255, 247, 245, 245),fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF800000),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: taskData.length,
          itemBuilder: (context, index) {
            final task = taskData[index];
            return InkWell(
              onTap: () {
                // Ensure that you pass all required parameters to DetailedTask
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailedTask(
                      taskTitle: task['taskTitle'] ?? '',
                      customerName: task['customerName'] ?? '',
                      taskDate: task['taskDate'] ?? '',
                      taskTime: '12:00 PM', // Provide a value for taskTime here
                      bidAmount: '100', // Provide a value for bidAmount here
                      customerProfileUrl: task['customerProfileUrl'] ?? '',
                    ),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 5,
                shadowColor: Colors.black.withOpacity(0.2),
                margin: const EdgeInsets.only(bottom: 16.0),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Left side showing task title and customer name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task['taskTitle'] ?? '',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF800000),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              task['customerName'] ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.0),
                      // Right side showing task date
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF800000),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          task['taskDate'] ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
