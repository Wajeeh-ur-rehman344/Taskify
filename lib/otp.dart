import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/ApiServices/customer_auth.dart';
import 'package:fyp/ApiServices/middleman_auth.dart';
import 'package:fyp/Customer/HomeScreen.dart';
import 'package:fyp/Login.dart';
import 'package:fyp/updatePass.dart';
import './URLs/config.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum OtpFlow { registration, forgotPassword }

class otp extends StatefulWidget {
  final String otps;
  final String email;
  final String role;
  final OtpFlow flowType;

  const otp({
    Key? key,
    required this.otps,
    required this.email,
    required this.role,
    required this.flowType,
  }) : super(key: key);

  @override
  _otpState createState() => _otpState();
}

class _otpState extends State<otp> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  late Timer _resendTimer;
  int _resendTime = 30;
  bool _canResend = false;
  late Future<SharedPreferences> _prefsFuture;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _prefsFuture = SharedPreferences.getInstance();
    _startResendTimer();
    Future.delayed(Duration.zero, () => _focusNodes[0].requestFocus());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _resendTimer.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTime > 0) {
        setState(() => _resendTime--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  void _handleOtpInput(String value, int index) {
    if (value.isNotEmpty) {
      if (value.length > 1) {
        _handlePaste(value);
        return;
      }
      if (index < 5) _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _handlePaste(String value) {
    if (value.length == 6) {
      for (int i = 0; i < 6; i++) {
        _controllers[i].text = value[i];
      }
      _focusNodes.last.unfocus();
    }
  }

  Future<void> _verifyOtp() async {
    final prefs = await _prefsFuture;
    String enteredOtp = _controllers.map((e) => e.text).join();

    if (enteredOtp.length != 6) {
      showSnackBar(context, 'Please enter a 6-digit OTP');
      return;
    }

    try {
      dynamic response;

      //requset for API with role based on the user
      if (widget.role == 'customer') {
        response = await custAuth().customerOtpVerify(
            enteredOtp, widget.otps); // heres the otp is the id
      } else {
        response = await middlemanAuth().middlemanVerifyOtp(
            widget.otps, enteredOtp); // heres the otp is the id
      }
      print("response: ${response}");

      //check if the response is true
      if (response['status'] == true) {
        //check if the flow type is registration
        if (widget.flowType == OtpFlow.registration) {
          //set token and user id to local variables
          String token = response['token'] ?? '';
          String userId = response['user'] ?? '';

          //save token and user id to shared preferences
          await prefs.setString('token', token);
          await prefs.setString('user_id', userId);

          //navigate to home screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
        else{
          _navigateToUpdatePassword();
        }
      } else {
          showSnackBar(context, response['message'] ?? 'Failed to verify OTP');
      }
    } catch (e) {
      print("Error: ${e.toString()}");
      showSnackBar(context, 'Error verifying OTP: ${e.toString()}');
    }
  }

  void _navigateToUpdatePassword() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => UpdatePass(
          email: widget.email.toString(),
          role: widget.role.toString(),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _resendOtp() async {
    if (_canResend) {
      try {
        dynamic response;

        if (widget.role == "customer") {
          response = await custAuth().customerResendOtp(widget.email);
        } else {
          response = await middlemanAuth().middlemanResendOtp(widget.email);

        }

        // ✅ Fix: Directly check response['status'] instead of response.data['status']
        if (response['status'] == true) {
          showSnackBar(context, 'OTP resent successfully');
          setState(() {
            _resendTime = 30;
            _canResend = false;
          });
          _startResendTimer();
        } else {
          showSnackBar(context, response?['message'] ?? 'Failed to resend OTP');
        }
      } catch (e) {
        print("Error: ${e.toString()}");
        showSnackBar(context, 'Error resending OTP: ${e.toString()}');
      }
    }
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
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: const <Widget>[
                  Text(
                    'OTP',
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    // Added here
                    physics: ClampingScrollPhysics(),
                    keyboardDismissBehavior: Platform.isIOS
                        ? ScrollViewKeyboardDismissBehavior.onDrag
                        : ScrollViewKeyboardDismissBehavior.manual,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 30),
                        Text(
                          'Enter OTP sent to your email',
                          style: TextStyle(
                            color: Color.fromRGBO(139, 35, 35, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '(${widget.email})',
                          style: TextStyle(
                            color: Color.fromRGBO(139, 35, 35, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(6, (index) {
                            return SizedBox(
                              width: 40,
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: const InputDecoration(
                                  counterText: '',
                                  border: OutlineInputBorder(),
                                  hintText: '0',
                                ),
                                onChanged: (value) =>
                                    _handleOtpInput(value, index),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 80),
                        Center(
                          child: ElevatedButton(
                            onPressed: _verifyOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B2323),
                              fixedSize: const Size(200, 50),
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              'Verify OTP',
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
                            const Text(
                              "Didn't receive the OTP? ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            TextButton(
                              onPressed: _canResend ? _resendOtp : null,
                              child: Text(
                                _canResend
                                    ? "Resend OTP"
                                    : "Resend in $_resendTime",
                                style: TextStyle(
                                  color: _canResend
                                      ? const Color(0xFF8B2323)
                                      : Colors.grey[600],
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).viewInsets.bottom),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
