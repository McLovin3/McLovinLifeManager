import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/event.dart';
import '../other/loading_widget.dart';

class EventList extends StatefulWidget {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final bool enableNotifications;
  final bool isWorkMode;

  const EventList(
      {required this.firestore,
      required this.firebaseAuth,
      required this.enableNotifications,
      required this.isWorkMode,
      super.key});

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  List<Event> _events = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Events")),
      ),
      body: FutureBuilder(
        future: widget.firestore
            .collection("events")
            .where("ownerId", isEqualTo: widget.firebaseAuth.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return const LoadingWidget();
          }

          _events = snapshot.data!.docs
              .map((e) => Event.fromQueryDocumentSnapshot(e))
              .toList();

          _events.sort((a, b) => a.date.compareTo(b.date));
          _events.removeWhere((a) => a.isWork != widget.isWorkMode);

          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemBuilder: (_, index) {
              Event event = _events[index];

              return ListTile(
                key: Key(event.id.toString()),
                title: Text(event.details),
                subtitle: Text(event.location),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        "${DateFormat.MMMd().format(event.date)} ${DateFormat.Hm().format(event.date)}"),
                    InkWell(
                      onDoubleTap: () {
                        widget.firestore
                            .collection("events")
                            .doc(event.id)
                            .delete();
                        setState(() {
                          _events.removeAt(index);
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          size: 30,
                          Icons.close,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext _, int __) => const Divider(),
            itemCount: _events.length,
          );
        },
      ),
    );
  }
}
