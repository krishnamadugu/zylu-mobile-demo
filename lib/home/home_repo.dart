import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class HomeRepository {
  static Future<DataSnapshot?> getData() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.get();

    if (snapshot.exists) {
      debugPrint(snapshot.value.toString());
      return snapshot;
    } else {
      debugPrint('No data available.');
      return null;
    }
  }
}
