import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static Future configureUpload(String dest, File file) async {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    final filename = date.toString();
    final String destination = dest + filename;
    UploadTask? task = FirebaseApi.uploadFile(destination, file);
    final snapshot = await task!.whenComplete(() {});
    final String urlDownload = await snapshot.ref.getDownloadURL();
    return urlDownload;
  }
}
