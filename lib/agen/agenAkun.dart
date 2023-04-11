import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/fireBase.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';

import '../DatabaseFolder/data.dart';
import '../DatabaseFolder/mongodb.dart';
import 'Agent.dart';
import 'Goals.dart';
import 'MessagePassing.dart';
import 'Plan.dart';

class AgentAkun extends Agent {
  AgentAkun() {
    _initAgent();
  }
  List<Plan> _plan = [];
  List<Goals> _goals = [];
  List<dynamic> pencarianData = [];
  String agentName = "";
  List _Message = [];
  List _Sender = [];
  bool stop = false;
  int _estimatedTime = 5;

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

    var goalsQuest =
        _goals.where((element) => element.request == task.action).toList();
    int clock = goalsQuest[0].time;

    Timer timer = Timer.periodic(Duration(seconds: clock), (timer) {
      stop = true;
      timer.cancel();

      MessagePassing messagePassing = MessagePassing();
      Messages msg = rejectTask(task, sender);
      messagePassing.sendMessage(msg);
      return;
    });

    Messages message = await action(task.action, task.data, sender);

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
            if (g.request == task.action &&
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
      case "login":
        return login(data, sender);
      case "cari user":
        return cariUser(data, sender);
      case "cari profile":
        return cariProfile(data, sender);
      case "cari tampilan home":
        return cariTampilanHome(data, sender);
      case "edit profile":
        return EditProfile(data, sender);
      case "update notification":
        return updateNotification(data, sender);
      case "find password":
        return cariPassword(data, sender);
      case "change password":
        return gantiPassword(data, sender);
      case "change profile picture":
        return changeProfilePicture(data, sender);
      case "log out":
        return logout(data, sender);
      case "sign up":
        return signup(data, sender);

      default:
        return rejectTask(data, data.sender);
    }
  }

  Future<Messages> signup(dynamic data, String sender) async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var checkEmail;
    var checkName;
    await userCollection.find({'name': data[0]}).toList().then((res) async {
          checkName = res;
          checkEmail = await userCollection.find({'email': data[1]}).toList();
        });

    try {
      if (checkName.length > 0) {
        Messages message = Messages(agentName, sender, "INFORM",
            Tasks("status modifikasi/ pencarian data akun", "nama"));
        return message;
      } else if (checkEmail.length > 0) {
        Messages message = Messages(agentName, sender, "INFORM",
            Tasks("status modifikasi/ pencarian data akun", "email"));
        return message;
      } else {
        var insert = await userCollection.insertOne({
          'name': data[0],
          'email': data[1],
          'password': data[2],
          'picture': "",
          "banned": 0,
          "notifGD": false,
          "notifPG": false,
          "tanggalDaftar": DateTime.now(),
          "paroki": "",
          "alamat": "",
          "lingkungan": "",
          "notelp": "",
          "token": ""
        });
        if (insert.isSuccess) {
          Messages message = Messages(agentName, sender, "INFORM",
              Tasks("status modifikasi/ pencarian data akun", "oke"));
          return message;
        } else {
          Messages message = Messages(agentName, sender, "INFORM",
              Tasks("status modifikasi/ pencarian data akun", "failed"));
          return message;
        }
      }
    } catch (e) {
      Messages message = Messages(agentName, sender, "INFORM",
          Tasks("status modifikasi/ pencarian data akun", "failed"));
      return message;
    }
  }

  Future<Messages> cariUser(dynamic data, String sender) async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var conn = await userCollection.find({'_id': data}).toList();
    Messages message = Messages(agentName, sender, "INFORM",
        Tasks("status modifikasi/ pencarian data akun", conn));
    return message;
  }

  Future<Messages> login(dynamic data, String sender) async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var conn = await userCollection
        .find({'email': data[0], 'password': data[1]}).toList();
    if (conn.length != 0) {
      var conn2 = await userCollection.updateOne(
          where.eq('email', data[0]).eq('password', data[1]),
          modify.set('token', await FirebaseMessaging.instance.getToken()));
      sendToAgenSettingLogin(conn, agentName);
    }

    Messages message = Messages(agentName, sender, "INFORM",
        Tasks("status modifikasi/ pencarian data akun", conn));
    return message;
  }

  Future<Messages> logout(dynamic data, String sender) async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var update = await userCollection.updateOne(
        where.eq('_id', data), modify.set('token', ""));

    sendToAgenSettingLogout(null, agentName);
    if (update.isSuccess) {
      Messages message = Messages(agentName, sender, "INFORM",
          Tasks("status modifikasi/ pencarian data akun", "oke"));
      return message;
    } else {
      Messages message = Messages(agentName, sender, "INFORM",
          Tasks("status modifikasi/ pencarian data akun", "failed"));
      return message;
    }
  }

  sendToAgenSettingLogin(dynamic data, String sender) async {
    Messages message =
        Messages(sender, "Agent Setting", "REQUEST", Tasks('save data', data));
    MessagePassing messagePassing = MessagePassing();
    messagePassing.sendMessage(message);
  }

  void sendToAgenSettingLogout(dynamic data, String sender) async {
    Messages message =
        Messages(sender, "Agent Setting", "REQUEST", Tasks('log out', data));
    MessagePassing messagePassing = MessagePassing();
    messagePassing.sendMessage(message);
  }

  Future<Messages> cariProfile(dynamic data, String sender) async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var conn = await userCollection.find({'_id': data}).toList();

    Messages message2 = Messages(sender, 'Agent Pencarian', "REQUEST",
        Tasks('cari profile', [data, conn]));
    MessagePassing messagePassing2 = MessagePassing();
    await messagePassing2.sendMessage(message2);

    Messages message = Messages(
        agentName, sender, "INFORM", Tasks("wait agen pencarian", "wait"));
    return message;
  }

  Future<Messages> cariTampilanHome(dynamic data, String sender) async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var conn = await userCollection.find({'_id': data}).toList();

    Messages message2 = Messages(sender, 'Agent Pencarian', "REQUEST",
        Tasks('cari tampilan home', [data, conn]));
    MessagePassing messagePassing2 = MessagePassing();
    await messagePassing2.sendMessage(message2);

    Messages message = Messages(
        agentName, sender, "INFORM", Tasks("wait agen pencarian", "wait"));
    return message;
  }

  Future<Messages> EditProfile(dynamic data, String sender) async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var update = await userCollection.updateOne(
        where.eq('_id', data[0]),
        modify
            .set('name', data[1])
            .set('email', data[2])
            .set('paroki', data[3])
            .set(
              'lingkungan',
              data[4],
            )
            .set('notelp', data[5])
            .set('alamat', data[6])
            .set('updatedAt', DateTime.now()));

    if (update.isSuccess) {
      Messages message = Messages(agentName, sender, "INFORM",
          Tasks("status modifikasi/ pencarian data akun", "oke"));
      return message;
    } else {
      Messages message = Messages(agentName, sender, "INFORM",
          Tasks("status modifikasi/ pencarian data akun", "failed"));
      return message;
    }
  }

  Future<Messages> updateNotification(dynamic data, String sender) async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var update = await userCollection.updateOne(where.eq('_id', data[0]),
        modify.set('notifPG', data[1]).set('updatedAt', DateTime.now()));
    if (update.isSuccess) {
      Messages message = Messages(agentName, sender, "INFORM",
          Tasks("status modifikasi/ pencarian data akun", "oke"));
      return message;
    } else {
      Messages message = Messages(agentName, sender, "INFORM",
          Tasks("status modifikasi/ pencarian data akun", "failed"));
      return message;
    }
  }

  Future<Messages> cariPassword(dynamic data, String sender) async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var conn = await userCollection
        .find({'_id': data[0], 'password': data[1]}).toList();
    try {
      if (conn[0]['_id'] == null) {
        Messages message = Messages(agentName, sender, "INFORM",
            Tasks("status modifikasi/ pencarian data akun", "not"));
        return message;
      } else {
        Messages message = Messages(agentName, sender, "INFORM",
            Tasks("status modifikasi/ pencarian data akun", "found"));
        return message;
      }
    } catch (e) {
      Messages message = Messages(agentName, sender, "INFORM",
          Tasks("status modifikasi/ pencarian data akun", "not"));
      return message;
    }
  }

  Future<Messages> gantiPassword(dynamic data, String sender) async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var update = await userCollection.updateOne(where.eq('_id', data[0]),
        modify.set('password', data[1]).set('updatedAt', DateTime.now()));

    if (update.isSuccess) {
      Messages message = Messages(agentName, sender, "INFORM",
          Tasks("status modifikasi/ pencarian data akun", "not"));
      return message;
    } else {
      Messages message = Messages(agentName, sender, "INFORM",
          Tasks("status modifikasi/ pencarian data akun", "found"));
      return message;
    }
  }

  Future<Messages> changeProfilePicture(dynamic data, String sender) async {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    final filename = date.toString();
    final destination = 'files/Pelayanan Imam Katolik/$filename';
    UploadTask? task = FirebaseApi.uploadFile(destination, data[1]);
    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var conn = await userCollection.updateOne(where.eq('_id', data[0]),
        modify.set('picture', urlDownload).set('updatedAt', DateTime.now()));
    if (conn.isSuccess) {
      Messages message = Messages(agentName, sender, "INFORM",
          Tasks("status modifikasi/ pencarian data akun", "not"));
      return message;
    } else {
      Messages message = Messages(agentName, sender, "INFORM",
          Tasks("status modifikasi/ pencarian data akun", "found"));
      return message;
    }
  }

  Messages rejectTask(dynamic task, sender) {
    Messages message = Messages(
        "Agent Akun",
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
        "Agent Akun",
        "INFORM",
        Tasks('error', [
          ['reject over time']
        ]));
    return message;
  }

  void _initAgent() {
    this.agentName = "Agent Akun";
    _plan = [
      Plan("login", "REQUEST"),
      Plan("cari user", "REQUEST"),
      Plan("cari profile", "REQUEST"),
      Plan("cari tampilan home", "REQUEST"),
      Plan("edit profile", "REQUEST"),
      Plan("update notification", "REQUEST"),
      Plan("find password", "REQUEST"),
      Plan("change password", "REQUEST"),
      Plan("change profile picture", "REQUEST"),
      Plan("log out", "REQUEST"),
    ];
    _goals = [
      Goals("login", List<Map<String, Object?>>, 5),
      Goals("cari user", List<Map<String, Object?>>, 5),
      Goals("cari profile", List<dynamic>, 5),
      Goals("cari tampilan home", List<dynamic>, 5),
      Goals("edit profile", String, 2),
      Goals("update notification", String, 2),
      Goals("find password", String, 2),
      Goals("change password", String, 2),
      Goals("change profile picture", String, 2),
      Goals("log out", String, 2),
    ];
  }
}
