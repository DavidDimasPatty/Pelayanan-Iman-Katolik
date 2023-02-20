import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/data.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';

import 'messages.dart';

class AgenPencarian {
  AgenPencarian() {
    ReadyBehaviour();
    ResponsBehaviour();
  }

  ResponsBehaviour() {
    Messages msg = Messages();

    var data = msg.receive();

    action() async {
      try {
        if (data.runtimeType == List<List<String>>) {
          if (data[0][0] == "cari Pemberkatan") {
            var gerejaImamCollection =
                MongoDatabase.db.collection(IMAM_COLLECTION);
            final pipeline = AggregationPipelineBuilder()
                .addStage(Lookup(
                    from: 'Gereja',
                    localField: 'idGereja',
                    foreignField: '_id',
                    as: 'GerejaImam'))
                .addStage(
                    Match(where.eq('statusPemberkatan', 0).map['\$query']))
                .build();
            var conn = await gerejaImamCollection
                .aggregateToStream(pipeline)
                .toList()
                .then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent(result);
              await msg.send();
            });
          }

          if (data[0][0] == "cari Baptis") {
            var gerejaKomuniCollection =
                MongoDatabase.db.collection(BAPTIS_COLLECTION);
            final pipeline = AggregationPipelineBuilder()
                .addStage(Lookup(
                    from: 'Gereja',
                    localField: 'idGereja',
                    foreignField: '_id',
                    as: 'GerejaBaptis'))
                .addStage(Match(where
                    .eq('status', 0)
                    .gt("kapasitas", 0)
                    .gte("jadwalTutup", DateTime.now())
                    .map['\$query']))
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
                .addStage(Match(where
                    .eq('status', 0)
                    .gt("kapasitas", 0)
                    .gte("jadwalTutup", DateTime.now())
                    .map['\$query']))
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
                .addStage(Match(where
                    .eq('status', 0)
                    .gt("kapasitas", 0)
                    .gte("jadwalTutup", DateTime.now())
                    .map['\$query']))
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
                .find(where
                    .eq('jenisKegiatan', "Rekoleksi")
                    .eq("status", 0)
                    .gt("kapasitas", 0)
                    .gte("tanggal", DateTime.now()))
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
                .find(where
                    .eq('jenisKegiatan', "Retret")
                    .eq("status", 0)
                    .gt("kapasitas", 0)
                    .gte("tanggal", DateTime.now()))
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
                .find(where
                    .eq('jenisKegiatan', "Pendalaman Alkitab")
                    .eq("status", 0)
                    .gt("kapasitas", 0)
                    .gte("tanggal", DateTime.now()))
                .toList()
                .then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent(result);
              await msg.send();
            });
          }
        }

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

          if (data[0][0] == "cari Detail Jadwal Baptis") {
            var jadwalCollection =
                MongoDatabase.db.collection(BAPTIS_COLLECTION);
            var conn =
                await jadwalCollection.find({'_id': data[1][0]}).toList();

            var GerejaCollection =
                MongoDatabase.db.collection(GEREJA_COLLECTION);
            var gereja = await GerejaCollection.find({'_id': data[2][0]})
                .toList()
                .then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent([
                [conn],
                [result]
              ]);
              await msg.send();
            });
          }

          if (data[0][0] == "cari Imam Pemberkatan") {
            var gerejaCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
            var conn = await gerejaCollection
                .find({
                  'idGereja': data[1][0],
                  "statusPemberkatan": 0,
                  "banned": 0
                })
                .toList()
                .then((result) async {
                  msg.addReceiver("agenPage");
                  msg.setContent(result);
                  await msg.send();
                });
          }

          if (data[0][0] == "cari Detail Jadwal Komuni") {
            var jadwalCollection =
                MongoDatabase.db.collection(KOMUNI_COLLECTION);
            var conn =
                await jadwalCollection.find({'_id': data[1][0]}).toList();
            var GerejaCollection =
                MongoDatabase.db.collection(GEREJA_COLLECTION);
            var gereja = await GerejaCollection.find({'_id': data[2][0]})
                .toList()
                .then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent([
                [conn],
                [result]
              ]);
              await msg.send();
            });
          }

          if (data[0][0] == "cari Detail Jadwal Krisma") {
            var jadwalCollection =
                MongoDatabase.db.collection(KRISMA_COLLECTION);
            var conn =
                await jadwalCollection.find({'_id': data[1][0]}).toList();
            var GerejaCollection =
                MongoDatabase.db.collection(GEREJA_COLLECTION);
            var gereja = await GerejaCollection.find({'_id': data[2][0]})
                .toList()
                .then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent([
                [conn],
                [result]
              ]);
              await msg.send();
            });
          }

          if (data[0][0] == "cari Detail Jadwal Umum") {
            var jadwalCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
            var conn = await jadwalCollection
                .find({'_id': data[1][0]})
                .toList()
                .then((result) async {
                  msg.addReceiver("agenPage");
                  msg.setContent(result);
                  await msg.send();
                });
          }

          if (data[0][0] == "cari Detail Jadwal Pemberkatan") {
            var pemberkatanCollection =
                MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
            var conn = await pemberkatanCollection
                .find({'_id': data[1][0]})
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

          if (data[0][0] == "cari Enroll History") {
            print("masuk enrollll");
            //////////Kegiatan Umum
            var userKegiatanCollection =
                MongoDatabase.db.collection(USER_UMUM_COLLECTION);
            final pipeline1 = AggregationPipelineBuilder()
                .addStage(
                  Lookup(
                      from: 'umum',
                      localField: 'idKegiatan',
                      foreignField: '_id',
                      as: 'UserKegiatan'),
                )
                .addStage(Match(where
                    .eq('idUser', data[1][0])
                    .eq('status', 0)
                    .map['\$query']))
                .build();
            var resUmum = await userKegiatanCollection
                .aggregateToStream(pipeline1)
                .toList();
            //////////Krisma
            var userKrismaCollection =
                MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
            final pipeline2 = AggregationPipelineBuilder()
                .addStage(
                  Lookup(
                      from: 'krisma',
                      localField: 'idKrisma',
                      foreignField: '_id',
                      as: 'UserKrisma'),
                )
                .addStage(Match(where
                    .eq('idUser', data[1][0])
                    .eq('status', 0)
                    .map['\$query']))
                .build();
            var resKrisma = await userKrismaCollection
                .aggregateToStream(pipeline2)
                .toList();
            //////////Baptis
            var userBaptisCollection =
                MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
            final pipeline3 = AggregationPipelineBuilder()
                .addStage(
                  Lookup(
                      from: 'baptis',
                      localField: 'idBaptis',
                      foreignField: '_id',
                      as: 'UserBaptis'),
                )
                .addStage(Match(where
                    .eq('idUser', data[1][0])
                    .eq('status', 0)
                    .map['\$query']))
                .build();
            var resBaptis = await userBaptisCollection
                .aggregateToStream(pipeline3)
                .toList();
            //////////Komuni
            var userKomuniCollection =
                MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
            final pipeline4 = AggregationPipelineBuilder()
                .addStage(
                  Lookup(
                      from: 'komuni',
                      localField: 'idKomuni',
                      foreignField: '_id',
                      as: 'UserKomuni'),
                )
                .addStage(Match(where
                    .eq('idUser', data[1][0])
                    .eq('status', 0)
                    .map['\$query']))
                .build();
            var resKomuni = await userKomuniCollection
                .aggregateToStream(pipeline4)
                .toList();
            //////////Pemberkatan
            var pemberkatanCollection =
                MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
            var resPemberkatan = await pemberkatanCollection
                .find({'idUser': data[1][0], 'status': 0})
                .toList()
                .then((result) async {
                  msg.addReceiver("agenPage");
                  msg.setContent([
                    [resBaptis],
                    [resKomuni],
                    [resKrisma],
                    [resUmum],
                    [result]
                  ]);
                  await msg.send();
                });
          }

          if (data[0][0] == "cari Enroll History Done") {
            print("masuk enrollll");
            //////////Kegiatan Umum
            var userKegiatanCollection =
                MongoDatabase.db.collection(USER_UMUM_COLLECTION);
            final pipeline1 = AggregationPipelineBuilder()
                .addStage(
                  Lookup(
                      from: 'umum',
                      localField: 'idKegiatan',
                      foreignField: '_id',
                      as: 'UserKegiatan'),
                )
                .addStage(Match(where
                    .eq('idUser', data[1][0])
                    .ne('status', 0)
                    .map['\$query']))
                .build();
            var resUmum = await userKegiatanCollection
                .aggregateToStream(pipeline1)
                .toList();
            //////////Krisma
            var userKrismaCollection =
                MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
            final pipeline2 = AggregationPipelineBuilder()
                .addStage(
                  Lookup(
                      from: 'krisma',
                      localField: 'idKrisma',
                      foreignField: '_id',
                      as: 'UserKrisma'),
                )
                .addStage(Match(where
                    .eq('idUser', data[1][0])
                    .ne('status', 0)
                    .map['\$query']))
                .build();
            var resKrisma = await userKrismaCollection
                .aggregateToStream(pipeline2)
                .toList();
            //////////Baptis
            var userBaptisCollection =
                MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
            final pipeline3 = AggregationPipelineBuilder()
                .addStage(
                  Lookup(
                      from: 'baptis',
                      localField: 'idBaptis',
                      foreignField: '_id',
                      as: 'UserBaptis'),
                )
                .addStage(Match(where
                    .eq('idUser', data[1][0])
                    .ne('status', 0)
                    .map['\$query']))
                .build();
            var resBaptis = await userBaptisCollection
                .aggregateToStream(pipeline3)
                .toList();
            //////////Komuni
            var userKomuniCollection =
                MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
            final pipeline4 = AggregationPipelineBuilder()
                .addStage(
                  Lookup(
                      from: 'komuni',
                      localField: 'idKomuni',
                      foreignField: '_id',
                      as: 'UserKomuni'),
                )
                .addStage(Match(where
                    .eq('idUser', data[1][0])
                    .ne('status', 0)
                    .map['\$query']))
                .build();
            var resKomuni = await userKomuniCollection
                .aggregateToStream(pipeline4)
                .toList();
            //////////Pemberkatan
            var pemberkatanCollection =
                MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
            var resPemberkatan = await pemberkatanCollection
                .find(where.eq('idUser', data[1][0]).ne('status', 0))
                .toList()
                .then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent([
                [resBaptis],
                [resKomuni],
                [resKrisma],
                [resUmum],
                [result]
              ]);
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
            try {
              if (ans.compareTo(
                      DateTime.parse(dateBap[0]['tanggalDaftar'].toString())) <
                  0) {
                ans = DateTime.parse(dateBap[0]['tanggalDaftar'].toString());
                hasil = dateBap;
              }
            } catch (e) {}

            try {
              if (ans.compareTo(
                      DateTime.parse(dateKom[0]['tanggalDaftar'].toString())) <
                  0) {
                ans = DateTime.parse(dateKom[0]['tanggalDaftar'].toString());
                hasil = dateKom;
              }
            } catch (e) {}
            try {
              if (ans.compareTo(
                      DateTime.parse(dateKeg[0]['tanggalDaftar'].toString())) <
                  0) {
                ans = DateTime.parse(dateKeg[0]['tanggalDaftar'].toString());
                hasil = dateKeg;
                // print(ans);
              }
            } catch (e) {}
            try {
              if (ans.compareTo(
                      DateTime.parse(dateKri[0]['tanggalDaftar'].toString())) <
                  0) {
                ans = DateTime.parse(dateKri[0]['tanggalDaftar'].toString());
                hasil = dateKri;
                // print(ans);
              }
            } catch (e) {}

            var gambarGerejaCollection =
                MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
            var connGambar = await gambarGerejaCollection
                .find(where
                    .sortBy('tanggal', descending: false)
                    .eq("status", 0)
                    .limit(4))
                .toList();

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
                    [hasil],
                    [connGambar]
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

//   UpdateBehaviour() {
//     Messages msg = Messages();

//     var data = msg.receive();
//     print(data.runtimeType);
//     action() async {
//       try {
//         if (data.runtimeType == List<List<dynamic>>) {
//           if (data[0][0] == "add Pemberkatan") {
//             try {
//               var pemberkatanCollection =
//                   MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
//               var checkEmail;

//               var hasil = await pemberkatanCollection.insertOne({
//                 'idUser': data[1][0],
//                 'namaLengkap': data[2][0],
//                 'paroki': data[3][0],
//                 'lingkungan': data[4][0],
//                 'notelp': data[5][0],
//                 'alamat': data[6][0],
//                 'jenis': data[7][0],
//                 'tanggal': DateTime.parse(data[8][0]),
//                 'note': data[9][0],
//                 'idGereja': data[10][0],
//                 'idImam': data[11][0],
//                 'status': 0
//               }).then((result) async {
//                 msg.addReceiver("agenPage");
//                 msg.setContent("oke");
//                 await msg.send();
//               });
//             } catch (e) {
//               msg.addReceiver("agenPage");
//               msg.setContent("failed");
//               await msg.send();
//             }
//           }

//           if (data[0][0] == "enroll Baptis") {
//             var daftarBaptisCollection =
//                 MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
//             var hasilFind = await daftarBaptisCollection.find({
//               'idBaptis': data[1][0],
//               'idUser': data[2][0],
//             }).length;
//             print(hasilFind);

//             if (hasilFind == 0) {
//               try {
//                 var daftarBaptisCollection =
//                     MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
//                 var baptisCollection =
//                     MongoDatabase.db.collection(BAPTIS_COLLECTION);
//                 var hasil = await daftarBaptisCollection.insertOne({
//                   'idBaptis': data[1][0],
//                   'idUser': data[2][0],
//                   "tanggalDaftar": DateTime.now(),
//                   'status': 0
//                 });

//                 var update = await baptisCollection
//                     .updateOne(where.eq('_id', data[1][0]),
//                         modify.set('kapasitas', data[3][0] - 1))
//                     .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent("oke");
//                   await msg.send();
//                 });
//               } catch (e) {
//                 msg.addReceiver("agenPage");
//                 msg.setContent("failed");
//                 await msg.send();
//               }
//             } else {
//               msg.addReceiver("agenPage");
//               msg.setContent("sudah");
//               await msg.send();
//             }
//           }

//           if (data[0][0] == "cancel Baptis") {
//             try {
//               var baptisCollection =
//                   MongoDatabase.db.collection(BAPTIS_COLLECTION);
//               var tiket = MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
//               var conn = await tiket.updateOne(
//                   where.eq('_id', data[1][0]), modify.set('status', -1));

//               var update = await baptisCollection
//                   .updateOne(where.eq('_id', data[2][0]),
//                       modify.set('kapasitas', data[3][0] + 1))
//                   .then((result) async {
//                 msg.addReceiver("agenPage");
//                 msg.setContent("oke");
//                 await msg.send();
//               });
//             } catch (e) {
//               msg.addReceiver("agenPage");
//               msg.setContent("failed");
//               await msg.send();
//             }
//           }

//           if (data[0][0] == "enroll Komuni") {
//             var daftarKomuniCollection =
//                 MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
//             var hasilFind = await daftarKomuniCollection.find({
//               'idKomuni': data[1][0],
//               'idUser': data[2][0],
//             }).length;
//             print(hasilFind);
//             if (hasilFind == 0) {
//               try {
//                 var daftarKomuniCollection =
//                     MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
//                 var komuniCollection =
//                     MongoDatabase.db.collection(KOMUNI_COLLECTION);
//                 var hasil = await daftarKomuniCollection.insertOne({
//                   'idKomuni': data[1][0],
//                   'idUser': data[2][0],
//                   "tanggalDaftar": DateTime.now(),
//                   'status': 0
//                 });

//                 var update = await komuniCollection
//                     .updateOne(where.eq('_id', data[1][0]),
//                         modify.set('kapasitas', data[3][0] - 1))
//                     .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent("oke");
//                   await msg.send();
//                 });
//               } catch (e) {
//                 msg.addReceiver("agenPage");
//                 msg.setContent("failed");
//                 await msg.send();
//               }
//             }
//           } else {
//             msg.addReceiver("agenPage");
//             msg.setContent("sudah");
//             await msg.send();
//           }

//           if (data[0][0] == "cancel Komuni") {
//             try {
//               var baptisCollection =
//                   MongoDatabase.db.collection(KOMUNI_COLLECTION);
//               var tiket = MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
//               var conn = await tiket.updateOne(
//                   where.eq('_id', data[1][0]), modify.set('status', -1));

//               var update = await baptisCollection
//                   .updateOne(where.eq('_id', data[2][0]),
//                       modify.set('kapasitas', data[3][0] + 1))
//                   .then((result) async {
//                 msg.addReceiver("agenPage");
//                 msg.setContent("oke");
//                 await msg.send();
//               });
//             } catch (e) {
//               msg.addReceiver("agenPage");
//               msg.setContent("failed");
//               await msg.send();
//             }
//           }

//           if (data[0][0] == "enroll Krisma") {
//             var daftarKrismaCollection =
//                 MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
//             var hasilFind = await daftarKrismaCollection.find({
//               'idKrisma': data[1][0],
//               'idUser': data[2][0],
//             }).length;
//             print(hasilFind);
//             if (hasilFind == 0) {
//               try {
//                 var daftarKrismaCollection =
//                     MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
//                 var komuniCollection =
//                     MongoDatabase.db.collection(KRISMA_COLLECTION);
//                 var hasil = await daftarKrismaCollection.insertOne({
//                   'idKrisma': data[1][0],
//                   'idUser': data[2][0],
//                   'status': 0,
//                   'tanggalDaftar': DateTime.now()
//                 });

//                 var update = await komuniCollection
//                     .updateOne(where.eq('_id', data[1][0]),
//                         modify.set('kapasitas', data[3][0] - 1))
//                     .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent("oke");
//                   await msg.send();
//                 });
//               } catch (e) {
//                 msg.addReceiver("agenPage");
//                 msg.setContent("failed");
//                 await msg.send();
//               }
//             }
//           } else {
//             msg.addReceiver("agenPage");
//             msg.setContent("sudah");
//             await msg.send();
//           }

//           if (data[0][0] == "cancel Krisma") {
//             try {
//               var baptisCollection =
//                   MongoDatabase.db.collection(KRISMA_COLLECTION);
//               var tiket = MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
//               var conn = await tiket.updateOne(
//                   where.eq('_id', data[1][0]), modify.set('status', -1));

//               var update = await baptisCollection
//                   .updateOne(where.eq('_id', data[2][0]),
//                       modify.set('kapasitas', data[3][0] + 1))
//                   .then((result) async {
//                 msg.addReceiver("agenPage");
//                 msg.setContent("oke");
//                 await msg.send();
//               });
//             } catch (e) {
//               msg.addReceiver("agenPage");
//               msg.setContent("failed");
//               await msg.send();
//             }
//           }

//           if (data[0][0] == "cancel Pemberkatan") {
//             try {
//               var tiket = MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
//               var conn = await tiket
//                   .updateOne(
//                       where.eq('_id', data[1][0]), modify.set('status', -2))
//                   .then((result) async {
//                 msg.addReceiver("agenPage");
//                 msg.setContent("oke");
//                 await msg.send();
//               });
//             } catch (e) {
//               msg.addReceiver("agenPage");
//               msg.setContent("failed");
//               await msg.send();
//             }
//           }

//           if (data[0][0] == "enroll Kegiatan") {
//             var daftarUmumCollection =
//                 MongoDatabase.db.collection(USER_UMUM_COLLECTION);
//             var hasilFind = await daftarUmumCollection.find({
//               'idKegiatan': data[1][0],
//               'idUser': data[2][0],
//             }).length;
//             print(hasilFind);
//             if (hasilFind == 0) {
//               try {
//                 var daftarUmumCollection =
//                     MongoDatabase.db.collection(USER_UMUM_COLLECTION);
//                 var umumCollection =
//                     MongoDatabase.db.collection(UMUM_COLLECTION);
//                 var hasil = await daftarUmumCollection.insertOne({
//                   'idKegiatan': data[1][0],
//                   'idUser': data[2][0],
//                   'tanggalDaftar': DateTime.now(),
//                   'status': 0
//                 });

//                 var update = await umumCollection
//                     .updateOne(where.eq('_id', data[1][0]),
//                         modify.set('kapasitas', data[3][0] - 1))
//                     .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent("oke");
//                   await msg.send();
//                 });
//               } catch (e) {
//                 msg.addReceiver("agenPage");
//                 msg.setContent("failed");
//                 await msg.send();
//               }
//             }
//           } else {
//             msg.addReceiver("agenPage");
//             msg.setContent("sudah");
//             await msg.send();
//           }

//           if (data[0][0] == "cancel Umum") {
//             try {
//               var baptisCollection =
//                   MongoDatabase.db.collection(UMUM_COLLECTION);
//               var tiket = MongoDatabase.db.collection(USER_UMUM_COLLECTION);
//               var conn = await tiket.updateOne(
//                   where.eq('_id', data[1][0]), modify.set('status', -1));

//               var update = await baptisCollection
//                   .updateOne(where.eq('_id', data[2][0]),
//                       modify.set('kapasitas', data[3][0] + 1))
//                   .then((result) async {
//                 msg.addReceiver("agenPage");
//                 msg.setContent("oke");
//                 await msg.send();
//               });
//             } catch (e) {
//               msg.addReceiver("agenPage");
//               msg.setContent("failed");
//               await msg.send();
//             }
//           }

// /////////////
//           /////////
//         }
//         if (data.runtimeType == List<List<String>>) {
//           if (data[0][0] == "add User") {
//             var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
//             var checkEmail;
//             var checkName;
//             await userCollection
//                 .find({'name': data[1][0]})
//                 .toList()
//                 .then((res) async {
//                   checkName = res;
//                   checkEmail =
//                       await userCollection.find({'email': data[2][0]}).toList();
//                 });

//             try {
//               if (checkName.length > 0) {
//                 return "nama";
//               }
//               if (checkEmail.length > 0) {
//                 print("MASUKKKK");
//                 return "email";
//               }
//               if (checkName.length == 0 && checkEmail.length == 0) {
//                 var hasil = await userCollection.insertOne({
//                   'name': data[1][0],
//                   'email': data[2][0],
//                   'password': data[3][0],
//                   'picture': "",
//                   "banned": 0,
//                   "notifGD": false,
//                   "notifPG": false,
//                   "tanggalDaftar": DateTime.now()
//                 }).then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent("oke");
//                   await msg.send();
//                 });
//               }
//             } catch (e) {
//               msg.addReceiver("agenPage");
//               msg.setContent("failed");
//               await msg.send();
//             }
//           }
//         }
//       } catch (e) {
//         return 0;
//       }
//     }

//     action();
//   }

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
