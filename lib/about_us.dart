import 'package:flutter/material.dart';
import 'package:flutterapp/screens/home.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/Sflow_1.png', // replace 'logo.png' with your actual logo file name
          height: 30, // you can adjust the size as needed
        ),
        backgroundColor: Color(0xFFBCBBBB),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFBCBBBB)),
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
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home Page'),
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
                Navigator.maybePop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About This App'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutUs(),
                  ),
                );
                Navigator.maybePop(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // margin: EdgeInsets.only(bottom: 5),
                child: Image.asset(
                  'assets/images/Sflow_1.png',
                  width: 180,
                  height: 180,
                ),
              ),
              SizedBox(height: 1), // Add spacing between logo and paragraphs
              // First paragraph with custom icon
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    SizedBox(width: 18),
                    Expanded(
                      child: Text(
                        'Empowering the world to develop technology through collective knowledge.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              // Second paragraph with custom icon
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    SizedBox(width: 18),
                    Expanded(
                      child: Text(
                        'Our products and tools enable people to ask, share and learn at work or at home.',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height:
                      32), // Add spacing between paragraphs and contact info
              // Contact information
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 8),
                  Text(
                    '15 year of trust',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFBCBBBB),
                    ),
                  ),
                  SizedBox(width: 16),
                  SizedBox(width: 8),
                  Text(
                    '58 million',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFBCBBBB),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
