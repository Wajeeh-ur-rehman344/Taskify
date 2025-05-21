import 'package:flutter/material.dart';
import 'package:fyp/ApiServices/middleman_postTask.dart';
import 'package:fyp/URLs/config.dart';
import 'package:http/http.dart' as http;
import '../MessageScreen.dart';
import 'package:fyp/Middleman/MiddlemanHomeScreen.dart';
import 'dart:convert';

class MiddlemanStatus1 extends StatefulWidget {
  final String taskId; // Only require taskId

  const MiddlemanStatus1({
    super.key,
    required this.taskId,
  });

  @override
  _MiddlemanStatus1State createState() => _MiddlemanStatus1State();
}

class _MiddlemanStatus1State extends State<MiddlemanStatus1> {
  bool _isUpdating = false;
  bool _isLoading = true;
  String currentStatus = "OnGoing";
  Map<String, dynamic> taskDetails = {};

  @override
  void initState() {
    super.initState();
    _fetchTaskDetails();
  }

  Future<void> _fetchTaskDetails() async {
    try {
      setState(() => _isLoading = true);

      final response =
          await MiddlemanPostTask().showStartTaskmiddleman(widget.taskId);

      if (response['status'] == true) {
        setState(() {
          taskDetails = response['data'];
          _isLoading = false;
        });
      } else {
        _showError('Failed to load task details');
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> updateStatus() async {
    setState(() => _isUpdating = true);

    try {
      final response =
          await MiddlemanPostTask().updateTaskStatus(widget.taskId);

      if (response['status'] == true) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task completed successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MiddlemanHomeScreen()),
        );
      } else {
        _showError(response['message'] ?? 'Failed to update status');
      }
    } catch (error) {
      _showError('Error: $error');
    } finally {
      setState(() => _isUpdating = false);
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
      appBar: AppBar(
        title: const Text(
          'Task Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF800000),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Map placeholder
                Positioned.fill(
                  child: Container(
                    color: const Color.fromARGB(255, 246, 240, 240),
                    child: const Center(child: Text("Map Placeholder")),
                  ),
                ),

                // Task Details
                DraggableScrollableSheet(
                  initialChildSize: 0.6,
                  minChildSize: 0.3,
                  maxChildSize: 0.9,
                  builder: (context, scrollController) {
                    final middBid = taskDetails['MiddBid'] != null &&
                            (taskDetails['MiddBid'] as List).isNotEmpty
                        ? (taskDetails['MiddBid'] as List)[0]
                        : null;

                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: ListView(
                        controller: scrollController,
                        children: [
                          // Title
                          Text(
                            taskDetails['title'] ?? 'No Title',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF800000),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Customer Name
                          Row(
                            children: [
                              Icon(Icons.person, color: Colors.grey[600]),
                              const SizedBox(width: 8),
                              Text(
                                'Customer: ${taskDetails['customerName'] ?? 'N/A'}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          // Category and Type
                          Row(
                            children: [
                              Icon(Icons.category, color: Colors.grey[600]),
                              const SizedBox(width: 8),
                              Text(
                                '${taskDetails['category'] ?? 'N/A'} - ${taskDetails['type'] ?? 'N/A'}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          // Description
                          if (taskDetails['description'] != null) ...[
                            const Text(
                              'Description:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              taskDetails['description'],
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 15),
                          ],

                          // Bid Details
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bid Amount: PKR ${taskDetails['bidAmount'] ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF800000),
                                  ),
                                ),
                                if (middBid != null) ...[
                                  const SizedBox(height: 10),
                                  Text(
                                    'Your Bid: PKR ${middBid['middbidAmount']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Estimated Time: ${middBid['middestimatedTime']}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Status
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: taskDetails['status'] == 'ongoing'
                                  ? Colors.green[100]
                                  : Colors.orange[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Status: ${taskDetails['status']?.toUpperCase() ?? 'N/A'}',
                              style: TextStyle(
                                color: taskDetails['status'] == 'ongoing'
                                    ? Colors.green[800]
                                    : Colors.orange[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),

                          // Complete Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF800000),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: _isUpdating ? null : updateStatus,
                              child: _isUpdating
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Complete Task',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                            ),
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
