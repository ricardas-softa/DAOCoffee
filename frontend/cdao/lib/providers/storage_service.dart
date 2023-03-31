import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageService {
  StorageService();
  final _storage = FirebaseStorage.instance; 

  Future<String> getDownloadURL({required String fileName}) async {
    var ref = _storage.ref().child("$fileName");
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
