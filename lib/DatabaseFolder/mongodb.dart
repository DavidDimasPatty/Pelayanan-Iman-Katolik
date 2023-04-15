import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import './data.dart';

class MongoDatabase {
  static var db;

  static Future<void> connect() async {
    try {
      String connection = MONGO_CONN_URL!;
      db = await Db.create(connection);
      await db.open();
      inspect(db);

      print("DB initialized successfully");
    } catch (e) {
      print("Error connecting to MongoDB: $e");
    }
  }
}
