import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';

import '../DatabaseFolder/data.dart';
import '../DatabaseFolder/fireBase.dart';
import '../DatabaseFolder/mongodb.dart';
import 'Agent.dart';
import 'Goals.dart';
import 'MessagePassing.dart';
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
        return enrollPelayanan(data.task.data, sender);
      case "cancel pelayanan":
        return cancelPelayanan(data.task.data, sender);

      default:
        return rejectTask(data.task.data, sender);
    }
  }

  Future<Messages> enrollPelayanan(dynamic data, String sender) async {
    var update1;
    var update2;
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

      update2 = await userPelayananCollection.insertOne({
        id: data[1],
        'idUser': data[2],
        "tanggalDaftar": DateTime.now(),
        'status': 0,
        'updatedAt': DateTime.now(),
        'updatedBy': data[1]
      });

      update1 = await pelayananCollection.updateOne(
          where.eq('_id', data[1]), modify.set('kapasitas', data[3] - 1));
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
        update1 = await pelayananCollection.insertOne({
          'idUser': data[1],
          'namaLengkap': data[2],
          'paroki': data[3],
          'lingkungan': data[4],
          'notelp': data[5],
          'alamat': data[6],
          'jenis': data[7],
          'tanggal': DateTime.parse(data[8]),
          'note': data[9],
          'idGereja': data[10],
          'idImam': data[11],
          'status': 0,
          'updatedAt': DateTime.now(),
          'updatedBy': data[1],
          'createdAt': DateTime.now(),
          'createdBy': data[1]
        });
      }
      if (data[0] == "perkawinan") {
        pelayananCollection =
            MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
        update1 = await pelayananCollection.insertOne({
          'idUser': data[1],
          'namaPria': data[2],
          'namaPerempuan': data[3],
          'notelp': data[4],
          'alamat': data[5],
          'email': data[6],
          'tanggal': DateTime.parse(data[7]),
          'note': data[8],
          'idGereja': data[9],
          'idImam': data[10],
          'status': 0,
          'updatedAt': DateTime.now(),
          'updatedBy': data[1],
          'createdAt': DateTime.now(),
          'createdBy': data[1]
        });
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

  Future<Messages> cancelPelayanan(dynamic data, String sender) async {
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
