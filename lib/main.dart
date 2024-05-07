// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:right_app/SignUpScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:right_app/const.dart';
import 'package:right_app/firebase_options.dart';
import 'package:right_app/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Gemini.init(
    apiKey: GEMINI_API_KEY,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset(
//             'lib/assets/LOGO.png',
//             height: 150,
//           ),
//           SizedBox(height: 20),
//           Text(
//             'The Right.',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           SizedBox(height: 20),
//           Text(
//             'Welcome to The Right.',
//             style: TextStyle(
//               fontSize: 18,
//               color: Colors.black,
//             ),
//           ),
//           SizedBox(height: 20, width: 20),
//           Container(
//             alignment: Alignment.center,
//             child: Text(
//               'Empower Your Voice: Report Malpractice Directly to Superiors',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           SizedBox(height: 30),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => SignUpScreen()),
//               );
//             },
//             child: Text(
//               'GET STARTED',
//               style: TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
