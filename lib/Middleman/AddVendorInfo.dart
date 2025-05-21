// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'MiddlemanStartTaskScreen.dart'; // Import the destination screen

// class AddVendorInfo extends StatefulWidget {
//   @override
//   _AddVendorInfoState createState() => _AddVendorInfoState();
// }

// class _AddVendorInfoState extends State<AddVendorInfo> {
//   final TextEditingController _vendorNameController = TextEditingController();
//   final TextEditingController _phoneNumberController = TextEditingController();
//   File? _cnicFront;
//   File? _cnicBack;

//   Future<void> _pickImage(bool isFront) async {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: Icon(Icons.camera),
//                 title: Text("Take a Photo"),
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await _selectImage(ImageSource.camera, isFront);
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.photo_library),
//                 title: Text("Choose from Gallery"),
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await _selectImage(ImageSource.gallery, isFront);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _selectImage(ImageSource source, bool isFront) async {
//     final pickedFile = await ImagePicker().pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() {
//         if (isFront) {
//           _cnicFront = File(pickedFile.path);
//         } else {
//           _cnicBack = File(pickedFile.path);
//         }
//       });
//     }
//   }

//  void _submitForm() {
//   if (_vendorNameController.text.isEmpty || _phoneNumberController.text.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Please fill all fields')),
//     );
//     return;
//   }

//   // Navigate to MiddlemanStartTaskScreen after submission
//   Navigator.pushReplacement(
//     context,
//     MaterialPageRoute(builder: (context) => MiddlemanStartTaskScreen()),
//   );
// }


//   void _skipForm() {
//     // Navigate to MiddlemanStartTaskScreen on skipping
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => MiddlemanStartTaskScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Add Vendor Info", style: TextStyle(color: Colors.white)),
//         backgroundColor: Color(0xFF800000), // Maroon color
//         actions: [
//           TextButton(
//             onPressed: _skipForm,
//             child: Text(
//               "Skip",
//               style: TextStyle(
//                   color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Vendor Name Input
//               Text("Vendor Name",
//                   style: TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF800000))),
//               TextField(
//                 controller: _vendorNameController,
//                 decoration: InputDecoration(
//                   hintText: "Enter Vendor Name",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 20),

//               // Phone Number Input
//               Text("Phone Number",
//                   style: TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF800000))),
//               TextField(
//                 controller: _phoneNumberController,
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(
//                   hintText: "Enter Phone Number",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 20),

//               // CNIC Front Upload
//               Text("CNIC Front (Optional)",
//                   style: TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF800000))),
//               GestureDetector(
//                 onTap: () => _pickImage(true),
//                 child: Container(
//                   height: 150,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(8),
//                     color: Colors.grey[200],
//                   ),
//                   child: _cnicFront == null
//                       ? Center(child: Text("Tap to upload CNIC Front"))
//                       : Image.file(_cnicFront!, fit: BoxFit.cover),
//                 ),
//               ),
//               SizedBox(height: 20),

//               // CNIC Back Upload
//               Text("CNIC Back (Optional)",
//                   style: TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF800000))),
//               GestureDetector(
//                 onTap: () => _pickImage(false),
//                 child: Container(
//                   height: 150,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(8),
//                     color: Colors.grey[200],
//                   ),
//                   child: _cnicBack == null
//                       ? Center(child: Text("Tap to upload CNIC Back"))
//                       : Image.file(_cnicBack!, fit: BoxFit.cover),
//                 ),
//               ),
//               SizedBox(height: 30),

//               // Submit Button
//               Center(
//                 child: ElevatedButton(
//                   onPressed: _submitForm,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
//                   child: Text(
//                     "Submit",
//                     style: TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
