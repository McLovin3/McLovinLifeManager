import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mclovin_life_manager/pages/todo_page.dart';
import 'package:mclovin_life_manager/widgets/loading_widget.dart';
import 'firebase_options.dart';

const String email = "mathieu.ford@gmail.com";
const String password = "password";

//TODO uid is reserved term :l

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

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("No internet connection"));
        }
        return const TodoPage();
      },
    );
  }
}
