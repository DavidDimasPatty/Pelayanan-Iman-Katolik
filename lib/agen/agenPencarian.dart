// import 'dart:developer';

// import 'package:mongo_dart/mongo_dart.dart';
// import 'package:pelayanan_iman_katolik/DatabaseFolder/data.dart';
// import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';

// import 'messages.dart';

// class AgenPencarian {
//   AgenPencarian() {
//     ReadyBehaviour();
//     ResponsBehaviour();
//   }

//   ResponsBehaviour() {
//     Messages msg = Messages();

//     var data = msg.receive();

//     action() async {
//       try {
//         if (data.runtimeType == List<List<String>>) {
//           if (data[0][0] == "cari Pemberkatan") {
//             var gerejaImamCollection =
//                 MongoDatabase.db.collection(IMAM_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'Gereja',
//                     localField: 'idGereja',
//                     foreignField: '_id',
//                     as: 'GerejaImam'))
//                 .addStage(
//                     Match(where.eq('statusPemberkatan', 0).map['\$query']))
//                 .build();
//             var conn = await gerejaImamCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Perkawinan") {
//             var gerejaImamCollection =
//                 MongoDatabase.db.collection(IMAM_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'Gereja',
//                     localField: 'idGereja',
//                     foreignField: '_id',
//                     as: 'GerejaImam'))
//                 .addStage(Match(where.eq('statusPerkawinan', 0).map['\$query']))
//                 .build();
//             var conn = await gerejaImamCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Perminyakan") {
//             var gerejaImamCollection =
//                 MongoDatabase.db.collection(IMAM_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'Gereja',
//                     localField: 'idGereja',
//                     foreignField: '_id',
//                     as: 'GerejaPerminyakan'))
//                 .addStage(
//                     Match(where.eq('statusPerminyakan', 0).map['\$query']))
//                 .build();
//             var conn = await gerejaImamCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Tobat") {
//             var gerejaImamCollection =
//                 MongoDatabase.db.collection(IMAM_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'Gereja',
//                     localField: 'idGereja',
//                     foreignField: '_id',
//                     as: 'GerejaTobat'))
//                 .addStage(Match(where.eq('statusTobat', 0).map['\$query']))
//                 .build();
//             var conn = await gerejaImamCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Baptis") {
//             var gerejaKomuniCollection =
//                 MongoDatabase.db.collection(BAPTIS_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'Gereja',
//                     localField: 'idGereja',
//                     foreignField: '_id',
//                     as: 'GerejaBaptis'))
//                 .addStage(Match(where
//                     .eq('status', 0)
//                     .gt("kapasitas", 0)
//                     .gte("jadwalTutup", DateTime.now())
//                     .map['\$query']))
//                 .build();
//             var conn = await gerejaKomuniCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Pengumuman") {
//             var pengumumanCollection =
//                 MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'Gereja',
//                     localField: 'idGereja',
//                     foreignField: '_id',
//                     as: 'GerejaPengumuman'))
//                 .addStage(Match(where.eq('status', 0).map['\$query']))
//                 .build();
//             var conn = await pengumumanCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Komuni") {
//             var gerejaKomuniCollection =
//                 MongoDatabase.db.collection(KOMUNI_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'Gereja',
//                     localField: 'idGereja',
//                     foreignField: '_id',
//                     as: 'GerejaKomuni'))
//                 .addStage(Match(where
//                     .eq('status', 0)
//                     .gt("kapasitas", 0)
//                     .gte("jadwalTutup", DateTime.now())
//                     .map['\$query']))
//                 .build();
//             var conn = await gerejaKomuniCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Krisma") {
//             var gerejaKrismaCollection =
//                 MongoDatabase.db.collection(KRISMA_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'Gereja',
//                     localField: 'idGereja',
//                     foreignField: '_id',
//                     as: 'GerejaKrisma'))
//                 .addStage(Match(where
//                     .eq('status', 0)
//                     .gt("kapasitas", 0)
//                     .gte("jadwalTutup", DateTime.now())
//                     .map['\$query']))
//                 .build();
//             var conn = await gerejaKrismaCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Rekoleksi") {
//             var umumCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
//             var conn = await umumCollection
//                 .find(where
//                     .eq('jenisKegiatan', "Rekoleksi")
//                     .eq("status", 0)
//                     .gt("kapasitas", 0)
//                     .gte("tanggal", DateTime.now()))
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Retret") {
//             var umumCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
//             var conn = await umumCollection
//                 .find(where
//                     .eq('jenisKegiatan', "Retret")
//                     .eq("status", 0)
//                     .gt("kapasitas", 0)
//                     .gte("tanggal", DateTime.now()))
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari PA") {
//             var umumCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
//             var conn = await umumCollection
//                 .find(where
//                     .eq('jenisKegiatan', "Pendalaman Alkitab")
//                     .eq("status", 0)
//                     .gt("kapasitas", 0)
//                     .gte("tanggal", DateTime.now()))
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }
//         }

//         if (data.runtimeType == List<List<dynamic>>) {

//           if (data[0][0] == "cari Detail Pengumuman") {
//             var pengumumanCollection =
//                 MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'Gereja',
//                     localField: 'idGereja',
//                     foreignField: '_id',
//                     as: 'GerejaPengumuman'))
//                 .addStage(Match(where.eq("_id", data[1][0]).map['\$query']))
//                 .build();
//             var conn = await pengumumanCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Detail Baptis") {
//             var aturanCollection =
//                 MongoDatabase.db.collection(ATURAN_PELAYANAN_COLLECTION);
//             var aturan = await aturanCollection
//                 .find(where.eq("idGereja", data[2][0]))
//                 .toList();
//             var gerejaBaptisCollection =
//                 MongoDatabase.db.collection(BAPTIS_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'Gereja',
//                     localField: 'idGereja',
//                     foreignField: '_id',
//                     as: 'GerejaBaptis'))
//                 .addStage(Match(where.eq('_id', data[1][0]).map['\$query']))
//                 .build();
//             var conn = await gerejaBaptisCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent([
//                 [result],
//                 [aturan]
//               ]);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Detail Jadwal Baptis") {
//             var jadwalCollection =
//                 MongoDatabase.db.collection(BAPTIS_COLLECTION);
//             var conn =
//                 await jadwalCollection.find({'_id': data[1][0]}).toList();

//             var GerejaCollection =
//                 MongoDatabase.db.collection(GEREJA_COLLECTION);
//             var gereja = await GerejaCollection.find({'_id': data[2][0]})
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent([
//                 [conn],
//                 [result]
//               ]);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Detail Imam") {
//             var aturanCollection =
//                 MongoDatabase.db.collection(ATURAN_PELAYANAN_COLLECTION);
//             var aturan = await aturanCollection
//                 .find(where.eq("idGereja", data[2][0]))
//                 .toList();
//             var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'Gereja',
//                     localField: 'idGereja',
//                     foreignField: '_id',
//                     as: 'GerejaImam'))
//                 .addStage(Match(where.eq('_id', data[1][0]).map['\$query']))
//                 .build();
//             var conn = await imamCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent([
//                 [result],
//                 [aturan]
//               ]);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Imam Pemberkatan") {
//             var gerejaCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
//             var conn = await gerejaCollection
//                 .find({
//                   'idGereja': data[1][0],
//                   "statusPemberkatan": 0,
//                   "banned": 0
//                 })
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari Imam Perkawinan") {
//             var gerejaCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
//             var conn = await gerejaCollection
//                 .find({
//                   'idGereja': data[1][0],
//                   "statusPerkawinan": 0,
//                   "banned": 0
//                 })
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari Imam Perminyakan") {
//             var gerejaCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
//             var conn = await gerejaCollection
//                 .find({
//                   'idGereja': data[1][0],
//                   "statusPerminyakan": 0,
//                   "banned": 0
//                 })
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari Imam Tobat") {
//             var gerejaCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
//             var conn = await gerejaCollection
//                 .find({'idGereja': data[1][0], "statusTobat": 0, "banned": 0})
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari Detail Jadwal Komuni") {
//             var jadwalCollection =
//                 MongoDatabase.db.collection(KOMUNI_COLLECTION);
//             var conn =
//                 await jadwalCollection.find({'_id': data[1][0]}).toList();
//             var GerejaCollection =
//                 MongoDatabase.db.collection(GEREJA_COLLECTION);
//             var gereja = await GerejaCollection.find({'_id': data[2][0]})
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent([
//                 [conn],
//                 [result]
//               ]);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Detail Jadwal Krisma") {
//             var jadwalCollection =
//                 MongoDatabase.db.collection(KRISMA_COLLECTION);
//             var conn =
//                 await jadwalCollection.find({'_id': data[1][0]}).toList();
//             var GerejaCollection =
//                 MongoDatabase.db.collection(GEREJA_COLLECTION);
//             var gereja = await GerejaCollection.find({'_id': data[2][0]})
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent([
//                 [conn],
//                 [result]
//               ]);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Detail Jadwal Umum") {
//             var jadwalCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
//             var conn = await jadwalCollection
//                 .find({'_id': data[1][0]})
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari Detail Jadwal Pemberkatan") {
//             var pemberkatanCollection =
//                 MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
//             var conn = await pemberkatanCollection
//                 .find({'_id': data[1][0]})
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari Detail Komuni") {
//             var aturanCollection =
//                 MongoDatabase.db.collection(ATURAN_PELAYANAN_COLLECTION);
//             var aturan = await aturanCollection
//                 .find(where.eq("idGereja", data[2][0]))
//                 .toList();
//             var gerejaBaptisCollection =
//                 MongoDatabase.db.collection(KOMUNI_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'Gereja',
//                     localField: 'idGereja',
//                     foreignField: '_id',
//                     as: 'GerejaKomuni'))
//                 .addStage(Match(where.eq('_id', data[1][0]).map['\$query']))
//                 .build();
//             var conn = await gerejaBaptisCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent([
//                 [result],
//                 [aturan]
//               ]);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Detail Krisma") {
//             var aturanCollection =
//                 MongoDatabase.db.collection(ATURAN_PELAYANAN_COLLECTION);
//             var aturan = await aturanCollection
//                 .find(where.eq("idGereja", data[2][0]))
//                 .toList();
//             var gerejaBaptisCollection =
//                 MongoDatabase.db.collection(KRISMA_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'Gereja',
//                     localField: 'idGereja',
//                     foreignField: '_id',
//                     as: 'GerejaKrisma'))
//                 .addStage(Match(where.eq('_id', data[1][0]).map['\$query']))
//                 .build();
//             var conn = await gerejaBaptisCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent([
//                 [result],
//                 [aturan]
//               ]);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Detail Kegiatan") {
//             var gerejaKegiatanCollection =
//                 MongoDatabase.db.collection(UMUM_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'Gereja',
//                     localField: 'idGereja',
//                     foreignField: '_id',
//                     as: 'GerejaKegiatan'))
//                 .addStage(Match(where.eq('_id', data[1][0]).map['\$query']))
//                 .build();
//             var conn = await gerejaKegiatanCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Enroll History") {
//             //////////Kegiatan Umum
//             var userKegiatanCollection =
//                 MongoDatabase.db.collection(USER_UMUM_COLLECTION);
//             final pipeline1 = AggregationPipelineBuilder()
//                 .addStage(
//                   Lookup(
//                       from: 'umum',
//                       localField: 'idKegiatan',
//                       foreignField: '_id',
//                       as: 'UserKegiatan'),
//                 )
//                 .addStage(Match(where
//                     .eq('idUser', data[1][0])
//                     .eq('status', 0)
//                     .map['\$query']))
//                 .build();
//             var resUmum = await userKegiatanCollection
//                 .aggregateToStream(pipeline1)
//                 .toList();
//             //////////Krisma
//             var userKrismaCollection =
//                 MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
//             final pipeline2 = AggregationPipelineBuilder()
//                 .addStage(
//                   Lookup(
//                       from: 'krisma',
//                       localField: 'idKrisma',
//                       foreignField: '_id',
//                       as: 'UserKrisma'),
//                 )
//                 .addStage(Match(where
//                     .eq('idUser', data[1][0])
//                     .eq('status', 0)
//                     .map['\$query']))
//                 .build();
//             var resKrisma = await userKrismaCollection
//                 .aggregateToStream(pipeline2)
//                 .toList();
//             //////////Baptis
//             var userBaptisCollection =
//                 MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
//             final pipeline3 = AggregationPipelineBuilder()
//                 .addStage(
//                   Lookup(
//                       from: 'baptis',
//                       localField: 'idBaptis',
//                       foreignField: '_id',
//                       as: 'UserBaptis'),
//                 )
//                 .addStage(Match(where
//                     .eq('idUser', data[1][0])
//                     .eq('status', 0)
//                     .map['\$query']))
//                 .build();
//             var resBaptis = await userBaptisCollection
//                 .aggregateToStream(pipeline3)
//                 .toList();
//             //////////Komuni
//             var userKomuniCollection =
//                 MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
//             final pipeline4 = AggregationPipelineBuilder()
//                 .addStage(
//                   Lookup(
//                       from: 'komuni',
//                       localField: 'idKomuni',
//                       foreignField: '_id',
//                       as: 'UserKomuni'),
//                 )
//                 .addStage(Match(where
//                     .eq('idUser', data[1][0])
//                     .eq('status', 0)
//                     .map['\$query']))
//                 .build();
//             var resKomuni = await userKomuniCollection
//                 .aggregateToStream(pipeline4)
//                 .toList();
//             //////////Pemberkatan
//             var pemberkatanCollection =
//                 MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
//             var resPemberkatan = await pemberkatanCollection
//                 .find({'idUser': data[1][0], 'status': 0})
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent([
//                     [resBaptis],
//                     [resKomuni],
//                     [resKrisma],
//                     [resUmum],
//                     [result]
//                   ]);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari Enroll History Done") {
//             //////////Kegiatan Umum
//             var userKegiatanCollection =
//                 MongoDatabase.db.collection(USER_UMUM_COLLECTION);
//             final pipeline1 = AggregationPipelineBuilder()
//                 .addStage(
//                   Lookup(
//                       from: 'umum',
//                       localField: 'idKegiatan',
//                       foreignField: '_id',
//                       as: 'UserKegiatan'),
//                 )
//                 .addStage(Match(where
//                     .eq('idUser', data[1][0])
//                     .ne('status', 0)
//                     .map['\$query']))
//                 .build();
//             var resUmum = await userKegiatanCollection
//                 .aggregateToStream(pipeline1)
//                 .toList();
//             //////////Krisma
//             var userKrismaCollection =
//                 MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
//             final pipeline2 = AggregationPipelineBuilder()
//                 .addStage(
//                   Lookup(
//                       from: 'krisma',
//                       localField: 'idKrisma',
//                       foreignField: '_id',
//                       as: 'UserKrisma'),
//                 )
//                 .addStage(Match(where
//                     .eq('idUser', data[1][0])
//                     .ne('status', 0)
//                     .map['\$query']))
//                 .build();
//             var resKrisma = await userKrismaCollection
//                 .aggregateToStream(pipeline2)
//                 .toList();
//             //////////Baptis
//             var userBaptisCollection =
//                 MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
//             final pipeline3 = AggregationPipelineBuilder()
//                 .addStage(
//                   Lookup(
//                       from: 'baptis',
//                       localField: 'idBaptis',
//                       foreignField: '_id',
//                       as: 'UserBaptis'),
//                 )
//                 .addStage(Match(where
//                     .eq('idUser', data[1][0])
//                     .ne('status', 0)
//                     .map['\$query']))
//                 .build();
//             var resBaptis = await userBaptisCollection
//                 .aggregateToStream(pipeline3)
//                 .toList();
//             //////////Komuni
//             var userKomuniCollection =
//                 MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
//             final pipeline4 = AggregationPipelineBuilder()
//                 .addStage(
//                   Lookup(
//                       from: 'komuni',
//                       localField: 'idKomuni',
//                       foreignField: '_id',
//                       as: 'UserKomuni'),
//                 )
//                 .addStage(Match(where
//                     .eq('idUser', data[1][0])
//                     .ne('status', 0)
//                     .map['\$query']))
//                 .build();
//             var resKomuni = await userKomuniCollection
//                 .aggregateToStream(pipeline4)
//                 .toList();
//             //////////Pemberkatan
//             var pemberkatanCollection =
//                 MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
//             var resPemberkatan = await pemberkatanCollection
//                 .find(where.eq('idUser', data[1][0]).ne('status', 0))
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent([
//                 [resBaptis],
//                 [resKomuni],
//                 [resKrisma],
//                 [resUmum],
//                 [result]
//               ]);
//               await msg.send();
//             });
//           }
// /////cari jumlah
//           if (data[0][0] == "cari tampilan homepage") {
//             var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
//             var dataUser =
//                 await userCollection.find({'_id': data[1][0]}).toList();

//             var userKrismaCollection =
//                 MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
//             var userBaptisCollection =
//                 MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
//             var userKomuniCollection =
//                 MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);

//             var userKegiatanCollection =
//                 MongoDatabase.db.collection(USER_UMUM_COLLECTION);
//             var dateKri = await userKrismaCollection
//                 .find(where
//                     .eq("idUser", data[1][0])
//                     .eq("status", 0)
//                     .sortBy('tanggalDaftar', descending: true)
//                     .limit(1))
//                 .toList();
//             var dateBap = await userBaptisCollection
//                 .find(where
//                     .eq("idUser", data[1][0])
//                     .eq("status", 0)
//                     .sortBy('tanggalDaftar', descending: true)
//                     .limit(1))
//                 .toList();
//             var dateKom = await userKomuniCollection
//                 .find(where
//                     .eq("idUser", data[1][0])
//                     .eq("status", 0)
//                     .sortBy('tanggalDaftar', descending: true)
//                     .limit(1))
//                 .toList();

//             var dateKeg = await userKegiatanCollection
//                 .find(where
//                     .eq("idUser", data[1][0])
//                     .eq("status", 0)
//                     .sortBy('tanggalDaftar', descending: true)
//                     .limit(1))
//                 .toList();

//             DateTime ans = DateTime.utc(1989, 11, 9);
//             var hasil = null;
//             try {
//               if (ans.compareTo(
//                       DateTime.parse(dateBap[0]['tanggalDaftar'].toString())) <
//                   0) {
//                 ans = DateTime.parse(dateBap[0]['tanggalDaftar'].toString());
//                 hasil = dateBap;
//               }
//             } catch (e) {}

//             try {
//               if (ans.compareTo(
//                       DateTime.parse(dateKom[0]['tanggalDaftar'].toString())) <
//                   0) {
//                 ans = DateTime.parse(dateKom[0]['tanggalDaftar'].toString());
//                 hasil = dateKom;
//               }
//             } catch (e) {}
//             try {
//               if (ans.compareTo(
//                       DateTime.parse(dateKeg[0]['tanggalDaftar'].toString())) <
//                   0) {
//                 ans = DateTime.parse(dateKeg[0]['tanggalDaftar'].toString());
//                 hasil = dateKeg;
//               }
//             } catch (e) {}
//             try {
//               if (ans.compareTo(
//                       DateTime.parse(dateKri[0]['tanggalDaftar'].toString())) <
//                   0) {
//                 ans = DateTime.parse(dateKri[0]['tanggalDaftar'].toString());
//                 hasil = dateKri;
//               }
//             } catch (e) {}

//             var gambarGerejaCollection =
//                 MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
//             var connGambar = await gambarGerejaCollection
//                 .find(where
//                     .sortBy('tanggal', descending: false)
//                     .eq("status", 0)
//                     .limit(4))
//                 .toList();

//             if (hasil != null) {
//               var jadwalCollection =
//                   MongoDatabase.db.collection(GEREJA_COLLECTION);
//               var conn = await jadwalCollection
//                   .find({'_id': hasil[0]['idGereja']})
//                   .toList()
//                   .then((result) async {
//                     msg.addReceiver("agenPage");
//                     msg.setContent([
//                       [dataUser],
//                       [result],
//                       [hasil],
//                       [connGambar]
//                     ]);
//                     await msg.send();
//                   });
//             } else {
//               msg.addReceiver("agenPage");
//               msg.setContent([
//                 [dataUser],
//                 [null],
//                 [hasil],
//                 [connGambar]
//               ]);
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

//   ReadyBehaviour() {
//     Messages msg = Messages();
//     var data = msg.receive();
//     action() {
//       try {
//         if (data == "ready") {
//           print("Agen Pencarian Ready");
//         }
//       } catch (e) {
//         return 0;
//       }
//     }

//     action();
//   }
// }
import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import '../DatabaseFolder/data.dart';
import '../DatabaseFolder/mongodb.dart';
import 'Agent.dart';
import 'Goals.dart';
import 'MessagePassing.dart';
import 'Plan.dart';
import 'Task.dart';

class AgentPencarian extends Agent {
  AgentPencarian() {
    _initAgent();
  }

  List<Plan> _plan = [];
  List<Goals> _goals = [];
  int _estimatedTime = 5;
  bool stop = false;
  String agentName = "";
  List _Message = [];
  List _Sender = [];

  bool canPerformTask(dynamic message) {
    for (var p in _plan) {
      if (p.goals == message.task.action && p.protocol == message.protocol) {
        return true;
      }
    }
    return false;
  }

  Future<dynamic> receiveMessage(Messages msg, String sender) {
    print(agentName + ' received message from $sender');
    _Message.add(msg);
    _Sender.add(sender);
    return performTask();
  }

  Future<dynamic> performTask() async {
    Messages msg = _Message.last;
    String sender = _Sender.last;

    dynamic task = msg.task;
    for (var p in _plan) {
      if (p.goals == task.action) {
        Timer timer = Timer.periodic(Duration(seconds: p.time), (timer) {
          stop = true;
          timer.cancel();

          MessagePassing messagePassing = MessagePassing();
          Messages msg = rejectTask(task, sender);
          messagePassing.sendMessage(msg);
        });

        Messages message = await action(p.goals, task.data, sender);

        if (stop == false) {
          if (timer.isActive) {
            timer.cancel();
            bool checkGoals = false;
            if (message.task.data.runtimeType == String &&
                message.task.data == "failed") {
              MessagePassing messagePassing = MessagePassing();
              Messages msg = rejectTask(task, sender);
              messagePassing.sendMessage(msg);
            } else {
              print(message.task.data.runtimeType);
              for (var g in _goals) {
                if (g.request == p.goals &&
                    g.goals == message.task.data.runtimeType) {
                  checkGoals = true;
                }
              }
              if (checkGoals == true) {
                print('Agent Pencarian returning data');
                MessagePassing messagePassing = MessagePassing();
                messagePassing.sendMessage(message);
                break;
              } else {
                rejectTask(task, sender);
              }
              break;
            }
          }
        }
      }
    }
  }

  Future<Messages> action(String goals, dynamic data, String sender) async {
    switch (goals) {
      case "cari pengumuman":
        return cariPengumuman(data, sender);
      case "cari jadwal pendaftaran":
        return cariJadwalPendaftaran(data, sender);
      case "cari pelayanan":
        return cariPelayanan(data, sender);
      case "cari tampilan home":
        return cariTampilanHome(data, sender);
      case "check pendaftaran":
        return checkPendaftaran(data, sender);
      default:
        return rejectTask(data.task, data.sender);
    }
  }

  Future<Messages> checkPendaftaran(dynamic data, String sender) async {
    var pelayananCollection;
    String id = "";
    if (data[0] == "baptis") {
      pelayananCollection = MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
      id = "idBaptis";
    }

    if (data[0] == "komuni") {
      pelayananCollection = MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
      id = "idKomuni";
    }
    if (data[0] == "krisma") {
      pelayananCollection = MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
      id = "idKrisma";
    }
    if (data[0] == "umum") {
      pelayananCollection = MongoDatabase.db.collection(USER_UMUM_COLLECTION);
      id = "idKegiatan";
    }

    var hasil = await pelayananCollection
        .find(where.eq(id, data[1]).eq("idUser", data[2]).eq("status", 0))
        .length;

    if (hasil == 0) {
      Completer<void> completer = Completer<void>();
      Messages message2 = Messages(sender, 'Agent Pendaftaran', "REQUEST",
          Tasks('enroll pelayanan', data));
      MessagePassing messagePassing2 = MessagePassing();
      await messagePassing2.sendMessage(message2);

      Messages message = Messages(
          agentName, sender, "INFORM", Tasks('wait', "Wait agent pendaftaran"));
      // Future.delayed(Duration(seconds: 1));
      completer.complete();

      await completer.future;
      return await message;
    } else {
      Messages message = Messages('Agent Pencarian', sender, "INFORM",
          Tasks('hasil pencarian', "sudah"));
      return message;
    }
  }

  Future<Messages> cariJadwalPendaftaran(dynamic data, String sender) async {
    dynamic statusQuery;
    dynamic statusPemPer;
    if (data[0] == "current") {
      statusQuery = where.eq('idUser', data[1]).eq('status', 0).map['\$query'];
      statusPemPer = {'idUser': data[1], 'status': 0};
    }
    if (data[0] == "history") {
      statusQuery = where.eq('idUser', data[1]).ne('status', 0).map['\$query'];
      statusPemPer = {'idUser': data[1]};
    }
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
        .addStage(Match(statusQuery))
        .build();
    var resUmum =
        await userKegiatanCollection.aggregateToStream(pipeline1).toList();
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
        .addStage(Match(statusQuery))
        .build();
    var resKrisma =
        await userKrismaCollection.aggregateToStream(pipeline2).toList();
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
        .addStage(Match(statusQuery))
        .build();
    var resBaptis =
        await userBaptisCollection.aggregateToStream(pipeline3).toList();
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
        .addStage(Match(statusQuery))
        .build();
    var resKomuni =
        await userKomuniCollection.aggregateToStream(pipeline4).toList();
    //////////Pemberkatan
    var pemberkatanCollection =
        MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
    var resPemberkatan =
        await pemberkatanCollection.find(statusPemPer).toList();
    var perkawinanCollection =
        MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
    var resPerkawinan = await perkawinanCollection.find(statusPemPer).toList();

    Messages message = Messages(
        'Agent Pencarian',
        sender,
        "INFORM",
        Tasks('hasil pencarian', [
          resBaptis,
          resKomuni,
          resKrisma,
          resUmum,
          resPemberkatan,
          resPerkawinan
        ]));
    return message;
  }

  Future<Messages> cariTampilanHome(dynamic data, String sender) async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var dataUser = await userCollection.find({'_id': data[0]}).toList();

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
            .eq("idUser", data[0])
            .eq("status", 0)
            .sortBy('tanggalDaftar', descending: true)
            .limit(1))
        .toList();
    var dateBap = await userBaptisCollection
        .find(where
            .eq("idUser", data[0])
            .eq("status", 0)
            .sortBy('tanggalDaftar', descending: true)
            .limit(1))
        .toList();
    var dateKom = await userKomuniCollection
        .find(where
            .eq("idUser", data[0])
            .eq("status", 0)
            .sortBy('tanggalDaftar', descending: true)
            .limit(1))
        .toList();

    var dateKeg = await userKegiatanCollection
        .find(where
            .eq("idUser", data[0])
            .eq("status", 0)
            .sortBy('tanggalDaftar', descending: true)
            .limit(1))
        .toList();

    DateTime ans = DateTime.utc(1989, 11, 9);
    var hasil = null;
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
      }
    } catch (e) {}
    try {
      if (ans.compareTo(
              DateTime.parse(dateKri[0]['tanggalDaftar'].toString())) <
          0) {
        ans = DateTime.parse(dateKri[0]['tanggalDaftar'].toString());
        hasil = dateKri;
      }
    } catch (e) {}

    var gambarGerejaCollection =
        MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
    var connGambar = await gambarGerejaCollection
        .find(
            where.sortBy('tanggal', descending: false).eq("status", 0).limit(4))
        .toList();

    if (hasil != null) {
      var jadwalCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
      var conn =
          await jadwalCollection.find({'_id': hasil[0]['idGereja']}).toList();
      Messages message = Messages('Agent Pencarian', sender, "INFORM",
          Tasks('hasil pencarian', [dataUser, conn, hasil, connGambar]));
      return message;
    } else {
      Messages message = Messages('Agent Pencarian', sender, "INFORM",
          Tasks('hasil pencarian', [dataUser, null, hasil, connGambar]));
      return message;
    }
  }

  Future<Messages> cariPengumuman(dynamic data, String sender) async {
    var pengumumanCollection =
        MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
    if (data[0] == "general") {
      final pipeline = AggregationPipelineBuilder()
          .addStage(Lookup(
              from: 'Gereja',
              localField: 'idGereja',
              foreignField: '_id',
              as: 'GerejaPengumuman'))
          .addStage(Match(where.eq('status', 0).map['\$query']))
          .build();
      var conn =
          await pengumumanCollection.aggregateToStream(pipeline).toList();
      Messages message = Messages(
          'Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', conn));
      return message;
    } else {
      var pengumumanCollection =
          MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
      final pipeline = AggregationPipelineBuilder()
          .addStage(Lookup(
              from: 'Gereja',
              localField: 'idGereja',
              foreignField: '_id',
              as: 'GerejaPengumuman'))
          .addStage(Match(where.eq("_id", data[1]).map['\$query']))
          .build();
      var conn =
          await pengumumanCollection.aggregateToStream(pipeline).toList();
      Messages message = Messages(
          'Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', conn));
      return message;
    }
  }

  Future<Messages> cariPelayanan(dynamic data, String sender) async {
    var pelayananCollection;
    var aturanCollection =
        MongoDatabase.db.collection(ATURAN_PELAYANAN_COLLECTION);
    String as = "";
    //////BAPTIS ATAU KOMUNI ATAU KRISMA
    if (data[0] == "baptis" || data[0] == "krisma" || data[0] == "komuni") {
      if (data[0] == "baptis") {
        pelayananCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
        as = "GerejaBaptis";
      }

      if (data[0] == "komuni") {
        pelayananCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
        as = "GerejaKomuni";
      }
      if (data[0] == "krisma") {
        pelayananCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
        as = "GerejaKrisma";
      }
      if (data[1] == "general") {
        final pipeline = AggregationPipelineBuilder()
            .addStage(Lookup(
                from: 'Gereja',
                localField: 'idGereja',
                foreignField: '_id',
                as: as))
            .addStage(Match(where
                .eq('status', 0)
                .gt("kapasitas", 0)
                .gte("jadwalTutup", DateTime.now())
                .map['\$query']))
            .build();
        var conn =
            await pelayananCollection.aggregateToStream(pipeline).toList();
        Messages message = Messages('Agent Pencarian', sender, "INFORM",
            Tasks('hasil pencarian', conn));
        return message;
      } else {
        var aturan =
            await aturanCollection.find(where.eq("idGereja", data[3])).toList();

        final pipeline = AggregationPipelineBuilder()
            .addStage(Lookup(
                from: 'Gereja',
                localField: 'idGereja',
                foreignField: '_id',
                as: as))
            .addStage(Match(where.eq('_id', data[2]).map['\$query']))
            .build();
        var conn =
            await pelayananCollection.aggregateToStream(pipeline).toList();
        Messages message = Messages('Agent Pencarian', sender, "INFORM",
            Tasks('hasil pencarian', [conn, aturan]));
        return message;
      }
    }

    ////PERKAWINAN atau SAKRAMENTALI atau TOBAT atau PERMINYAKAN
    else if (data[0] == "perkawinan" ||
        data[0] == "sakramentali" ||
        data[0] == "tobat" ||
        data[0] == "perminyakan") {
      String status = "";
      if (data[0] == "tobat") {
        pelayananCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
        as = "GerejaTobat";
        status = "statusTobat";
      }
      if (data[0] == "perminyakan") {
        pelayananCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
        as = "GerejaPerminyakan";
        status = "statusPerminyakan";
      }
      if (data[0] == "perkawinan") {
        pelayananCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
        as = "GerejaImam";
        status = "statusPerkawinan";
      }
      if (data[0] == "sakramentali") {
        pelayananCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
        as = "GerejaImam";
        status = "statusPemberkatan";
      }
      if (data[1] == "history") {
        var conn = await MongoDatabase.db
            .collection(PEMBERKATAN_COLLECTION)
            .find({'_id': data[2]}).toList();
        Messages message = Messages('Agent Pencarian', sender, "INFORM",
            Tasks('hasil pencarian', conn));
        return message;
      } else if (data[1] == "general") {
        final pipeline = AggregationPipelineBuilder()
            .addStage(Lookup(
                from: 'Gereja',
                localField: 'idGereja',
                foreignField: '_id',
                as: as))
            .addStage(Match(where.eq('statusPerkawinan', 0).map['\$query']))
            .build();
        var conn =
            await pelayananCollection.aggregateToStream(pipeline).toList();
        Messages message = Messages('Agent Pencarian', sender, "INFORM",
            Tasks('hasil pencarian', conn));
        return message;
      } else if (data[1] == "imam") {
        var conn = await pelayananCollection
            .find({'idGereja': data[2], status: 0, "banned": 0}).toList();
        Messages message = Messages('Agent Pencarian', sender, "INFORM",
            Tasks('hasil pencarian', conn));
        return message;
      } else {
        if (data[0] == "perminyakan" || data[0] == "tobat") {
          var aturan = await aturanCollection
              .find(where.eq("idGereja", data[3]))
              .toList();

          final pipeline = AggregationPipelineBuilder()
              .addStage(Lookup(
                  from: 'Gereja',
                  localField: 'idGereja',
                  foreignField: '_id',
                  as: as))
              .addStage(Match(where.eq('_id', data[2]).map['\$query']))
              .build();
          var conn =
              await pelayananCollection.aggregateToStream(pipeline).toList();
          Messages message = Messages('Agent Pencarian', sender, "INFORM",
              Tasks('hasil pencarian', [conn, aturan]));
          return message;
        } else {
          var aturan = await aturanCollection
              .find(where.eq("idGereja", data[2]))
              .toList();
          Messages message = Messages('Agent Pencarian', sender, "INFORM",
              Tasks('hasil pencarian', aturan));
          return message;
        }
      }
    }

    ////UMUM
    else {
      pelayananCollection = MongoDatabase.db.collection(UMUM_COLLECTION);

      if (data[1] == "detail") {
        final pipeline = AggregationPipelineBuilder()
            .addStage(Lookup(
                from: 'Gereja',
                localField: 'idGereja',
                foreignField: '_id',
                as: 'GerejaKegiatan'))
            .addStage(Match(where.eq('_id', data[2]).map['\$query']))
            .build();
        var conn =
            await pelayananCollection.aggregateToStream(pipeline).toList();

        Messages message = Messages('Agent Pencarian', sender, "INFORM",
            Tasks('hasil pencarian', conn));
        return message;
      } else {
        var conn = await pelayananCollection
            .find(where
                .eq('jenisKegiatan', data[2])
                .eq("status", 0)
                .gt("kapasitas", 0)
                .gte("tanggal", DateTime.now()))
            .toList();
        Messages message = Messages('Agent Pencarian', sender, "INFORM",
            Tasks('hasil pencarian', conn));
        return message;
      }
    }
  }

  Messages rejectTask(dynamic task, sender) {
    Messages message = Messages(
        agentName,
        sender,
        "INFORM",
        Tasks('error', [
          ['failed']
        ]));

    print(this.agentName + ' rejected task form $sender: ${task.action}');
    return message;
  }

  Messages overTime(sender) {
    Messages message = Messages(
        sender,
        agentName,
        "INFORM",
        Tasks('error', [
          ['reject over time']
        ]));
    return message;
  }

  void _initAgent() {
    this.agentName = "Agent Pencarian";
    _plan = [
      Plan("cari pengumuman", "REQUEST", _estimatedTime),
      Plan("cari jadwal pendaftaran", "REQUEST", _estimatedTime),
      Plan("cari pelayanan", "REQUEST", _estimatedTime),
      Plan("cari tampilan home", "REQUEST", _estimatedTime),
      Plan("check pendaftaran", "REQUEST", _estimatedTime),
    ];
    _goals = [
      Goals("cari pengumuman", List<Map<String, Object?>>, 2),
      Goals("cari jadwal pendaftaran", List<dynamic>, 2),
      Goals("cari pelayanan", List<Map<String, Object?>>, 2),
      Goals("cari pelayanan", List<dynamic>, 2),
      Goals("cari tampilan home", List<dynamic>, 2),
      Goals("check pendaftaran", List<dynamic>, 2),
      Goals("check pendaftaran", String, 2),
    ];
  }
}
