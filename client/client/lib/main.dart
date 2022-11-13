import 'package:client/view/auth_screen.dart';
import 'package:client/view/dashboard.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

const firebaseConfig = FirebaseOptions(
    apiKey: "AIzaSyCoZ3G0ypyaymz63mMhCHhmsptBZdq2ZBI",
    authDomain: "tender-bidding-swe-754b6.firebaseapp.com",
    projectId: "tender-bidding-swe-754b6",
    storageBucket: "tender-bidding-swe-754b6.appspot.com",
    messagingSenderId: "272752532502",
    appId: "1:272752532502:web:2399dfd21cb23964326937");

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseConfig);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthScreen());
  }
}
