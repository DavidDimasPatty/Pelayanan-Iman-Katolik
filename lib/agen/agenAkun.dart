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

  Future<Messages> action(String goals, dynamic data, String sender) async {
    switch (goals) {
      case "login":
        return login(data.task.data, sender);
      case "cari user":
        return cariUser(data.task.data, sender);
      case "cari profile":
        return cariProfile(data.task.data, sender);
      case "cari tampilan home":
        return cariTampilanHome(data.task.data, sender);
      case "edit profile":
        return EditProfile(data.task.data, sender);
      case "update notification":
        return updateNotification(data.task.data, sender);
      case "find password":
        return cariPassword(data.task.data, sender);
      case "change password":
        return gantiPassword(data.task.data, sender);
      case "change profile picture":
        return changeProfilePicture(data.task.data, sender);
      case "log out":
        return logout(data.task.data, sender);
      case "sign up":
        return signup(data.task.data, sender);

      default:
        return rejectTask(data, sender);
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

  sendToAgenSettingLogout(dynamic data, String sender) async {
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

  addEstimatedTime() {
    _estimatedTime++;
  }

  _initAgent() {
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
      Goals("login", List<Map<String, Object?>>, _estimatedTime),
      Goals("cari user", List<Map<String, Object?>>, _estimatedTime),
      Goals("cari profile", List<dynamic>, _estimatedTime),
      Goals("cari tampilan home", List<dynamic>, _estimatedTime),
      Goals("edit profile", String, _estimatedTime),
      Goals("update notification", String, _estimatedTime),
      Goals("find password", String, _estimatedTime),
      Goals("change password", String, _estimatedTime),
      Goals("change profile picture", String, _estimatedTime),
      Goals("log out", String, _estimatedTime),
      Goals("sign up", String, _estimatedTime),
    ];
  }
}
