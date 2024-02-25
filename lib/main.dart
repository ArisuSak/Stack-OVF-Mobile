import 'package:flutter/material.dart';
import 'screens/loading.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Loading(),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutterapp/screens/home.dart';
// // Import the home.dart and about_us.dart files
// import 'about_us.dart';

// void main() {
//   runApp(const App());
// }

// class App extends StatelessWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       initialRoute: '/',
//       // Add the routes property
//       routes: {
//         // When navigating to the '/' route, build the Home widget
//         '/': (context) => Home(),
//         // When navigating to the '/about' route, build the AboutUs widget
//         '/about': (context) => AboutUs(),
//       },
//     );
//   }
// }
