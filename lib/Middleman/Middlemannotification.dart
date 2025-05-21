import 'package:flutter/material.dart';
import 'package:fyp/ApiServices/midd_notify.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../URLs/config.dart';
import './Middlemanstatus1.dart';

class Middlemannotification extends StatefulWidget {
  @override
  _MiddlemannotificationState createState() => _MiddlemannotificationState();
}

class _MiddlemannotificationState extends State<Middlemannotification> {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final middId = prefs.getString('user_id');

      if (middId == null) {
        setState(() {
          _errorMessage = 'User ID not found';
          _isLoading = false;
        });
        return;
      }

      final response =
          await MiddlemanNotification().ShowNotifyAgainstCustTask(middId);
      print("Raw response from server: $response"); // Debug print

      if (response['status'] == true && response['data'] != null) {
        final data = response['data'];
        List<Map<String, dynamic>> notifyData = [];

        if (data is List) {
          // Direct list handling
          notifyData = data.map<Map<String, dynamic>>((item) {
            return {
              'taskId':
                  item['_id']?.toString() ?? '', // Add this line for taskId
              'customerName': item['customerName']?.toString() ?? 'Unknown',
              'category': item['category']?.toString() ?? 'N/A',
              'type': item['type']?.toString() ?? 'N/A',
              'attImg': item['attImg']?.toString() ?? '',
              'middbidAmount': item['middbidAmount']?.toString() ?? '0',
              'middestimatedTime':
                  item['middestimatedTime']?.toString() ?? 'N/A'
            };
          }).toList();
        }

        setState(() {
          _notifications = notifyData;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Failed to load notifications';
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error in _fetchNotifications: $e"); // Debug print
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MiddlemanStatus1(
              taskId: notification['taskId'],
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 92, 13, 8),
                Color.fromARGB(255, 139, 34, 34),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer and Image Row
                Row(
                  children: [
                    // Profile Image
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: notification['attImg'].isNotEmpty
                          ? ClipOval(
                              child: Image.memory(
                                base64Decode(notification['attImg']),
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.person,
                              color: Colors.white, size: 40),
                    ),
                    const SizedBox(width: 16),
                    // Customer Name and Category
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification['customerName'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${notification['category']} - ${notification['type']}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Bid Amount and Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoItem(
                      Icons.monetization_on,
                      'Bid Amount',
                      'PKR ${notification['middbidAmount']}',
                    ),
                    _buildInfoItem(
                      Icons.access_time,
                      'Estimated Time',
                      notification['middestimatedTime'],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 92, 13, 8),
        title: const Text(
          'Notifications ',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildNotificationCard(_notifications[index]),
                    );
                  },
                ),
    );
  }
}
