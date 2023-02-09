import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mclovin_life_manager/model/todo.dart';

class TodoFormDialog extends StatefulWidget {
  final Function refreshTodos;

  const TodoFormDialog(this.refreshTodos, {super.key});

  @override
  State<TodoFormDialog> createState() => _TodoFormDialogState();
}

class _TodoFormDialogState extends State<TodoFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _actionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  @override
  void initState() {
    _dueDateController.text = DateTime.now().toString().split(" ")[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(child: Text("Add a todo")),
      contentPadding: const EdgeInsets.all(15),
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: "Todo",
                ),
                controller: _actionController,
                autofocus: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter something to do";
                  }
                  return null;
                },
              ),
              TextFormField(
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: "Due date",
                ),
                controller: _dueDateController,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    _dueDateController.text = date.toString().split(" ")[0];
                  }
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      FirebaseFirestore.instance.collection("todos").add({
                        "action": _actionController.text,
                        "dueDate": _dueDateController.text,
                        "ownerId": FirebaseAuth.instance.currentUser!.uid,
                        "isWork": false,
                      });
                      widget.refreshTodos();
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
    _actionController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }
}
