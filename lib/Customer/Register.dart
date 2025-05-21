import 'dart:convert';
import '../URLs/config.dart';
import '../otp.dart';
import 'package:flutter/material.dart';
import 'package:fyp/Login.dart';
import 'package:http/http.dart' as http;
import 'package:fyp/ApiServices/customer_auth.dart';

class Register extends StatefulWidget {
  final String role;

  const Register({Key? key, required this.role}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> registerCustomer() async {
    setState(() {
      _isLoading = true;
    });

    // Validate inputs concurrently
    final validations = [
      _validateNotEmpty(),
      _validatePhoneNumber(),
      _validateEmail(),
      _validatePasswordLength()
    ];

    for (var validation in validations) {
      final errorMessage = validation ?? '';
      if (errorMessage.isNotEmpty) {
        showSnackBar(context, errorMessage);
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    // Proceed with registration
    try {
      final response = await custAuth().customerregister(
        nameController.text,
        emailController.text,
        passwordController.text,
        phoneController.text,
      );

      print("Dio response: $response");

      if (response != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => otp(
              otps: response, // passing the _id of registered user
              email: emailController.text,
              role: "customer",
              flowType: OtpFlow.registration,
            ),
          ),
        );
      } else {
        showSnackBar(context, "Registration failed");
      }
    } catch (e) {
      showSnackBar(context, "Network error. Please check your connection.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String? _validateNotEmpty() {
    if ([nameController, emailController, passwordController, phoneController]
        .any((c) => c.text.isEmpty)) {
      return "Please fill all the credentials";
    }
    return null;
  }

  String? _validatePhoneNumber() {
    if (!RegExp(r'^03\d{9}$').hasMatch(phoneController.text)) {
      return "Invalid phone number. Format: 0300-0000000";
    }
    return null;
  }

  String? _validateEmail() {
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(emailController.text)) {
      return "Please enter a valid email";
    }
    return null;
  }

  String? _validatePasswordLength() {
    if (passwordController.text.length < 8) {
      return "Password must be at least 8 characters";
    }
    return null;
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
        decoration: BoxDecoration(
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
          children: [
            SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Create your TASKIFY account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(60),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        "Enter Your Credentials",
                        style: TextStyle(
                          color: Color(0xFF8B2323),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildInputField(
                        controller: nameController,
                        icon: Icons.person,
                        hint: "john", // Placeholder text
                        label: "Name", // Floating label
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(height: 20),
                      _buildInputField(
                        controller: emailController,
                        icon: Icons.email,
                        hint: "john@example.com", // Placeholder text
                        label: "Email", // Floating label
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 20),
                      _buildInputField(
                        controller: passwordController,
                        icon: Icons.lock,
                        hint: "********", // Placeholder text
                        label: "Password", // Floating label
                        keyboardType: TextInputType.visiblePassword,
                        isPassword: true,
                      ),
                      SizedBox(height: 20),
                      _buildInputField(
                        controller: phoneController,
                        icon: Icons.phone,
                        hint: "0300-0000000", // Placeholder text
                        label: "Phone", // Floating label
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 40),
                      Center(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : registerCustomer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF8B2323),
                            fixedSize: Size(200, 50),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text(
                                  'Register',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 30),
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
                                          rolee: "customer",
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String hint, // Changed from label
    required String label, // Added label for floating behavior
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black54),
        hintText: hint, // Placeholder text
        labelText: label, // Floating label
        floatingLabelBehavior:
            FloatingLabelBehavior.auto, // Enables floating label
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black54,
                ),
                onPressed: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
              )
            : null,
      ),
    );
  }
}
