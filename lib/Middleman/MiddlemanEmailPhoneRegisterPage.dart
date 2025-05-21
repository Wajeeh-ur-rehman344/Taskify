import 'package:flutter/material.dart';
import 'package:fyp/ApiServices/customer_auth.dart';
import 'package:fyp/ApiServices/middleman_auth.dart';
import 'package:fyp/Login.dart';
import 'middlemanOtpVerification.dart'; // Import the OTP screen
import '../URLs/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MiddlemanEmailPhoneRegisterPage extends StatefulWidget {
  const MiddlemanEmailPhoneRegisterPage({super.key});

  @override
  State<MiddlemanEmailPhoneRegisterPage> createState() =>
      _MiddlemanEmailPhoneRegisterPageState();
}

class _MiddlemanEmailPhoneRegisterPageState
    extends State<MiddlemanEmailPhoneRegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;
  final RegExp phoneRegex = RegExp(r'^03\d{9}$'); // Updated regex to match 0300-0000000 format

  Future<void> handleMiddlemanReg() async {
    setState(() {
      isLoading = true;
    });

    final String email = emailController.text.trim();
    final String phone = phoneController.text.trim();

    final RegExp emailRegex = RegExp(r"^[^@]+@[^@]+\.[^@]+$");

    // Validate inputs
    if (email.isEmpty || phone.isEmpty) {
      showSnackBar(context,
          email.isEmpty ? "Please input email" : "Please input phone number");
      setState(() {
        isLoading = false;
      });
      return;
    }
    if (!emailRegex.hasMatch(email)) {
      showSnackBar(context, "Invalid email format");
      setState(() {
        isLoading = false;
      });
      return;
    }
    if (!phoneRegex.hasMatch(phone.replaceAll('-', ''))) { // Remove hyphen before matching
      showSnackBar(context, "Invalid phone number. Format: 0300-0000000");
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final response = await middlemanAuth().middlemanRegister(email, phone);
      print("Middleman register response: $response");

      if (response is Map<String, dynamic> && response['status'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MiddlemanOtpVerification(
              middId: response['user'], // passing the middleman id
              phone: phone,
              email: email,
            ),
          ),
        );
      } else {
        showSnackBar(context, response['message'] ?? "Registration failed");
      }
    } catch (e) {
      print("Error: $e");
      showSnackBar(context, "Network error. Please check your connection.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6D1B1B), Color(0xFF8B2323), Color(0xFFA63A3A)],
          ),
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: const <Widget>[
                  Text(
                    'Register',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const SizedBox(height: 30),
                            const SizedBox(height: 10),
                            buildEmailField(),
                            const SizedBox(height: 20),
                            buildPhoneNumberField(),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account? ",
                                  style: TextStyle(fontSize: 16),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login(
                                                rolee: "middleman",
                                              )),
                                    );
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Color(0xFF8B2323),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : handleMiddlemanReg,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B2323),
                            minimumSize: const Size(200, 50),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: isLoading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : const Text(
                                  'Continue',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEmailField() {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email, color: Colors.black54),
        labelText: 'Email',
        hintText: "john@example.com",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      ),
    );
  }

  Widget buildPhoneNumberField() {
    return TextField(
      controller: phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.phone, color: Colors.black54),
        labelText: 'Phone number',
        hintText: "0300-0000000",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      ),
      onChanged: (value) {
        if (value.length == 11 && phoneRegex.hasMatch(value.replaceAll('-', ''))) { // Remove hyphen before matching
          final formattedValue =
              '${value.substring(0, 4)}-${value.substring(4)}';
          phoneController.value = TextEditingValue(
            text: formattedValue,
            selection: TextSelection.collapsed(offset: formattedValue.length),
          );
        }
      },
    );
  }
}
