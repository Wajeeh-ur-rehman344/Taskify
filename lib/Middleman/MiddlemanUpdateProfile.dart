import 'package:flutter/material.dart';

class MiddlemanUpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<MiddlemanUpdateProfile> {
  // Controllers to manage user input
  final TextEditingController _nameController =
      TextEditingController(text: "John Doe");
  final TextEditingController _emailController =
      TextEditingController(text: "johndoe@example.com");
  final TextEditingController _phoneController =
      TextEditingController(text: "+1 234 567 890");
  final TextEditingController _addressController =
      TextEditingController(text: "123 Main Street, New York, USA");

  // Controller for Profile Picture (optional if you plan to allow image upload)
  final TextEditingController _imageController =
      TextEditingController(text: "assets/profile.jpg");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor:   const Color(0xFF800000),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile Image Section (optional)
            GestureDetector(
              onTap: () {
                // This can be extended to allow image selection
                print("Change Profile Image");
              },
              child: Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(_imageController.text),
                  child: Icon(Icons.camera_alt, size: 30, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Full Name TextField
            _buildTextField("Full Name", _nameController),
            SizedBox(height: 15),

            // Email TextField
            _buildTextField("Email", _emailController),
            SizedBox(height: 15),

            // Phone Number TextField
            _buildTextField("Phone Number", _phoneController),
            SizedBox(height: 15),

            // Address TextField
            _buildTextField("Address", _addressController),
            SizedBox(height: 20),

            // Save Button
            ElevatedButton(
              onPressed: () {
                // Handle Save Logic
                // Here, you could save the updated profile info to a server or local storage
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Profile Updated Successfully!")),
                );
                Navigator.pop(
                    context); // Go back to Profile screen after saving
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:   const Color(0xFF800000),
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Save Changes",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build text fields for each profile detail
  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
