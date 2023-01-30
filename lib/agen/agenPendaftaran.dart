import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/data.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';

import 'messages.dart';

class AgenPendaftaran {
  AgenPendaftaran() {
    ReadyBehaviour();
    ResponsBehaviour();
  }

  ResponsBehaviour() {
    Messages msg = Messages();

    var data = msg.receive();
    action() async {
      try {
        if (data.runtimeType == List<List<dynamic>>) {
          if (data[0][0] == "add Pemberkatan") {
            try {
              var pemberkatanCollection =
                  MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
              var checkEmail;

              var hasil = await pemberkatanCollection.insertOne({
                'idUser': data[1][0],
                'namaLengkap': data[2][0],
                'paroki': data[3][0],
                'lingkungan': data[4][0],
                'notelp': data[5][0],
                'alamat': data[6][0],
                'jenis': data[7][0],
                'tanggal': DateTime.parse(data[8][0]),
                'note': data[9][0],
                'idGereja': data[10][0],
                'idImam': data[11][0],
                'status': 0
              }).then((result) async {
                msg.addReceiver("agenPage");
                msg.setContent("oke");
                await msg.send();
              });
            } catch (e) {
              msg.addReceiver("agenPage");
              msg.setContent("failed");
              await msg.send();
            }
          }

          if (data[0][0] == "enroll Baptis") {
            var daftarBaptisCollection =
                MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
            var hasilFind = await daftarBaptisCollection
                .find(
                    {'idBaptis': data[1][0], 'idUser': data[2][0], 'status': 0})
                .length
                .then((res) async {
                  print("nawww");
                  print(res.runtimeType);
                  if (res == 0) {
                    var daftarBaptisCollection =
                        MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
                    var baptisCollection =
                        MongoDatabase.db.collection(BAPTIS_COLLECTION);
                    var hasil = await daftarBaptisCollection.insertOne({
                      'idBaptis': data[1][0],
                      'idUser': data[2][0],
                      "tanggalDaftar": DateTime.now(),
                      'status': 0
                    });

                    var update = await baptisCollection
                        .updateOne(where.eq('_id', data[1][0]),
                            modify.set('kapasitas', data[3][0] - 1))
                        .then((result) async {
                      msg.addReceiver("agenPage");
                      msg.setContent("oke");
                      await msg.send();
                    });
                  }
                  if (res > 0) {
                    print("????");
                    msg.addReceiver("agenPage");
                    msg.setContent("sudah");
                    await msg.send();
                  }
                });
          }

          if (data[0][0] == "cancel Baptis") {
            try {
              var baptisCollection =
                  MongoDatabase.db.collection(BAPTIS_COLLECTION);
              var tiket = MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
              var conn = await tiket.updateOne(
                  where.eq('_id', data[1][0]), modify.set('status', -1));

              var update = await baptisCollection
                  .updateOne(where.eq('_id', data[2][0]),
                      modify.set('kapasitas', data[3][0] + 1))
                  .then((result) async {
                msg.addReceiver("agenPage");
                msg.setContent("oke");
                await msg.send();
              });
            } catch (e) {
              msg.addReceiver("agenPage");
              msg.setContent("failed");
              await msg.send();
            }
          }

          if (data[0][0] == "enroll Komuni") {
            var daftarKomuniCollection =
                MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
            var hasilFind = await daftarKomuniCollection.find({
              'idKomuni': data[1][0],
              'idUser': data[2][0],
              'status': 0
            }).length;
            print(hasilFind);
            if (hasilFind == 0) {
              try {
                var daftarKomuniCollection =
                    MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
                var komuniCollection =
                    MongoDatabase.db.collection(KOMUNI_COLLECTION);
                var hasil = await daftarKomuniCollection.insertOne({
                  'idKomuni': data[1][0],
                  'idUser': data[2][0],
                  "tanggalDaftar": DateTime.now(),
                  'status': 0
                });

                var update = await komuniCollection
                    .updateOne(where.eq('_id', data[1][0]),
                        modify.set('kapasitas', data[3][0] - 1))
                    .then((result) async {
                  msg.addReceiver("agenPage");
                  msg.setContent("oke");
                  await msg.send();
                });
              } catch (e) {
                msg.addReceiver("agenPage");
                msg.setContent("failed");
                await msg.send();
              }
            } else {
              msg.addReceiver("agenPage");
              msg.setContent("sudah");
              await msg.send();
            }
          }

          if (data[0][0] == "cancel Komuni") {
            try {
              var baptisCollection =
                  MongoDatabase.db.collection(KOMUNI_COLLECTION);
              var tiket = MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
              var conn = await tiket.updateOne(
                  where.eq('_id', data[1][0]), modify.set('status', -1));

              var update = await baptisCollection
                  .updateOne(where.eq('_id', data[2][0]),
                      modify.set('kapasitas', data[3][0] + 1))
                  .then((result) async {
                msg.addReceiver("agenPage");
                msg.setContent("oke");
                await msg.send();
              });
            } catch (e) {
              msg.addReceiver("agenPage");
              msg.setContent("failed");
              await msg.send();
            }
          }

          if (data[0][0] == "enroll Krisma") {
            var daftarKrismaCollection =
                MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
            var hasilFind = await daftarKrismaCollection.find({
              'idKrisma': data[1][0],
              'idUser': data[2][0],
              'status': 0
            }).length;
            print(hasilFind);
            if (hasilFind == 0) {
              try {
                var daftarKrismaCollection =
                    MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
                var komuniCollection =
                    MongoDatabase.db.collection(KRISMA_COLLECTION);
                var hasil = await daftarKrismaCollection.insertOne({
                  'idKrisma': data[1][0],
                  'idUser': data[2][0],
                  'status': 0,
                  'tanggalDaftar': DateTime.now()
                });

                var update = await komuniCollection
                    .updateOne(where.eq('_id', data[1][0]),
                        modify.set('kapasitas', data[3][0] - 1))
                    .then((result) async {
                  msg.addReceiver("agenPage");
                  msg.setContent("oke");
                  await msg.send();
                });
              } catch (e) {
                msg.addReceiver("agenPage");
                msg.setContent("failed");
                await msg.send();
              }
            } else {
              msg.addReceiver("agenPage");
              msg.setContent("sudah");
              await msg.send();
            }
          }

          if (data[0][0] == "cancel Krisma") {
            try {
              var baptisCollection =
                  MongoDatabase.db.collection(KRISMA_COLLECTION);
              var tiket = MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
              var conn = await tiket.updateOne(
                  where.eq('_id', data[1][0]), modify.set('status', -1));

              var update = await baptisCollection
                  .updateOne(where.eq('_id', data[2][0]),
                      modify.set('kapasitas', data[3][0] + 1))
                  .then((result) async {
                msg.addReceiver("agenPage");
                msg.setContent("oke");
                await msg.send();
              });
            } catch (e) {
              msg.addReceiver("agenPage");
              msg.setContent("failed");
              await msg.send();
            }
          }

          if (data[0][0] == "cancel Pemberkatan") {
            try {
              var tiket = MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
              var conn = await tiket
                  .updateOne(
                      where.eq('_id', data[1][0]), modify.set('status', -2))
                  .then((result) async {
                msg.addReceiver("agenPage");
                msg.setContent("oke");
                await msg.send();
              });
            } catch (e) {
              msg.addReceiver("agenPage");
              msg.setContent("failed");
              await msg.send();
            }
          }

          if (data[0][0] == "enroll Kegiatan") {
            var daftarUmumCollection =
                MongoDatabase.db.collection(USER_UMUM_COLLECTION);
            var hasilFind = await daftarUmumCollection.find({
              'idKegiatan': data[1][0],
              'idUser': data[2][0],
              'status': 0
            }).length;
            print(hasilFind);
            if (hasilFind == 0) {
              try {
                var daftarUmumCollection =
                    MongoDatabase.db.collection(USER_UMUM_COLLECTION);
                var umumCollection =
                    MongoDatabase.db.collection(UMUM_COLLECTION);
                var hasil = await daftarUmumCollection.insertOne({
                  'idKegiatan': data[1][0],
                  'idUser': data[2][0],
                  'tanggalDaftar': DateTime.now(),
                  'status': 0
                });

                var update = await umumCollection
                    .updateOne(where.eq('_id', data[1][0]),
                        modify.set('kapasitas', data[3][0] - 1))
                    .then((result) async {
                  msg.addReceiver("agenPage");
                  msg.setContent("oke");
                  await msg.send();
                });
              } catch (e) {
                msg.addReceiver("agenPage");
                msg.setContent("failed");
                await msg.send();
              }
            } else {
              msg.addReceiver("agenPage");
              msg.setContent("sudah");
              await msg.send();
            }
          }

          if (data[0][0] == "cancel Umum") {
            try {
              var baptisCollection =
                  MongoDatabase.db.collection(UMUM_COLLECTION);
              var tiket = MongoDatabase.db.collection(USER_UMUM_COLLECTION);
              var conn = await tiket.updateOne(
                  where.eq('_id', data[1][0]), modify.set('status', -1));

              var update = await baptisCollection
                  .updateOne(where.eq('_id', data[2][0]),
                      modify.set('kapasitas', data[3][0] + 1))
                  .then((result) async {
                msg.addReceiver("agenPage");
                msg.setContent("oke");
                await msg.send();
              });
            } catch (e) {
              msg.addReceiver("agenPage");
              msg.setContent("failed");
              await msg.send();
            }
          }

/////////////
          /////////
        }
        if (data.runtimeType == List<List<String>>) {
          if (data[0][0] == "add User") {
            var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
            var checkEmail;
            var checkName;
            await userCollection
                .find({'name': data[1][0]})
                .toList()
                .then((res) async {
                  checkName = res;
                  checkEmail =
                      await userCollection.find({'email': data[2][0]}).toList();
                });

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
                  'name': data[1][0],
                  'email': data[2][0],
                  'password': data[3][0],
                  'picture': "",
                  "banned": 0,
                  "notifGD": false,
                  "notifPG": false,
                  "tanggalDaftar": DateTime.now()
                }).then((result) async {
                  msg.addReceiver("agenPage");
                  msg.setContent("oke");
                  await msg.send();
                });
              }
            } catch (e) {
              msg.addReceiver("agenPage");
              msg.setContent("failed");
              await msg.send();
            }
          }
        }
      } catch (e) {
        return 0;
      }
    }

    action();
  }

  ReadyBehaviour() {
    Messages msg = Messages();
    var data = msg.receive();
    action() {
      try {
        if (data == "ready") {
          print("Agen Pendaftaran Ready");
        }
      } catch (e) {
        return 0;
      }
    }

    action();
  }
}
