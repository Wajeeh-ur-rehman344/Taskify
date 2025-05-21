import 'package:flutter/material.dart';

class Jazzcash extends StatefulWidget {
  final String amount;

  const Jazzcash({Key? key, required this.amount}) : super(key: key); // ✅ Add constructor

  @override
  _JazzcashState createState() => _JazzcashState();
}

class _JazzcashState extends State<Jazzcash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("JazzCash Payment")),
      body: Center(
        child: Text("Proceed to pay PKR ${widget.amount} via JazzCash"),
      ),
    );
  }
}
