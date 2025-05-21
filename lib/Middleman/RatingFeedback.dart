import 'package:flutter/material.dart';

class RatingFeedback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ratings & Feedback',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF800000), // Maroon color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Card
              Card(
                elevation: 5,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Left Side: Task and Customer
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Grocery", // Task
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF800000), // Maroon color
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Farwa", // Customer
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF800000), // Maroon color
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 20),

                      // Right Side: Rating and Feedback
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Rating
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.star_rate,
                                  color: Colors.amber,
                                  size: 24,
                                ),
                                Text(
                                  '4.4', // Rating
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),

                            // Feedback
                            Text(
                              'Good work, a little delay in service', // Feedback
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Second Card
              Card(
                elevation: 5,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Left Side: Task and Customer
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Plumbing", // Task
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF800000), // Maroon color
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Jamal", // Customer
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF800000), // Maroon color
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 20),

                      // Right Side: Rating and Feedback
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Rating
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.star_rate,
                                  color: Colors.amber,
                                  size: 24,
                                ),
                                Text(
                                  '4.8', // Rating
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),

                            // Feedback
                            Text(
                              'Very professional, excellent service', // Feedback
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Third Card
              Card(
                elevation: 5,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Left Side: Task and Customer
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pharmacy", // Task
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF800000), // Maroon color
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Saad", // Customer
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF800000), // Maroon color
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 20),

                      // Right Side: Rating and Feedback
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Rating
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.star_rate,
                                  color: Colors.amber,
                                  size: 24,
                                ),
                                Text(
                                  '4.2', // Rating
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),

                            // Feedback
                            Text(
                              'Great service, but needs improvement', // Feedback
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Fourth Card
              Card(
                elevation: 5,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Left Side: Task and Customer
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Home Repairs", // Task
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF800000), // Maroon color
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Ali", // Customer
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF800000), // Maroon color
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 20),

                      // Right Side: Rating and Feedback
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Rating
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.star_rate,
                                  color: Colors.amber,
                                  size: 24,
                                ),
                                Text(
                                  '5.0', // Rating
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),

                            // Feedback
                            Text(
                              'Excellent job, highly recommended', // Feedback
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
