import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Complaint extends StatefulWidget {
  final String taskName;
  final String middleman;

  Complaint({required this.taskName, required this.middleman});

  @override
  _ComplaintScreenState createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<Complaint> {
  bool time = false;
  bool quality = false;
  bool behaviour = false;
  bool other = false;
  final Color maroonColor = Color(0xFF6D1B1B);
  final Color backgroundColor = Color.fromARGB(255, 246, 240, 240);

  File? _selectedFile;

  /// Function to pick image from Camera or Gallery
  Future<void> _pickFile(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    }
  }

  /// Function to show selection dialog
  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: maroonColor),
                title: Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFile(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.image, color: maroonColor),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFile(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text('File Complaint',
            style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 3,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: maroonColor,
                      child: Text('J', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.middleman,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: maroonColor,
                                fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Text("4.5 (344 orders)",
                                style: TextStyle(color: maroonColor)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Text('Choose Category',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: maroonColor)),
                SizedBox(height: 10.0),
                Wrap(
                  spacing: 8.0,
                  children: [
                    _buildChip('Time', time, (value) => setState(() => time = value)),
                    _buildChip('Quality', quality, (value) => setState(() => quality = value)),
                    _buildChip('Behaviour', behaviour, (value) => setState(() => behaviour = value)),
                    _buildChip('Other', other, (value) => setState(() => other = value)),
                  ],
                ),
                SizedBox(height: 20.0),
                Text('Write Note',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: maroonColor)),
                SizedBox(height: 10.0),
                TextField(
                  maxLines: 5,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: maroonColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: maroonColor),
                    ),
                    hintText: 'Write your note here...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 20.0),
                Text('Attach documents',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: maroonColor)),
                SizedBox(height: 10.0),
                
                /// File Attachment Button
                ElevatedButton(
                  onPressed: _showAttachmentOptions,
                  child: Text('Attach File',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: maroonColor,
                    foregroundColor: Colors.white,
                  ),
                ),

                /// Display Selected File
                if (_selectedFile != null) ...[
                  SizedBox(height: 10.0),
                  Image.file(_selectedFile!, height: 100, fit: BoxFit.cover),
                  SizedBox(height: 5.0),
                  Text("Selected File: ${_selectedFile!.path.split('/').last}",
                      style: TextStyle(color: maroonColor)),
                ],

                SizedBox(height: 20.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('SUBMIT',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: maroonColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label, bool selected, Function(bool) onSelected) {
    return FilterChip(
      label: Text(label, style: TextStyle(color: Colors.black)),
      selected: selected,
      selectedColor: maroonColor.withOpacity(0.2),
      checkmarkColor: maroonColor,
      onSelected: onSelected,
    );
  }
}
