import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../lists/event_list.dart';
import '../lists/todo_list.dart';

class WorkScaffold extends StatefulWidget {
  final bool isDarkTheme;
  final Function changeTheme;
  final Function changeMode;
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final Uint8List? background;

  const WorkScaffold({
    required this.background,
    required this.isDarkTheme,
    required this.changeTheme,
    required this.changeMode,
    required this.firestore,
    required this.firebaseAuth,
    super.key,
  });

  @override
  State<WorkScaffold> createState() => _WorkScaffoldState();
}

class _WorkScaffoldState extends State<WorkScaffold> {
  int _selectedPage = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    pages = [
      TodoList(
        isWorkMode: true,
        firebaseAuth: widget.firebaseAuth,
        firestore: widget.firestore,
      ),
      EventList(
        firestore: widget.firestore,
        firebaseAuth: widget.firebaseAuth,
        enableNotifications: true,
        isWorkMode: true,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Work")),
        actions: [
          IconButton(
            onPressed: () => widget.changeMode(),
            icon: const Icon(Icons.home),
          ),
          IconButton(
            onPressed: () => widget.changeTheme(),
            icon: Icon(widget.isDarkTheme ? Icons.sunny : Icons.nightlight),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Image.memory(widget.background!).image,
            fit: BoxFit.cover,
          ),
        ),
        child: pages.elementAt(_selectedPage),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Todo",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Events",
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
