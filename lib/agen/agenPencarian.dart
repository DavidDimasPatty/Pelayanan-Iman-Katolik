import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/data.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';

import 'messages.dart';

class AgenPencarian {
  AgenPencarian() {
    ReadyBehaviour();
    ResponsBehaviour();
    UpdateBehaviour();
  }

  ResponsBehaviour() {
    Messages msg = Messages();

    var data = msg.receive();

    action() async {
      try {
        if (data.runtimeType == List<List<String>>) {
          if (data[0][0] == "cari Baptis") {
            var gerejaKomuniCollection =
                MongoDatabase.db.collection(BAPTIS_COLLECTION);
            final pipeline = AggregationPipelineBuilder()
                .addStage(Lookup(
                    from: 'Gereja',
                    localField: 'idGereja',
                    foreignField: '_id',
                    as: 'GerejaBaptis'))
                .addStage(Match(where.eq('status', 0).map['\$query']))
                .build();
            var conn = await gerejaKomuniCollection
                .aggregateToStream(pipeline)
                .toList()
                .then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent(result);
              await msg.send();
            });
          }
          if (data[0][0] == "cari Komuni") {
            var gerejaKomuniCollection =
                MongoDatabase.db.collection(KOMUNI_COLLECTION);
            final pipeline = AggregationPipelineBuilder()
                .addStage(Lookup(
                    from: 'Gereja',
                    localField: 'idGereja',
                    foreignField: '_id',
                    as: 'GerejaKomuni'))
                .addStage(Match(where.eq('status', 0).map['\$query']))
                .build();
            var conn = await gerejaKomuniCollection
                .aggregateToStream(pipeline)
                .toList()
                .then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent(result);
              await msg.send();
            });
          }

          if (data[0][0] == "cari Krisma") {
            var gerejaKrismaCollection =
                MongoDatabase.db.collection(KRISMA_COLLECTION);
            final pipeline = AggregationPipelineBuilder()
                .addStage(Lookup(
                    from: 'Gereja',
                    localField: 'idGereja',
                    foreignField: '_id',
                    as: 'GerejaKrisma'))
                .addStage(Match(where.eq('status', 0).map['\$query']))
                .build();
            var conn = await gerejaKrismaCollection
                .aggregateToStream(pipeline)
                .toList()
                .then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent(result);
              await msg.send();
            });
          }

          if (data[0][0] == "cari Rekoleksi") {
            var umumCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
            var conn = await umumCollection
                .find({'jenisKegiatan': "Rekoleksi", "status": 0})
                .toList()
                .then((result) async {
                  msg.addReceiver("agenPage");
                  msg.setContent(result);
                  await msg.send();
                });
          }

          if (data[0][0] == "cari Retret") {
            var umumCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
            var conn = await umumCollection
                .find({'jenisKegiatan': "Retret", "status": 0})
                .toList()
                .then((result) async {
                  msg.addReceiver("agenPage");
                  msg.setContent(result);
                  await msg.send();
                });
          }

          if (data[0][0] == "cari PA") {
            var umumCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
            var conn = await umumCollection
                .find({'jenisKegiatan': "Pendalaman Alkitab", "status": 0})
                .toList()
                .then((result) async {
                  msg.addReceiver("agenPage");
                  msg.setContent(result);
                  await msg.send();
                });
          }
        }

        if (data.runtimeType == List<List<dynamic>>) {
          if (data[0][0] == "cari tampilan Profile") {
            var userKrismaCollection =
                MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
            var userBaptisCollection =
                MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
            var userKomuniCollection =
                MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
            var userPemberkatanCollection =
                MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
            var userKegiatanCollection =
                MongoDatabase.db.collection(USER_UMUM_COLLECTION);
            var count = 0;

            var countKr =
                await userKrismaCollection.find({'idUser': data[1][0]}).length;

            var countB =
                await userBaptisCollection.find({'idUser': data[1][0]}).length;
            var countKo =
                await userKomuniCollection.find({'idUser': data[1][0]}).length;
            var countP = await userPemberkatanCollection
                .find({'idUser': data[1][0]}).length;
            var countKe = await userKegiatanCollection
                .find({'idUser': data[1][0]}).length;

            // return countKr + countB + countKo + countP + countKe;

            var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
            var conn = await userCollection
                .find({'_id': data[1][0]})
                .toList()
                .then((result) async {
                  msg.addReceiver("agenPage");
                  msg.setContent([
                    [result],
                    [countKr + countB + countKo + countP + countKe]
                  ]);
                  await msg.send();
                });
          }

          if (data[0][0] == "cari Detail Baptis") {
            var gerejaBaptisCollection =
                MongoDatabase.db.collection(BAPTIS_COLLECTION);
            final pipeline = AggregationPipelineBuilder()
                .addStage(Lookup(
                    from: 'Gereja',
                    localField: 'idGereja',
                    foreignField: '_id',
                    as: 'GerejaBaptis'))
                .addStage(Match(where.eq('_id', data[1][0]).map['\$query']))
                .build();
            var conn = await gerejaBaptisCollection
                .aggregateToStream(pipeline)
                .toList()
                .then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent(result);
              await msg.send();
            });
          }

          if (data[0][0] == "cari Detail Komuni") {
            var gerejaBaptisCollection =
                MongoDatabase.db.collection(KOMUNI_COLLECTION);
            final pipeline = AggregationPipelineBuilder()
                .addStage(Lookup(
                    from: 'Gereja',
                    localField: 'idGereja',
                    foreignField: '_id',
                    as: 'GerejaKomuni'))
                .addStage(Match(where.eq('_id', data[1][0]).map['\$query']))
                .build();
            var conn = await gerejaBaptisCollection
                .aggregateToStream(pipeline)
                .toList()
                .then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent(result);
              await msg.send();
            });
          }

          if (data[0][0] == "cari Detail Krisma") {
            var gerejaBaptisCollection =
                MongoDatabase.db.collection(KRISMA_COLLECTION);
            final pipeline = AggregationPipelineBuilder()
                .addStage(Lookup(
                    from: 'Gereja',
                    localField: 'idGereja',
                    foreignField: '_id',
                    as: 'GerejaKrisma'))
                .addStage(Match(where.eq('_id', data[1][0]).map['\$query']))
                .build();
            var conn = await gerejaBaptisCollection
                .aggregateToStream(pipeline)
                .toList()
                .then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent(result);
              await msg.send();
            });
          }

          if (data[0][0] == "cari Detail Kegiatan") {
            print("udah masukk");
            var gerejaKegiatanCollection =
                MongoDatabase.db.collection(UMUM_COLLECTION);
            final pipeline = AggregationPipelineBuilder()
                .addStage(Lookup(
                    from: 'Gereja',
                    localField: 'idGereja',
                    foreignField: '_id',
                    as: 'GerejaKegiatan'))
                .addStage(Match(where.eq('_id', data[1][0]).map['\$query']))
                .build();
            var conn = await gerejaKegiatanCollection
                .aggregateToStream(pipeline)
                .toList()
                .then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent(result);
              await msg.send();
            });
          }

/////cari jumlah
          if (data[0][0] == "cari tampilan homepage") {
            var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
            var dataUser =
                await userCollection.find({'_id': data[1][0]}).toList();

            var userKrismaCollection =
                MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
            var userBaptisCollection =
                MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
            var userKomuniCollection =
                MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);

            var userKegiatanCollection =
                MongoDatabase.db.collection(USER_UMUM_COLLECTION);
            var dateKri = await userKrismaCollection
                .find(where
                    .eq("idUser", data[1][0])
                    .sortBy('tanggalDaftar', descending: true)
                    .limit(1))
                .toList();
            var dateBap = await userBaptisCollection
                .find(where
                    .eq("idUser", data[1][0])
                    .sortBy('tanggalDaftar', descending: true)
                    .limit(1))
                .toList();
            var dateKom = await userKomuniCollection
                .find(where
                    .eq("idUser", data[1][0])
                    .sortBy('tanggalDaftar', descending: true)
                    .limit(1))
                .toList();

            var dateKeg = await userKegiatanCollection
                .find(where
                    .eq("idUser", data[1][0])
                    .sortBy('tanggalDaftar', descending: true)
                    .limit(1))
                .toList();

            DateTime ans = DateTime.utc(1989, 11, 9);
            var hasil;

            if (ans.compareTo(
                    DateTime.parse(dateBap[0]['tanggalDaftar'].toString())) <
                0) {
              ans = DateTime.parse(dateBap[0]['tanggalDaftar'].toString());
              hasil = dateBap;
            }

            if (ans.compareTo(
                    DateTime.parse(dateKom[0]['tanggalDaftar'].toString())) <
                0) {
              ans = DateTime.parse(dateKom[0]['tanggalDaftar'].toString());
              hasil = dateKom;
            }

            if (ans.compareTo(
                    DateTime.parse(dateKeg[0]['tanggalDaftar'].toString())) <
                0) {
              ans = DateTime.parse(dateKeg[0]['tanggalDaftar'].toString());
              hasil = dateKeg;
              // print(ans);
            }

            var jadwalCollection =
                MongoDatabase.db.collection(GEREJA_COLLECTION);
            var conn = await jadwalCollection
                .find({'_id': hasil[0]['idGereja']})
                .toList()
                .then((result) async {
                  msg.addReceiver("agenPage");
                  msg.setContent([
                    [dataUser],
                    [result],
                    [hasil]
                  ]);
                  await msg.send();
                });
          }
        }
      } catch (e) {
        return 0;
      }
    }

    action();
  }

  UpdateBehaviour() {
    Messages msg = Messages();

    var data = msg.receive();
    print(data.runtimeType);
    action() async {
      try {
        if (data.runtimeType == List<List<dynamic>>) {
          if (data[0][0] == "cari user") {
            print("nih");
            print(data);
            var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
            var conn = await userCollection
                .find({'email': data[1][0], 'password': data[2][0]})
                .toList()
                .then((result) async {
                  print(result);

                  if (result != 0) {
                    msg.addReceiver("agenPage");
                    msg.setContent(result);
                    await msg.send();
                  } else {
                    msg.addReceiver("agenPage");
                    msg.setContent(result);
                    await msg.send();
                  }
                });
          }

          if (data[0][0] == "enroll Baptis") {
            try {
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
            } catch (e) {
              msg.addReceiver("agenPage");
              msg.setContent("failed");
              await msg.send();
            }
          }

          if (data[0][0] == "enroll Komuni") {
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
          }

          if (data[0][0] == "enroll Krisma") {
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
          }

          if (data[0][0] == "enroll Kegiatan") {
            try {
              var daftarUmumCollection =
                  MongoDatabase.db.collection(USER_UMUM_COLLECTION);
              var umumCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
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
          }

/////////////
          /////////
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
          print("Agen Pencarian Ready");
        }
      } catch (e) {
        return 0;
      }
    }

    action();
  }
}
