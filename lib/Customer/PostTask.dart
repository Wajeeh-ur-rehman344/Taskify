import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fyp/Customer/Request.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import '../ApiServices/customer_postTask.dart'; // Import the API service
import '../URLs/config.dart';

class PostTask extends StatefulWidget {
  final String? selectedCategory;

  const PostTask({super.key, this.selectedCategory});

  @override
  _PostTaskState createState() => _PostTaskState();
}

class _PostTaskState extends State<PostTask> {
  final _formKey = GlobalKey<FormState>();
  late String? selectedCategory;
  String? selectedType;
  String? _userId;
  bool _isLoading = false;
  bool _locationLoading = true;
  LatLng? _currentPosition;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationNameController = TextEditingController();
  final TextEditingController _locationCoordController =
      TextEditingController();
  final TextEditingController _bidController = TextEditingController();

  File? _selectedImage; // Single image file
  final List<String> _categories = [
    'Grocery',
    'Pharmacy Pickup',
    'Courier',
    'Home Repairs',
    'Auto Care Services',
    'Others'
  ];
  final List<String> _types = ['Indoor', 'Outdoor'];
  final ImagePicker _picker = ImagePicker();

  final Map<String, int> _minimumBids = {
    'Grocery': 150,
    'Pharmacy Pickup': 200,
    'Courier': 250,
    'Home Repairs': 300,
    'Auto Care Services': 500,
    'Others': 700,
  };

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.selectedCategory;
    _loadUserData();
    _setTypeAutomatically(selectedCategory);
    _getCurrentLocation();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('user_id');
    });
  }

  void _setTypeAutomatically(String? category) {
    setState(() {
      if (category == 'Grocery' ||
          category == 'Pharmacy Pickup' ||
          category == 'Courier' ||
          category == 'Auto Care Services') {
        selectedType = 'Outdoor';
      } else if (category == 'Home Repairs') {
        selectedType = 'Indoor';
      } else {
        selectedType = null;
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showErrorSnackbar('Please enable location services');
      setState(() => _locationLoading = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showErrorSnackbar('Location permissions are denied');
        setState(() => _locationLoading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showErrorSnackbar('Location permissions are permanently denied');
      setState(() => _locationLoading = false);
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _locationCoordController.text =
            "${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}";
        _locationLoading = false;
      });
    } catch (e) {
      _showErrorSnackbar('Error getting location: $e');
      setState(() => _locationLoading = false);
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showErrorSnackbar('Error picking image: $e');
    }
  }

  Future<void> _postTask() async {
    if (!_formKey.currentState!.validate()) return;
    if (_userId == null) {
      _showErrorSnackbar('User not authenticated');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await CustomerPostTask().customerPostTask(
        custId: _userId!,
        title: _titleController.text,
        description: _descriptionController.text,
        custlocation: _locationCoordController.text,
        custlocationwords: _locationNameController.text,
        category: selectedCategory!,
        type: selectedType!,
        bidAmount: _bidController.text,
        image: _selectedImage, // Pass the selected image
      );

      if (success['status'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Request(taskId: success['taskId'], bidAmount: _bidController.text, custlocation: _locationCoordController.text),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task posted successfully!')),
        );
      } else {
        _showErrorSnackbar('Failed to post task');
      }
    } catch (e) {
      _showErrorSnackbar('Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F0F0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildCategoryDropdown(),
                const SizedBox(height: 16),
                _buildTitleField(),
                const SizedBox(height: 16),
                _buildTypeDropdown(),
                const SizedBox(height: 16),
                _buildDescriptionField(),
                const SizedBox(height: 16),
                _buildBidField(),
                const SizedBox(height: 16),
                _buildLocationCoordinateField(),
                const SizedBox(height: 16),
                _buildLocationNameField(),
                const SizedBox(height: 16),
                _buildImageUploadSection(),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('UPLOAD IMAGE'),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF800000)),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: _selectedImage == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.upload, size: 40, color: Color(0xFF800000)),
                      SizedBox(height: 8),
                      Text('Tap to upload image',
                          style: TextStyle(color: Color(0xFF800000))),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(_selectedImage!,
                        width: double.infinity, height: 150, fit: BoxFit.cover),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Text(
      'POST TASK',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF800000),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('SELECT CATEGORY'),
        DropdownButtonFormField<String>(
          value: selectedCategory,
          hint: const Text('Select Category'),
          items: _categories
              .map((category) => DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedCategory = value;
              _setTypeAutomatically(value);
              // Automatically set the minimum bid amount
              final minBid = _minimumBids[selectedCategory] ?? 0;
              _bidController.text = minBid.toString();
            });
          },
          decoration: _inputDecoration(),
          validator: (value) => value == null ? 'Required field' : null,
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('TITLE'),
        TextFormField(
          controller: _titleController,
          decoration: _inputDecoration('Enter title'),
          validator: (value) => value!.isEmpty ? 'Required field' : null,
        ),
      ],
    );
  }

  Widget _buildTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('SELECT TYPE'),
        DropdownButtonFormField<String>(
          value: selectedType,
          hint: const Text('Select Type'),
          items: _types
              .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ))
              .toList(),
          onChanged: selectedCategory == 'Others'
              ? (value) => setState(() => selectedType = value)
              : null,
          decoration: _inputDecoration(),
          validator: (value) => value == null ? 'Required field' : null,
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('DESCRIPTION'),
        TextFormField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: _inputDecoration('Enter description'),
          validator: (value) => value!.isEmpty ? 'Required field' : null,
        ),
      ],
    );
  }

  Widget _buildBidField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('BID AMOUNT'),
        TextFormField(
          controller: _bidController,
          keyboardType: TextInputType.number, // Restrict to numbers
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly
          ], // Allow only digits
          decoration: _inputDecoration('Enter bid amount'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Bid amount is required';
            }
            final bid = int.tryParse(value);
            final minBid = _minimumBids[selectedCategory] ?? 0;
            if (bid == null || bid < minBid) {
              return 'The minimum required bid for $selectedCategory is $minBid';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLocationCoordinateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('LOCATION COORDINATES'),
        Stack(
          children: [
            TextFormField(
              controller: _locationCoordController,
              readOnly: true,
              decoration: _inputDecoration('Fetching location...'),
              validator: (value) => value!.isEmpty ? 'Location required' : null,
            ),
            if (_locationLoading)
              Positioned(
                right: 10,
                top: 15,
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF800000),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('LOCATION NAME/ADDRESS'),
        TextFormField(
          controller: _locationNameController,
          decoration: _inputDecoration('Enter location name/address'),
          validator: (value) => value!.isEmpty ? 'Required field' : null,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _isLoading ? null : _postTask,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF800000),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('POST TASK',
                style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Color(0xFF800000)),
      ),
    );
  }

  InputDecoration _inputDecoration([String? hint]) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF800000), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF800000), width: 2),
      ),
    );
  }
}
