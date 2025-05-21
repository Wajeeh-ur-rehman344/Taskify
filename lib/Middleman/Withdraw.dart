import 'package:flutter/material.dart';

class Withdraw extends StatefulWidget {
  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<Withdraw> {
  final TextEditingController _amountController = TextEditingController();

  void _withdraw(String method) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Withdrawing via $method')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Withdraw ', style: TextStyle(color:  Colors.white),),
        backgroundColor: Color(0xFF800000),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Choose Withdrawal Method',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 6, 6, 6)),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter Amount (RS)',  // Using PKR (RS)
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money, color: const Color.fromARGB(255, 183, 58, 58)),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PaymentButton(
                  image: 'assets/images/e.png',
                  label: 'Easypaisa',
                  onPressed: () => _withdraw('Easypaisa'),
                ),
                PaymentButton(
                  image: 'assets/images/j.webp',
                  label: 'JazzCash',
                  onPressed: () => _withdraw('JazzCash'),
                ),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (_amountController.text.isNotEmpty) {
                  _withdraw('Selected Method');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF800000),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Confirm Withdrawal', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}

class PaymentButton extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback onPressed;

  PaymentButton({required this.image, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          child: Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Image.asset(image, fit: BoxFit.contain),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF800000))),
      ],
    );
  }
}
