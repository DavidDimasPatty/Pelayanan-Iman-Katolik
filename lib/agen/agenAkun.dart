// import 'dart:developer';
// import 'dart:io';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:mongo_dart/mongo_dart.dart';
// import 'package:pelayanan_iman_katolik/DatabaseFolder/data.dart';
// import 'package:pelayanan_iman_katolik/DatabaseFolder/fireBase.dart';
// import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
// import 'package:path_provider/path_provider.dart';
// import 'messages.dart';

// class AgenAkun {
//   AgenAkun() {
//     ReadyBehaviour();
//     ResponsBehaviour();
//   }

//   ResponsBehaviour() {
//     Messages msg = Messages();

//     var data = msg.receive();
//     action() async {
//       try {
//         if (data.runtimeType == List<List<dynamic>>) {
//           if (data[0][0] == "cari data user") {
//             var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
//             var conn = await userCollection
//                 .find({'_id': data[1][0]})
//                 .toList()
//                 .then((result) async {
//                   print(result);
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari user") {
//             var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
//             var conn = await userCollection
//                 .find({'email': data[1][0], 'password': data[2][0]})
//                 .toList()
//                 .then((result) async {
//                   if (result != 0) {
//                     var conn = await userCollection.updateOne(
//                         where
//                             .eq('email', data[1][0])
//                             .eq('password', data[2][0]),
//                         modify.set('token',
//                             await FirebaseMessaging.instance.getToken()));

//                     await msg.addReceiver("agenSetting");
//                     await msg.setContent([
//                       ["save data"],
//                       [result]
//                     ]);
//                     await msg.send();

//                     await msg.addReceiver("agenPage");
//                     await msg.setContent(result);
//                     await msg.send();
//                   } else {
//                     msg.addReceiver("agenPage");
//                     msg.setContent(result);
//                     await msg.send();
//                   }
//                 });
//           }
//           if (data[0][0] == "change Picture") {
//             DateTime now = new DateTime.now();
//             DateTime date = new DateTime(
//                 now.year, now.month, now.day, now.hour, now.minute, now.second);
//             final filename = date.toString();
//             final destination = 'files/$filename';
//             UploadTask? task = FirebaseApi.uploadFile(destination, data[2][0]);
//             final snapshot = await task!.whenComplete(() {});
//             final urlDownload = await snapshot.ref.getDownloadURL();

//             var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
//             var conn = await userCollection
//                 .updateOne(where.eq('_id', data[1][0]),
//                     modify.set('picture', urlDownload))
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent("oke");
//               await msg.send();
//             });
//           }
//           if (data[0][0] == "find Password") {
//             var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
//             var conn = await userCollection
//                 .find({'email': data[1][0], 'password': data[2][0]}).toList();
//             try {
//               print(conn[0]['_id']);
//               if (conn[0]['_id'] == null) {
//                 msg.addReceiver("agenPage");
//                 msg.setContent("not");
//                 await msg.send();
//               } else {
//                 msg.addReceiver("agenPage");
//                 msg.setContent("found");
//                 await msg.send();
//               }
//             } catch (e) {
//               msg.addReceiver("agenPage");
//               msg.setContent("not");
//               await msg.send();
//             }
//           }
//           if (data[0][0] == "ganti Password") {
//             var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
//             var conn = await userCollection
//                 .updateOne(where.eq('_id', data[1][0]),
//                     modify.set('password', data[2][0]))
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent("oke");
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "log out") {
//             var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
//             // final directory = await getApplicationDocumentsDirectory();
//             // var path = directory.path;
//             msg.addReceiver("agenSetting");
//             msg.setContent([
//               ["log out akun"]
//             ]);
//             await msg.send();

//             // final file = await File('$path/login.txt');
//             // await file.writeAsString("");

//             var conn = await userCollection
//                 .updateOne(where.eq('_id', data[1][0]), modify.set('token', ""))
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent("oke");
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "edit Profile") {
//             try {
//               var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
//               var conn = await userCollection.updateOne(
//                   where.eq('_id', data[1][0]), modify.set('name', data[2][0]));

//               var conn1 = await userCollection.updateOne(
//                   where.eq('_id', data[1][0]), modify.set('email', data[3][0]));

//               var conn2 = await userCollection.updateOne(
//                   where.eq('_id', data[1][0]),
//                   modify.set('paroki', data[4][0]));

//               var conn3 = await userCollection.updateOne(
//                   where.eq('_id', data[1][0]),
//                   modify.set(
//                     'lingkungan',
//                     data[5][0],
//                   ));

//               var conn4 = await userCollection.updateOne(
//                   where.eq('_id', data[1][0]),
//                   modify.set('notelp', data[6][0]));

//               var conn5 = await userCollection
//                   .updateOne(where.eq('_id', data[1][0]),
//                       modify.set('alamat', data[7][0]))
//                   .then((result) async {
//                 msg.addReceiver("agenPage");
//                 msg.setContent("oke");
//                 await msg.send();
//               });
//             } catch (e) {
//               print(e);
//             }
//           }

//           if (data[0][0] == "update NotifPG") {
//             var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
//             var conn = await userCollection
//                 .updateOne(where.eq('_id', data[1][0]),
//                     modify.set('notifPG', data[2][0]))
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent("oke");
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "update NotifGD") {
//             var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
//             var conn = await userCollection
//                 .updateOne(where.eq('_id', data[1][0]),
//                     modify.set('notifGD', data[2][0]))
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent("oke");
//               await msg.send();
//             });
//           }
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
//                   "tanggalDaftar": DateTime.now(),
//                   "paroki": "",
//                   "alamat": "",
//                   "lingkungan": "",
//                   "notelp": "",
//                   "token": ""
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

//   ReadyBehaviour() {
//     Messages msg = Messages();
//     var data = msg.receive();
//     action() {
//       try {
//         if (data == "ready") {
//           print("Agen Akun Ready");
//         }
//       } catch (e) {
//         return 0;
//       }
//     }

//     action();
//   }
// }
import 'dart:async';

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
              for (var g in _goals) {
                if (g.request == p.goals &&
                    g.goals == message.task.data.runtimeType) {
                  checkGoals = true;
                }
              }
              if (checkGoals == true) {
                print(agentName + ' returning data to ${message.receiver}');
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

  messageSetData(task) {
    pencarianData.add(task);
  }

  Future<List> getDataPencarian() async {
    return pencarianData;
  }

  Future<Messages> action(String goals, dynamic data, String sender) async {
    switch (goals) {
      case "login":
        return login(data, sender);
      case "cari user":
        return cariUser(data, sender);
      case "cari profile":
        return cariProfile(data, sender);
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

    sendToAgenSettingLogin(conn, agentName);
    Messages message = Messages(agentName, sender, "INFORM",
        Tasks("status modifikasi/ pencarian data akun", conn));
    return message;
  }

  Future<Messages> logout(dynamic data, String sender) async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var update = await userCollection.updateOne(
        where.eq('_id', data[0]), modify.set('token', ""));

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

  void sendToAgenSettingLogin(dynamic data, String sender) async {
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
        await userKrismaCollection.find({'idUser': data, 'status': 0}).length;

    var countB =
        await userBaptisCollection.find({'idUser': data, 'status': 0}).length;
    var countKo =
        await userKomuniCollection.find({'idUser': data, 'status': 0}).length;
    var countP = await userPemberkatanCollection
        .find({'idUser': data, 'status': 0}).length;
    var countKe =
        await userKegiatanCollection.find({'idUser': data, 'status': 0}).length;

    // return countKr + countB + countKo + countP + countKe;

    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var conn = await userCollection.find({'_id': data}).toList();

    Messages message = Messages(
        'Agent Pencarian',
        sender,
        "INFORM",
        Tasks("status modifikasi/ pencarian data akun",
            [conn, countKr + countB + countKo + countP + countKe]));
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
    final destination = 'files/$filename';
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
      Plan("login", "REQUEST", _estimatedTime),
      Plan("cari user", "REQUEST", _estimatedTime),
      Plan("cari profile", "REQUEST", _estimatedTime),
      Plan("edit profile", "REQUEST", _estimatedTime),
      Plan("update notification", "REQUEST", _estimatedTime),
      Plan("find password", "REQUEST", _estimatedTime),
      Plan("change password", "REQUEST", _estimatedTime),
      Plan("change profile picture", "REQUEST", _estimatedTime),
      Plan("log out", "REQUEST", _estimatedTime),
    ];
    _goals = [
      Goals("login", List<Map<String, Object?>>, 5),
      Goals("cari user", List<Map<String, Object?>>, 5),
      Goals("cari profile", List<dynamic>, 5),
      Goals("edit profile", String, 2),
      Goals("update notification", String, 2),
      Goals("find password", String, 2),
      Goals("change password", String, 2),
      Goals("change profile picture", String, 2),
      Goals("log out", String, 2),
    ];
  }
}
