import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mclovin_life_manager/model/todo.dart';
import 'package:mclovin_life_manager/widgets/loading_widget.dart';
import 'package:mclovin_life_manager/widgets/todo_form_dialog.dart';

class TodoPage extends StatefulWidget {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  const TodoPage(
      {required FirebaseFirestore firestore,
      required FirebaseAuth firebaseAuth,
      Key? key})
      : _firebaseAuth = firebaseAuth,
        _firestore = firestore,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Todo> _todos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("TODO")),
        backgroundColor: Colors.pinkAccent,
      ),
      body: FutureBuilder(
        future: widget._firestore
            .collection("todos")
            .where("ownerId", isEqualTo: widget._firebaseAuth.currentUser!.uid)
            .get(),
        builder: (_, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return const LoadingWidget();
          }

          _todos = snapshot.data!.docs
              .map((e) => Todo.fromQueryDocumentSnapshot(e))
              .toList();

          _todos.sort((a, b) => a.dueDate.compareTo(b.dueDate));

          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemBuilder: (_, index) {
              Todo todo = _todos.elementAt(index);

              return ListTile(
                key: Key(todo.id.toString()),
                title: Text(todo.action),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(DateFormat.MMMd().format(todo.dueDate)),
                    InkWell(
                      onDoubleTap: () {
                        widget._firestore
                            .collection("todos")
                            .doc(todo.id)
                            .delete();
                        setState(() {
                          _todos.removeAt(index);
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          size: 30,
                          Icons.check,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: _todos.length,
            separatorBuilder: (BuildContext _, int __) => const Divider(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) => TodoFormDialog(
                  refreshTodos: () => setState(() {}),
                  firestore: widget._firestore,
                  firebaseAuth: widget._firebaseAuth,
                )),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
