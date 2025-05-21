import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../ApiServices/middleman_postTask.dart';
import './MiddlemanHomeScreen.dart';

class MiddlemanTime extends StatefulWidget {
  final String taskId;
  final String middId;
  final String bidAmount;
  final String location;

  const MiddlemanTime({
    super.key,
    required this.taskId,
    required this.middId,
    required this.bidAmount,
    required this.location,
  });

  @override
  _MiddlemanTimeState createState() => _MiddlemanTimeState();
}

class _MiddlemanTimeState extends State<MiddlemanTime> {
  String? selectedTime;
  TextEditingController customTimeController = TextEditingController();
  bool _isLoading = false;
  String userId = "";

  final MiddlemanPostTask _postTaskService = MiddlemanPostTask();

  GoogleMapController? _mapController;
  Position? _currentPosition;
  CameraPosition? _initialCameraPosition;

  @override
  void initState() {
    super.initState();
    loadUserData();
    _getCurrentLocation();
  }

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id') ?? "N/A";
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return;
      }
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
      _initialCameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 15,
      );
    });
  }

  Future<void> _handleConfirm() async {
    final time = selectedTime ?? customTimeController.text;
    if (time.isEmpty) {
      _showErrorDialog("Please select or enter a time");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await _postTaskService.middlemanPlaceBid(
        widget.taskId,
        widget.middId,
        widget.bidAmount,
        time,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Bid placed successfully!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MiddlemanHomeScreen()),
        );
      } else {
        throw Exception("Failed to place bid");
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit bid: $error")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Map Section
            Expanded(
              flex: 2,
              child: _initialCameraPosition == null
                  ? const Center(child: CircularProgressIndicator())
                  : GoogleMap(
                      initialCameraPosition: _initialCameraPosition!,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                    ),
            ),

            // Bottom Section
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "How soon will you arrive?",
                      style: TextStyle(
                        color: Color(0xFF800000),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        _buildTimeOption("10 MINS"),
                        _buildTimeOption("15 MINS"),
                        _buildTimeOption("20 MINS"),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextField(
                            controller: customTimeController,
                            decoration: InputDecoration(
                              hintText: "Enter custom time",
                              filled: true,
                              fillColor: const Color(0xFF800000),
                              hintStyle: const TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                            onTap: () => setState(() => selectedTime = null),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildActionButton("Cancel", const Color(0xFF800000)),
                        _buildActionButton("Confirm", const Color(0xFF800000)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeOption(String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: GestureDetector(
        onTap: _isLoading ? null : () => _selectTime(time),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selectedTime == time
                ? Colors.blueGrey
                : const Color(0xFF800000),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: Center(
            child: Text(
              time,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: _isLoading
              ? null
              : () => label == "Confirm"
                  ? _handleConfirm()
                  : Navigator.pop(context),
          child: _isLoading && label == "Confirm"
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
        ),
      ),
    );
  }

  void _selectTime(String time) {
    setState(() {
      selectedTime = time;
      customTimeController.clear();
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
