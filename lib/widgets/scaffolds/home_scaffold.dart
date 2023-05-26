import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../lists/birthday_list.dart';
import '../lists/event_list.dart';
import '../lists/item_list_list.dart';
import '../lists/todo_list.dart';

class HomeScaffold extends StatefulWidget {
  final bool isDarkTheme;
  final Function changeTheme;
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final Uint8List? background;
  final Function refreshImage;

  const HomeScaffold({
    required this.isDarkTheme,
    required this.changeTheme,
    required this.firestore,
    required this.firebaseAuth,
    required this.background,
    required this.refreshImage,
    super.key,
  });

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  int _selectedPage = 0;
  ImagePicker picker = ImagePicker();
  List<Widget> pages = [];

  @override
  void initState() {
    pages = [
      TodoList(
        isWorkMode: false,
        firebaseAuth: widget.firebaseAuth,
        firestore: widget.firestore,
      ),
      BirthdayList(
        firebaseAuth: widget.firebaseAuth,
        firestore: widget.firestore,
        enableNotifications: true,
      ),
      ItemListList(
        firebaseAuth: widget.firebaseAuth,
        firestore: widget.firestore,
      ),
      EventList(
        firestore: widget.firestore,
        firebaseAuth: widget.firebaseAuth,
        enableNotifications: true,
        isWorkMode: false,
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
            onPressed: () => widget.changeTheme(),
            icon: Icon(widget.isDarkTheme ? Icons.sunny : Icons.nightlight),
          ),
          IconButton(
            onPressed: () async {
              XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);
              final storageRef = FirebaseStorage.instance.ref();
              final backgroundRef = storageRef.child("background.png");
              if (image != null) {
                await backgroundRef.putFile(File(image.path));
                widget.refreshImage();
              }
            },
            icon: const Icon(Icons.image),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: widget.background == null
                ? const AssetImage("assets/background.png")
                : Image.memory(widget.background!).image,
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
            icon: Icon(Icons.cake),
            label: "Birthdays",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "Lists",
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
