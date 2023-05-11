import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageService {
  StorageService();
  final _storage = FirebaseStorage.instance;

  Future<List<String>> getCaresoleDownloadURLs(
      {required String farmName}) async {
    List<String> urlList = [];
    final storageRef = _storage.ref().child("farms/$farmName/carousel");
    final listResult = await storageRef.listAll();

    for (var prefix in listResult.prefixes) {
      print('4444444444 prefix $prefix');
      // The prefixes under storageRef.
      // You can call listAll() recursively on them.
    }

    for (Reference item in listResult.items) {
      urlList.add(await _storage.ref().child(item.fullPath).getDownloadURL());
    }
    return urlList;
  }

  Future<String> getHeaderDownloadURLs({required String farmName}) async {
    var ref = _storage.ref().child("farms/$farmName/carousel/header.png");
    String url = await ref.getDownloadURL();
    return url;
  }

  Future<String> getNFTDownloadURLs({required String gs}) async {
    String url = await _storage.ref().child(gs.substring(28)).getDownloadURL();
    return url;
  }
}
