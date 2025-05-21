import 'package:flutter/material.dart';

class easypaisa extends StatelessWidget {
  final String amount;

  easypaisa({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Easypaisa Payment")),
      body: Center(
        child: Text("Proceed to pay PKR $amount via Easypaisa"),
      ),
    );
  }
}
