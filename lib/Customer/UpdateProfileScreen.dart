import 'package:flutter/material.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  // Controllers for the text fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Profile picture URL (you can replace it with dynamic selection)
  String _profilePictureUrl =
      'https://via.placeholder.com/150'; // Default image

  @override
  void dispose() {
    // Clean up controllers when the screen is disposed
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Function to handle profile picture update
  void _updateProfilePicture() {
    // You can replace this with an image picker to select a new picture
    setState(() {
      // Just for illustration: change the image to another URL
      _profilePictureUrl = 'https://via.placeholder.com/150/0000FF/808080';
    });
  }

  // Function to handle profile update action
  void _updateProfile() {
    final String username = _usernameController.text;
    final String email = _emailController.text;
    final String phone = _phoneController.text;
    final String address = _addressController.text;
    final String password = _passwordController.text;

    if (username.isNotEmpty &&
        email.isNotEmpty &&
        phone.isNotEmpty &&
        address.isNotEmpty &&
        password.isNotEmpty) {
      // Update logic here (e.g., save to a backend or local storage)
      print(
          'Profile updated: Username: $username, Email: $email, Phone: $phone, Address: $address');
      // Optionally, you can navigate back to the previous screen
      Navigator.pop(context);
    } else {
      // Show a message if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF8B2323), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture and Edit Icon
              Row(
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(_profilePictureUrl),
                  ),
                  SizedBox(width: 16),
                  // Profile Picture Change Icon
                  GestureDetector(
                    onTap: _updateProfilePicture,
                    child: Icon(
                      Icons.camera_alt,
                      size: 30,
                      color :const Color(0xFF8B2323), 
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Username Text Field
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Email Text Field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Phone Number Text Field
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              // Password Text Field
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true, // Hide password input
              ),
              SizedBox(height: 20),
              // Update Button
              ElevatedButton(
                onPressed: _updateProfile,
                child: Text('Update Profile', style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF8B2323),  // Button color
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
