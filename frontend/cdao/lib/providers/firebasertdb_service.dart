import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/nftsModel.dart';

class DB extends ChangeNotifier {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  late StreamSubscription<DatabaseEvent> dblistStream;
  List<NftsModel>? _nftlist;
  List<NftsModel>? get nftlist => _nftlist;

  DB() {
    _listenToNfts();
  }

  void _listenToNfts() {
    dblistStream = _db
        .child('nft')
        .orderByChild("available")
        .equalTo(true)
        .onValue
        .listen((event) {
      try {
        List<NftsModel>? list = [];
        Map<dynamic, dynamic> values =
            event.snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, data) {
          list.add(NftsModel.fromRTDB(data));
        });
        _nftlist = list;
        notifyListeners();
      } catch (e) {
        print('_listenToNfts error $e');
      }
    });
  }

  Future<NftsModel> getNft() async {
    late NftsModel nftm;
    // late String nftm;
    print('getNFT service');
    await _db
        .child('nft')
        .orderByChild("available")
        .equalTo(true)
        .limitToFirst(1)
        .once()
        .then((value) {
      try {
        Map<dynamic, dynamic> values =
            value.snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, data) {
          nftm = NftsModel.fromRTDB(data);
        });
        return nftm;
      } catch (e) {
        print('9999999999999999 getNft() try catch error $e');
      }
    }).onError((error, stackTrace) {
      print('9999999999999999999999 getNft error $error ');
      throw 'getNft error $error';
    });
    return nftm;
  }

  Future<void> updateNft(nftId) async {
    await _db.update({
      'totalMinted': ServerValue.increment(1),
    }).onError((error, stackTrace) => print(
        '9999999999999999999999 updateNft update({totalMinted error $error '));

    final event = await _db.child('nft').child(nftId).update({
      'available': false
    }).onError((error, stackTrace) => print(
        '9999999999999999999999 updateNft update({available) error $error '));
    return;
  }

  Future<int> getMinted() async {
    final snapshot =
        await _db.child('totalMinted').get().onError((error, stackTrace) {
      print('9999999999999999999999 getMinted error $error ');
      throw 'getMinted error $error';
    });
    if (snapshot.exists) {
      return snapshot.value as int;
    } else {
      print('55555555555555 getMinted No data available.');
      return -1;
    }
  }

  Future<void> notifyEntery(String email) async {
    var intValue = Random().nextInt(500000);
    await _db.child('notifyMe').update({intValue.toString(): email}).onError(
        (error, stackTrace) =>
            print('9999999999999999999999 notifyEntery error $error '));
    return;
  }

  @override
  void dispose() {
    dblistStream.cancel();
    super.dispose();
  }
}
