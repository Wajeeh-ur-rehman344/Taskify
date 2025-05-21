// import 'dart:io';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';

// // Dynamic base URL with default fallback
// late String url = '';
// // Flag to indicate if we're using a manually configured IP
// bool isManuallyConfigured = false;
// // Flag to indicate if initialization failed
// bool initializationFailed = false;

// // Initialize the base URL
// Future<void> initializeBaseUrl(BuildContext? context) async {
//   // First try to get from SharedPreferences if saved previously
//   final prefs = await SharedPreferences.getInstance();
//   String? savedIp = prefs.getString('server_ip');
//   bool? isManual = prefs.getBool('is_manual_ip');

//   if (savedIp != null && savedIp.isNotEmpty) {
//     url = 'http://$savedIp:3000/';
//     isManuallyConfigured = isManual ?? false;
//     print('Using saved IP address: $url');

//     // Try to ping the URL to validate it
//     try {
//       final result = await InternetAddress.lookup(savedIp);
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         print('Successfully connected to: $url');
//         initializationFailed = false;
//         return;
//       }
//     } catch (_) {
//       // If ping fails but it's manually configured, still use it
//       if (isManuallyConfigured) {
//         print(
//             'Using manually configured IP: $url (could not verify connection)');
//         initializationFailed = false;
//         return;
//       }
//     }
//   }

//   // If no valid saved IP, try to get the device's IP address
//   try {
//     // Check if we're connected to WiFi
//     var connectivityResult = await Connectivity().checkConnectivity();
//     if (connectivityResult == ConnectivityResult.wifi) {
//       // Get list of network interfaces
//       final interfaces = await NetworkInterface.list(
//         type: InternetAddressType.IPv4,
//         includeLinkLocal: false,
//       );

//       // Look for non-loopback address
//       for (var interface in interfaces) {
//         for (var addr in interface.addresses) {
//           if (!addr.isLoopback) {
//             // Use the device's subnet with .1 as the likely router/server address
//             String subnet =
//                 addr.address.substring(0, addr.address.lastIndexOf('.'));
//             String serverIp = '$subnet.1';
//             url = 'http://$serverIp:3000/';

//             print('Detected network IP: $url');

//             // Try to ping the server to check if it's valid
//             try {
//               final result = await InternetAddress.lookup(serverIp);
//               if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//                 // Save for future use
//                 await prefs.setString('server_ip', serverIp);
//                 await prefs.setBool('is_manual_ip', false);
//                 print('Successfully connected to: $url');
//                 initializationFailed = false;
//                 return;
//               }
//             } catch (_) {
//               // Keep trying other interfaces
//               continue;
//             }
//           }
//         }
//       }
//     }

//     // If we've reached here, we couldn't find a valid IP
//     initializationFailed = true;
//     url = 'http://127.0.0.1:3000/'; // Localhost fallback
//     print('Failed to find a valid server IP. Using fallback: $url');

//     // Show error message if context is provided
//     if (context != null) {
//       _showConnectManuallyDialog(context);
//     }
//   } catch (e) {
//     // Error during detection
//     initializationFailed = true;
//     url = 'http://127.0.0.1:3000/'; // Localhost fallback
//     print('Error detecting network: $e');
//     print('Using fallback IP: $url');

//     // Show error message if context is provided
//     if (context != null) {
//       _showConnectManuallyDialog(context);
//     }
//   }
// }

// // Function to show dialog asking user to configure IP manually
// void _showConnectManuallyDialog(BuildContext context) {
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Connection Failed'),
//           content: Text(
//               'Unable to connect to the server automatically. Please configure your IP address manually in the settings.'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 // Here you could navigate to settings screen
//                 // Navigator.of(context).push(MaterialPageRoute(builder: (context) => YourSettingsScreen()));
//               },
//             ),
//           ],
//         );
//       },
//     );
//   });
// }

// // Function to manually set the server IP
// Future<bool> setServerIp(String ipAddress) async {
//   try {
//     final prefs = await SharedPreferences.getInstance();

//     // Validate the IP address format
//     if (!RegExp(r'^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$')
//         .hasMatch(ipAddress)) {
//       print('Invalid IP address format: $ipAddress');
//       return false;
//     }

//     // Try to ping the IP before saving
//     try {
//       final result = await InternetAddress.lookup(ipAddress);
//       if (result.isEmpty || result[0].rawAddress.isEmpty) {
//         print('Could not verify IP address: $ipAddress');
//         // We still save it as the user wants to use this specific IP
//       }
//     } catch (e) {
//       print('Error verifying IP address: $e');
//       // We still save it as the user wants to use this specific IP
//     }

//     // Save the IP address
//     await prefs.setString('server_ip', ipAddress);
//     await prefs.setBool('is_manual_ip', true);

//     // Update the current URL
//     url = 'http://$ipAddress:3000/';
//     isManuallyConfigured = true;
//     initializationFailed = false;

//     print('Manually set server IP: $url');
//     return true;
//   } catch (e) {
//     print('Error setting server IP: $e');
//     return false;
//   }
// }

// // Function to check if initialization failed and we need manual configuration
// bool needsManualConfiguration() {
//   return initializationFailed;
// }

final url = 'http://192.168.10.14:3000/';

//------------------customer login & registeration routes--------------------------------
String get customerRegister => "${url}customerregister";
String get customerVerifyOtp => "${url}customerVerifyOtp";
String get customerResendOtps => "${url}customerResendOtp";
String get customerlogins => "${url}customerlogin";
String get customerForgetPass => "${url}customerForgetPassword";
String get customerUpdatePass => "${url}customerUpdatePass";

//---------------middleman login & registeration routes--------------------------------
String get middlemanRegisters => "${url}middlemanRegisters";
String get middlemanOtpVerify => "${url}middlemanOtpVerify";
String get midRegisterDetails => "${url}midRegisterDetails";
String get middlemanlogin => "${url}middlemanlogin";
String get midForgetpassword => "${url}midForgetpassword";
String get midVerifyOtp => "${url}midVerifyOtp";
String get midResendOtp => "${url}midResendOtp";
String get midUpdatePass => "${url}midUpdatePass";
String get midProfilePic => "${url}midProfilePic";

//customer post task
String get customerTaskPost => "${url}customerTaskPost";
String get custPlaceBid => "${url}custPlaceBid";
String get custAcceptMidds => "${url}custAcceptmidd";
String get custShowStartTask => "${url}custShowStartTask";

//customer show task
String get custShowManageTask => "${url}custManageTask";



//middleman
String get showStartTaskmiddlemans => "${url}middshowStartTask";
String get middBids => "${url}middBid";
String get midTime => "${url}midTime";
String get showMidd => "${url}showMidd";
String get acceptmidd => "${url}acceptmidd";
String get midnotify => "${url}midnotify";
String get middUpdateStatusToComplete => "${url}middUpdateStatusToComplete";

//middleman notification
String get middShowNotifyAgainstCustTasks => "${url}middShowNotifyAgainstCustTask";
