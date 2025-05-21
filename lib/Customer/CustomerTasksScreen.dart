import 'package:flutter/material.dart';
import 'Complaint.dart'; // Import the Complaint screen
import 'RatingFeedbackScreen.dart'; // Import the RatingFeedbackScreen

class CustomerTasksScreen extends StatefulWidget {
  final bool isForRating;

  CustomerTasksScreen({required this.isForRating});

  @override
  _CustomerTasksScreenState createState() => _CustomerTasksScreenState();
}

class _CustomerTasksScreenState extends State<CustomerTasksScreen> {
  int _selectedIndex = 2;

  final List<Map<String, String>> _tasks = [
    {"name": "Plumbing Work", "middleman": "John Doe", "date": "2024-01-25"},
    {"name": "House Cleaning", "middleman": "Sarah Smith", "date": "2024-01-20"},
    {"name": "Car Repair", "middleman": "Mike Johnson", "date": "2024-01-18"},
    {"name": "Gardening Service", "middleman": "Emily Davis", "date": "2024-01-15"},
    {"name": "Electrical Fixing", "middleman": "Robert Brown", "date": "2024-01-10"},
  ];

  void _navigateToScreen(String taskName, String middleman) {
    if (widget.isForRating) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RatingFeedbackScreen(taskName: taskName, middleman: middleman),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Complaint(taskName: taskName, middleman: middleman),
        ),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 92, 13, 8),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Taskify', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
          ],
        ),
        
      ),
      body: Container(
        color: Color.fromARGB(255, 246, 240, 240), // Set background color here
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                widget.isForRating ? 'Rate Completed Tasks' : 'File a Complaint',
                style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5, // Shadow effect
                      color: Colors.white.withOpacity(0.9), // White background with slight transparency
                      child: InkWell(
                        onTap: () {
                          _navigateToScreen(_tasks[index]["name"]!, _tasks[index]["middleman"]!);
                        },
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _tasks[index]["name"]!,
                                      style: TextStyle(color: Color(0xFF6D1B1B), fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Middleman: ${_tasks[index]["middleman"]}',
                                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      _tasks[index]["date"]!,
                                      style: TextStyle(color: Colors.black87, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.check_circle, color: Colors.green, size: 30),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Location'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Post'),
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Posted Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Color.fromARGB(255, 105, 18, 12),
        onTap: _onItemTapped,
      ),
    );
  }
}
