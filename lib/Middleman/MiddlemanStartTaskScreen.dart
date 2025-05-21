import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'MiddlemanTime.dart';

class MiddlemanStartTaskScreen extends StatefulWidget {
  final String taskId;
  final String name;
  final String budget;
  final String category;
  final String location;
  final String description;
  final String attImg;
  final String type;
  final String custlocation;

  const MiddlemanStartTaskScreen({
    super.key,
    required this.taskId,
    required this.name,
    required this.budget,
    required this.category,
    required this.location,
    required this.description,
    required this.attImg,
    required this.type,
    required this.custlocation,
  });

  @override
  State<MiddlemanStartTaskScreen> createState() => _MiddlemanStartTaskScreenState();
}

class _MiddlemanStartTaskScreenState extends State<MiddlemanStartTaskScreen> {
  final TextEditingController _bidController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;
  String userId = "";
  String email = "";
  late GoogleMapController mapController;
  LatLng? _currentLatLng;
  final Location location = Location();
  bool _isLocationLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        setState(() => _isLocationLoading = false);
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        setState(() => _isLocationLoading = false);
        return;
      }
    }

    final currentLocation = await location.getLocation();
    setState(() {
      _currentLatLng = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      _isLocationLoading = false;
    });

    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentLatLng!, zoom: 14.0),
      ));
    }
  }

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id') ?? "N/A";
      email = prefs.getString('email') ?? "N/A";
    });
  }

  void _handleConfirm() {
    String bid = _bidController.text.isEmpty ? widget.budget : _bidController.text;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MiddlemanTime(
          taskId: widget.taskId,
          location: widget.custlocation,
          middId: userId,
          bidAmount: bid,
        ),
      ),
    );
  }

  void _showDetailsModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Task Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF800000),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.attImg.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(
                          base64Decode(widget.attImg),
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error, color: Colors.red);
                          },
                        ),
                      )
                    : const Icon(
                        Icons.image_not_supported,
                        size: 100,
                        color: Colors.grey,
                      ),
                const SizedBox(height: 20),
                Text('Name: ${widget.name}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('Budget: RS ${widget.budget}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text('Category: ${widget.category}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text('Location: ${widget.location}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text('Description: ${widget.description}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text('Customer Location: ${widget.custlocation}', style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Color(0xFF800000))),
            ),
          ],
        );
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_currentLatLng != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentLatLng!, zoom: 14.0),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double detailsHeight = MediaQuery.of(context).size.height * 0.5;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 242, 242),
      body: Stack(
        children: [
          // Full screen map below
          Positioned.fill(
            child: _isLocationLoading
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _currentLatLng ?? LatLng(0, 0),
                      zoom: 14.0,
                    ),
                    markers: _currentLatLng != null
                        ? {
                            Marker(
                              markerId: const MarkerId('current'),
                              position: _currentLatLng!,
                              infoWindow: const InfoWindow(title: 'Your Location'),
                            ),
                          }
                        : {},
                  ),
          ),

          // Details container fixed at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: detailsHeight,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20), // bottom padding same for buttons
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundImage: AssetImage('assets/jack.png'),
                          radius: 25,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.name,
                                style: const TextStyle(color: Color(0xFF800000), fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('RS ${widget.budget}', style: const TextStyle(color: Color(0xFF800000), fontSize: 16)),
                          ],
                        ),
                        const Spacer(),
                        Text(widget.category,
                            style: const TextStyle(color: Color(0xFF800000), fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _showDetailsModal,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF800000),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          ),
                          child: const Text('View More Details', style: TextStyle(color: Colors.white)),
                        ),
                        ElevatedButton(
                          onPressed: _handleConfirm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF800000),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          ),
                          child: Text('ACCEPT FOR RS ${widget.budget}', style: const TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('Your Offer',
                        style: TextStyle(color: Color(0xFF800000), fontSize: 18, fontWeight: FontWeight.bold)),
                    TextField(
                      controller: _bidController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 117, 37, 30),
                        border: OutlineInputBorder(),
                        hintText: 'Enter your offer',
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red.shade700, fontSize: 14),
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Buttons row fixed at bottom of this container, aligned left and right
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: _isLoading ? null : () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF800000),
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                        ),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleConfirm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF800000),
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text('Confirm', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
