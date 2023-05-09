import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/modelDB.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import '../DatabaseFolder/data.dart';
import '../DatabaseFolder/mongodb.dart';
import 'Agent.dart';
import 'Goals.dart';
import 'Plan.dart';
import 'Task.dart';

class AgentPendaftaran extends Agent {
  AgentPendaftaran() {
    //Konstruktor agen memanggil fungsi initAgent
    _initAgent();
  }

  static int _estimatedTime = 5;
  //Batas waktu awal pengerjaan seluruh tugas agen
  static Map<String, int> _timeAction = {
    "enroll pelayanan": _estimatedTime,
    "cancel pelayanan": _estimatedTime,
  };
  //Daftar batas waktu pengerjaan masing-masing tugas

  Future<Messages> action(String goals, dynamic data, String sender) async {
    //Daftar tindakan yang bisa dilakukan oleh agen, fungsi ini memilih tindakan
    //berdasarkan tugas yang berada pada isi pesan
    switch (goals) {
      case "enroll pelayanan":
        return _enrollPelayanan(data.task.data, sender);
      case "cancel pelayanan":
        return _cancelPelayanan(data.task.data, sender);

      default:
        return rejectTask(data.task.data, sender);
    }
  }

  // Future<Messages> _enrollPelayanan(dynamic data, String sender) async {
  //   //Fungsi tindakan untuk menambahkan data baru pada
  //   //collection userPelayanan atau pelayanan
  //   /////Inisialisasi Variabel///////////////////////////////////////////////
  //   var add1;
  //   var add2;
  //   var pelayananCollection;
  //   String id = "";
  //   var userPelayananCollection;
  //   /////////////////////////////////////////////////////////////////////////
  //   //////////////////////////////Penjelasan data////////////////////////////
  //   /// ["baptis", idBaptis, idUser, kapasitas]
  //   ///data[0] = nama pelayanan
  //   ///data[1] = id pelayanan yang didaftar
  //   ///data[2] = id pengguna yang mendaftar
  //   ///data[3] = kapasitas pendaftaran
  //   ///
  //   ///  untuk data[0] = perkawinan
  //   /// [  "perkawinan",  iduser, namap, namaw,notelp,alamat, email,tanggal,
  //   // note, idGereja, idImam]
  //   ///  untuk data[0] = sakramentali
  //   /// [ "sakramentali", iduser, nama, paroki, lingkungan, notelp, alamat,
  //   ///     jenis, tanggal, note, idGereja, idImam]

  //   if (data[0] != "perkawinan" && data[0] != "sakramentali") {
  //     //Memberi nilai pada variabel pelayananCollection, id, dan userPelayananCollection
  //     //dari data yang diterima, jika data [0] bukan perkawinan dan sakramentali
  //     if (data[0] == "baptis") {
  //       pelayananCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
  //       userPelayananCollection =
  //           MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
  //       id = "idBaptis";
  //     }
  //     if (data[0] == "komuni") {
  //       pelayananCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
  //       userPelayananCollection =
  //           MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
  //       id = "idKomuni";
  //     }
  //     if (data[0] == "krisma") {
  //       pelayananCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
  //       userPelayananCollection =
  //           MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
  //       id = "idKrisma";
  //     }
  //     if (data[0] == "umum") {
  //       pelayananCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
  //       userPelayananCollection =
  //           MongoDatabase.db.collection(USER_UMUM_COLLECTION);
  //       id = "idKegiatan";
  //     }
  //     //////////////////////////////////////////////////////////////////
  //     ////////////Menambahkan data baru ke collection user pelayanan//////////
  //     var configJson = modelDB.userPelayanan(
  //         id, data[1], data[2], DateTime.now(), 0, DateTime.now(), data[1]);
  //     add2 = await userPelayananCollection.insertOne(configJson);
  //     ////////////////////////////////////////////////////////////////////////
  //     /////////////////////Memperbarui kapasitas pelayanan////////////////////
  //     add1 = await pelayananCollection.updateOne(
  //         where.eq('_id', data[1]), modify.set('kapasitas', data[3] - 1));
  //     /////////////////////////////////////////////////////////////////////
  //     if (add1.isSuccess && add2.isSuccess) {
  //       //Jika proses menambahkan dan memperbarui data berhasil
  //       Messages message = Messages(agentName, "Agent Page", "INFORM",
  //           Tasks('status modifikasi data', "oke"));

  //       return message;
  //     } else {
  //       //Jika proses menambahkan dan memperbarui data gagal
  //       Messages message = Messages(agentName, "Agent Page", "INFORM",
  //           Tasks('status modifikasi data', "failed"));
  //       return message;
  //     }
  //   } else {
  //     ///Jika data[0] sakramentali atau perkawinan
  //     if (data[0] == "sakramentali") {
  //       pelayananCollection =
  //           MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
  //       var configJson = modelDB.pemberkatan(
  //           data[1],
  //           data[10],
  //           data[11],
  //           data[2],
  //           data[3],
  //           data[4],
  //           data[5],
  //           data[6],
  //           data[7],
  //           DateTime.parse(data[8]),
  //           data[9],
  //           0,
  //           DateTime.now(),
  //           data[1],
  //           DateTime.now());
  //       add1 = await pelayananCollection.insertOne(configJson);
  //       ////////////Menambahkan data baru ke collection pelayanan//////////
  //     }
  //     if (data[0] == "perkawinan") {
  //       pelayananCollection =
  //           MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
  //       var configJson = modelDB.perkawinan(
  //           data[1],
  //           data[9],
  //           data[10],
  //           data[2],
  //           data[3],
  //           data[4],
  //           data[5],
  //           data[6],
  //           DateTime.parse(data[7]),
  //           data[8],
  //           0,
  //           DateTime.now(),
  //           data[1],
  //           DateTime.now());
  //       add1 = await pelayananCollection.insertOne(configJson);
  //       ////////////Menambahkan data baru ke collection pelayanan//////////
  //     }
  //     if (add1.isSuccess) {
  //       //Jika proses menambahkan data berhasil
  //       Messages message = Messages(agentName, "Agent Page", "INFORM",
  //           Tasks('status modifikasi data', "oke"));

  //       return message;
  //     } else {
  //       //Jika proses menambahkan data gagal
  //       Messages message = Messages(agentName, "Agent Page", "INFORM",
  //           Tasks('status modifikasi data', "failed"));
  //       return message;
  //     }
  //   }
  // }

  Future<Messages> _enrollPelayanan(dynamic data, String sender) async {
    //Fungsi tindakan untuk menambahkan data baru pada
    //collection userPelayanan atau pelayanan
    /////Inisialisasi Variabel///////////////////////////////////////////////
    var add1;
    var add2;
    var pelayananCollection;
    String id = "";
    var userPelayananCollection;
    /////////////////////////////////////////////////////////////////////////
    //////////////////////////////Penjelasan data////////////////////////////
    /// ["baptis", idBaptis, idUser, kapasitas]
    ///data[0] = nama pelayanan
    ///data[1] = id pelayanan yang didaftar
    ///data[2] = id pengguna yang mendaftar
    ///data[3] = kapasitas pendaftaran
    ///
    ///  untuk data[0] = perkawinan
    /// [  "perkawinan",  iduser, namap, namaw,notelp,alamat, email,tanggal,
    // note, idGereja, idImam]
    ///  untuk data[0] = sakramentali
    /// [ "sakramentali", iduser, nama, paroki, lingkungan, notelp, alamat,
    ///     jenis, tanggal, note, idGereja, idImam]

    if (data[0] != "Perkawinan" && data[0] != "Pemberkatan") {
      //Memberi nilai pada variabel pelayananCollection, id, dan userPelayananCollection
      //dari data yang diterima, jika data [0] bukan perkawinan dan sakramentali
      if (data[0] == "Baptis") {
        pelayananCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
        userPelayananCollection =
            MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
        id = "idBaptis";
      }
      if (data[0] == "Komuni") {
        pelayananCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
        userPelayananCollection =
            MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
        id = "idKomuni";
      }
      if (data[0] == "Krisma") {
        pelayananCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
        userPelayananCollection =
            MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
        id = "idKrisma";
      }
      if (data[0] == "Umum") {
        pelayananCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
        userPelayananCollection =
            MongoDatabase.db.collection(USER_UMUM_COLLECTION);
        id = "idKegiatan";
      }
      //////////////////////////////////////////////////////////////////
      ////////////Menambahkan data baru ke collection user pelayanan//////////
      var configJson = modelDB.userPelayanan(
          id, data[1], data[2], DateTime.now(), 0, DateTime.now(), data[1]);
      add2 = await userPelayananCollection.insertOne(configJson);
      ////////////////////////////////////////////////////////////////////////
      /////////////////////Memperbarui kapasitas pelayanan////////////////////
      add1 = await pelayananCollection.updateOne(
          where.eq('_id', data[1]), modify.set('kapasitas', data[3] - 1));
      /////////////////////////////////////////////////////////////////////
      if (add1.isSuccess && add2.isSuccess) {
        //Jika proses menambahkan dan memperbarui data berhasil
        Messages message = Messages(agentName, "Agent Page", "INFORM",
            Tasks('status modifikasi data', "oke"));

        return message;
      } else {
        //Jika proses menambahkan dan memperbarui data gagal
        Messages message = Messages(agentName, "Agent Page", "INFORM",
            Tasks('status modifikasi data', "failed"));
        return message;
      }
    } else {
      ///Jika data[0] sakramentali atau perkawinan
      if (data[0] == "Pemberkatan") {
        pelayananCollection =
            MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
        var configJson = modelDB.pemberkatan(
            data[1],
            data[10],
            data[11],
            data[2],
            data[3],
            data[4],
            data[5],
            data[6],
            data[7],
            DateTime.parse(data[8]),
            data[9],
            0,
            DateTime.now(),
            data[1],
            DateTime.now());
        add1 = await pelayananCollection.insertOne(configJson);
        ////////////Menambahkan data baru ke collection pelayanan//////////
      }
      if (data[0] == "Perkawinan") {
        pelayananCollection =
            MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
        var configJson = modelDB.perkawinan(
            data[1],
            data[9],
            data[10],
            data[2],
            data[3],
            data[4],
            data[5],
            data[6],
            DateTime.parse(data[7]),
            data[8],
            0,
            DateTime.now(),
            data[1],
            DateTime.now());
        add1 = await pelayananCollection.insertOne(configJson);
        ////////////Menambahkan data baru ke collection pelayanan//////////
      }
      if (add1.isSuccess) {
        //Jika proses menambahkan data berhasil
        Messages message = Messages(agentName, "Agent Page", "INFORM",
            Tasks('status modifikasi data', "oke"));

        return message;
      } else {
        //Jika proses menambahkan data gagal
        Messages message = Messages(agentName, "Agent Page", "INFORM",
            Tasks('status modifikasi data', "failed"));
        return message;
      }
    }
  }

  Future<Messages> _cancelPelayanan(dynamic data, String sender) async {
    //Fungsi tindakan untuk memperbarui dat pada
    //collection userPelayanan atau pelayanan
    /////Inisialisasi Variabel///////////////////////////////////////////////
    var update1;
    var update2;
    var pelayananCollection;
    String id = "";
    var userPelayananCollection;
    /////////////////////////////////////////////////////////////////////////
    //////////////////////////////PENJELASAN DATA////////////////////////////
    /// ["baptis", idUserBaptis, idBaptis, kapasitas, iduser]
    ///data[0] = nama pelayanan
    ///data[1] = id userPelayanan
    ///data[2] = id pelayanan yang didaftar
    ///data[3] = kapasitas pendaftaran
    ///data[4] = id pengguna
    ///
    ///
    if (data[0] != "perkawinan" && data[0] != "sakramentali") {
      //Memberi nilai pada variabel pelayananCollection, id, dan userPelayananCollection
      //dari data yang diterima, jika data [0] bukan perkawinan dan sakramentali
      if (data[0] == "baptis") {
        pelayananCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
        userPelayananCollection =
            MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
        id = "idBaptis";
      }
      if (data[0] == "komuni") {
        pelayananCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
        userPelayananCollection =
            MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
        id = "idKomuni";
      }
      if (data[0] == "krisma") {
        pelayananCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
        userPelayananCollection =
            MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
        id = "idKrisma";
      }
      if (data[0] == "umum") {
        pelayananCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
        userPelayananCollection =
            MongoDatabase.db.collection(USER_UMUM_COLLECTION);
        id = "idKegiatan";
      }
      //Memperbarui data status pada userPelayanan dan kapasitas pelayanan//
      update1 = await userPelayananCollection.updateOne(
          where.eq('_id', data[1]),
          modify
              .set('status', -1)
              .set("updatedAt", DateTime.now())
              .set("updatedBy", data[4]));

      update2 = await pelayananCollection.updateOne(
          where.eq('_id', data[2]), modify.set('kapasitas', data[3] + 1));
      //////////////////////////////////////////////////////////////////
      ///
      if (update1.isSuccess && update2.isSuccess) {
        //Jika pembaruan data berhasil maka akan dibuat pesan
        Messages message = Messages(agentName, "Agent Page", "INFORM",
            Tasks('status modifikasi data', "oke"));

        return message;
      } else {
        //Jika pembaruan data tidak berhasil maka akan dibuat pesan
        Messages message = Messages(agentName, "Agent Page", "INFORM",
            Tasks('status modifikasi data', "failed"));
        return message;
      }
    } else {
      //Jika data[0] sakramentali atau perkawinan
      if (data[0] == "sakramentali") {
        //Perbarui data status pelayanan sakramentali
        pelayananCollection =
            MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
        update1 = await pelayananCollection.updateOne(
            where.eq('_id', data[1]),
            modify
                .set('status', -2)
                .set("updatedAt", DateTime.now())
                .set("updatedBy", data[2]));
      }
      if (data[0] == "perkawinan") {
        //Perbarui data status pelayanan perkawinan
        pelayananCollection =
            MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
        update1 = await pelayananCollection.updateOne(
            where.eq('_id', data[1]),
            modify
                .set('status', -2)
                .set("updatedAt", DateTime.now())
                .set("updatedBy", data[2]));
      }
      if (update1.isSuccess) {
        //Jika pembaruan data berhasil maka akan dibuat pesan
        Messages message = Messages(agentName, "Agent Page", "INFORM",
            Tasks('status modifikasi data', "oke"));

        return message;
      } else {
        //Jika pembaruan data tidak berhasil maka akan dibuat pesan
        Messages message = Messages(agentName, "Agent Page", "INFORM",
            Tasks('status modifikasi data', "failed"));
        return message;
      }
    }
  }

  @override
  addEstimatedTime(String goals) {
    //Fungsi menambahkan batas waktu pengerjaan tugas dengan 1 detik
    _timeAction[goals] = _timeAction[goals]! + 1;
  }

  _initAgent() {
    //Inisialisasi identitas agen
    this.agentName = "Agent Pendaftaran";
    //nama agen
    plan = [
      Plan("enroll pelayanan", "REQUEST"),
      Plan("cancel pelayanan", "REQUEST"),
    ];
    //Perencanaan agen
    goals = [
      Goals("enroll pelayanan", String, _timeAction["enroll pelayanan"]),
      Goals("cancel pelayanan", String, _timeAction["cancel pelayanan"]),
    ]; //goals agen
  }
}
