import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import './data.dart';

class MongoDatabase {
  static var db, userCollection;

  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    inspect(db);
    userCollection = db.collection(USER_COLLECTION);
    var cob = await userCollection.find().toList();
    print(cob);
    //print(userCollection);
    inspect(userCollection);
  }

  static showUser() async {
    var coll = db.collection('user');
    await coll();
    print(coll);
  }
}
