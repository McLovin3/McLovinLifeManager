import 'package:cloud_firestore/cloud_firestore.dart';

class ItemList {
  String id;
  String ownerId;
  String title;
  List<String> items;

  ItemList(
    this.id,
    this.ownerId,
    this.title,
    this.items,
  );

  static ItemList fromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> json) {
    return ItemList(
      json.id,
      json.data()["ownerId"],
      json.data()["title"],
      (json.data()["items"] as List).map((e) => e as String).toList(),
    );
  }
}
