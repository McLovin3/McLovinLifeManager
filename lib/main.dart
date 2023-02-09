import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mclovin_life_manager/pages/todo_page.dart';
import 'firebase_options.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.hasError) {
            return const CircularProgressIndicator();
          } else {
            return MaterialApp(
              title: 'McLovin Life Manager',
              theme: ThemeData(
                primarySwatch: Colors.pink,
              ),
              home: TodoPage(),
            );
          }
        });
  }
}
