import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:light/light.dart';
import 'package:mclovin_life_manager/pages/home_scaffold.dart';
import 'package:mclovin_life_manager/pages/work_scaffold.dart';
import 'package:mclovin_life_manager/widgets/themes/themes.dart';
import 'firebase_options.dart';

const String email = "mathieu.ford@gmail.com";
const String password = "password";
const int lightThreshhold = 25;
late final int lightLevel;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  lightLevel = await Light().lightSensorStream.first;

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isWorkTheme = false;
  bool _isDarkTheme = lightLevel < lightThreshhold;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "McLovin Life Manager",
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: FutureBuilder(
        future: FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("No internet connection"));
          }
          return _isWorkTheme
              ? WorkScaffold(
                  isDarkTheme: _isDarkTheme,
                  changeTheme: changeTheme,
                  changeMode: changeMode,
                  firestore: FirebaseFirestore.instance,
                  firebaseAuth: FirebaseAuth.instance,
                )
              : HomeScaffold(
                  changeMode: changeMode,
                  firebaseAuth: FirebaseAuth.instance,
                  firestore: FirebaseFirestore.instance,
                  changeTheme: changeTheme,
                  isDarkTheme: _isDarkTheme,
                );
        },
      ),
    );
  }

  void changeTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  void changeMode() {
    setState(() {
      _isWorkTheme = !_isWorkTheme;
    });
  }
}
