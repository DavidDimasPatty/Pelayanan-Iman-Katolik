import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import './data.dart';

class MongoDatabase {
  static var db;

  static connect() async {
    String connection = MONGO_CONN_URL!;
    db = await Db.create(connection);
    await db.open();
    inspect(db);
  }
}
