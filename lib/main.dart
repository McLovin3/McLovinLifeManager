import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:light/light.dart';

import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'pages/journal_page.dart';
import 'pages/list_page.dart';
import 'services/notifications_service.dart';
import 'widgets/themes/themes.dart';

const int lightThreshhold = 25;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationsService().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  try {
    await dotenv.load(fileName: ".env");
    // ignore: empty_catches
  } catch (e) {}
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
  String? email;
  String? password;

  @override
  void initState() {
    super.initState();
    _isDarkTheme = widget.lightLevel < lightThreshhold;
  }

  @override
  Widget build(BuildContext context) {
    try {
      email = dotenv.env["email"];
      password = dotenv.env["password"];
      // ignore: empty_catches
    } catch (e) {}

    if (email == null || password == null) {
      return const Center(
        child: MaterialApp(
          home: Center(
            child: Text(
              "Please add email and password to .env file",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return FutureBuilder(
      future: widget.firebaseAuth
          .signInWithEmailAndPassword(email: email!, password: password!),
      builder: (context, snapshot) {
        return MaterialApp(
          title: "McLovin Life Manager",
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          initialRoute: "/",
          routes: {
            "/": (context) => snapshot.hasError
                ? HomePage(
                    isDarkTheme: _isDarkTheme,
                    changeTheme: changeTheme,
                    firebaseAuth: widget.firebaseAuth,
                    firestore: widget.firestore,
                  )
                : const Center(
                    child: Text(
                      "No internet connection",
                      textAlign: TextAlign.center,
                    ),
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
