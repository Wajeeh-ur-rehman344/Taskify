import 'package:flutter/material.dart';
import 'package:fyp/Login.dart';
import 'package:fyp/URLs/config.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:fyp/ApiServices/middleman_auth.dart';

class MiddlemanRegImageUpload extends StatefulWidget {
  final String middId;

  const MiddlemanRegImageUpload({
    Key? key,
    required this.middId,
  }) : super(key: key);

  @override
  State<MiddlemanRegImageUpload> createState() =>
      _MiddlemanRegImageUploadState();
}

class _MiddlemanRegImageUploadState extends State<MiddlemanRegImageUpload> {
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    }
  }

  // Function to upload the profile picture to the backend
  Future<void> _uploadProfileImage() async {
    if (_profileImage == null) {
      showSnackBar(context,"Please select a profile picture",);
      return;
    }

    try {
      // Call the API method from middleman_auth
      final response = await middlemanAuth().uploadProfilePicture(
        middId: widget.middId,
        profilePicPath: _profileImage!.path,
      );

      if (response['status'] == true) {
        // On success, navigate to the login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(
              rolee: 'middleman',
            ),
          ),
        );
      } else {
        showSnackBar(context, response['message']);
      }
    } catch (e) {
      print("Upload error: $e");
      showSnackBar(context, "An error occurred while uploading the image.");
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildImagePreview(File? image, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 250,
        width: 200, // Ensure the container is a square for a perfect circle
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Make the container circular
          border: Border.all(color: Colors.grey, width: 2),
          color: Colors.grey[200],
        ),
        child: image == null
            ? const Icon(
                Icons.account_circle, // Profile icon
                size: 150, // Adjust the size of the icon
                color: Colors.grey,
              )
            : ClipOval(
                // Clip the image into a circular shape
                child: Image.file(
                  image,
                  fit: BoxFit.cover, // Ensure the image covers the container
                  width: 200,
                  height: 200,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6D1B1B), Color(0xFF8B2323), Color(0xFFA63A3A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 120),
            Text(
              'Profile Picture',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 100),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(60)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Select the profile picture",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B2323), // Match the theme color
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildImagePreview(
                        _profileImage,
                        _pickImage,
                      ),
                      const SizedBox(height: 90),
                      ElevatedButton(
                        onPressed: _uploadProfileImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B2323),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 30),
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
