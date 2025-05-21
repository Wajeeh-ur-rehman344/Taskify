import 'dart:async';
import 'dart:convert'; // For base64 decoding
import 'package:flutter/material.dart';
import 'package:fyp/Middleman/MiddlemanStartTaskScreen.dart';
import 'package:fyp/URLs/config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late IO.Socket _socket;
  List<Map<String, dynamic>> _tasks = [];
  bool _isLoading = true;
  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    _initializeSocket();
    _startAutoRefresh(); // Start auto-refresh when the screen loads
  }

  @override
  void dispose() {
    _socket.dispose(); // Disconnect the socket when the screen is disposed
    _autoRefreshTimer?.cancel(); // Cancel the auto-refresh timer
    super.dispose();
  }

  void _initializeSocket() {
    // Connect to the Socket.IO server
    _socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.connect();

    // Listen for connection
    _socket.onConnect((_) {
      print('✅ Connected to Socket.IO server');
      // Emit the event to fetch tasks
      _fetchTasks();
    });

    // Listen for tasks data
    _socket.on('middle-tasks-data', (data) {
      print('📋 Tasks received: $data');
      setState(() {
        _tasks = List<Map<String, dynamic>>.from(data);
        _isLoading = false;
      });
    });

    // Handle disconnection
    _socket.onDisconnect((_) {
      print('❌ Disconnected from Socket.IO server');
    });
  }

  void _fetchTasks() {
    setState(() => _isLoading = true);
    _socket.emit('get-middle-tasks'); // Emit the event to fetch tasks
  }

  Future<void> _refreshTasks() async {
    _fetchTasks(); // Fetch tasks again when the user pulls to refresh
    await Future.delayed(const Duration(seconds: 1)); // Simulate a delay
  }

  void _startAutoRefresh() {
    // Auto-refresh every 15 seconds
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      print('🔄 Auto-refreshing tasks...');
      _fetchTasks();
    });
  }

  Widget _buildTaskItem(Map<String, dynamic> task) {
    return GestureDetector(
      onTap: () {
        // Navigate to MiddlemanStartTaskScreen and pass the task data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MiddlemanStartTaskScreen(
              taskId: task['_id'] ?? '',
              name: task['customerName'] ?? 'N/A',
              budget: task['bidAmount']?.toString() ?? '0',
              category: task['category'] ?? 'N/A',
              location: task['custlocationwords'] ?? 'N/A',
              description: task['description'] ?? 'N/A',
              attImg: task['attImg'] ?? '',
              type: task['type'] ?? 'N/A',
              custlocation: task['custlocation'] ?? 'N/A',
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.2),
        margin: const EdgeInsets.only(bottom: 16.0),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Decode and display the base64 image
              task['attImg'] != null
                  ? CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      radius: 30,
                      child: ClipOval(
                        child: Image.memory(
                          base64Decode(task['attImg']),
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error, color: Colors.red);
                          },
                        ),
                      ),
                    )
                  : const CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 30,
                      child:
                          Icon(Icons.image_not_supported, color: Colors.white),
                    ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${task['customerName']?.toString() ?? 'N/A Name'}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF800000),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Category: ${task['category']?.toString() ?? 'No Category'}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      (task['bidAmount']?.toString().isNotEmpty == true)
                          ? 'Rs ${task['bidAmount']}'
                          : 'No Budget',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Tasks',
            style: TextStyle(
                color: Color.fromARGB(255, 220, 60, 60),
                fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 244, 243, 243),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTasks, // Trigger refresh when pulled down
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _tasks.isEmpty
                ? const Center(child: Text('No tasks available.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) =>
                        _buildTaskItem(_tasks[index]),
                  ),
      ),
    );
  }
}
