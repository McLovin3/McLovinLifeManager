import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BirthdayFormDialog extends StatefulWidget {
  final Function refreshBirthdays;
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  const BirthdayFormDialog(
      {required this.refreshBirthdays,
      required this.firestore,
      required this.firebaseAuth,
      Key? key})
      : super(key: key);

  @override
  State<BirthdayFormDialog> createState() => _BirthdayFormDialogState();
}

class _BirthdayFormDialogState extends State<BirthdayFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    _dateController.text = DateTime.now().toString().split(" ")[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(child: Text("Add a Birthday")),
      contentPadding: const EdgeInsets.all(15),
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: const Key("name"),
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: "Name",
                ),
                controller: _nameController,
                autofocus: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a name";
                  }
                  return null;
                },
              ),
              TextFormField(
                key: const Key("date"),
                readOnly: true,
                controller: _dateController,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    _dateController.text = date.toString().split(" ")[0];
                  }
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.firestore.collection("birthdays").add({
                        "name": _nameController.text,
                        "date": _dateController.text,
                        "ownerId": widget.firebaseAuth.currentUser!.uid,
                      });
                      widget.refreshBirthdays();
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
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}
