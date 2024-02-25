import 'package:flutter/material.dart';

class PublicDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/logo.png', width: 80, height: 80), // change this to your logo image asset
                Text('Recipe App', style: TextStyle(fontSize: 18, color: Colors.white)), // change this to your app name
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context); // close the drawer
              Navigator.pushNamed(context, '/home'); // navigate to the home page
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About Us'),
            onTap: () {
              Navigator.pop(context); // close the drawer
              Navigator.pushNamed(context, '/about'); // navigate to the about us page
            },
          ),
        ],
      ),
    );
  }
}
