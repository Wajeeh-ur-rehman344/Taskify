import 'package:flutter/material.dart';
import 'package:fyp/ApiServices/customer_manageTask.dart';
import 'package:fyp/URLs/config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'PostTask.dart';
import 'HomeScreen.dart';
import 'Task.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Request extends StatefulWidget {
  final String taskId;
  final String bidAmount;
  final String custlocation;

  const Request({super.key, required this.taskId, required this.bidAmount, required this.custlocation});

  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<Request> {
  late int currentPrice = int.parse(widget.bidAmount);
  late IO.Socket socket;
  List<dynamic> middlemanBids = [];
  bool isLoading = true;

  late GoogleMapController mapController;
  LatLng? custLatLng;

  @override
  void initState() {
    super.initState();
    _connectSocket();
    _parseCustomerLocation();
  }

  void _parseCustomerLocation() {
    try {
      List<String> parts = widget.custlocation.split(',');
      double lat = double.parse(parts[0].trim());
      double lng = double.parse(parts[1].trim());
      custLatLng = LatLng(lat, lng);
    } catch (e) {
      print('Error parsing location: $e');
      custLatLng = LatLng(24.8607, 67.0011); // Default Karachi
    }
  }

  void _connectSocket() {
    socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );
    socket.connect();

    socket.onConnect((_) {
      _refreshBids();
    });

    socket.on('midd-against-cust-task-data', (data) {
      setState(() {
        middlemanBids = data;
        isLoading = false;
      });
    });

    socket.onDisconnect((_) {
      print('Socket disconnected');
    });
  }

  Future<void> _refreshBids() async {
    setState(() {
      isLoading = true;
    });
    socket.emit('midd-against-cust-task', widget.taskId);
    while (isLoading) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Widget _buildPriceController() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.remove, color: Color(0xFF6D1B1B)),
          onPressed: () => setState(() {
            if (currentPrice > 0) currentPrice -= 5;
          }),
        ),
        Container(
          width: 100,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF6D1B1B)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "PKR $currentPrice",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6D1B1B),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add, color: Color(0xFF6D1B1B)),
          onPressed: () => setState(() => currentPrice += 5),
        ),
      ],
    );
  }

  Widget _buildMiddlemanCard(dynamic middleman) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(middleman['name'] ?? 'Unknown'),
        subtitle: Text("Bid: PKR ${middleman['bid']}"),
        trailing: ElevatedButton(
          onPressed: () {
            // Handle accept bid
          },
          child: const Text('Accept'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6D1B1B),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double bottomPanelHeight = MediaQuery.of(context).size.height * 0.20;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Full screen Google Map in background
            custLatLng == null
                ? const Center(child: Text('Invalid location'))
                : GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: custLatLng!,
                      zoom: 14,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('customerLocation'),
                        position: custLatLng!,
                        infoWindow: const InfoWindow(title: 'Customer Location'),
                      ),
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    rotateGesturesEnabled: true,
                    tiltGesturesEnabled: true,
                  ),

            // Bottom container with bids + offer
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: bottomPanelHeight,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Bids list, take remaining height after offer controller
                    Expanded(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : middlemanBids.isEmpty
                              ? const Center(child: Text("No bids yet."))
                              : ListView.builder(
                                  itemCount: middlemanBids.length,
                                  itemBuilder: (context, index) {
                                    return _buildMiddlemanCard(middlemanBids[index]);
                                  },
                                ),
                    ),

                    const SizedBox(height: 10),

                    // Offer controller and buttons
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Your Offer",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildPriceController(),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PostTask()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6D1B1B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: const Size(120, 50),
                              ),
                              child: const Text(
                                "UPDATE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomeScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6D1B1B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: const Size(120, 50),
                              ),
                              child: const Text(
                                "CANCEL",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Floating refresh button top right (optional)
            Positioned(
              top: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: _refreshBids,
                backgroundColor: const Color(0xFF6D1B1B),
                child: const Icon(Icons.refresh),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
