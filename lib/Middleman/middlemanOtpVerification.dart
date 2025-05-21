import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/ApiServices/middleman_auth.dart';
import 'package:fyp/Middleman/middlemanRegisterDetails.dart';
import 'package:fyp/URLs/config.dart';
import 'middlemanRegImageupload.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MiddlemanOtpVerification extends StatefulWidget {
  final String middId;
  final String phone;
  final String email;

  const MiddlemanOtpVerification({
    Key? key,
    required this.middId,
    required this.phone,
    required this.email,
  }) : super(key: key);

  @override
  _MiddlemanOtpVerificationState createState() =>
      _MiddlemanOtpVerificationState();
}

class _MiddlemanOtpVerificationState extends State<MiddlemanOtpVerification> {
  final List<TextEditingController> _emailControllers =
      List.generate(6, (_) => TextEditingController());
  final List<TextEditingController> _phoneControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _emailFocusNodes = List.generate(6, (_) => FocusNode());
  final List<FocusNode> _phoneFocusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => _emailFocusNodes[0].requestFocus());
  }

  @override
  void dispose() {
    for (var controller in _emailControllers) controller.dispose();
    for (var controller in _phoneControllers) controller.dispose();
    for (var node in _emailFocusNodes) node.dispose();
    for (var node in _phoneFocusNodes) node.dispose();
    super.dispose();
  }

  void _handleOtpInput(String value, int index, bool isEmail) {
    if (value.isNotEmpty) {
      if (value.length > 1) {
        _handlePaste(value, isEmail);
        return;
      }

      // Move to next field only within the same OTP group
      if (index < 5) {
        if (isEmail) {
          _emailFocusNodes[index + 1].requestFocus();
        } else {
          _phoneFocusNodes[index + 1].requestFocus();
        }
      } else {
        // When last field is filled, stay in the current group
        if (isEmail) {
          _emailFocusNodes[index].unfocus();
        } else {
          _phoneFocusNodes[index].unfocus();
        }
      }
    } else if (value.isEmpty) {
      // Move to previous field only within the same OTP group
      if (index > 0) {
        if (isEmail) {
          _emailFocusNodes[index - 1].requestFocus();
        } else {
          _phoneFocusNodes[index - 1].requestFocus();
        }
      }
    }
  }

  void _handlePaste(String value, bool isEmail) {
    if (value.length == 6) {
      for (int i = 0; i < 6; i++) {
        if (isEmail) {
          _emailControllers[i].text = value[i];
        } else {
          _phoneControllers[i].text = value[i];
        }
      }
      // Keep focus in the current group's last field
      if (isEmail) {
        _emailFocusNodes.last.requestFocus();
      } else {
        _phoneFocusNodes.last.requestFocus();
      }
    }
  }

  Future<void> _verifyOtp() async {
    final emailOtp = _emailControllers.map((e) => e.text).join();
    final phoneOtp = _phoneControllers.map((e) => e.text).join();

    if (emailOtp.length != 6 || phoneOtp.length != 6) {
      showSnackBar(context, 'Please enter complete 6-digit OTP for both fields');
      return;
    }

    try {
      final response = await middlemanAuth().middlemanEmailPhoneVerification(widget.middId, emailOtp, phoneOtp);
      print(response);

      if (response['status']) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => MiddlemanRegisterDetails(middId: widget.middId)),
        );
      } else {
        showSnackBar(context, response['message'] ?? 'OTP verification failed');
      }




    } catch (e) {
      showSnackBar(context, 'Error verifying OTP: ${e.toString()}');
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildOtpField(String label, List<TextEditingController> controllers,
      List<FocusNode> focusNodes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            6,
            (index) => SizedBox(
              width: 40,
              child: TextField(
                controller: controllers[index],
                focusNode: focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(),
                  hintText: '0',
                ),
                onChanged: (value) =>
                    _handleOtpInput(value, index, label == 'Enter Email OTP'),
              ),
            ),
          ),
        ),
      ],
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
                children: <Widget>[
                   Text(
                    'OTP Verification',
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'OTP sent to',
                              style: TextStyle(
                                color: Color(0xFF8B2323),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '(${widget.email}, ${widget.phone}, )',
                              style: TextStyle(
                                color: Color(0xFF8B2323),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildOtpField('Enter Email OTP', _emailControllers,
                          _emailFocusNodes),
                      const SizedBox(height: 30),
                      _buildOtpField('Enter Phone OTP', _phoneControllers,
                          _phoneFocusNodes),
                      const SizedBox(height: 40),
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
}
