import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../pages/birthday_page.dart';
import '../../pages/list_page.dart';
import '../../pages/todo_page.dart';

class HomeScaffold extends StatefulWidget {
  final bool isDarkTheme;
  final Function changeTheme;
  final Function changeMode;
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  const HomeScaffold({
    required this.isDarkTheme,
    required this.changeTheme,
    required this.changeMode,
    required this.firestore,
    required this.firebaseAuth,
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  int _selectedPage = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    pages = [
      TodoPage(
        isWorkMode: false,
        firebaseAuth: widget.firebaseAuth,
        firestore: widget.firestore,
      ),
      BirthdayPage(
        firebaseAuth: widget.firebaseAuth,
        firestore: widget.firestore,
      ),
      ListPage(
        firebaseAuth: widget.firebaseAuth,
        firestore: widget.firestore,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Home")),
        actions: [
          IconButton(
            onPressed: () => widget.changeMode(),
            icon: const Icon(Icons.work),
          ),
          IconButton(
            onPressed: () => widget.changeTheme(),
            icon: Icon(widget.isDarkTheme ? Icons.sunny : Icons.nightlight),
          )
        ],
      ),
      body: pages.elementAt(_selectedPage),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Todo",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cake),
            label: "Birthdays",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "Lists",
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedPage = index;
          });
        },
      ),
    );
  }
}
