import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fyp/ApiServices/middleman_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './URLs/config.dart';
import 'Login.dart';
import 'ApiServices/customer_auth.dart';

class UpdatePass extends StatefulWidget {
  final String role;
  final String email;

  const UpdatePass({Key? key, required this.role, required this.email})
      : super(key: key);

  @override
  _UpdatePassState createState() => _UpdatePassState();
}

class _UpdatePassState extends State<UpdatePass> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String errorMessage = "";
  bool _isLoading = false;

  Future<void> _submitNewPassword() async {
    setState(() {
      errorMessage = "";
      _isLoading = true;
    });

    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        errorMessage = "Please fill in all fields";
        _isLoading = false;
      });
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() {
        errorMessage = "Passwords do not match";
        _isLoading = false;
      });
      return;
    }

    if (newPassword.length < 8) {
      setState(() {
        errorMessage = "Password must be at least 8 characters";
        _isLoading = false;
      });
      return;
    }

    try {
      dynamic response;

      if (widget.role == 'customer') {
        // Use the custAuth service for customer password update
        response = await custAuth()
            .customerForgetAndUpdatePassword(widget.email, newPassword);
      } else {
        response = await middlemanAuth().middlemanUpdatePassword(widget.email, newPassword);
      }

      if (response['status'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(rolee: widget.role),
          ),
        );
      } else {
        setState(() {
          errorMessage = response['message'] ?? 'Password update failed';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error updating password: ${e.toString()}';
        _isLoading = false;
      });
    }
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
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Reset Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(60)),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 50),
                            const Text(
                              'Set your new password',
                              style: TextStyle(
                                color: Color(0xFF8B2323),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            if (errorMessage.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  errorMessage,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            _buildPasswordField(
                              controller: _newPasswordController,
                              label: "New Password",
                              isVisible: _isNewPasswordVisible,
                              onToggle: () => setState(() =>
                                  _isNewPasswordVisible =
                                      !_isNewPasswordVisible),
                            ),
                            const SizedBox(height: 20),
                            _buildPasswordField(
                              controller: _confirmPasswordController,
                              label: "Confirm Password",
                              isVisible: _isConfirmPasswordVisible,
                              onToggle: () => setState(() =>
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                    // Bottom button section
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Color(0xFF8B2323))
                            : ElevatedButton(
                                onPressed: _submitNewPassword,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8B2323),
                                  minimumSize: const Size(double.infinity, 50),
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: const Text(
                                  'Update Password',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock, color: Colors.black54),
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.black54,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}
