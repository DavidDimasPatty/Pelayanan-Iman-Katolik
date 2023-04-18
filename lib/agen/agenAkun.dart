import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/fireBase.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/modelDB.dart';
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

  static int _estimatedTime = 5;
  static Map<String, int> _timeAction = {
    "login": _estimatedTime,
    "sign up": _estimatedTime,
    "cari user": _estimatedTime,
    "cari profile": _estimatedTime,
    "cari tampilan home": _estimatedTime,
    "edit profile": _estimatedTime,
    "update notification": _estimatedTime,
    "find password": _estimatedTime,
    "change password": _estimatedTime,
    "change profile picture": _estimatedTime,
    "log out": _estimatedTime
  };

  Future<Messages> action(String goals, dynamic data, String sender) async {
    switch (goals) {
      case "login":
        return _login(data.task.data, sender);
      case "cari user":
        return _cariUser(data.task.data, sender);
      case "cari profile":
        return _cariProfile(data.task.data, sender);
      case "cari tampilan home":
        return _cariTampilanHome(data.task.data, sender);
      case "edit profile":
        return _EditProfile(data.task.data, sender);
      case "update notification":
        return _updateNotification(data.task.data, sender);
      case "find password":
        return _cariPassword(data.task.data, sender);
      case "change password":
        return _gantiPassword(data.task.data, sender);
      case "change profile picture":
        return _changeProfilePicture(data.task.data, sender);
      case "log out":
        return _logout(data.task.data, sender);
      case "sign up":
        return _signup(data.task.data, sender);

      default:
        return rejectTask(data, sender);
    }
  }

  Future<Messages> _signup(dynamic data, String sender) async {
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
        var configJson = modelDB.user(data[0], data[1], data[2], "", 0, false,
            DateTime.now(), "", "", "", "", "", DateTime.now());

        var add = await userCollection.insertOne(configJson);
        if (add.isSuccess) {
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

  Future<Messages> _cariUser(dynamic data, String sender) async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var conn = await userCollection.find({'_id': data}).toList();
    Messages message = Messages(agentName, sender, "INFORM",
        Tasks("status modifikasi/ pencarian data akun", conn));
    return message;
  }

  Future<Messages> _login(dynamic data, String sender) async {
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

  Future<Messages> _logout(dynamic data, String sender) async {
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

  sendToAgenSettingLogout(dynamic data, String sender) async {
    Messages message =
        Messages(sender, "Agent Setting", "REQUEST", Tasks('log out', data));
    MessagePassing messagePassing = MessagePassing();
    messagePassing.sendMessage(message);
  }

  Future<Messages> _cariProfile(dynamic data, String sender) async {
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

  Future<Messages> _cariTampilanHome(dynamic data, String sender) async {
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

  Future<Messages> _EditProfile(dynamic data, String sender) async {
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

  Future<Messages> _updateNotification(dynamic data, String sender) async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var update = await userCollection.updateOne(where.eq('_id', data[0]),
        modify.set('notifGD', data[1]).set('updatedAt', DateTime.now()));
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

  Future<Messages> _cariPassword(dynamic data, String sender) async {
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

  Future<Messages> _gantiPassword(dynamic data, String sender) async {
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

  Future<Messages> _changeProfilePicture(dynamic data, String sender) async {
    var urlDownload = await FirebaseApi.configureUpload(
        'files/Pelayanan Imam Katolik/', data[1]);

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

  @override
  addEstimatedTime(String goals) {
    _timeAction[goals] = _timeAction[goals]! + 1;
  }

  void _initAgent() {
    this.agentName = "Agent Akun";
    plan = [
      Plan("login", "REQUEST"),
      Plan("sign up", "REQUEST"),
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
    goals = [
      Goals("login", List<Map<String, Object?>>, _timeAction["login"]),
      Goals("cari user", List<Map<String, Object?>>, _timeAction["cari user"]),
      Goals("cari profile", List<dynamic>, _timeAction["cari profile"]),
      Goals("cari tampilan home", List<dynamic>,
          _timeAction["cari tampilan home"]),
      Goals("edit profile", String, _timeAction["edit profile"]),
      Goals("update notification", String, _timeAction["update notification"]),
      Goals("find password", String, _timeAction["find password"]),
      Goals("change password", String, _timeAction["change password"]),
      Goals("change profile picture", String,
          _timeAction["change profile picture"]),
      Goals("log out", String, _timeAction["log out"]),
      Goals("sign up", String, _timeAction["sign up"]),
    ];
  }
}
