import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'package:fyp/Login.dart'; // Use this if your app's package name is `fyp`
import 'Middlemannotification.dart';
import 'MiddlemanTaskHistory.dart'; // Import TaskHistory
import 'RatingFeedback.dart'; // Import Ratings
import 'RatingFeedback.dart'
    as custom_feedback; // Aliased import for RatingFeedback
import 'DonutChartPainter.dart';
import 'Wallet.dart';
import 'MiddlemanTasksPage.dart';
import 'MiddlemanProfilePage.dart';

class MiddlemanHomeScreen extends StatefulWidget {
  @override
  _MiddlemanHomeScreenState createState() => _MiddlemanHomeScreenState();
}

class _MiddlemanHomeScreenState extends State<MiddlemanHomeScreen> {
  int _currentIndex = 0;
  String userId = "";
  String token = "";

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id') ?? "N/A";
      token = prefs.getString('token') ?? "N/A";
    });
  }

  void _onDrawerItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.pop(context);
  }

  void _onBottomNavBarTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _getCurrentScreen(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return Wallet();
      case 2:
        return TasksPage();
      case 3:
        return MiddlemanProfilePage();
      default:
        return HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Taskify ${token}', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF800000), Color.fromARGB(255, 118, 16, 16)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Middlemannotification(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF800000), Color.fromARGB(255, 118, 16, 16)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(Icons.history, color: Colors.black),
              title: Text('Task History',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MiddlemanTaskHistory()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.star, color: Colors.black),
              title: Text('Ratings & Feedback',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => custom_feedback.RatingFeedback()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.black),
              title:
                  Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Login(
                            rolee: "middlemen",
                          )),
                );
              },
            ),
          ],
        ),
      ),
      body: _getCurrentScreen(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF800000),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        onTap: _onBottomNavBarTapped,
      ),
    );
  }
}
