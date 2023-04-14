import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventFormDialog extends StatefulWidget {
  final Function refreshEvents;
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final bool isWorkMode;

  const EventFormDialog({
    required this.refreshEvents,
    required this.firebaseAuth,
    required this.firestore,
    required this.isWorkMode,
    super.key,
  });

  @override
  State<EventFormDialog> createState() => _EventFormDialogState();
}

class _EventFormDialogState extends State<EventFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final currentDateTime = DateTime.now();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    _dateController.text = currentDateTime.toString().split(" ")[0];
    _timeController.text = DateFormat.Hm().format(currentDateTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(child: Text("Add an Event")),
      contentPadding: const EdgeInsets.all(15),
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: const Key("Details"),
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: "Details",
                ),
                controller: _detailsController,
                autofocus: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter event details";
                  }
                  return null;
                },
              ),
              TextFormField(
                key: const Key("Location"),
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: "Location",
                ),
                controller: _locationController,
              ),
              TextFormField(
                key: const Key("date"),
                readOnly: true,
                controller: _dateController,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: currentDateTime,
                      firstDate: currentDateTime,
                      lastDate: DateTime(2100));
                  if (date != null) {
                    _dateController.text = date.toString().split(" ")[0];
                  }
                },
              ),
              TextFormField(
                key: const Key("time"),
                readOnly: true,
                controller: _timeController,
                onTap: () async {
                  TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    if (time.minute < 10) {
                      _timeController.text = "${time.hour}:0${time.minute}";
                    } else {
                      _timeController.text = "${time.hour}:${time.minute}";
                    }
                  }
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.firestore.collection("events").add({
                        "details": _detailsController.text,
                        "date":
                            "${_dateController.text} ${_timeController.text}",
                        "location": _locationController.text,
                        "isWork": widget.isWorkMode,
                        "ownerId": widget.firebaseAuth.currentUser!.uid,
                      });
                      widget.refreshEvents();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Confirm"))
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _detailsController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }
}
