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
  List<Plan> _plan = [];
  List<Goals> _goals = [];
  List<dynamic> pencarianData = [];
  String agentName = "";
  bool stop = false;
  int _estimatedTime = 5;
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
    var planQuest =
        _plan.where((element) => element.goals == task.action).toList();
    Plan p = planQuest[0];
    var goalsQuest =
        _goals.where((element) => element.request == p.goals).toList();
    int clock = goalsQuest[0].time;
    Goals goalquest = goalsQuest[0];

    Timer timer = Timer.periodic(Duration(seconds: clock), (timer) {
      stop = true;
      timer.cancel();

      MessagePassing messagePassing = MessagePassing();
      Messages msg = rejectTask(task, sender);
      messagePassing.sendMessage(msg);
      return;
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
          for (var g in _goals) {
            if (g.request == p.goals &&
                g.goals == message.task.data.runtimeType) {
              checkGoals = true;
              break;
            }
          }

          if (checkGoals == true) {
            print(agentName + ' returning data to ${message.receiver}');
            MessagePassing messagePassing = MessagePassing();
            messagePassing.sendMessage(message);
          } else {
            rejectTask(task, sender);
          }
        }
      }
    }
  }

  Future<Messages> action(String goals, dynamic data, String sender) async {
    switch (goals) {
      case "enroll pelayanan":
        return enrollPelayanan(data, sender);
      case "cancel pelayanan":
        return cancelPelayanan(data, sender);

      default:
        return rejectTask(data, sender);
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

  Messages rejectTask(dynamic task, sender) {
    Messages message = Messages(
        "Agent Pendaftaran",
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
        "Agent Pendaftaran",
        "INFORM",
        Tasks('error', [
          ['reject over time']
        ]));
    return message;
  }

  void _initAgent() {
    this.agentName = "Agent Pendaftaran";
    _plan = [
      Plan("enroll pelayanan", "REQUEST"),
      Plan("cancel pelayanan", "REQUEST"),
    ];
    _goals = [
      Goals("enroll pelayanan", String, 2),
      Goals("cancel pelayanan", String, 2),
    ];
  }
}
