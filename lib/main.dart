import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:light/light.dart';

import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'pages/journal_page.dart';
import 'pages/list_page.dart';
import 'services/notifications_service.dart';
import 'widgets/themes/themes.dart';

const String email = "mathieu.ford@gmail.com";
const String password = "password";
const int lightThreshhold = 25;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationsService().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  int lightLevel = await Light()
      .lightSensorStream
      .first
      .timeout(const Duration(seconds: 3), onTimeout: () => 50);

  runApp(
    MyApp(
      firestore: FirebaseFirestore.instance,
      firebaseAuth: FirebaseAuth.instance,
      lightLevel: lightLevel,
    ),
  );
}

class MyApp extends StatefulWidget {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final int lightLevel;

  const MyApp({
    super.key,
    required this.firestore,
    required this.firebaseAuth,
    required this.lightLevel,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    _isDarkTheme = widget.lightLevel < lightThreshhold;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("No internet connection"));
        }
        return MaterialApp(
          title: "McLovin Life Manager",
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          initialRoute: "/",
          routes: {
            "/": (context) => HomePage(
                  isDarkTheme: _isDarkTheme,
                  changeTheme: changeTheme,
                  firebaseAuth: widget.firebaseAuth,
                  firestore: widget.firestore,
                ),
            "/list": (context) => ListPage(
                  firebaseAuth: widget.firebaseAuth,
                  firestore: widget.firestore,
                ),
            "/journal": (context) => JournalPage(
                  firebaseAuth: widget.firebaseAuth,
                  firestore: widget.firestore,
                ),
          },
        );
      },
    );
  }

  void changeTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }
}
