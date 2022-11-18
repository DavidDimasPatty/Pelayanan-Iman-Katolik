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
      } else {
        return "failed";
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

  static findRekoleksi() async {
    var umumCollection = db.collection(UMUM_COLLECTION);
    var conn =
        await umumCollection.find({'jenisKegiatan': "Rekoleksi"}).toList();

    return conn;
  }

  static findRetret() async {
    var umumCollection = db.collection(UMUM_COLLECTION);
    var conn = await umumCollection.find({'jenisKegiatan': "Retret"}).toList();

    return conn;
  }

  static pemberkatanTerdaftar(idUser) async {
    var pemberkatanCollection = db.collection(PEMBERKATAN_COLLECTION);
    var conn = await pemberkatanCollection
        .find({'idUser': idUser, 'status': 0}).toList();
    print(conn);
    return conn;
  }

  static pemberkatanHistory(idUser) async {
    var pemberkatanCollection = db.collection(PEMBERKATAN_COLLECTION);
    var conn = await pemberkatanCollection.find({'idUser': idUser}).toList();
    print(conn);
    return conn;
  }

  static pemberkatanSpec(idPemberkatan) async {
    var pemberkatanCollection = db.collection(PEMBERKATAN_COLLECTION);
    var conn =
        await pemberkatanCollection.find({'_id': idPemberkatan}).toList();
    print(conn);
    return conn;
  }

  static findPA() async {
    var umumCollection = db.collection(UMUM_COLLECTION);
    var conn = await umumCollection
        .find({'jenisKegiatan': "Pendalaman Alkitab"}).toList();

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

  static findGerejaKrisma() async {
    var gerejaKrismaCollection = db.collection(KRISMA_COLLECTION);
    final pipeline = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'Gereja',
            localField: 'idGereja',
            foreignField: '_id',
            as: 'GerejaKrisma'))
        .build();
    var conn =
        await gerejaKrismaCollection.aggregateToStream(pipeline).toList();
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

  static detailGerejaKrisma(idGereja) async {
    var gerejaKrismaCollection = db.collection(GEREJA_COLLECTION);
    final pipeline = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'krisma',
            localField: '_id',
            foreignField: 'idGereja',
            as: 'GerejaKrisma'))
        .addStage(Match(where.eq('nama', idGereja).map['\$query']))
        .build();
    var conn =
        await gerejaKrismaCollection.aggregateToStream(pipeline).toList();
    print(conn);
    print(idGereja);
    return conn;
  }

  static countAllHistory(userId) async {
    var userKrismaCollection = db.collection(USER_KRISMA_COLLECTION);
    var userBaptisCollection = db.collection(USER_BAPTIS_COLLECTION);
    var userKomuniCollection = db.collection(USER_KOMUNI_COLLECTION);
    var userPemberkatanCollection = db.collection(PEMBERKATAN_COLLECTION);
    var userKegiatanCollection = db.collection(USER_UMUM_COLLECTION);
    var count = 0;

    var countKr = await userKrismaCollection.find({'idUser': userId}).length;

    var countB = await userBaptisCollection.find({'idUser': userId}).length;
    var countKo = await userKomuniCollection.find({'idUser': userId}).length;
    var countP =
        await userPemberkatanCollection.find({'idUser': userId}).length;
    var countKe = await userKegiatanCollection.find({'idUser': userId}).length;

    return countKr + countB + countKo + countP + countKe;
  }

  static latestJadwal(userId) async {
    print("masuk");
    var userKrismaCollection = db.collection(USER_KRISMA_COLLECTION);
    var userBaptisCollection = db.collection(USER_BAPTIS_COLLECTION);
    var userKomuniCollection = db.collection(USER_KOMUNI_COLLECTION);
    var userPemberkatanCollection = db.collection(PEMBERKATAN_COLLECTION);
    var userKegiatanCollection = db.collection(USER_UMUM_COLLECTION);
    var dateKri = await userKrismaCollection
        .find(where.eq("idUser", userId).sortBy('tanggalDaftar').limit(1))
        .toList();
    var dateBap = await userBaptisCollection
        .find(where.eq("idUser", userId).sortBy('tanggalDaftar').limit(1))
        .toList();
    var dateKom = await userKomuniCollection
        .find(where.eq("idUser", userId).sortBy('tanggalDaftar').limit(1))
        .toList();
    var datePem = await userPemberkatanCollection
        .find(where.eq("idUser", userId).sortBy('tanggal').limit(1))
        .toList();
    var dateKeg = await userKegiatanCollection
        .find(where.eq("idUser", userId).sortBy('tanggalDaftar').limit(1))
        .toList();

    var ans = DateTime.utc(1989, 11, 9);
    var hasil = [];

    if (ans.compareTo(DateTime.parse(dateKri[0]['tanggalDaftar'].toString())) <
        0) {
      ans = DateTime.parse(dateKri[0]['tanggalDaftar'].toString());
      hasil = dateKri;
      print(ans);
    }

    if (ans.compareTo(DateTime.parse(dateBap[0]['tanggalDaftar'].toString())) <
        0) {
      ans = DateTime.parse(dateBap[0]['tanggalDaftar'].toString());
      hasil = dateBap;
      print(ans);
    }

    if (ans.compareTo(DateTime.parse(dateKom[0]['tanggalDaftar'].toString())) <
        0) {
      ans = DateTime.parse(dateKom[0]['tanggalDaftar'].toString());
      hasil = dateKom;
      print(ans);
    }

    if (ans.compareTo(DateTime.parse(datePem[0]['tanggalDaftar'].toString())) <
        0) {
      ans = DateTime.parse(datePem[0]['tanggalDaftar'].toString());
      hasil = datePem;
      print(ans);
    }

    if (ans.compareTo(DateTime.parse(dateKeg[0]['tanggalDaftar'].toString())) <
        0) {
      ans = DateTime.parse(dateKeg[0]['tanggalDaftar'].toString());
      hasil = dateKeg;
      print(ans);
    }

    return hasil;
  }

  static detailRekoleksi(idKegiatan) async {
    print(idKegiatan);
    var gerejaKegiatanCollection = db.collection(UMUM_COLLECTION);
    final pipeline = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'Gereja',
            localField: 'idGereja',
            foreignField: '_id',
            as: 'GerejaKegiatan'))
        .addStage(Match(where.eq('_id', idKegiatan).map['\$query']))
        .build();
    var conn =
        await gerejaKegiatanCollection.aggregateToStream(pipeline).toList();

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

    return conn;
  }

  static krismaTerdaftar(idUser) async {
    var userKrismaCollection = db.collection(USER_KRISMA_COLLECTION);
    final pipeline = AggregationPipelineBuilder()
        .addStage(
          Lookup(
              from: 'krisma',
              localField: 'idKrisma',
              foreignField: '_id',
              as: 'UserKrisma'),
        )
        .addStage(
            Match(where.eq('idUser', idUser).eq('status', '0').map['\$query']))
        .build();
    var conn = await userKrismaCollection.aggregateToStream(pipeline).toList();

    return conn;
  }

  static krismaHistory(idUser) async {
    var userKrismaCollection = db.collection(USER_KRISMA_COLLECTION);
    final pipeline = AggregationPipelineBuilder()
        .addStage(
          Lookup(
              from: 'krisma',
              localField: 'idKrisma',
              foreignField: '_id',
              as: 'UserKrisma'),
        )
        .build();
    var conn = await userKrismaCollection.aggregateToStream(pipeline).toList();

    return conn;
  }

  static kegiatanTerdaftar(idUser) async {
    var userKegiatanCollection = db.collection(USER_UMUM_COLLECTION);
    final pipeline = AggregationPipelineBuilder()
        .addStage(
          Lookup(
              from: 'umum',
              localField: 'idKegiatan',
              foreignField: '_id',
              as: 'UserKegiatan'),
        )
        .addStage(
            Match(where.eq('idUser', idUser).eq('status', '0').map['\$query']))
        .build();
    var conn =
        await userKegiatanCollection.aggregateToStream(pipeline).toList();

    return conn;
  }

  static kegiatanHistory(idUser) async {
    var userKegiatanCollection = db.collection(USER_UMUM_COLLECTION);
    final pipeline = AggregationPipelineBuilder()
        .addStage(
          Lookup(
              from: 'umum',
              localField: 'idKegiatan',
              foreignField: '_id',
              as: 'UserKegiatan'),
        )
        .build();
    var conn =
        await userKegiatanCollection.aggregateToStream(pipeline).toList();

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

  static jadwalKrisma(idKrisma) async {
    var jadwalCollection = db.collection(KRISMA_COLLECTION);
    var conn = await jadwalCollection.find({'_id': idKrisma}).toList();
    return conn;
  }

  static jadwalKegiatan(idKegiatan) async {
    var jadwalCollection = db.collection(UMUM_COLLECTION);
    var conn = await jadwalCollection.find({'_id': idKegiatan}).toList();
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
    return conn;
  }

  static addPemberkatan(idUser, nama, paroki, lingkungan, notelp, alamat, jenis,
      tanggal, note) async {
    var pemberkatanCollection = db.collection(PEMBERKATAN_COLLECTION);
    var checkEmail;

    var hasil = await pemberkatanCollection.insertOne({
      'idUser': idUser,
      'namaLengkap': nama,
      'paroki': paroki,
      'lingkungan': lingkungan,
      'notelp': notelp,
      'alamat': alamat,
      'jenis': jenis,
      'tanggal': DateTime.parse(tanggal),
      'note': note,
      'status': 0
    });

    if (!hasil.isSuccess) {
      print('Error detected in record insertion');
      return 'fail';
    } else {
      return 'oke';
    }
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

  static daftarKrisma(idKrisma, idUser, kapasitas) async {
    var daftarKrismaCollection = db.collection(USER_KRISMA_COLLECTION);
    var komuniCollection = db.collection(KRISMA_COLLECTION);
    var hasil = await daftarKrismaCollection.insertOne({
      'idKrisma': idKrisma,
      'idUser': idUser,
      'status': "0",
      'tanggalDaftar': DateTime.now()
    });

    var update = await komuniCollection.updateOne(
        where.eq('_id', idKrisma), modify.set('kapasitas', kapasitas - 1));

    if (!hasil.isSuccess) {
      print('Error detected in record insertion');
      return 'fail';
    } else {
      return 'oke';
    }
  }

  static daftarKegiatan(idKegiatan, idUser, kapasitas) async {
    var daftarUmumCollection = db.collection(USER_UMUM_COLLECTION);
    var umumCollection = db.collection(UMUM_COLLECTION);
    var hasil = await daftarUmumCollection.insertOne({
      'idKegiatan': idKegiatan,
      'idUser': idUser,
      'tanggalDaftar': DateTime.now(),
      'status': "0"
    });

    var update = await umumCollection.updateOne(
        where.eq('_id', idKegiatan), modify.set('kapasitas', kapasitas - 1));

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

  static cancelPemberkatan(idTiket) async {
    var tiket = db.collection(PEMBERKATAN_COLLECTION);
    var conn = await tiket.updateOne(
        where.eq('_id', idTiket), modify.set('status', "-2"));
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

  static cancelDaftarKrisma(idTiket) async {
    var tiket = db.collection(USER_KRISMA_COLLECTION);
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

  static cancelDaftarKegiatan(idTiket) async {
    var tiket = db.collection(USER_UMUM_COLLECTION);
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
