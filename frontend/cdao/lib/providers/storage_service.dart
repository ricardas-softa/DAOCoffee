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
    print('4444444444 listResult ${listResult.toString()}');

    for (var prefix in listResult.prefixes) {
      print('4444444444 prefix $prefix');
      // The prefixes under storageRef.
      // You can call listAll() recursively on them.
    }

    for (Reference item in listResult.items) {
      print('4444444444 item ${item.fullPath}');
      urlList.add(await _storage.ref().child(item.fullPath).getDownloadURL());
    }
    return urlList;
  }

  Future<String> getHeaderDownloadURLs({required String farmName}) async {
    var ref = _storage.ref().child("farms/$farmName/carousel/header.png");
    String url = await ref.getDownloadURL();
    return url;
  }

  //1 signIn
  Future<String> downloadFromStorageToFile(
      {required String path, required String fileName}) async {
    final pathReference = _storage.refFromURL(path);
    final io.Directory systemTempDir = io.Directory.systemTemp;
    final io.File tempFile = io.File('${systemTempDir.path}/$fileName');
    final bool fileExsist = await tempFile.exists();
    try {
      if (fileExsist) {
        tempFile.delete();
      }

      final downloadTask = pathReference.writeToFile(tempFile);
      downloadTask.snapshotEvents.listen((taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            // TODO: Handle this case.
            break;
          case TaskState.paused:
            // TODO: Handle this case.
            break;
          case TaskState.success:
            // debugPrint('*****************Storage download success: $taskSnapshot');
            break;
          case TaskState.canceled:
            // TODO: Handle this case.
            break;
          case TaskState.error:
            debugPrint(
                '*****************Storage download error: $taskSnapshot');
            break;
        }
      });
    } catch (e) {
      debugPrint('***********************Storage Download e $e');
    }
    return 'sucsess';
  }
}
