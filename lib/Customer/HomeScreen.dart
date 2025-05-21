import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CustomerTasksScreen.dart';
import 'ManageTask.dart';
import 'TaskHistory.dart';
import 'PostTask.dart';
import 'LocationScreen.dart';
import 'ProfileScreen.dart';
import 'PostedTasksScreen.dart';
import 'NotificationScreen.dart'; 
import '../Login.dart';// Import the NotificationScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
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

  final List<Widget> _pages = [
    HomeContent(),
    LocationScreen(),
    PostTask(),
    PostedTasksScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 240, 240),
      appBar: AppBar(
        backgroundColor: Color(0xFF800000), // Matching the first screen color
        title: Row(
          children: [
            Text("token ID: $token", style: TextStyle(fontSize: 20)),
            // Text("Email: $email", style: TextStyle(fontSize: 20)),
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Taskify',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Navigate to the Notification Screen when the icon is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Color(0xFF800000), // Matching the first screen color
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 249, 248, 248), // Set the background color to black
              ),
              accountName: Text(
                'User Name',
                style: TextStyle(
                    color: const Color.fromARGB(255, 20, 19, 19)), // Set account name text color to white
              ),
              accountEmail: Text(
                'user@example.com',
                style: TextStyle(
                    color: const Color.fromARGB(179, 18, 18, 18)), // Set account email text color to a lighter white
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: Colors.black, // Set the icon color to black
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.task, color: Colors.white),
              title: Text('Manage Task', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageTask()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history, color: Colors.white),
              title: Text('Task History', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskHistory()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.star, color: Colors.white),
              title: Text('Rating and Feedback',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CustomerTasksScreen(isForRating: true)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.message, color: Colors.white),
              title: Text('Complaint', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CustomerTasksScreen(isForRating: false)),
                );
              },
            ),
           ListTile(
              leading: Icon(Icons.logout, color: Colors.black),
              title: Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login(rolee: "customer",)),
                );
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on), label: 'Location'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Post'),
          BottomNavigationBarItem(
              icon: Icon(Icons.checklist), label: 'Posted Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Color(0xFF800000), // Matching the first screen color
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(16),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildTaskCategory(context, 'Grocery', 'assets/images/5.png'),
        _buildTaskCategory(context, 'Pharmacy Pickup', 'assets/images/1.png'),
        _buildTaskCategory(context, 'Home Repairs', 'assets/images/4.png'),
        _buildTaskCategory(context, 'Courier', 'assets/images/2.png'),
        _buildTaskCategory(
            context, 'Auto Care Services', 'assets/images/6.png'),
        _buildTaskCategory(context, 'Others', 'assets/images/3.png'),
      ],
    );
  }

  Widget _buildTaskCategory(
      BuildContext context, String title, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostTask()),
        );
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Color(0xFF800000)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 80,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                  color: Color(0xFF800000),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
