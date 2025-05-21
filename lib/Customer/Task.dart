import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/ApiServices/customer_postTask.dart';
import '../MessageScreen.dart';
import '../CallScreen.dart';
import 'MiddlemanProfileScreen.dart';

class Task extends StatefulWidget {
  final String taskId;

  Task({
    super.key,
    required this.taskId,
  }) : assert(taskId.isNotEmpty);

  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  bool _isLoading = true;
  Map<String, dynamic> taskData = {};

  @override
  void initState() {
    super.initState();
    _fetchTaskDetails();
  }

  Future<void> _fetchTaskDetails() async {
    try {
      print("Fetching task details for taskId: ${widget.taskId}"); // Debug print

      final response = await CustomerPostTask().custShowMiddTask(widget.taskId);
      print("API Response: $response"); // Debug print

      if (response['status'] == true && response['data'] != null) {
        setState(() {
          taskData = response['data'];
          _isLoading = false;
        });
      } else {
        _showError('Failed to load task details: ${response['message']}');
      }
    } catch (e) {
      print("Error in _fetchTaskDetails: $e"); // Debug print
      _showError('Error: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 240, 240),
      appBar: AppBar(
        title: const Text("TASKIFY",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF6D1B1B),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Map Section with Location
                Positioned.fill(
                  child: Container(
                    color: const Color.fromARGB(255, 246, 240, 240),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Map Placeholder ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6D1B1B),
                          ),
                        ),
                        const SizedBox(height: 10),
                       
                        Text(
                          "Coordinates: ${taskData['custlocation'] ?? 'N/A'}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Draggable Details Sheet
                DraggableScrollableSheet(
                  initialChildSize: 0.6,
                  minChildSize: 0.3,
                  maxChildSize: 0.9,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(20),
                        children: [
                          // Drag Handle
                          Center(
                            child: Container(
                              width: 40,
                              height: 5,
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          // Middleman Details Section
                          Row(
                            children: [
                              // Profile Picture
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: taskData['middleman']?['profilePic']?.isNotEmpty == true
                                    ? MemoryImage(base64Decode(taskData['middleman']['profilePic']))
                                    : null,
                                child: taskData['middleman']?['profilePic']?.isEmpty ?? true
                                    ? const Icon(Icons.person)
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              // Middleman Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      taskData['middleman']?['name'] ?? 'Unknown',
                                      style: const TextStyle(
                                        color: Color(0xFF800000),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Communication Icons
                              IconButton(
                                icon: const Icon(Icons.call, color: Color(0xFF800000), size: 30),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CallScreen()),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.message, color: Color(0xFF800000), size: 30),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MessageScreen(
                                      middId: 'middId',
                                      custId: 'custId',
                                      taskId: widget.taskId,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Bid Amount
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Bid Amount:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "PKR ${taskData['MiddBid']?['middbidAmount']?.toString() ?? 'N/A'}",
                                  style: const TextStyle(
                                    color: Color(0xFF6D1B1B),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Status and Time
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6D1B1B).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Status",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        taskData['status']?.toUpperCase() ?? 'UNKNOWN',
                                        style: const TextStyle(
                                          color: Color(0xFF6D1B1B),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6D1B1B),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Estimated Time",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        taskData['MiddBid']?['middestimatedTime'] ?? 'Unknown',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Divider
                          const Divider(thickness: 1),
                          const SizedBox(height: 20),

                          // Bottom Information Section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Category and Type
                              Row(
                                children: [
                                  const Icon(Icons.category, color: Color(0xFF6D1B1B)),
                                  const SizedBox(width: 10),
                                  Text(
                                    "${taskData['category'] ?? 'N/A'} - ${taskData['type'] ?? 'N/A'}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),

                              // Phone
                              Row(
                                children: [
                                  const Icon(Icons.phone, color: Color(0xFF6D1B1B)),
                                  const SizedBox(width: 10),
                                  Text(
                                    taskData['middleman']?['phone'] ?? 'No phone',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),

                              // Location
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Color(0xFF6D1B1B)),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          taskData['custlocationwords'] ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          taskData['custlocation'] ?? 'N/A',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
