import 'package:flutter/material.dart';
import 'RatingFeedbackScreen.dart'; // Assuming you have a RateFeedbackScreen
import 'Complaint.dart'; // Assuming you have a ComplaintScreen

class TaskDetailScreen extends StatefulWidget {
  final String taskName;
  final String bidAmount;
  final String description;
  final String middleman;
  final String time;

  TaskDetailScreen({
    required this.taskName,
    required this.bidAmount,
    required this.description,
    required this.middleman,
    required this.time,
  });

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  List<String> middlemen = ["Farwa", "Saad", "Jamal", "Ali"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Details", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Color(0xFFF6F0F0),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: EdgeInsets.all(20),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Task Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF800000),
                ),
              ),
              Divider(color: Color(0xFF800000)),
              SizedBox(height: 10),
              _buildTaskDetail("Task", widget.taskName),
              _buildTaskDetail("Middleman", widget.middleman),
              _buildTaskDetail("Time", widget.time),
              _buildTaskDetail("Bid", "PKR ${widget.bidAmount}"),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RatingFeedbackScreen(
                            taskName: widget.taskName,
                            middleman: widget.middleman,
                          ),
                        ),
                      );
                    },
                    child: Text("Rate Task"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Complaint(
                            taskName: widget.taskName,
                            middleman: widget.middleman,
                          ),
                        ),
                      );
                    },
                    child: Text("File Complaint"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskDetail(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label:",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF800000),
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
