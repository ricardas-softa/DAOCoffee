import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DB  extends ChangeNotifier {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  // DB() {}

  Future<void> notifyEntery(String email) async {
    var intValue = Random().nextInt(500000);
    await _db.child('notifyMe').update({intValue.toString(): email});
    return;
  }
}
