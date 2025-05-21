import 'package:flutter/material.dart';
import 'TaskDetailScreen.dart'; // Import the TaskDetailScreen

class PostedTasksScreen extends StatelessWidget {
  final List<Map<String, String>> _postedTasks = [
    {
      "name": "Grocery Pickup",
      "date": "2024-02-01",
      "status": "Posted",
      "bid": "50",
      "description": "Pick up groceries from the local store."
    },
    {
      "name": "Home Cleaning",
      "date": "2024-01-30",
      "status": "Posted",
      "bid": "100",
      "description": "Complete cleaning of the house."
    },
    {
      "name": "Car Wash",
      "date": "2024-01-28",
      "status": "Posted",
      "bid": "20",
      "description": "Wash and vacuum the car."
    },
    {
      "name": "Delivery Service",
      "date": "2024-01-25",
      "status": "Posted",
      "bid": "30",
      "description": "Deliver a package to the specified address."
    },
    {
      "name": "Pet Sitting",
      "date": "2024-01-20",
      "status": "Posted",
      "bid": "75",
      "description": "Take care of pets while the owner is away."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 240, 240), // Match background color
      appBar: AppBar(
        title: Text('Posted Tasks', style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 8, 8, 8))),
       backgroundColor: const Color.fromARGB(255, 246, 240, 240), // Match app bar color
      ),
      body: ListView.builder(
        itemCount: _postedTasks.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: Colors.white, // White card background
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _postedTasks[index]["name"]!,
                            style: TextStyle(
                              color: Color(0xFF6D1B1B), // Text color changed to red
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Posted on ${_postedTasks[index]["date"]}',
                            style: TextStyle(color: Color(0xFF6D1B1B), fontSize: 14), // Text color changed to red
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Bid: \$${_postedTasks[index]["bid"]}',
                            style: TextStyle(color: Color(0xFF6D1B1B), fontSize: 14), // Text color changed to red
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to TaskDetailScreen on tapping the task
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskDetailScreen(
                                  taskName: _postedTasks[index]["name"]!,
                                  bidAmount: _postedTasks[index]["bid"]!,
                                  description: _postedTasks[index]["description"]!,
                                  middleman: 'John Doe', // Set dynamically as needed
                                  time: _postedTasks[index]["date"]!, // Pass the date as time
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                          child: Text("VIEW DETAILS",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
