import 'package:flutter/material.dart';
import 'package:fyp/URLs/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'PostTask.dart';
import 'Task.dart';
import 'Request.dart';
import 'package:fyp/ApiServices/customer_manageTask.dart';

class ManageTask extends StatefulWidget {
  @override
  _ManageTaskState createState() => _ManageTaskState();
}

class _ManageTaskState extends State<ManageTask> {
  List<dynamic> _tasks = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String userId = "";

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserData();
    await _fetchTasks();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id') ?? "";
    });
  }

  Future<void> _fetchTasks() async {
    if (userId.isEmpty) {
      setState(() {
        _errorMessage = 'User not authenticated';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await CustomerManageTask().custManageTask(userId);
      print("Raw response: ${response}"); // Debug print

      if (response['status'] == true) {
        // Convert the task object into a list
        final Map<String, dynamic> tasksMap = response['data'];
        final List<Map<String, dynamic>> tasksList = [];

        tasksMap.forEach((key, value) {
          if (value is Map) {
            // Add the key (task1, task2) as a title field
            final taskData = Map<String, dynamic>.from(value);
            taskData['title'] = key;
            tasksList.add(taskData);
          }
        });

        print("Transformed tasks list: $tasksList"); // Debug print

        setState(() {
          _tasks = tasksList.map((task) => _mapTask(task)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Failed to fetch tasks';
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error in _fetchTasks: $e"); // Debug print
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _mapTask(dynamic backendTask) {
    return {
      'attImg': backendTask['attImg'] ?? '',
      'bidAmount': backendTask['bidAmount']?.toString() ?? 'N/A',
      'status': (backendTask['status']?.toString() ?? 'pending').capitalize,
      'id': backendTask['_id'],
      'location': backendTask['custlocationwords'] ?? 'N/A',
      'category': backendTask['category'] ?? 'N/A',
      'custlocation': backendTask['custlocation'] ?? 'N/A',
    };
  }

  String _formatTime(String? isoTime) {
    if (isoTime == null) return 'N/A';
    try {
      final time = DateTime.parse(isoTime);
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Invalid time';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 240, 240),
      appBar: AppBar(
        title: Text(
          "Manage Tasks",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 248, 245, 245),
          ),
        ),
        backgroundColor: Color(0xFF800000),
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return Center(child: CircularProgressIndicator());
    if (_errorMessage.isNotEmpty) return Center(child: Text(_errorMessage));
    if (_tasks.isEmpty) return Center(child: Text('No tasks found'));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          final status = task['status'] ?? 'Pending';
          final bidAmount = task['bid'] ?? 'N/A';

          return _buildTaskCard(task, status, bidAmount);
        },
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task, String status, String bid) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Color(0xFF800000), width: 1.5),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => _handleTaskTap(task),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Color(0xFFFBECEC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              // Left side - Image
              Container(
                width: 100,
                height: 80,
                margin: EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Color(0xFF800000),
                    width: 1,
                  ),
                ),
                child: task['attImg'].isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: Image.memory(
                          base64Decode(task['attImg']),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.image_not_supported,
                        color: Color(0xFF800000),
                        size: 40,
                      ),
              ),
              // Right side - Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status and Bid Amount in the same row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Category
                        Row(
                          children: [
                            Icon(
                              Icons.category,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 4),
                            Text(
                              task['category'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        // Status indicator aligned to the right
                        _buildStatusIndicator(task['status']),
                      ],
                    ),
                    SizedBox(height: 8),
                    // Location and Bid Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Location
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 4),
                            Text(
                              task['location'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        // Bid Amount aligned to the right
                        Text(
                          '${task['bidAmount']} RS',
                          style: TextStyle(
                            color: Color(0xFF800000),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Update the status indicator to be more compact
  Widget _buildStatusIndicator(String status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: status.toLowerCase() == 'pending'
            ? Colors.orange.withOpacity(0.9)
            : Colors.green.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  void _handleTaskTap(Map<String, dynamic> task) {
    if (task['status'] == 'Pending') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Request(
            taskId: task['id'],
            bidAmount: task['bidAmount'],
            custlocation: task['custlocation'],
          ),
        ),
      );
    } else {
      // Pass the correct taskId from the task data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Task(
            taskId: task['id'], // Use the actual task ID instead of hardcoded string
          ),
        ),
      );
    }
  }
}

extension StringExtension on String {
  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
