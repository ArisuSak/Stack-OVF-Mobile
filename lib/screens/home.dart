import 'package:flutter/material.dart';
import 'package:flutterapp/about_us.dart';
import 'package:flutterapp/screens/post_screen.dart';
import 'package:flutterapp/screens/profile.dart';
import 'package:flutterapp/services/user_service.dart';

import 'login.dart';
import 'post_form.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
              'assets/images/Sflow_1.png', // replace 'logo.png' with your actual logo file name
              height: 30, // you can adjust the size as needed
            ),
            backgroundColor: const Color(0xFFBCBBBB),
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              logout().then((value) => {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Login()),
                        (route) => false)
                  });
            },
          )
        ],
      ),
      // Add a drawer property here
      drawer: Drawer(
        // Add a ListView to the drawer
        child: ListView(
          // Remove any padding from the ListView
          padding: EdgeInsets.zero,
          children: [
            // Add a DrawerHeader with your app name and logo
            DrawerHeader(
              decoration:
                  BoxDecoration(color: Color(0xFFBCBBBB)),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/Sflow_1.png',
                    width: 180,
                    height: 180,
                    // You can adjust the width and height as needed
                  ),
                  SizedBox(
                    width: 16,
                  ),
                ],
              ),
            ),
            // Add a ListTile for each page you want to navigate to
            ListTile(
              leading: Icon(
                Icons.home,
              ),
              title: Text('Home Page'),
              onTap: () {
                // Navigate to the home page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
                // Close the drawer
                Navigator.maybePop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.info,
              ),
              title: Text('About This App'),
              onTap: () {
                // Navigate to the about us page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutUs(),
                  ),
                );
                // Close the drawer
                Navigator.maybePop(context);
              },
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                child: const Text(
                  "What's on your mind?",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PostForm(
                            title: 'Add new post',
                          )));
                },
              ),
            ),
          ),
          Expanded(
            child: currentIndex == 0 ? PostScreen() : Profile(),
          ),
        ],
      ),
    bottomNavigationBar: Container(
        height: 92, // set the height here
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
          ],
          currentIndex: currentIndex,
          onTap: (val) {
            setState(() {
              currentIndex = val;
            });
          },
          backgroundColor: Colors.grey,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
        ),
      ),
    );
  }
}
