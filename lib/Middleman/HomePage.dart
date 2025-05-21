import 'package:flutter/material.dart';
import 'DonutChartPainter.dart';
import 'MiddlemanTaskHistory.dart'; // Import the TaskHistory page
import 'Wallet.dart'; // Import the Wallet page

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            flex: 3, // Takes 3/4 of available space
            child: Card(
              elevation: 4,
              color: Color.fromARGB(255, 250, 249, 249),
              margin: EdgeInsets.only(bottom: 16), // Add bottom margin
              child: Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Left side for Donut chart
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Tasks Completed',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 190, 9, 9),
                            ),
                          ),
                          SizedBox(height: 20),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final size = Size(
                                  constraints.maxWidth,
                                  constraints.maxHeight,
                                );
                                return CustomPaint(
                                  size: size,
                                  painter: DonutChartPainter(
                                    completed: 10, // 10% completed
                                    total: 100, // Total tasks
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20), // Space between chart and text
                    // Right side for Completed tasks this month
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Tasks Completed This Month',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 190, 9, 9),
                            ),
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              // Navigate to TaskHistory page when tapped
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MiddlemanTaskHistory(),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 39, 94, 233), // Green rectangle
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  ' Tasks Completed',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1, // Takes 1/4 of available space
            child: Row(
              children: [
                // Wallet Balance Card with Navigation
                Expanded(
                  flex: 5, // Reduce width slightly to avoid overflow
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to Wallet screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Wallet()),
                      );
                    },
                    child: Card(
                      elevation: 8,
                      color: Colors.red.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0), // Adjusted padding
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.account_balance_wallet,
                                  color: const Color.fromARGB(255, 243, 238, 238),
                                  size: 28,
                                ),
                                SizedBox(width: 6), // Reduced spacing
                                Text(
                                  'Wallet Balance',
                                  style: TextStyle(
                                    fontSize: 14, // Slightly reduced font size
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(255, 244, 241, 241),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Rs120.50',
                              style: TextStyle(
                                fontSize: 22, // Slightly reduced size
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 247, 242, 242),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12), // Reduced spacing
                Expanded(
                  flex: 5, // Reduce width slightly to avoid overflow
                  child: Card(
                    elevation: 8,
                    color: Colors.green[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0), // Adjusted padding
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star_rate,
                                color: Colors.yellow,
                                size: 28,
                              ),
                              SizedBox(width: 6), // Reduced spacing
                              Text(
                                'Your Rating',
                                style: TextStyle(
                                  fontSize: 14, // Slightly reduced font size
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 254, 249, 249),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            '4.5/5.0',
                            style: TextStyle(
                              fontSize: 22, // Slightly reduced size
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 241, 236, 236),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
