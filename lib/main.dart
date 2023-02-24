import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:light/light.dart';
import 'package:mclovin_life_manager/pages/birthday_page.dart';
import 'package:mclovin_life_manager/pages/todo_page.dart';
import 'package:mclovin_life_manager/widgets/other/general_scaffold.dart';
import 'package:mclovin_life_manager/widgets/themes/themes.dart';
import 'firebase_options.dart';

const String email = "mathieu.ford@gmail.com";
const String password = "password";
const int lightThreshhold = 25;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  int lightLevel = await Light().lightSensorStream.first;

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

  const  MyApp({
    super.key,
    required this.firestore,
    required this.firebaseAuth,
    required this.lightLevel,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedPage = 0;
  bool _isWorkMode = false;
  bool _isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    _isDarkTheme = widget.lightLevel < lightThreshhold;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "McLovin Life Manager",
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: FutureBuilder(
        future: widget.firebaseAuth
            .signInWithEmailAndPassword(email: email, password: password),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("No internet connection"));
          }
          return _isWorkMode
              ? GeneralScaffold(
                  title: "Work",
                  selectedPage: _selectedPage,
                  isWorkMode: _isWorkMode,
                  bottomNavigationBar: null,
                  pages: [
                    TodoPage(
                      isWorkMode: true,
                      firebaseAuth: widget.firebaseAuth,
                      firestore: widget.firestore,
                    ),
                  ],
                  isDarkTheme: _isDarkTheme,
                  changeTheme: changeTheme,
                  changeMode: changeMode,
                  firestore: widget.firestore,
                  firebaseAuth: widget.firebaseAuth,
                )
              : GeneralScaffold(
                  title: "Home",
                  isWorkMode: _isWorkMode,
                  selectedPage: _selectedPage,
                  bottomNavigationBar: BottomNavigationBar(
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.list),
                        label: "Todo",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.cake),
                        label: "Birthdays",
                      ),
                    ],
                    onTap: (index) {
                      setState(() {
                        _selectedPage = index;
                      });
                    },
                  ),
                  pages: [
                    TodoPage(
                      isWorkMode: false,
                      firebaseAuth: widget.firebaseAuth,
                      firestore: widget.firestore,
                    ),
                    BirthdayPage(
                      firebaseAuth: widget.firebaseAuth,
                      firestore: widget.firestore,
                    ),
                  ],
                  changeMode: changeMode,
                  firebaseAuth: widget.firebaseAuth,
                  firestore: widget.firestore,
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
      _isWorkMode = !_isWorkMode;
    });
  }
}
