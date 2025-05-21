import 'package:flutter/material.dart';
import 'Deposit.dart';
import 'Withdraw.dart';

class Wallet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light background for contrast
      appBar: AppBar(
        title: Text("Wallet",
            textAlign: TextAlign.left), // Align title to the left
        backgroundColor: const Color.fromARGB(255, 244, 236, 236),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity, // Full width
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF800000),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to the left
              children: [
                Text(
                  'Your Current Balance',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  '-2500.00',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Deposit()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF800000), // Dark Maroon
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Deposit',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Withdraw()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF800000), // Dark Maroon
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Withdraw',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: SingleChildScrollView(
                // Make the transaction history scrollable
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      "Transaction History",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    transactionTile(
                        '-\$30.00', Icons.arrow_upward, Colors.red, context),
                    transactionTile('\$200.00', Icons.arrow_downward,
                        Colors.green, context),
                    transactionTile('\$100.00', Icons.arrow_downward,
                        Colors.green, context),
                    transactionTile(
                        '-\$50.00', Icons.arrow_upward, Colors.red, context),
                    transactionTile(
                        '\$75.00', Icons.arrow_downward, Colors.green, context),
                    transactionTile(
                        '-\$20.00', Icons.arrow_upward, Colors.red, context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget transactionTile(
      String amount, IconData icon, Color iconColor, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.account_balance_wallet, color: Colors.black),
        title: Text(
          amount,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        trailing: Icon(icon, color: iconColor, size: 28),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TransactionDetailScreen(
                      amount: amount, iconColor: iconColor)));
        },
      ),
    );
  }
}


class TransactionDetailScreen extends StatelessWidget {
  final String amount;
  final Color iconColor;

  TransactionDetailScreen({required this.amount, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Transaction Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text('Amount: $amount', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text(
                  'Status: ${iconColor == Colors.green ? "Deposited" : "Withdrawn"}',
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
