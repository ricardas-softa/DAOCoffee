import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';

class DB {
  final _notifyRef = FirebaseDatabase.instance.ref('notifyMe');

  Future<void> notifyEntery(String email) async {
    var intValue = Random().nextInt(500000);
    await _notifyRef.update({intValue.toString(): email});
    return;
  }
}
