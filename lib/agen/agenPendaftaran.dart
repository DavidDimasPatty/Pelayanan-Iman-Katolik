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
    _initAgent();
  }

  static int _estimatedTime = 5;

  Future<Messages> action(String goals, dynamic data, String sender) async {
    switch (goals) {
      case "enroll pelayanan":
        return _enrollPelayanan(data.task.data, sender);
      case "cancel pelayanan":
        return _cancelPelayanan(data.task.data, sender);

      default:
        return rejectTask(data.task.data, sender);
    }
  }

  Future<Messages> _enrollPelayanan(dynamic data, String sender) async {
    var add1;
    var add2;
    var pelayananCollection;
    String id = "";
    var userPelayananCollection;
    if (data[0] != "perkawinan" && data[0] != "sakramentali") {
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

      var configJson = modelDB.userPelayanan(
          id, data[1], data[2], DateTime.now(), 0, DateTime.now(), data[1]);

      add2 = await userPelayananCollection.insertOne(configJson);

      add1 = await pelayananCollection.updateOne(
          where.eq('_id', data[1]), modify.set('kapasitas', data[3] - 1));
      if (add1.isSuccess && add2.isSuccess) {
        Messages message = Messages(agentName, "Agent Page", "INFORM",
            Tasks('status modifikasi data', "oke"));

        return message;
      } else {
        Messages message = Messages(agentName, "Agent Page", "INFORM",
            Tasks('status modifikasi data', "failed"));
        return message;
      }
    } else {
      if (data[0] == "sakramentali") {
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
            DateTime.now(),
            data[1]);

        add1 = await pelayananCollection.insertOne(configJson);
      }
      if (data[0] == "perkawinan") {
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
            DateTime.now(),
            data[1]);

        add1 = await pelayananCollection.insertOne(configJson);
      }
      if (add1.isSuccess) {
        Messages message = Messages(agentName, "Agent Page", "INFORM",
            Tasks('status modifikasi data', "oke"));

        return message;
      } else {
        Messages message = Messages(agentName, "Agent Page", "INFORM",
            Tasks('status modifikasi data', "failed"));
        return message;
      }
    }
  }

  Future<Messages> _cancelPelayanan(dynamic data, String sender) async {
    var update1;
    var update2;
    var pelayananCollection;
    String id;
    var userPelayananCollection;
    if (data[0] != "perkawinan" && data[0] != "sakramentali") {
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

      update1 = await userPelayananCollection.updateOne(
          where.eq('_id', data[1]),
          modify
              .set('status', -1)
              .set("updatedAt", DateTime.now())
              .set("updatedBy", data[4]));

      update2 = await pelayananCollection.updateOne(
          where.eq('_id', data[2]), modify.set('kapasitas', data[3] + 1));
      if (update1.isSuccess && update2.isSuccess) {
        Messages message = Messages(agentName, "Agent Page", "INFORM",
            Tasks('status modifikasi data', "oke"));

        return message;
      } else {
        Messages message = Messages(agentName, "Agent Page", "INFORM",
            Tasks('status modifikasi data', "failed"));
        return message;
      }
    } else {
      if (data[0] == "sakramentali") {
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
        Messages message = Messages(agentName, "Agent Page", "INFORM",
            Tasks('status modifikasi data', "oke"));

        return message;
      } else {
        Messages message = Messages(agentName, "Agent Page", "INFORM",
            Tasks('status modifikasi data', "failed"));
        return message;
      }
    }
  }

  addEstimatedTime() {
    _estimatedTime++;
  }

  _initAgent() {
    this.agentName = "Agent Pendaftaran";
    plan = [
      Plan("enroll pelayanan", "REQUEST"),
      Plan("cancel pelayanan", "REQUEST"),
    ];
    goals = [
      Goals("enroll pelayanan", String, _estimatedTime),
      Goals("cancel pelayanan", String, _estimatedTime),
    ];
  }
}
