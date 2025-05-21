// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:fyp/URLs/config.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'Request.dart';
// import 'package:http/http.dart' as http;

// class Bid extends StatefulWidget {
//   final String taskIdd; // Keep consistent naming

//   const Bid({Key? key, required this.taskIdd}) : super(key: key);

//   @override
//   _BidState createState() => _BidState();
// }

// class _BidState extends State<Bid> {
//   TextEditingController _bidController = TextEditingController();
//   GoogleMapController? _mapController;
//   LatLng? _currentPosition;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     print('Received Task ID: ${widget.taskIdd}'); // Verify ID
//     _getUserLocation();
//   }

//   void _confirmBid() async {
//     final String apiUrl = custPlaceBid; // Replace with your backend URL

//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "userId": widget.taskIdd, // Sending task ID as userId
//           "budget": _bidController.text, // Bid amount from input field
//         }),
//       );

//       final responseData = jsonDecode(response.body);
//       print(responseData);

//       if (response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Bid placed successfully!")),
//         );
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => Request(),
//           ),
//         );
//       } else {
//         print("Failed to place bid: ${responseData['message']}");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text("Failed to place bid: ${responseData['message']}")),
//         );
//       }
//     } catch (error) {
//       print("Error placing bid: $error");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error placing bid, try again!")),
//       );
//     }
//   }

//   Future<void> _getUserLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Location services check
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return;
//     }

//     // Permission check
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return;
//     }

//     // Get current location
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     setState(() {
//       _currentPosition = LatLng(position.latitude, position.longitude);
//       _isLoading = false;
//     });

//     _mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition!));

//     // Keep tracking location
//     Geolocator.getPositionStream(
//             locationSettings: LocationSettings(
//                 accuracy: LocationAccuracy.high, distanceFilter: 10))
//         .listen((Position position) {
//       setState(() {
//         _currentPosition = LatLng(position.latitude, position.longitude);
//       });
//       _mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
//     });
//   }

//   void _incrementBid() {
//     int currentBid = int.tryParse(_bidController.text) ?? 0;
//     setState(() {
//       _bidController.text = (currentBid + 10).toString();
//     });
//   }

//   void _decrementBid() {
//     int currentBid = int.tryParse(_bidController.text) ?? 0;
//     if (currentBid > 10) {
//       setState(() {
//         _bidController.text = (currentBid - 10).toString();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 246, 240, 240),
//       body: Stack(
//         children: [
//           // Google Map covering most of the screen
//           _isLoading
//               ? Center(child: CircularProgressIndicator())
//               : GoogleMap(
//                   initialCameraPosition: CameraPosition(
//                     target: _currentPosition!,
//                     zoom: 14,
//                   ),
//                   onMapCreated: (GoogleMapController controller) {
//                     _mapController = controller;
//                   },
//                   markers: _currentPosition != null
//                       ? {
//                           Marker(
//                             markerId: MarkerId("customerLocation"),
//                             position: _currentPosition!,
//                             infoWindow: InfoWindow(title: "Your Location"),
//                           ),
//                         }
//                       : {},
//                 ),

//           // Bottom Bid UI
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               width: double.infinity,
//               height: 250,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(16),
//                   topRight: Radius.circular(16),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 10,
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'place Your Desired Bid',
//                     style: TextStyle(
//                       color: Color(0xFF800000),
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                         onPressed: _decrementBid,
//                         style: ElevatedButton.styleFrom(
//                           shape: CircleBorder(),
//                           padding: EdgeInsets.all(16),
//                           backgroundColor: Color(0xFF800000),
//                         ),
//                         child: Icon(Icons.remove, color: Colors.white),
//                       ),
//                       Container(
//                         width: 200,
//                         child: TextField(
//                           controller: _bidController,
//                           keyboardType: TextInputType.number,
//                           textAlign: TextAlign.center,
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Color(0xFF800000),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: BorderSide(color: Colors.black),
//                             ),
//                             hintText: 'Enter bid',
//                             hintStyle: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                             ),
//                           ),
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: _incrementBid,
//                         style: ElevatedButton.styleFrom(
//                           shape: CircleBorder(),
//                           padding: EdgeInsets.all(16),
//                           backgroundColor: Color(0xFF800000),
//                         ),
//                         child: Icon(Icons.add, color: Colors.white),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFF800000),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       padding:
//                           EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                     ),
//                     onPressed: _confirmBid, // Call the API on button press
//                     child: Text(
//                       'Confirm',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
