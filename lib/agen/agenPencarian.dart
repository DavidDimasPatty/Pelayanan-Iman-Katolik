import 'dart:async';
import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import '../DatabaseFolder/data.dart';
import '../DatabaseFolder/mongodb.dart';
import 'Agent.dart';
import 'Goals.dart';
import 'MessagePassing.dart';
import 'Plan.dart';
import 'Task.dart';
import 'package:http/http.dart' as http;

class AgentPencarian extends Agent {
  AgentPencarian() {
    //Konstruktor agen memanggil fungsi initAgent
    _initAgent();
  }

  static int _estimatedTime = 5;
  //Batas waktu awal pengerjaan seluruh tugas agen
  static Map<String, int> _timeAction = {
    "cari pengumuman": _estimatedTime,
    "cari jadwal pendaftaran": _estimatedTime,
    "cari pelayanan": _estimatedTime,
    "cari tampilan home": _estimatedTime,
    "cari profile": _estimatedTime,
    "check pendaftaran": _estimatedTime,
    "cari alkitab": _estimatedTime
  };

  //Daftar batas waktu pengerjaan masing-masing tugas

  Future<Messages> action(String goals, dynamic data, String sender) async {
    //Daftar tindakan yang bisa dilakukan oleh agen, fungsi ini memilih tindakan
    //berdasarkan tugas yang berada pada isi pesan
    switch (goals) {
      case "cari pengumuman":
        return _cariPengumuman(data.task.data, sender);
      case "cari jadwal pendaftaran":
        return _cariJadwalPendaftaran(data.task.data, sender);
      case "cari pelayanan":
        return _cariPelayanan(data.task.data, sender);
      case "cari tampilan home":
        return _cariTampilanHome(data.task.data, sender);
      case "check pendaftaran":
        return _checkPendaftaran(data.task.data, sender);
      case "cari profile":
        return _cariProfile(data.task.data, sender);
      case "cari alkitab":
        return _cariAlkitab(data.task.data, sender);
      default:
        return rejectTask(data, sender);
    }
  }

  Future<Messages> _cariProfile(dynamic data, String sender) async {
    //Fungsi tindakan yang digunakan untuk mencari data halaman profile
    //dengan koordinasi dengan agen Akun
    //
    /////////////INISIALISASI VARIABEL////////////////////
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
    var pemberkatanCollection =
        MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
    var perkawinanCollection =
        MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
///////////////////////////////////////////////////////////////
    ///
////////CARI JUMLAH PENDAFTARAN YANG MASIH AKTIF YANG DILAKUKAN PENGGUNA//////
    var countKr = await userKrismaCollection
        .find({'idUser': data[0], 'status': 0}).length;
    var countB = await userBaptisCollection
        .find({'idUser': data[0], 'status': 0}).length;
    var countKo = await userKomuniCollection
        .find({'idUser': data[0], 'status': 0}).length;
    var countP = await userPemberkatanCollection
        .find({'idUser': data, 'status': 0}).length;
    var countKe = await userKegiatanCollection
        .find({'idUser': data[0], 'status': 0}).length;
    var countPem = await pemberkatanCollection
        .find({'idUser': data[0], 'status': 0}).length;
    var countPerk = await perkawinanCollection
        .find({'idUser': data[0], 'status': 0}).length;
/////////////////////////////////////////////////////////////////////////////
    Messages message = Messages(
        agentName,
        sender,
        "INFORM",
        Tasks("hasil pencarian", [
          data[1],
          countKr + countB + countKo + countP + countKe + countPem + countPerk
        ]));
    //mengirim pesan dengan isi data penjumlahan hasil pencarian
    return message;
  }

  Future<Messages> _checkPendaftaran(dynamic data, String sender) async {
    //Fungsi tindakan untuk mengecek apakah pengguna sudah mendaftar pelayanan
    //berkoordinasi dengan agen Pendaftaran
    var pelayananCollection;
    String id = "";
    //////Inisialisasi pelayanan berdasarkan data[0]///////////////////////////
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
    //////////////////////////////////////////////////////////////////////////////
    var hasil = await pelayananCollection
        .find(where.eq(id, data[1]).eq("idUser", data[2]).eq("status", 0))
        .length;
    //Mencari jumlah data yang pernah didaftarkan pengguna terhadap suatu pelayanan
    if (hasil == 0) {
      //Jika belum pernah mendaftar maka akan dikirim pesan pada agen Pendaftaran
      //dengan isi pesan "enroll pelayanan" dan data
      Completer<void> completer = Completer<void>(); //variabel untuk menunggu
      Messages message2 = Messages(sender, 'Agent Pendaftaran', "REQUEST",
          Tasks('enroll pelayanan', data));
      MessagePassing messagePassing2 = MessagePassing();
      await messagePassing2.sendMessage(message2);
      //Mengirim pesan kepada agen Pendaftaran
      Messages message = Messages(
          agentName, sender, "INFORM", Tasks('done', "Wait agent pendaftaran"));
      completer.complete(); //Batas pengerjaan yang memerlukan completer

      await completer
          .future; //Proses penungguan sudah selesai ketika varibel hasil
      //memiliki nilai
      return await message;
    } else {
      //Jika pengguna sudah pernah mendaftar kepada suatu pelayanan
      Messages message = Messages(
          agentName, sender, "INFORM", Tasks('hasil pencarian', "sudah"));
      return message;
    }
  }

  Future<Messages> _cariJadwalPendaftaran(dynamic data, String sender) async {
    //Fungsi tindakan untuk mencari data tampilan halaman jadwal dan history jadwal
    dynamic statusQuery;
    dynamic statusPemPer;

    if (data[0] == "current") {
      //Jika data[0] "current" yang berarti untuk halaman jadwal
      statusQuery = where.eq('idUser', data[1]).eq('status', 0).map['\$query'];
      statusPemPer = {'idUser': data[1], 'status': 0};
    }
    if (data[0] == "history") {
      //Jika data[0] "history" yang berarti untuk halaman history jadwal
      statusQuery = where.eq('idUser', data[1]).ne('status', 0).map['\$query'];
      statusPemPer = {'idUser': data[1]};
    }

    ////////Melakukan join pada masing masing pelayanan dengan UserPelayanan//////
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
////////////////////////////////////////////////////////////////////////////////////
    Messages message = Messages(
        agentName,
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
    //Membuat pesan yang berisikan data hasil pencarian dan pencarian dengan join
    return message;
  }

  Future<Messages> _cariTampilanHome(dynamic data, String sender) async {
    //Fungsi tindakan untuk mencari data yang dibutuhkan oleh halaman home
    ////////////////////INISIALISASI VARIABEL////////////////////////////
    var userKrismaCollection =
        MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
    var userBaptisCollection =
        MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
    var userKomuniCollection =
        MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
    var perkawinanCollection =
        MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
    var pemberkatanCollection =
        MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
    var userKegiatanCollection =
        MongoDatabase.db.collection(USER_UMUM_COLLECTION);
    //////////////////////////////////////////////////////////////////////
    ///
////////Mencari pendaftaran masing-masing pelayanan pengguna dengan waktu terdekat///////////
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

    var datePem = await pemberkatanCollection
        .find(where
            .eq("idUser", data[0])
            .eq("status", 0)
            .sortBy('tanggal', descending: true)
            .limit(1))
        .toList();

    var datePerk = await perkawinanCollection
        .find(where
            .eq("idUser", data[0])
            .eq("status", 0)
            .sortBy('tanggal', descending: true)
            .limit(1))
        .toList();
///////////////////////////////////////////////////////////////////////
    ///
//////////Membandingkan masing-masing pelayanan siapa yang paling dekat waktu mulainya/////////
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

    try {
      if (ans.compareTo(DateTime.parse(datePem[0]['tanggal'].toString())) < 0) {
        ans = DateTime.parse(datePem[0]['tanggal'].toString());
        hasil = datePem;
      }
    } catch (e) {}

    try {
      if (ans.compareTo(DateTime.parse(datePerk[0]['tanggal'].toString())) <
          0) {
        ans = DateTime.parse(datePerk[0]['tanggal'].toString());
        hasil = datePerk;
      }
    } catch (e) {}
//////////////////////////////////////////////////////////////////////////////////
    ///
    ///Mencari pengumuman data hanya diambil ke 4 terbaru////////////////////
    var gambarGerejaCollection =
        MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
    var connGambar = await gambarGerejaCollection
        .find(
            where.sortBy('tanggal', descending: false).eq("status", 0).limit(4))
        .toList();
/////////////////////////////////////////////////////////////////////////
    if (hasil != null) {
      ///Jika pengguna pernah melakukan pendaftaran ke salah satu pelayanan aktif
      var jadwalCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
      var conn =
          await jadwalCollection.find({'_id': hasil[0]['idGereja']}).toList();
      Messages message = Messages(agentName, sender, "INFORM",
          Tasks('hasil pencarian', [data[1], conn, hasil, connGambar]));
      return message;
    } else {
      ///Jika pengguna tidak pernah melakukan pendaftaran ke salah satu pelayanan aktif
      Messages message = Messages(agentName, sender, "INFORM",
          Tasks('hasil pencarian', [data[1], null, hasil, connGambar]));
      return message;
    }
  }

  Future<Messages> _cariPengumuman(dynamic data, String sender) async {
    //Fungsi tindakan untuk mencari data pada halaman pengumuman dan detail pengumuman
    var pengumumanCollection =
        MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
    if (data[0] == "general") {
      //Jika data[0] = general maka untuk halaman pengumuman
      final pipeline = AggregationPipelineBuilder()
          .addStage(Lookup(
              from: 'Gereja',
              localField: 'idGereja',
              foreignField: '_id',
              as: 'GerejaPengumuman'))
          .addStage(Match(where
              .eq('status', 0)
              .sortBy("createdAt", descending: true)
              .map['\$query']))
          .build();
      var conn =
          await pengumumanCollection.aggregateToStream(pipeline).toList();
      Messages message =
          Messages(agentName, sender, "INFORM", Tasks('hasil pencarian', conn));
      return message;
    } else {
      //Jika data[0] != general maka untuk halaman detail pengumuman
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
      Messages message =
          Messages(agentName, sender, "INFORM", Tasks('hasil pencarian', conn));
      //Membuat pesan yang berisikan hasil pencarian
      return message;
    }
  }

  // Future<Messages> _cariPelayanan(dynamic data, String sender) async {
  //   //Fungsi tindakan agen Pencarian untuk mencari data yang dibutuhkan pada
  //   //halaman pelayanan dan detail pelayanan
  //   var pelayananCollection;
  //   var aturanCollection =
  //       MongoDatabase.db.collection(ATURAN_PELAYANAN_COLLECTION);
  //   String as = "";
  //   //////BAPTIS ATAU KOMUNI ATAU KRISMA
  //   if (data[0] == "baptis" || data[0] == "krisma" || data[0] == "komuni") {
  //     if (data[0] == "baptis") {
  //       pelayananCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
  //       as = "GerejaBaptis";
  //     }

  //     if (data[0] == "komuni") {
  //       pelayananCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
  //       as = "GerejaKomuni";
  //     }
  //     if (data[0] == "krisma") {
  //       pelayananCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
  //       as = "GerejaKrisma";
  //     }
  //     if (data[1] == "general") {
  //       //Jika data[1] = general maka pencarian pada data halaman pelayanan
  //       final pipeline = AggregationPipelineBuilder()
  //           .addStage(Match(where
  //               .eq('status', 0)
  //               .gt("kapasitas", 0)
  //               .gte("jadwalTutup", DateTime.now())
  //               .map['\$query']))
  //           .addStage(Lookup(
  //               from: 'Gereja',
  //               localField: 'idGereja',
  //               foreignField: '_id',
  //               as: as))
  //           .build();
  //       var conn =
  //           await pelayananCollection.aggregateToStream(pipeline).toList();
  //       Messages message = Messages(
  //           agentName, sender, "INFORM", Tasks('hasil pencarian', conn));
  //       return message;
  //     } else {
  //       //Jika data[1] != general maka pencarian pada data halaman detail pelayanan
  //       var aturan =
  //           await aturanCollection.find(where.eq("idGereja", data[3])).toList();

  //       final pipeline = AggregationPipelineBuilder()
  //           .addStage(Lookup(
  //               from: 'Gereja',
  //               localField: 'idGereja',
  //               foreignField: '_id',
  //               as: as))
  //           .addStage(Match(where.eq('_id', data[2]).map['\$query']))
  //           .build();
  //       var conn =
  //           await pelayananCollection.aggregateToStream(pipeline).toList();
  //       Messages message = Messages(agentName, sender, "INFORM",
  //           Tasks('hasil pencarian', [conn, aturan]));
  //       return message;
  //     }
  //   }

  //   ////PERKAWINAN atau SAKRAMENTALI atau TOBAT atau PERMINYAKAN
  //   else if (data[0] == "perkawinan" ||
  //       data[0] == "sakramentali" ||
  //       data[0] == "tobat" ||
  //       data[0] == "perminyakan") {
  //     var pelayanan2Collection;
  //     String status = "";
  //     if (data[0] == "tobat") {
  //       pelayananCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
  //       as = "GerejaTobat";
  //       status = "statusTobat";
  //     }
  //     if (data[0] == "perminyakan") {
  //       pelayananCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
  //       as = "GerejaPerminyakan";
  //       status = "statusPerminyakan";
  //     }
  //     if (data[0] == "perkawinan") {
  //       pelayananCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
  //       pelayanan2Collection =
  //           MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
  //       as = "GerejaImam";
  //       status = "statusPerkawinan";
  //     }
  //     if (data[0] == "sakramentali") {
  //       pelayananCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
  //       pelayanan2Collection =
  //           MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
  //       as = "GerejaImam";
  //       status = "statusPemberkatan";
  //     }
  //     if (data[1] == "history") {
  //       //Jika data[1] = history maka pencarian untuk halaman history pelayanan
  //       var conn = await pelayanan2Collection.find({'_id': data[2]}).toList();
  //       Messages message = Messages(
  //           agentName, sender, "INFORM", Tasks('hasil pencarian', conn));
  //       return message;
  //     } else if (data[1] == "general") {
  //       //Jika data[1] = general maka pencarian untuk halaman pelayanan
  //       pelayananCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
  //       final pipeline = AggregationPipelineBuilder()
  //           .addStage(Lookup(
  //               from: 'imam',
  //               localField: '_id',
  //               foreignField: 'idGereja',
  //               as: as))
  //           .addStage(Match(where.eq("banned", 0).map['\$query']))
  //           .addStage(Match(where
  //               .eq('${as}.${status}', 0)
  //               .eq('${as}.role', 0)
  //               .map['\$query']))
  //           .build();
  //       var conn =
  //           await pelayananCollection.aggregateToStream(pipeline).toList();
  //       Messages message = Messages(
  //           agentName, sender, "INFORM", Tasks('hasil pencarian', conn));
  //       return message;
  //     } else if (data[1] == "imam") {
  //       var conn = await pelayananCollection.find(
  //           {'idGereja': data[2], status: 0, "banned": 0, "role": 0}).toList();
  //       Messages message = Messages(
  //           agentName, sender, "INFORM", Tasks('hasil pencarian', conn));
  //       return message;
  //     } else {
  //       if (data[0] == "perminyakan" || data[0] == "tobat") {
  //         var aturan = await aturanCollection
  //             .find(where.eq("idGereja", data[3]))
  //             .toList();

  //         final pipeline = AggregationPipelineBuilder()
  //             .addStage(Lookup(
  //                 from: 'Gereja',
  //                 localField: 'idGereja',
  //                 foreignField: '_id',
  //                 as: as))
  //             .addStage(Match(where.eq('_id', data[2]).map['\$query']))
  //             .build();
  //         var conn =
  //             await pelayananCollection.aggregateToStream(pipeline).toList();
  //         Messages message = Messages(agentName, sender, "INFORM",
  //             Tasks('hasil pencarian', [conn, aturan]));
  //         return message;
  //       } else {
  //         var aturan = await aturanCollection
  //             .find(where.eq("idGereja", data[2]))
  //             .toList();
  //         Messages message = Messages(
  //             agentName, sender, "INFORM", Tasks('hasil pencarian', aturan));
  //         return message;
  //       }
  //     }
  //   }

  //   ////UMUM
  //   else {
  //     pelayananCollection = MongoDatabase.db.collection(UMUM_COLLECTION);

  //     if (data[1] == "detail") {
  //       final pipeline = AggregationPipelineBuilder()
  //           .addStage(Lookup(
  //               from: 'Gereja',
  //               localField: 'idGereja',
  //               foreignField: '_id',
  //               as: 'GerejaKegiatan'))
  //           .addStage(Match(where.eq('_id', data[2]).map['\$query']))
  //           .build();
  //       var conn =
  //           await pelayananCollection.aggregateToStream(pipeline).toList();

  //       Messages message = Messages(
  //           agentName, sender, "INFORM", Tasks('hasil pencarian', conn));
  //       return message;
  //     } else {
  //       var conn = await pelayananCollection
  //           .find(where
  //               .eq('jenisKegiatan', data[2])
  //               .eq("status", 0)
  //               .gt("kapasitas", 0)
  //               .gte("tanggal", DateTime.now()))
  //           .toList();
  //       Messages message = Messages(
  //           agentName, sender, "INFORM", Tasks('hasil pencarian', conn));
  //       return message;
  //     }
  //   }
  // }
  Future<Messages> _cariPelayanan(dynamic data, String sender) async {
    //Fungsi tindakan agen Pencarian untuk mencari data yang dibutuhkan pada
    //halaman pelayanan dan detail pelayanan
    var pelayananCollection;
    var aturanCollection =
        MongoDatabase.db.collection(ATURAN_PELAYANAN_COLLECTION);
    String as = "GerejaPelayanan";
    //////BAPTIS ATAU KOMUNI ATAU KRISMA
    if (data[0] == "Baptis" || data[0] == "Krisma" || data[0] == "Komuni") {
      if (data[0] == "Baptis") {
        pelayananCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
        // as = "GerejaBaptis";
      }

      if (data[0] == "Komuni") {
        pelayananCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
        // as = "GerejaKomuni";
      }
      if (data[0] == "Krisma") {
        pelayananCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
        // as = "GerejaKrisma";
      }
      if (data[1] == "general") {
        //Jika data[1] = general maka pencarian pada data halaman pelayanan
        final pipeline = AggregationPipelineBuilder()
            .addStage(Match(where
                .eq('status', 0)
                .gt("kapasitas", 0)
                .gte("jadwalTutup", DateTime.now())
                .map['\$query']))
            .addStage(Lookup(
                from: 'Gereja',
                localField: 'idGereja',
                foreignField: '_id',
                as: as))
            .build();
        var conn =
            await pelayananCollection.aggregateToStream(pipeline).toList();
        Messages message = Messages(
            agentName, sender, "INFORM", Tasks('hasil pencarian', conn));
        return message;
      } else {
        //Jika data[1] != general maka pencarian pada data halaman detail pelayanan
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
        Messages message = Messages(agentName, sender, "INFORM",
            Tasks('hasil pencarian', [conn, aturan]));
        return message;
      }
    }

    ////PERKAWINAN atau SAKRAMENTALI atau TOBAT atau PERMINYAKAN
    else if (data[0] == "Perkawinan" ||
        data[0] == "Sakramentali" ||
        data[0] == "Tobat" ||
        data[0] == "Perminyakan") {
      var pelayanan2Collection;
      String status = "";
      if (data[0] == "Tobat") {
        pelayananCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
        // as = "GerejaTobat";
        status = "statusTobat";
      }
      if (data[0] == "Perminyakan") {
        pelayananCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
        // as = "GerejaPerminyakan";
        status = "statusPerminyakan";
      }
      if (data[0] == "Perkawinan") {
        pelayananCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
        pelayanan2Collection =
            MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
        // as = "GerejaImam";
        status = "statusPerkawinan";
      }
      if (data[0] == "Pemberkatan") {
        pelayananCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
        pelayanan2Collection =
            MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
        // as = "GerejaImam";
        status = "statusPemberkatan";
      }
      if (data[1] == "history") {
        //Jika data[1] = history maka pencarian untuk halaman history pelayanan
        var conn = await pelayanan2Collection.find({'_id': data[2]}).toList();
        Messages message = Messages(
            agentName, sender, "INFORM", Tasks('hasil pencarian', conn));
        return message;
      } else if (data[1] == "general") {
        //Jika data[1] = general maka pencarian untuk halaman pelayanan
        pelayananCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
        final pipeline = AggregationPipelineBuilder()
            .addStage(Lookup(
                from: 'imam',
                localField: '_id',
                foreignField: 'idGereja',
                as: as))
            .addStage(Match(where.eq("banned", 0).map['\$query']))
            .addStage(Match(where
                .eq('${as}.${status}', 0)
                .eq('${as}.role', 0)
                .map['\$query']))
            .build();
        var conn =
            await pelayananCollection.aggregateToStream(pipeline).toList();
        Messages message = Messages(
            agentName, sender, "INFORM", Tasks('hasil pencarian', conn));
        return message;
      } else if (data[1] == "imam") {
        var conn = await pelayananCollection.find(
            {'idGereja': data[2], status: 0, "banned": 0, "role": 0}).toList();
        Messages message = Messages(
            agentName, sender, "INFORM", Tasks('hasil pencarian', conn));
        return message;
      } else {
        if (data[0] == "Perminyakan" || data[0] == "Tobat") {
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
          Messages message = Messages(agentName, sender, "INFORM",
              Tasks('hasil pencarian', [conn, aturan]));
          return message;
        } else {
          var aturan = await aturanCollection
              .find(where.eq("idGereja", data[2]))
              .toList();
          Messages message = Messages(
              agentName, sender, "INFORM", Tasks('hasil pencarian', aturan));
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
                as: as))
            .addStage(Match(where.eq('_id', data[2]).map['\$query']))
            .build();
        var conn =
            await pelayananCollection.aggregateToStream(pipeline).toList();

        Messages message = Messages(
            agentName, sender, "INFORM", Tasks('hasil pencarian', conn));
        return message;
      } else {
        var conn = await pelayananCollection
            .find(where
                .eq('jenisKegiatan', data[2])
                .eq("status", 0)
                .gt("kapasitas", 0)
                .gte("tanggal", DateTime.now()))
            .toList();
        Messages message = Messages(
            agentName, sender, "INFORM", Tasks('hasil pencarian', conn));
        return message;
      }
    }
  }

  Future<Messages> _cariAlkitab(dynamic data, String sender) async {
    var hasilPencarian;
    Map<String, dynamic> jsonResponse;
    if (data[0] == "load data") {
      final url = Uri.parse("https://beeble.vercel.app/api/v1/passage/list");
      hasilPencarian = await http.get(
        url,
      );
      jsonResponse =
          Map<String, dynamic>.from(json.decode(hasilPencarian.body));
      hasilPencarian = [jsonResponse];
    } else if (data[0] == "cari ayat") {
      final url = Uri.parse("https://beeble.vercel.app/api/v1/passage/" +
          data[1].toString() +
          "/" +
          data[2].toString());
      hasilPencarian = await http.get(
        url,
      );

      jsonResponse =
          Map<String, dynamic>.from(json.decode(hasilPencarian.body));
      hasilPencarian = [jsonResponse];
    }
    Messages message = Messages(
        agentName, sender, "INFORM", Tasks('hasil pencarian', hasilPencarian));
    return message;
  }

  @override
  addEstimatedTime(String goals) {
    //Fungsi menambahkan batas waktu pengerjaan tugas dengan 1 detik
    _timeAction[goals] = _timeAction[goals]! + 1;
  }

  void _initAgent() {
    //Inisialisasi identitas agen
    this.agentName = "Agent Pencarian";
    //nama agen
    plan = [
      Plan("cari pengumuman", "REQUEST"),
      Plan("cari jadwal pendaftaran", "REQUEST"),
      Plan("cari pelayanan", "REQUEST"),
      Plan("cari tampilan home", "REQUEST"),
      Plan("check pendaftaran", "REQUEST"),
      Plan("cari profile", "REQUEST"),
      Plan("cari alkitab", "REQUEST"),
    ];
    //Perencanaan agen
    goals = [
      Goals("cari pengumuman", List<Map<String, Object?>>,
          _timeAction["cari pengumuman"]),
      Goals("cari jadwal pendaftaran", List<dynamic>,
          _timeAction["cari jadwal pendaftaran"]),
      Goals("cari pelayanan", List<Map<String, Object?>>,
          _timeAction["cari pelayanan"]),
      Goals("cari pelayanan", List<dynamic>, _timeAction["cari pelayanan"]),
      Goals("cari tampilan home", List<dynamic>,
          _timeAction["cari tampilan home"]),
      Goals(
          "check pendaftaran", List<dynamic>, _timeAction["check pendaftaran"]),
      Goals("cari profile", List<dynamic>, _timeAction["cari profile"]),
      Goals("check pendaftaran", String, _timeAction["check pendaftaran"]),
      Goals("cari alkitab", List<Map<String, dynamic>>,
          _timeAction["cari alkitab"]),
    ]; //goals agen
  }
}
