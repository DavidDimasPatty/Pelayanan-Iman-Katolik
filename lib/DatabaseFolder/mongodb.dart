import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import './data.dart';

///Kelas untuk koneksi pada database sehingga koneksinya terbuka
class MongoDatabase {
  static var db;

  static Future<void> connect() async {
    //Fungsi koneksi database
    try {
      String connection =
          MONGO_CONN_URL!; //variabel diisi dengan data pada kelas data (tanda seru dijamin isi variabel tidak null)
      db = await Db.create(
          connection); //Melakukan koneksi dengan database GerejaDB dengan parameter key
      await db.open(); //Membuka koneksi dengan database GerejaDB
      inspect(db); //Menampilkan properti koneksi dengan database

      print("DB initialized successfully");
    } catch (e) {
      //jika koneksi gagal
      print("Error connecting to MongoDB: $e");
    }
  }
}
