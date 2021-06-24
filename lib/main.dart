import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/home.dart';

void main() {
  // firebase
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: home(),
      /* routes: {
        "/home": (context) => home(),
        "/second": (context) => SecondPage(),
      }, */
    );
  }
}
