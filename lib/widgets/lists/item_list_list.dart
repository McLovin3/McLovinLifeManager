import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/item_list.dart';
import '../../widgets/other/loading_widget.dart';
import '../forms/text_input_dialog.dart';

class ItemListList extends StatefulWidget {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  const ItemListList(
      {required this.firestore, required this.firebaseAuth, Key? key})
      : super(key: key);

  @override
  State<ItemListList> createState() => _ItemListListState();
}

class _ItemListListState extends State<ItemListList> {
  List<ItemList> _itemLists = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Lists")),
      ),
      body: FutureBuilder(
        future: widget.firestore
            .collection("itemlists")
            .where("ownerId", isEqualTo: widget.firebaseAuth.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return const LoadingWidget();
          }

          _itemLists = snapshot.data!.docs
              .map((e) => ItemList.fromQueryDocumentSnapshot(e))
              .toList();

          return ListView.separated(
              padding: const EdgeInsets.all(8),
              itemBuilder: (_, index) {
                ItemList itemList = _itemLists[index];

                return ListTile(
                  key: Key(itemList.id.toString()),
                  title: Text(itemList.title),
                  onTap: () {
                    Navigator.pushNamed(context, "/list", arguments: itemList);
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onDoubleTap: () {
                          widget.firestore
                              .collection("itemlists")
                              .doc(itemList.id)
                              .delete();
                          setState(() {
                            _itemLists.removeAt(index);
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
              itemCount: _itemLists.length);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => TextInputDialog(
            hintText: "Name",
            onSubmit: (String text) {
              widget.firestore.collection("itemlists").add({
                "title": text,
                "ownerId": widget.firebaseAuth.currentUser!.uid,
                "items": []
              });
              setState(() => {});
            },
            title: "Add a new list",
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
