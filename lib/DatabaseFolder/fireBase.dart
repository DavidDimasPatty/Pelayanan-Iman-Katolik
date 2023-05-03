import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
//Kelas untuk penguploadan file di Firebase

  static UploadTask? uploadFile(String destination, File file) {
    //Fungsi untuk upload File
    try {
      final ref = FirebaseStorage.instance
          .ref(destination); // Inisialisasi tempat penyimpanan
      return ref.putFile(
          file); // Fungsi putFile untuk proses upload file, yang tersedia pada paket Firebase
    } on FirebaseException catch (e) {
      //Jika proses upload gagal atau tidak ketemu destinasi penyimpanannya
      return null;
    }
  }

  static Future configureUpload(String dest, File file) async {
    //Fungsi untuk mengatur nama penyimpanan
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    final filename = date
        .toString(); //nama file akan disimpan berdasarkan waktu proses upload file
    final String destination =
        dest + filename; //menyatukan destinasi penyimpanan dengan nama file
    UploadTask? task = FirebaseApi.uploadFile(
        destination, file); //Memanggil fungsi upload file untuk proses upload
    final snapshot = await task!.whenComplete(
        () {}); //hasil data proses upload disimpan pada variabel snapshot
    final String urlDownload = await snapshot.ref
        .getDownloadURL(); // mendapatkan data url file untuk mengakses file
    return urlDownload; // mengembalikan url file
  }
}
