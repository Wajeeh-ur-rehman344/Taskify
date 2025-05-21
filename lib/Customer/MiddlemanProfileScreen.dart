import 'package:flutter/material.dart';

class MiddlemanProfileScreen extends StatelessWidget {
  final String name;
  final String username;
  final String email;
  final String phone;
  final int tasksCompleted;
  final double rating;
  final List<String> feedbacks;

  const MiddlemanProfileScreen({
    Key? key,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.tasksCompleted,
    required this.rating,
    required this.feedbacks,
  }) : super(key: key); // Ensure proper key handling

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Middleman Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Middleman Info Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    Text('@$username', style: const TextStyle(fontSize: 16, color: Colors.grey)),
                    const Divider(),
                    _buildInfoRow(Icons.email, Colors.blueGrey, email),
                    _buildInfoRow(Icons.phone, Colors.green, phone),
                    _buildInfoRow(Icons.task, Colors.orange, 'Tasks Completed: $tasksCompleted'),
                    _buildInfoRow(Icons.star, Colors.amber, 'Rating: $rating'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Feedback Section
            const Text('Feedbacks', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            feedbacks.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: feedbacks.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(feedbacks[index], style: const TextStyle(fontSize: 16)),
                        ),
                      );
                    },
                  )
                : const Text('No feedbacks available', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // Helper method for building info rows
  Widget _buildInfoRow(IconData icon, Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
