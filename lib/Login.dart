import 'dart:convert';
import 'package:fyp/ApiServices/customer_auth.dart';
import 'package:fyp/ApiServices/middleman_auth.dart';
import 'package:fyp/Middleman/MiddlemanEmailPhoneRegisterPage.dart';
import 'package:fyp/Middleman/MiddlemanHomeScreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import './URLs/config.dart';
import 'package:flutter/material.dart';
import './Customer/HomeScreen.dart';
import './Customer/Register.dart';
import 'Forget.dart';
import 'package:dio/dio.dart';

class Login extends StatefulWidget {
  final String rolee;

  const Login({Key? key, required this.rolee}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String errorMessage = "";
  bool _isLoading = false;

  // Initialize SharedPreferences later
  late SharedPreferences prefs;

  // Initialize Dio with proper configuration
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    validateStatus: (status) => status != null && status < 500,
  ));

  @override
  void initState() {
    super.initState();
    _initializePrefs();
  }

  // Initialize SharedPreferences
  Future<void> _initializePrefs() async {
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (e) {
      showSnackBar(context, 'Error initializing SharedPreferences: $e');
    }
  }

  Future<void> submitLogin() async {
    setState(() {
      errorMessage = "";
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validate input fields
    final validationError = _validateCredentials(email, password);
    if (validationError != null) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, validationError);
      return;
    }

    try {
      // Determine the login URL based on role
      dynamic response;

      //Getting the DATA from DB
      if (widget.rolee == 'customer') {
        response = await custAuth().customerLogin(email, password);
      } else {
        response = await middlemanAuth().middlemanLogin(email, password);
      }

      ///check User and save <Token, UserId> then navigate to HomeScreen
      if (response['status'] == true) {
        String token = response['token'] ?? '';
        String userId = widget.rolee == 'customer'
            ? response['userId'] ?? ''
            : response['userId'] ?? '';
        print("token: $token");
        print("userId: $userId");

        if (token.isNotEmpty && userId.isNotEmpty) {
          await prefs.setString('token', token);
          await prefs.setString('user_id', userId);

          _navigateToHome();
        }
      } else {
        showSnackBar(
            context, response['message'] ?? "Please enter valid credentials");
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

  // Validate credentials
  String? _validateCredentials(String email, String password) {
    if (email.isEmpty && password.isEmpty) {
      return "Please fill in all fields";
    }
    if (email.isEmpty) {
      return "Please enter your email";
    }
    if (password.isEmpty) {
      return "Please enter your password";
    }
    if (password.length < 8) {
      return "Password must be at least 8 characters";
    }
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email)) {
      return "Please enter a valid email";
    }
    return null;
  }

  // Handle DioExceptions with specific error messages
  void _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      showSnackBar(context, 'Connection timed out. Please try again.');
    } else if (e.type == DioExceptionType.connectionError) {
      showSnackBar(context, 'No internet connection.');
    } else if (e.response != null) {
      showSnackBar(
          context,
          e.response?.data['message'] ??
              'Server error: ${e.response?.statusCode}');
    } else {
      showSnackBar(context, 'Network error. Please check your connection');
    }
    setState(() {
      _isLoading = false;
    });
    print('Dio error: ${e.message}');
  }

  // Save user data to SharedPreferences
  Future<void> _saveUserData(dynamic jsonResponse) async {
    final user = jsonResponse['user'];
    await prefs.setString('token', jsonResponse['token']);
    await prefs.setString('user_id', user['_id']);
    await prefs.setString('email', user['email']);
    print('User data saved successfully');
  }

  // Navigate to appropriate home screen
  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            widget.rolee == 'customer' ? HomeScreen() : MiddlemanHomeScreen(),
      ),
    );
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
            colors: [
              Color(0xFF6D1B1B),
              Color(0xFF8B2323),
              Color(0xFFA63A3A),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome to TASKIFY',
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
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(60)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 25),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Enter Your Credentials",
                        style: TextStyle(
                          color: Color(0xFF8B2323),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _buildInputField(
                        controller: _emailController,
                        icon: Icons.email,
                        hint: "john@example.com", // Placeholder text
                        label: "Email", // Floating label
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 20),
                      _buildInputField(
                        controller: _passwordController,
                        icon: Icons.lock,
                        hint: "********", // Placeholder text
                        label: "Password", // Floating label
                        isPassword: true,
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Forget(role: widget.rolee.toString())),
                          ),
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Color(0xFF8B2323),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Center(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : submitLogin,
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
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Login',
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
                            "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (widget.rolee == "customer") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Register(role: "customer"),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MiddlemanEmailPhoneRegisterPage(),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              "Sign Up",
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
