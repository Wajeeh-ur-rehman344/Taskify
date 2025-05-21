import 'package:flutter/material.dart';

class Deposit extends StatefulWidget {
  @override
  _DepositScreenState createState() => _DepositScreenState();
}

class _DepositScreenState extends State<Deposit> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  String? _selectedPaymentMethod = 'EasyPaisa'; // Default selected method

  // Method to handle deposit action
  void _handleDeposit() {
    String amount = _amountController.text;
    String mobileNumber = _mobileNumberController.text;

    if (amount.isEmpty || mobileNumber.isEmpty || _selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
    } else {
      // Perform deposit action here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Deposit of \$${amount} via ${_selectedPaymentMethod} to $mobileNumber has been made!')),
      );
      // Optionally, navigate to another screen after deposit (e.g., confirmation screen)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposit Screen',style: TextStyle(color: const Color.fromARGB(255, 247, 245, 245),fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF800000), // Maroon color for AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Title Section
              Center(
                child: Text(
                  'Make a Deposit',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF800000), // Maroon color for Title
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Amount Field
              const Text(
                'Amount to Deposit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF800000)),
              ),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Amount',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF800000)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF800000)),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 20),

              // Payment Method Selector
              const Text(
                'Select Payment Method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF800000)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFF800000)),
                  color: Colors.grey[100],
                ),
                child: DropdownButton<String>(
                  value: _selectedPaymentMethod,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPaymentMethod = newValue;
                    });
                  },
                  isExpanded: true,
                  dropdownColor: Colors.grey[100],
                  icon: Icon(Icons.arrow_drop_down, color: Color(0xFF800000)),
                  underline: Container(),
                  items: <String>['EasyPaisa', 'JazzCash']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Color(0xFF800000))),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Mobile Number Field
              const Text(
                'Mobile Number',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF800000)),
              ),
              TextField(
                controller: _mobileNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Enter Mobile Number',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF800000)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF800000)),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 40),

              // Deposit Button
              Center(
                child: ElevatedButton(
                  onPressed: _handleDeposit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Corrected property
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 80),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Deposit Now',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
