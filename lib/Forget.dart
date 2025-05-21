import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fyp/ApiServices/customer_auth.dart';
import 'package:fyp/ApiServices/middleman_auth.dart';
import './Login.dart';
import './otp.dart';
import './URLs/config.dart';
import 'package:http/http.dart' as http;

class Forget extends StatefulWidget {
  final String role;

  const Forget({Key? key, required this.role}) : super(key: key);

  @override
  State<Forget> createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  final TextEditingController emailController = TextEditingController();
  String errorMessage = "";
  bool _isLoading = false;

  Future<void> submitForgetPass() async {
    setState(() {
      _isLoading = true;
    });

    final email = emailController.text.trim();

    if (!_isValidEmail(email)) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, errorMessage);
      return;
    }

    try {
      dynamic response;

      //API call for customer & middleman forget password
      if (widget.role == "customer") {
        response = await custAuth().customerUpdatePassword(email);
      } else {
        response = await middlemanAuth().middlemanForgetPassword(email);
      }
      print("response: ${response}");

      //check if the response is true then navigate to otp screen for both users
      if (response['status'] == true) {
        _navigateToOtpScreen(email, response['userId']);
      } else {
        showSnackBar(context, response['message']);
      }
    } catch (e) {
      print("Error: ${e.toString()}");
      showSnackBar(context, 'Error Login: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Validates email format and displays an error if invalid
  bool _isValidEmail(String email) {
    if (email.isEmpty) {
      setState(() => errorMessage = 'Please enter your email');
      return false;
    }

    final emailRegex =
        RegExp(r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$");
    if (!emailRegex.hasMatch(email)) {
      setState(() => errorMessage = 'Please enter a valid email');
      return false;
    }

    return true;
  }

  /// Navigates to the OTP screen
  void _navigateToOtpScreen(String email, String userId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => otp(
          otps: userId,
          email: email,
          role: widget.role,
          flowType: OtpFlow.forgotPassword,
        ),
      ),
    );
  }

  /// Handles and displays error messages
  void _handleError(String message) {
    setState(() {
      errorMessage = message;
      _isLoading = false;
    });
    showSnackBar(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6D1B1B),
              Color(0xFF8B2323),
              Color(0xFFA63A3A),
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 110),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Forgot Password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(60),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      if (errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            errorMessage,
                            style: const TextStyle(
                              color: Color(0xFF8B2323),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const SizedBox(height: 10),
                      Text(
                        'Enter Your Email',
                        style: const TextStyle(
                          color: Color(0xFF8B2323),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildInputField(
                        controller: emailController,
                        icon: Icons.email,
                        hint: "john@example.com",
                        label: "Email",
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Color(0xFF8B2323),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  if (emailController.text.isEmpty) {
                                    showSnackBar(
                                        context, "Please fill all the fields");
                                  } else {
                                    submitForgetPass();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8B2323),
                                  fixedSize: const Size(200, 50),
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: const Text(
                                  'Reset Password',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Remember your password? ",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const Login(rolee: "customer"),
                                ),
                              );
                            },
                            child: const Text(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required String label,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black54),
        hintText: hint,
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}
