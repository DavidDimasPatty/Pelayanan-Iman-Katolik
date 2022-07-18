import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import './data.dart';

class MongoDatabase {
  static var db, userCollection;

  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    inspect(db);
  }

  static findUser(email, password) async {
    userCollection = db.collection(USER_COLLECTION);
    var conn = await userCollection
        .find({'email': email, 'password': password}).toList();
    try {
      print(conn[0]);
      if (conn[0]['id'] != "") {
        return conn;
      }
    } catch (e) {
      return "failed";
    }
  }

  static findGereja() async {
    var gerejaCollection = db.collection(GEREJA_COLLECTION);
    var conn = await gerejaCollection.find().toList();
    return conn;
  }

  static detailGereja(namaGereja) async {
    var gerejaCollection = db.collection(GEREJA_COLLECTION);
    var conn = await gerejaCollection.find({'nama': namaGereja}).toList();
    return conn;
  }

  static jadwalGereja(idGereja) async {
    var jadwalCollection = db.collection(JADWAL_GEREJA_COLLECTION);
    var conn = await jadwalCollection.find({'idGereja': idGereja}).toList();
    return conn;
  }

  static jadwalku(idUser) async {
    var jadwalCollection = db.collection(TIKET_COLLECTION);
    var conn = await jadwalCollection.find({'idUser': idUser}).toList();
    return conn;
  }

  static jadwalMisaku(idMisa) async {
    var jadwalCollection = db.collection(JADWAL_GEREJA_COLLECTION);
    var conn = await jadwalCollection.find({'_id': idMisa}).toList();
    return conn;
  }

  static cariGereja(idGereja) async {
    var jadwalCollection = db.collection(GEREJA_COLLECTION);
    var conn = await jadwalCollection.find({'_id': idGereja}).toList();
    return conn;
  }

  static addUser(nama, email, password) async {
    userCollection = db.collection(USER_COLLECTION);
    var checkEmail;
    var checkName;
    await userCollection.find({'name': nama}).toList().then((res) async {
          checkName = res;
          checkEmail = await userCollection.find({'email': email}).toList();
        });

    print("checkemail: " + checkEmail.toString());
    print("checknama: " + checkName.toString());
    try {
      if (checkName.length > 0) {
        return "nama";
      }
      if (checkEmail.length > 0) {
        print("MASUKKKK");
        return "email";
      }
      if (checkName.length == 0 && checkEmail.length == 0) {
        var hasil = await userCollection
            .insertOne({'name': nama, 'email': email, 'password': password});
        if (!hasil.isSuccess) {
          print('Error detected in record insertion');
          return 'fail';
        } else {
          return 'oke';
        }
      }
    } catch (e) {
      return 'failed';
    }
  }
}
