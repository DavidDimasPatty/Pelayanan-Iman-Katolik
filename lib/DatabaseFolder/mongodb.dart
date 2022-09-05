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

  static getDataUser(id) async {
    userCollection = db.collection(USER_COLLECTION);
    var conn = await userCollection.find({'_id': id}).toList();
    try {
      if (conn[0]['id'] != "") {
        return conn;
      }
    } catch (e) {
      return "failed";
    }
  }

  static totalGereja(id) async {
    var jadwalCollection = db.collection(TIKET_COLLECTION);
    var conn = await jadwalCollection.find({'idUser': id}).length;

    return conn;
  }

  static findGereja() async {
    var gerejaCollection = db.collection(GEREJA_COLLECTION);
    var conn = await gerejaCollection.find().toList();
    return conn;
  }

  static findGerejaKomuni() async {
    var gerejaKomuniCollection = db.collection(KOMUNI_COLLECTION);
    final pipeline = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'Gereja',
            localField: 'idGereja',
            foreignField: '_id',
            as: 'GerejaKomuni'))
        .build();
    var conn =
        await gerejaKomuniCollection.aggregateToStream(pipeline).toList();
    print(conn);
    return conn;
  }

  static findGerejaBaptis() async {
    var gerejaKomuniCollection = db.collection(BAPTIS_COLLECTION);
    final pipeline = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'Gereja',
            localField: 'idGereja',
            foreignField: '_id',
            as: 'GerejaBaptis'))
        .build();
    var conn =
        await gerejaKomuniCollection.aggregateToStream(pipeline).toList();
    print(conn);
    return conn;
  }

  static detailGerejaBaptis(idGereja) async {
    var gerejaBaptisCollection = db.collection(GEREJA_COLLECTION);
    final pipeline = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'baptis',
            localField: '_id',
            foreignField: 'idGereja',
            as: 'GerejaBaptis'))
        .addStage(Match(where.eq('nama', idGereja).map['\$query']))
        .build();
    var conn =
        await gerejaBaptisCollection.aggregateToStream(pipeline).toList();
    print(conn);
    print(idGereja);
    return conn;
  }

  static baptisTerdaftar(idUser) async {
    var userBaptisCollection = db.collection(USER_BAPTIS_COLLECTION);
    final pipeline = AggregationPipelineBuilder()
        .addStage(
          Lookup(
              from: 'baptis',
              localField: 'idBaptis',
              foreignField: '_id',
              as: 'UserBaptis'),
        )
        .addStage(
            Match(where.eq('idUser', idUser).eq('status', '0').map['\$query']))
        .build();
    var conn = await userBaptisCollection.aggregateToStream(pipeline).toList();
    print(conn);
    return conn;
  }

  static komuniTerdaftar(idUser) async {
    var userBaptisCollection = db.collection(USER_KOMUNI_COLLECTION);
    final pipeline = AggregationPipelineBuilder()
        .addStage(
          Lookup(
              from: 'komuni',
              localField: 'idKomuni',
              foreignField: '_id',
              as: 'UserKomuni'),
        )
        .addStage(
            Match(where.eq('idUser', idUser).eq('status', '0').map['\$query']))
        .build();
    var conn = await userBaptisCollection.aggregateToStream(pipeline).toList();
    print(conn);
    return conn;
  }

  static baptisHistory(idUser) async {
    var userBaptisCollection = db.collection(USER_BAPTIS_COLLECTION);
    final pipeline = AggregationPipelineBuilder()
        .addStage(
          Lookup(
              from: 'baptis',
              localField: 'idBaptis',
              foreignField: '_id',
              as: 'UserBaptis'),
        )
        .addStage(Match(where.eq('idUser', idUser).map['\$query']))
        .build();
    var conn = await userBaptisCollection.aggregateToStream(pipeline).toList();

    return conn;
  }

  static komuniHistory(idUser) async {
    var userBaptisCollection = db.collection(USER_KOMUNI_COLLECTION);
    final pipeline = AggregationPipelineBuilder()
        .addStage(
          Lookup(
              from: 'komuni',
              localField: 'idKomuni',
              foreignField: '_id',
              as: 'UserKomuni'),
        )
        .addStage(Match(where.eq('idUser', idUser).map['\$query']))
        .build();
    var conn = await userBaptisCollection.aggregateToStream(pipeline).toList();
    print(conn);
    return conn;
  }

  static detailGerejaKomuni(idGereja) async {
    var gerejaKomuniCollection = db.collection(GEREJA_COLLECTION);
    final pipeline = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'komuni',
            localField: '_id',
            foreignField: 'idGereja',
            as: 'GerejaKomuni'))
        .addStage(Match(where.eq('nama', idGereja).map['\$query']))
        .build();
    var conn =
        await gerejaKomuniCollection.aggregateToStream(pipeline).toList();
    print(conn);
    print(idGereja);
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
    var conn =
        await jadwalCollection.find({'idUser': idUser, 'status': "0"}).toList();
    return conn;
  }

  static jadwalHistory(idUser) async {
    var jadwalCollection = db.collection(TIKET_COLLECTION);
    var conn = await jadwalCollection.find({'idUser': idUser}).toList();
    return conn;
  }

  static jadwalMisaku(idMisa) async {
    var jadwalCollection = db.collection(JADWAL_GEREJA_COLLECTION);
    var conn = await jadwalCollection.find({'_id': idMisa}).toList();
    return conn;
  }

  static jadwalBaptis(idBaptis) async {
    var jadwalCollection = db.collection(BAPTIS_COLLECTION);
    var conn = await jadwalCollection.find({'_id': idBaptis}).toList();
    return conn;
  }

  static jadwalKomuni(idKomuni) async {
    print(idKomuni);
    var jadwalCollection = db.collection(KOMUNI_COLLECTION);
    var conn = await jadwalCollection.find({'_id': idKomuni}).toList();
    return conn;
  }

  static cariGereja(idGereja) async {
    var jadwalCollection = db.collection(GEREJA_COLLECTION);
    var conn = await jadwalCollection.find({'_id': idGereja}).toList();
    print(conn);
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
        var hasil = await userCollection.insertOne({
          'name': nama,
          'email': email,
          'password': password,
          'picture': "",
          "banned": 0,
          "notifGD": false,
          "notifPG": false,
          "tanggalDaftar": DateTime.now()
        });
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

  static daftarMisa(idMisa, idUser, kapasitas) async {
    var tiketCollection = db.collection(TIKET_COLLECTION);
    var jadwalCollection = db.collection(JADWAL_GEREJA_COLLECTION);
    var hasil = await tiketCollection
        .insertOne({'idMisa': idMisa, 'idUser': idUser, 'status': "0"});
    var update = await jadwalCollection.updateOne(
        where.eq('_id', idMisa), modify.set('KapasitasJadwal', kapasitas - 1));

    if (!hasil.isSuccess) {
      print('Error detected in record insertion');
      return 'fail';
    } else {
      return 'oke';
    }
  }

  static daftarKomuni(idKomuni, idUser, kapasitas) async {
    var daftarKomuniCollection = db.collection(USER_KOMUNI_COLLECTION);
    var komuniCollection = db.collection(KOMUNI_COLLECTION);
    var hasil = await daftarKomuniCollection
        .insertOne({'idKomuni': idKomuni, 'idUser': idUser, 'status': "0"});

    var update = await komuniCollection.updateOne(
        where.eq('_id', idKomuni), modify.set('kapasitas', kapasitas - 1));

    if (!hasil.isSuccess) {
      print('Error detected in record insertion');
      return 'fail';
    } else {
      return 'oke';
    }
  }

  static daftarBaptis(idBaptis, idUser, kapasitas) async {
    var daftarBaptisCollection = db.collection(USER_BAPTIS_COLLECTION);
    var baptisCollection = db.collection(BAPTIS_COLLECTION);
    var hasil = await daftarBaptisCollection
        .insertOne({'idBaptis': idBaptis, 'idUser': idUser, 'status': "0"});

    var update = await baptisCollection.updateOne(
        where.eq('_id', idBaptis), modify.set('kapasitas', kapasitas - 1));

    if (!hasil.isSuccess) {
      print('Error detected in record insertion');
      return 'fail';
    } else {
      return 'oke';
    }
  }

  static updateProfilePicture(id, path) async {
    userCollection = db.collection(USER_COLLECTION);
    var conn = await userCollection.updateOne(
        where.eq('_id', id), modify.set('picture', path));
    if (conn.isSuccess) {
      return "oke";
    } else {
      return "failed";
    }
  }

  static findPassword(email, pass) async {
    userCollection = db.collection(USER_COLLECTION);
    var conn =
        await userCollection.find({'email': email, 'password': pass}).toList();
    try {
      print(conn[0]['_id']);
      if (conn[0]['_id'] == null) {
        return "not";
      } else {
        return "found";
      }
    } catch (e) {
      return "failed";
    }
  }

  static updatePassword(id, pass) async {
    userCollection = db.collection(USER_COLLECTION);
    var conn = await userCollection.updateOne(
        where.eq('_id', id), modify.set('password', pass));
    if (conn.isSuccess) {
      return "oke";
    } else {
      return "failed";
    }
  }

  static cancelDaftar(idTiket) async {
    var tiket = db.collection(TIKET_COLLECTION);
    var conn = await tiket.updateOne(
        where.eq('_id', idTiket), modify.set('status', "-1"));
    if (conn.isSuccess) {
      return "oke";
    } else {
      return "failed";
    }
  }

  static cancelDaftarBaptis(idTiket) async {
    var tiket = db.collection(USER_BAPTIS_COLLECTION);
    var conn = await tiket.updateOne(
        where.eq('_id', idTiket), modify.set('status', "-1"));
    if (conn.isSuccess) {
      return "oke";
    } else {
      return "failed";
    }
  }

  static cancelDaftarKomuni(idTiket) async {
    var tiket = db.collection(USER_KOMUNI_COLLECTION);
    var conn = await tiket.updateOne(
        where.eq('_id', idTiket), modify.set('status', "-1"));
    if (conn.isSuccess) {
      return "oke";
    } else {
      return "failed";
    }
  }

  static updateNotifPg(id, notifPg) async {
    userCollection = db.collection(USER_COLLECTION);
    var conn = await userCollection.updateOne(
        where.eq('_id', id), modify.set('notifPG', notifPg));
    if (conn.isSuccess) {
      return "oke";
    } else {
      return "failed";
    }
  }

  static updateNotifGd(id, notifGd) async {
    userCollection = db.collection(USER_COLLECTION);
    var conn = await userCollection.updateOne(
        where.eq('_id', id), modify.set('notifGD', notifGd));
    if (conn.isSuccess) {
      return "oke";
    } else {
      return "failed";
    }
  }

  static jadwalTerakhir(idUser) async {
    var jadwalgerejaCollection = db.collection(JADWAL_GEREJA_COLLECTION);
    var gerejaCollection = db.collection(GEREJA_COLLECTION);
    var jadwalCollection = db.collection(TIKET_COLLECTION);
    var conn1 = await jadwalCollection
        .find({'idUser': idUser})
        .toList()
        .then((data) async {
          var conn2 = await jadwalgerejaCollection
              .find({'_id': data[0]['idMisa']})
              .toList()
              .then((data2) async {
                var conn3 = await gerejaCollection
                    .find({'_id': data2[0]['idGereja']})
                    .toList()
                    .then((data3) {
                      return data2;
                    });
              });
        });
  }
}
