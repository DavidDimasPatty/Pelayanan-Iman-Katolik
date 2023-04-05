// import 'package:flutter/material.dart';
// import 'package:mongo_dart/mongo_dart.dart';
// import 'package:pelayanan_iman_katolik/view/homePage.dart';

// import '../view/login.dart';
// import 'messages.dart';

// class AgenPage {
//   static var dataTampilan;
//   AgenPage() {
//     //measure
//     ReadyBehaviour();
//     //SendBehaviour();
//     ResponsBehaviour();
//   }
//   setDataTampilan(data) async {
//     dataTampilan = await data;
//   }

//   receiverTampilan() async {
//     return await dataTampilan;
//   }

//   ResponsBehaviour() async {
//     Messages msg = Messages();
//     var data = msg.receive();
//     print(data.runtimeType);

//     action() async {
//       try {
//         if (data.runtimeType == List<Map<String, Object?>>) {
//           await setDataTampilan(data);
//         }
//         if (data.runtimeType == String) {
//           await setDataTampilan(data);
//         }
//         if (data.runtimeType == List<dynamic>) {
//           await setDataTampilan(data);
//         }
//         if (data.runtimeType == List<List<dynamic>>) {
//           await setDataTampilan(data);
//         }
//       } catch (error) {
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
//         if (data[0][0] == "Application Setting Ready") {
//           if (data[2][0] == "pagi") {
//             if (data[1][0].length != 0 && data[1][0] != "nothing") {
//               var object = data[1][0][2]
//                   .toString()
//                   .substring(10, data[1][0][2].length - 2);
//               runApp(MaterialApp(
//                 title: 'Navigation Basics',
//                 theme: ThemeData(
//                   // Define the default brightness and colors.
//                   brightness: Brightness.light,
//                   primaryColor: Colors.grey,

//                   // Define the default font family.
//                   // fontFamily: 'Georgia',

//                   // Define the default `TextTheme`. Use this to specify the default
//                   // text styling for headlines, titles, bodies of text, and more.
//                   // textTheme: const TextTheme(
//                   //   displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
//                   //   titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
//                   //   bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
//                   // ),
//                 ),
//                 home: HomePage(
//                     data[0][0][0], data[0][0][1], ObjectId.parse(object)),
//               ));
//             } else {
//               print("Morning!");
//               runApp(MaterialApp(
//                 title: 'Navigation Basics',
//                 theme: ThemeData(
//                   // Define the default brightness and colors.
//                   brightness: Brightness.light,
//                   primaryColor: Colors.grey,

//                   // Define the default font family.
//                   // fontFamily: 'Georgia',

//                   // Define the default `TextTheme`. Use this to specify the default
//                   // text styling for headlines, titles, bodies of text, and more.
//                   // textTheme: const TextTheme(
//                   //   displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
//                   //   titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
//                   //   bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
//                   // ),
//                 ),
//                 home: Login(),
//               ));
//             }
//           } else {
//             if (data[1][0].length != 0 && data[1][0] != "nothing") {
//               var object = data[1][0][2]
//                   .toString()
//                   .substring(10, data[1][0][2].length - 2);
//               print("Night!");
//               runApp(MaterialApp(
//                 title: 'Navigation Basics',
//                 theme: ThemeData(
//                   brightness: Brightness.dark,
//                   primaryColor: Colors.grey,
//                   // ),
//                 ),
//                 home: HomePage(
//                     data[1][0][0], data[1][0][1], ObjectId.parse(object)),
//               ));
//             } else {
//               runApp(MaterialApp(
//                 title: 'Navigation Basics',
//                 theme: ThemeData(
//                   brightness: Brightness.dark,
//                   primaryColor: Colors.grey,
//                 ),
//                 home: Login(),
//               ));
//             }
//           }
//         }
//       } catch (error) {
//         return 0;
//       }
//     }

//     action();
//   }
// }
import 'dart:async';
import 'package:pelayanan_iman_katolik/agen/Message.dart';

import 'Agent.dart';
import 'Goals.dart';
import 'Plan.dart';
import 'Task.dart';

class AgentPage extends Agent {
  AgentPage() {
    _initAgent();
  }

  List<Plan> _plan = [];
  List<Goals> _goals = [];
  static List<dynamic> dataView = [];
  String agentName = "";
  int _estimatedTime = 1;
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
      action(p.goals, task.data, sender);
      print("View can use data store in " + agentName);
    }
  }

  static messageSetData(task) {
    dataView.add(task);
  }

  static Future getDataPencarian() async {
    return dataView.last;
  }

  Messages rejectTask(dynamic task, sender) {
    Messages message = Messages(
        agentName,
        sender,
        "INFORM",
        Tasks('error', [
          ['failed']
        ]));

    print(agentName + ' rejected task form $sender: ${task.action}');
    return message;
  }

  void _initAgent() {
    this.agentName = "Agent Page";
    _plan = [
      Plan("status modifikasi data", "INFORM",
          _estimatedTime), //come from agen Pendaftaran
      Plan("hasil pencarian", "INFORM",
          _estimatedTime), //come from agen Pencarian
      Plan(
          "status aplikasi", "INFORM", _estimatedTime), //come from agen Setting
      Plan("status modifikasi/ pencarian data akun", "INFORM",
          _estimatedTime), //come from agen Akun
    ];
    _goals = [
      Goals("status modifikasi data", String, 5),
      Goals("hasil pencarian", String, 5),
      Goals("status aplikasi", String, 5),
      Goals("status modifikasi/ pencarian data akun", String, 5),
    ];
  }

  @override
  void action(String goals, data, String sender) {
    messageSetData(data);
  }
}
