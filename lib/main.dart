import 'package:flutter/material.dart';
import 'package:fyp/Customer/HomeScreen.dart';
import 'package:fyp/MessageScreen.dart';
import 'package:fyp/Customer/Task.dart';
import 'package:fyp/Middleman/MiddlemanStartTaskScreen.dart';
import 'package:fyp/Middleman/MiddlemanTasksPage.dart';
import 'package:fyp/Middleman/Middlemannotification.dart';
import 'package:fyp/Middleman/Middlemanstatus1.dart';
import 'package:fyp/Middleman/middlemanRegImageupload.dart';
import 'package:fyp/Middleman/middlemanRegisterDetails.dart';
import 'Middleman/MiddlemanEmailPhoneRegisterPage.dart';
import 'Login.dart';
import 'UserSelectionScreen.dart';
import 'Splash.dart';
import 'AppTour.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Middleman/MiddlemanHomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Always start with the Splash screen
  // Widget initialScreen = MiddlemanStartTaskScreen(taskId: '', budget: '', name: '', category: '', location: '',);
  // Widget initialScreen = MiddlemanStartTaskScreen(taskId: '', name: '', budget: '', category: '', location: '', description: '', attImg: '', type: '', custlocation: 'R',);
  // Widget initialScreen = Task(taskId: '682ba64f452ed22481dcf7c4',);
  Widget initialScreen = Splash();

  runApp(MyApp(initialScreen: initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  MyApp({required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: initialScreen,
    );
  }
}
