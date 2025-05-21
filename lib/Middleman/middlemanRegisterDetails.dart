import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/ApiServices/middleman_auth.dart';
import 'package:fyp/Middleman/middlemanRegImageupload.dart';
import 'package:fyp/URLs/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cnic_scanner/cnic_scanner.dart';
import 'package:cnic_scanner/model/cnic_model.dart';
import 'dart:io';

class MiddlemanRegisterDetails extends StatefulWidget {
  final String middId;

  MiddlemanRegisterDetails({required this.middId});

  @override
  _MiddlemanRegisterDetailsState createState() =>
      _MiddlemanRegisterDetailsState();
}

class _MiddlemanRegisterDetailsState extends State<MiddlemanRegisterDetails> {
  late TextEditingController _middIdController;
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String errorMessage = '';
  CnicModel _cnicModel = CnicModel();
  XFile? _cnicImage;

  Future<void> scanCnic(ImageSource imageSource) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: imageSource);
      if (pickedFile != null) {
        CnicModel cnicModel =
            await CnicScanner().scanImage(imageSource: imageSource);

        if (cnicModel.cnicNumber.isEmpty ||
            cnicModel.cnicHolderName.isEmpty ||
            cnicModel.cnicHolderDateOfBirth.isEmpty) {
          showSnackBar(context, "Please use a valid CNIC card");
          return;
        }

        setState(() {
          _cnicModel = cnicModel;
          _cnicController.text = _cnicModel.cnicNumber; // Populate CNIC field
          _fNameController.text =
              _cnicModel.cnicHolderName; // Populate Name field
          _dobController.text =
              _cnicModel.cnicHolderDateOfBirth; // Populate DOB field
          _cnicImage = pickedFile; // Store the CNIC image
        });
      }
    } catch (e) {
      showSnackBar(context, "Error scanning CNIC: ${e.toString()}");
    }
  }

  void _showScanOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Scan CNIC"),
          content: const Text("Choose scan method"),
          actions: [
            TextButton(
              child: const Text("Camera"),
              onPressed: () {
                Navigator.pop(context);
                scanCnic(ImageSource.camera);
              },
            ),
            TextButton(
              child: const Text("Gallery"),
              onPressed: () {
                Navigator.pop(context);
                scanCnic(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _middIdController = TextEditingController(text: widget.middId);
  }

  Future<void> registerMiddleman() async {
    final name = _fNameController.text.trim();
    final dob = _dobController.text.trim();
    final cnic = _cnicController.text.trim();
    final address = _addressController.text.trim();
    final password = _passwordController.text.trim();

    if ([name, dob, cnic, address, password].any((field) => field.isEmpty)) {
      showSnackBar(context, "Please fill all the fields");
      return;
    }

    if (cnic.length != 15 || !RegExp(r'^\d{5}-\d{7}-\d$').hasMatch(cnic)) {
      showSnackBar(context, "Please enter correct CNIC");
      return;
    }

    if (password.length < 8) {
      showSnackBar(context, "Password must be at least 8 characters");
      return;
    }

    if (_cnicImage == null) {
      showSnackBar(context, "Please upload a CNIC image");
      return;
    }

    try {
      final response = await middlemanAuth().middlemanDetails(
        id: widget.middId,
        name: name,
        dob: dob,
        cnic: cnic,
        address: address,
        password: password,
        cnicImagePath: _cnicImage!.path, // Pass the CNIC image path
      );

      if (response['status'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MiddlemanRegImageUpload(middId: widget.middId),
          ),
        );
      } else {
        showSnackBar(context, response['message']);
      }
    } catch (e) {
      print(e);
      showSnackBar(context, 'Error registering middleman: ${e.toString()}');
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
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
          children: [
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Register Info',
                    style: const TextStyle(
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      if (errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            errorMessage,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 16),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                        ),
                      const SizedBox(height: 10),
                      const Text(
                        "Enter Your CNIC Detail",
                        style: TextStyle(
                          color: Color(0xFF8B2323),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Name
                      _buildInputField(
                        controller:
                            _fNameController, // Reusing _fNameController for Name
                        icon: Icons.person_outline,
                        hint: "John Doe",
                        label: "Name",
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 20),
                      // Date of Birth
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: _buildInputField(
                            controller: _dobController,
                            icon: Icons.calendar_today,
                            hint: "YYYY-MM-DD",
                            label: "Date of Birth",
                            keyboardType: TextInputType.datetime,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // CNIC
                      _buildInputField(
                        controller: _cnicController,
                        icon: Icons.credit_card,
                        hint: "34601-1523157-7",
                        label: "CNIC",
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(13),
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            final text = newValue.text;
                            if (text.length <= 5) {
                              return newValue;
                            } else if (text.length <= 12) {
                              return newValue.copyWith(
                                text:
                                    '${text.substring(0, 5)}-${text.substring(5)}',
                                selection: TextSelection.collapsed(
                                    offset: newValue.selection.end + 1),
                              );
                            } else if (text.length <= 13) {
                              return newValue.copyWith(
                                text:
                                    '${text.substring(0, 5)}-${text.substring(5, 12)}-${text.substring(12)}',
                                selection: TextSelection.collapsed(
                                    offset: newValue.selection.end + 2),
                              );
                            }
                            return newValue;
                          }),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Address
                      _buildInputField(
                        controller: _addressController,
                        icon: Icons.location_on,
                        hint: "123 Main Street, City",
                        label: "Address",
                        keyboardType: TextInputType.streetAddress,
                      ),
                      const SizedBox(height: 20),
                      // Password
                      _buildInputField(
                        controller: _passwordController,
                        icon: Icons.lock,
                        hint: "******",
                        label: "Password",
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !_isPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Display CNIC Image if available
                      if (_cnicImage != null)
                        Column(
                          children: [
                            const Text(
                              "Scanned CNIC Image",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8B2323),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Image.file(
                              File(_cnicImage!.path),
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      // Scan CNIC Button
                      ElevatedButton(
                        onPressed: () => _showScanOptionsDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 101, 140,
                              226), // Same background color as the Register button
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          "Scan CNIC",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black, // Black text color
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Register Button
                      ElevatedButton(
                        onPressed: registerMiddleman,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B2323),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 20),
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
    bool obscureText = false,
    Widget? suffixIcon,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Color(0xFF8B2323)),
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
