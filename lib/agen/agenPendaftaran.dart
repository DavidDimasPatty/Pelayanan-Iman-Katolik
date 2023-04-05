// import 'dart:developer';
// import 'dart:ffi';

// import 'package:mongo_dart/mongo_dart.dart';
// import 'package:pelayanan_iman_katolik/DatabaseFolder/data.dart';
// import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';

// import 'messages.dart';

// class AgenPendaftaran {
//   static var dataPencarian;
//   AgenPendaftaran() {
//     ReadyBehaviour();
//     ReceiveBehaviour();
//     ResponsBehaviour();
//   }
//   setDataTampilan(data) {
//     dataPencarian = data;
//   }

//   receiverTampilan() {
//     return dataPencarian;
//   }

//   ReceiveBehaviour() {
//     Messages msg = Messages();

//     var data = msg.receive();
//     print("APAANIH DATANYA");
//     print(data.runtimeType);
//     action() async {
//       try {
//         if (data.runtimeType == List<Map<String, Object?>>) {
//           await setDataTampilan(data);
//         }

//         if (data.runtimeType == int) {
//           await setDataTampilan(data);
//         }
//       } catch (e) {}
//     }

//     action();
//   }

//   ResponsBehaviour() {
//     Messages msg = Messages();

//     var data = msg.receive();
//     action() async {
//       try {
//         if (data.runtimeType == List<List<dynamic>>) {
//           if (data[0][0] == "add Pemberkatan") {
//             try {
//               var pemberkatanCollection =
//                   MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
//               var checkEmail;

//               var hasil = await pemberkatanCollection.insertOne({
//                 'idUser': data[1][0],
//                 'namaLengkap': data[2][0],
//                 'paroki': data[3][0],
//                 'lingkungan': data[4][0],
//                 'notelp': data[5][0],
//                 'alamat': data[6][0],
//                 'jenis': data[7][0],
//                 'tanggal': DateTime.parse(data[8][0]),
//                 'note': data[9][0],
//                 'idGereja': data[10][0],
//                 'idImam': data[11][0],
//                 'status': 0
//               }).then((result) async {
//                 msg.addReceiver("agenPage");
//                 msg.setContent("oke");
//                 await msg.send();
//               });
//             } catch (e) {
//               print(e);
//               msg.addReceiver("agenPage");
//               msg.setContent("failed");
//               await msg.send();
//             }
//           }
//           if (data[0][0] == "add Perkawinan") {
//             try {
//               var perkawinanCollection =
//                   MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
//               var checkEmail;

//               var hasil = await perkawinanCollection.insertOne({
//                 'idUser': data[1][0],
//                 'namaPria': data[2][0],
//                 'namaPerempuan': data[3][0],
//                 'notelp': data[4][0],
//                 'alamat': data[5][0],
//                 'email': data[6][0],
//                 'tanggal': DateTime.parse(data[7][0]),
//                 'note': data[8][0],
//                 'idGereja': data[9][0],
//                 'idImam': data[10][0],
//                 'status': 0
//               }).then((result) async {
//                 msg.addReceiver("agenPage");
//                 msg.setContent("oke");
//                 await msg.send();
//               });
//             } catch (e) {
//               print(e);
//               msg.addReceiver("agenPage");
//               msg.setContent("failed");
//               await msg.send();
//             }
//           }

//           if (data[0][0] == "enroll Baptis") {
//             msg.addReceiver("agenPencarian");
//             msg.setContent([
//               ['enroll baptis pencarian'],
//               [data[1][0]],
//               [data[2][0]]
//             ]);
//             await msg.send();
//             await Future.delayed(Duration(seconds: 1));
//             var res = await receiverTampilan();
//             print(res);
//             if (res == 0) {
//               var daftarBaptisCollection =
//                   MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
//               var baptisCollection =
//                   MongoDatabase.db.collection(BAPTIS_COLLECTION);
//               var hasil = await daftarBaptisCollection.insertOne({
//                 'idBaptis': data[1][0],
//                 'idUser': data[2][0],
//                 "tanggalDaftar": DateTime.now(),
//                 'status': 0
//               });

//               var update = await baptisCollection
//                   .updateOne(where.eq('_id', data[1][0]),
//                       modify.set('kapasitas', data[3][0] - 1))
//                   .then((result) async {
//                 msg.addReceiver("agenPage");
//                 msg.setContent("oke");
//                 await msg.send();
//               });
//             }
//             if (res > 0) {
//               print("????");
//               msg.addReceiver("agenPage");
//               msg.setContent("sudah");
//               await msg.send();
//             }
//           }

//           if (data[0][0] == "cancel Baptis") {
//             try {
//               var baptisCollection =
//                   MongoDatabase.db.collection(BAPTIS_COLLECTION);
//               var tiket = MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
//               var conn = await tiket.updateOne(
//                   where.eq('_id', data[1][0]), modify.set('status', -1));

//               var update = await baptisCollection
//                   .updateOne(where.eq('_id', data[2][0]),
//                       modify.set('kapasitas', data[3][0] + 1))
//                   .then((result) async {
//                 msg.addReceiver("agenPage");
//                 msg.setContent("oke");
//                 await msg.send();
//               });
//             } catch (e) {
//               msg.addReceiver("agenPage");
//               msg.setContent("failed");
//               await msg.send();
//             }
//           }

//           if (data[0][0] == "enroll Komuni") {
//             var daftarKomuniCollection =
//                 MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
//             msg.addReceiver("agenPencarian");
//             msg.setContent([
//               ['enroll komuni pencarian'],
//               [data[1][0]],
//               [data[2][0]]
//             ]);
//             await msg.send();
//             await Future.delayed(Duration(seconds: 1));
//             var res = await receiverTampilan();
//             print(res);
//             if (res == 0) {
//               try {
//                 var daftarKomuniCollection =
//                     MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
//                 var komuniCollection =
//                     MongoDatabase.db.collection(KOMUNI_COLLECTION);
//                 var hasil = await daftarKomuniCollection.insertOne({
//                   'idKomuni': data[1][0],
//                   'idUser': data[2][0],
//                   "tanggalDaftar": DateTime.now(),
//                   'status': 0
//                 });

//                 var update = await komuniCollection
//                     .updateOne(where.eq('_id', data[1][0]),
//                         modify.set('kapasitas', data[3][0] - 1))
//                     .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent("oke");
//                   await msg.send();
//                 });
//               } catch (e) {
//                 msg.addReceiver("agenPage");
//                 msg.setContent("failed");
//                 await msg.send();
//               }
//             } else {
//               msg.addReceiver("agenPage");
//               msg.setContent("sudah");
//               await msg.send();
//             }
//           }

//           if (data[0][0] == "cancel Komuni") {
//             try {
//               var baptisCollection =
//                   MongoDatabase.db.collection(KOMUNI_COLLECTION);
//               var tiket = MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
//               var conn = await tiket.updateOne(
//                   where.eq('_id', data[1][0]), modify.set('status', -1));

//               var update = await baptisCollection
//                   .updateOne(where.eq('_id', data[2][0]),
//                       modify.set('kapasitas', data[3][0] + 1))
//                   .then((result) async {
//                 msg.addReceiver("agenPage");
//                 msg.setContent("oke");
//                 await msg.send();
//               });
//             } catch (e) {
//               msg.addReceiver("agenPage");
//               msg.setContent("failed");
//               await msg.send();
//             }
//           }

//           if (data[0][0] == "enroll Krisma") {
//             var daftarKrismaCollection =
//                 MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
//             msg.addReceiver("agenPencarian");
//             msg.setContent([
//               ['enroll krisma pencarian'],
//               [data[1][0]],
//               [data[2][0]]
//             ]);
//             await msg.send();
//             await Future.delayed(Duration(seconds: 1));
//             var res = await receiverTampilan();
//             print(res);
//             if (res == 0) {
//               try {
//                 var daftarKrismaCollection =
//                     MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
//                 var komuniCollection =
//                     MongoDatabase.db.collection(KRISMA_COLLECTION);
//                 var hasil = await daftarKrismaCollection.insertOne({
//                   'idKrisma': data[1][0],
//                   'idUser': data[2][0],
//                   'status': 0,
//                   'tanggalDaftar': DateTime.now()
//                 });

//                 var update = await komuniCollection
//                     .updateOne(where.eq('_id', data[1][0]),
//                         modify.set('kapasitas', data[3][0] - 1))
//                     .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent("oke");
//                   await msg.send();
//                 });
//               } catch (e) {
//                 msg.addReceiver("agenPage");
//                 msg.setContent("failed");
//                 await msg.send();
//               }
//             } else {
//               msg.addReceiver("agenPage");
//               msg.setContent("sudah");
//               await msg.send();
//             }
//           }

//           if (data[0][0] == "cancel Krisma") {
//             try {
//               var baptisCollection =
//                   MongoDatabase.db.collection(KRISMA_COLLECTION);
//               var tiket = MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
//               var conn = await tiket.updateOne(
//                   where.eq('_id', data[1][0]), modify.set('status', -1));

//               var update = await baptisCollection
//                   .updateOne(where.eq('_id', data[2][0]),
//                       modify.set('kapasitas', data[3][0] + 1))
//                   .then((result) async {
//                 msg.addReceiver("agenPage");
//                 msg.setContent("oke");
//                 await msg.send();
//               });
//             } catch (e) {
//               msg.addReceiver("agenPage");
//               msg.setContent("failed");
//               await msg.send();
//             }
//           }

//           if (data[0][0] == "cancel Pemberkatan") {
//             try {
//               var tiket = MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
//               var conn = await tiket
//                   .updateOne(
//                       where.eq('_id', data[1][0]), modify.set('status', -2))
//                   .then((result) async {
//                 msg.addReceiver("agenPage");
//                 msg.setContent("oke");
//                 await msg.send();
//               });
//             } catch (e) {
//               msg.addReceiver("agenPage");
//               msg.setContent("failed");
//               await msg.send();
//             }
//           }

//           if (data[0][0] == "enroll Kegiatan") {
//             var daftarUmumCollection =
//                 MongoDatabase.db.collection(USER_UMUM_COLLECTION);
//             msg.addReceiver("agenPencarian");
//             msg.setContent([
//               ['enroll umum pencarian'],
//               [data[1][0]],
//               [data[2][0]]
//             ]);
//             await msg.send();
//             await Future.delayed(Duration(seconds: 1));
//             var res = await receiverTampilan();
//             if (res == 0) {
//               try {
//                 var daftarUmumCollection =
//                     MongoDatabase.db.collection(USER_UMUM_COLLECTION);
//                 var umumCollection =
//                     MongoDatabase.db.collection(UMUM_COLLECTION);
//                 var hasil = await daftarUmumCollection.insertOne({
//                   'idKegiatan': data[1][0],
//                   'idUser': data[2][0],
//                   'tanggalDaftar': DateTime.now(),
//                   'status': 0
//                 });

//                 var update = await umumCollection
//                     .updateOne(where.eq('_id', data[1][0]),
//                         modify.set('kapasitas', data[3][0] - 1))
//                     .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent("oke");
//                   await msg.send();
//                 });
//               } catch (e) {
//                 msg.addReceiver("agenPage");
//                 msg.setContent("failed");
//                 await msg.send();
//               }
//             } else {
//               msg.addReceiver("agenPage");
//               msg.setContent("sudah");
//               await msg.send();
//             }
//           }

//           if (data[0][0] == "cancel Umum") {
//             try {
//               var baptisCollection =
//                   MongoDatabase.db.collection(UMUM_COLLECTION);
//               var tiket = MongoDatabase.db.collection(USER_UMUM_COLLECTION);
//               var conn = await tiket.updateOne(
//                   where.eq('_id', data[1][0]), modify.set('status', -1));

//               var update = await baptisCollection
//                   .updateOne(where.eq('_id', data[2][0]),
//                       modify.set('kapasitas', data[3][0] + 1))
//                   .then((result) async {
//                 msg.addReceiver("agenPage");
//                 msg.setContent("oke");
//                 await msg.send();
//               });
//             } catch (e) {
//               msg.addReceiver("agenPage");
//               msg.setContent("failed");
//               await msg.send();
//             }
//           }

// /////////////
//           /////////
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
//                   "tanggalDaftar": DateTime.now()
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
//           print("Agen Pendaftaran Ready");
//         }
//       } catch (e) {
//         return 0;
//       }
//     }

//     action();
//   }
// }
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
    for (var p in _plan) {
      if (p.goals == task.action) {
        Timer timer = Timer.periodic(Duration(seconds: p.time), (timer) {
          stop = true;
          timer.cancel();

          MessagePassing messagePassing = MessagePassing();
          Messages msg = rejectTask(task, sender);
          messagePassing.sendMessage(msg);
        });

        Messages message = await action(p.goals, task, sender);

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
      case "enroll pelayanan":
        return enrollPelayanan(data.data, sender);
      case "cancel pelayanan":
        return cancelPelayanan(data.data, sender);

      default:
        return rejectTask(data, data.sender);
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
        Messages message = Messages(agentName, sender, "INFORM",
            Tasks('status modifikasi data', "oke"));

        return message;
      } else {
        Messages message = Messages(agentName, sender, "INFORM",
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

      update2 = await userPelayananCollection.updateOne(
          where.eq('_id', data[1]),
          modify
              .set('status', -1)
              .set("updatedAt", DateTime.now())
              .set("updatedBy", data[1]));

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
                .set("updatedBy", data[1]));
      }
      if (data[0] == "perkawinan") {
        pelayananCollection =
            MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
        update1 = await pelayananCollection.updateOne(
            where.eq('_id', data[1]),
            modify
                .set('status', -2)
                .set("updatedAt", DateTime.now())
                .set("updatedBy", data[1]));
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
      Plan("enroll pelayanan", "REQUEST", _estimatedTime),
      Plan("cancel pelayanan", "REQUEST", _estimatedTime),
    ];
    _goals = [
      Goals("enroll pelayanan", String, 2),
      Goals("cancel pelayanan", String, 2),
    ];
  }
}
