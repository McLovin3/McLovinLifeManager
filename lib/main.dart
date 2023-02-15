import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mclovin_life_manager/pages/birthday_page.dart';
import 'package:mclovin_life_manager/pages/todo_page.dart';
import 'package:mclovin_life_manager/widgets/loading_widget.dart';
import 'firebase_options.dart';

const String email = "mathieu.ford@gmail.com";
const String password = "password";

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'McLovin Life Manager',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.hasError) {
              return const LoadingWidget();
            }
            return const MainApp();
          }),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedPage = 0;
  static final List<Widget> _pages = <Widget>[
    TodoPage(
        firebaseAuth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance),
    BirthdayPage(
        firebaseAuth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance),
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("No internet connection"));
        }
        return Scaffold(
            appBar: AppBar(
              title: const Center(child: Text("McLovin Life Manager")),
            ),
            body: _pages.elementAt(_selectedPage),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: "Todo",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.cake),
                  label: "Birthdays",
                ),
              ],
              currentIndex: _selectedPage,
              onTap: (int index) {
                setState(() {
                  _selectedPage = index;
                });
              },
            ));
      },
    );
  }
}
