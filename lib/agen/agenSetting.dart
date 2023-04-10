// import 'dart:developer';
// import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:mongo_dart/mongo_dart.dart';
// import 'package:pelayanan_iman_katolik/DatabaseFolder/data.dart';
// import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
// import 'package:path_provider/path_provider.dart';

// import 'messages.dart';

// class AgenSetting {
//   AgenSetting() {
//     ReadyBehaviour();
//     ResponsBehaviour();
//   }

//   var dataSetting;
//   setDataTampilan(data) {
//     dataSetting = data;
//   }

//   receiverTampilan() {
//     return dataSetting;
//   }

//   Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     // If you're going to use other Firebase services in the background, such as Firestore,
//     // make sure you call `initializeApp` before using other Firebase services.
//     await Firebase.initializeApp();
//     // print(message.from);
//     // print(message.data);

//     print('Handling a background message ${message.messageId}');
//   }

//   /// Create a [AndroidNotificationChannel] for heads up notifications
//   AndroidNotificationChannel? channel;

//   /// Initialize the [FlutterLocalNotificationsPlugin] package.
//   FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

//   ResponsBehaviour() {
//     Messages msg = Messages();

//     var data = msg.receive();
//     action() async {
//       try {
//         if (data[0][0] == "save data") {
//           final directory = await getApplicationDocumentsDirectory();
//           var path = directory.path;

//           if (await File('$path/login.txt').exists()) {
//             final file = await File('$path/login.txt');
//             print("found file");
//             print(data[1][0][0]);
//             await file.writeAsString(data[1][0][0]['name']);
//             await file.writeAsString('\n' + data[1][0][0]['email'],
//                 mode: FileMode.append);

//             await file.writeAsString('\n' + data[1][0][0]['_id'].toString(),
//                 mode: FileMode.append);
//           } else {
//             print("file not found");
//             final file = await File('$path/login.txt').create(recursive: true);
//             await file.writeAsString(data[1][0][0]['name']);
//             await file.writeAsString('\n' + data[1][0][0]['email'],
//                 mode: FileMode.append);

//             await file.writeAsString('\n' + data[1][0][0]['_id'].toString(),
//                 mode: FileMode.append);
//           }
//         }

//         if (data[0][0] == "setting User") {
//           var date = DateTime.now();
//           var hour = date.hour;
//           WidgetsFlutterBinding.ensureInitialized();
//           await dotenv.load(fileName: ".env");
//           await Firebase.initializeApp();
//           await MongoDatabase.connect();
//           // FirebaseMessaging.onBackgroundMessage(
//           //     _firebaseMessagingBackgroundHandler);
//           // if (!kIsWeb) {
//           //   channel = const AndroidNotificationChannel(
//           //     'high_importance_channel', // id
//           //     'High Importance Notifications', // title
//           //     // 'This channel is used for important notifications.', // description
//           //     importance: Importance.high,
//           //   );

//           //   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//           //   /// Create an Android Notification Channel.
//           //   ///
//           //   /// We use this channel in the `AndroidManifest.xml` file to override the
//           //   /// default FCM channel to enable heads up notifications.
//           //   await flutterLocalNotificationsPlugin!
//           //       .resolvePlatformSpecificImplementation<
//           //           AndroidFlutterLocalNotificationsPlugin>()
//           //       ?.createNotificationChannel(channel!);

//           //   /// Update the iOS foreground notification presentation options to allow
//           //   /// heads up notifications.
//           //   await FirebaseMessaging.instance
//           //       .setForegroundNotificationPresentationOptions(
//           //     alert: true,
//           //     badge: true,
//           //     sound: true,
//           //   );
//           // }
//           LocationPermission permission = await Geolocator.checkPermission();
//           print(permission);
//           if (permission == LocationPermission.denied) {
//             LocationPermission permission =
//                 await Geolocator.requestPermission();
//             LocationPermission permission2 = await Geolocator.checkPermission();
//             print(permission2);
//           }
//           var res;
//           try {
//             final directory = await getApplicationDocumentsDirectory();
//             var path = directory.path;

//             final file = await File('$path/login.txt');

//             // Read the file
//             res = await file.readAsLines();
//           } catch (e) {
//             // If encountering an error, return 0
//             res = "nothing";
//           }

//           print(hour);
//           if (hour >= 5 && hour <= 17) {
//             msg.addReceiver("agenPage");
//             msg.setContent([
//               ["Application Setting Ready"],
//               [res],
//               ["pagi"]
//             ]);
//             await msg.send();
//           }
//           if (hour >= 18 || hour <= 4) {
//             msg.addReceiver("agenPage");
//             msg.setContent([
//               ["Application Setting Ready"],
//               [res],
//               ["malam"]
//             ]);
//             await msg.send();
//           }
//         }

//         if (data[0][0] == "log out akun") {
//           final directory = await getApplicationDocumentsDirectory();
//           var path = directory.path;
//           print("cobaaaa");
//           final file = await File('$path/login.txt');
//           await file.writeAsString("");
//           print("log out");
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
//           print("Agen Setting Ready");
//         }
//       } catch (e) {
//         return 0;
//       }
//     }

//     action();
//   }
// }
import 'dart:async';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import '../DatabaseFolder/data.dart';
import '../DatabaseFolder/mongodb.dart';
import '../view/login.dart';
import 'Agent.dart';
import 'Goals.dart';
import 'MessagePassing.dart';
import 'Plan.dart';
import 'Task.dart';

class AgentSetting extends Agent {
  AgentSetting() {
    _initAgent();
  }
  List<Plan> _plan = [];
  List<Goals> _goals = [];
  List<dynamic> pencarianData = [];
  String agentName = "";
  bool stop = false;
  int _estimatedTime = 10;
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

        Messages message = await action(p.goals, task.data, sender);
        print(message.task.data.runtimeType);

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
                print('Agent Setting returning data to ${message.receiver}');
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

  Future<Messages> action(String goals, dynamic data, String sender) async {
    switch (goals) {
      case "setting user":
        return settingUser(data, sender);

      case "save data":
        return saveData(data, sender);

      case "log out":
        return logOut(data, sender);

      default:
        return rejectTask(data, sender);
    }
  }

  Future<Messages> settingUser(dynamic data, String sender) async {
    var date = DateTime.now();
    var hour = date.hour;
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");
    await Firebase.initializeApp();
    await MongoDatabase.connect();

    LocationPermission permission = await Geolocator.checkPermission();
    print(permission);
    if (permission == LocationPermission.denied) {
      LocationPermission permission = await Geolocator.requestPermission();
      LocationPermission permission2 = await Geolocator.checkPermission();
      print(permission2);
    }
    var res;
    try {
      final directory = await getApplicationDocumentsDirectory();
      var path = directory.path;

      final file = await File('$path/login.txt');
      // await file.writeAsString("");
      // Read the file
      res = await file.readAsLines();
    } catch (e) {
      // If encountering an error, return 0
      res = "nothing";
    }

    //   Messages message2 = Messages(sender, 'Agent Akun', "REQUEST",
    //     Tasks('ganti token', null));
    // MessagePassing messagePassing2 = MessagePassing();
    // await messagePassing2.sendMessage(message2);

    if (hour >= 5 && hour <= 17) {
      Messages message = Messages(
          'Agent Setting',
          sender,
          "INFORM",
          Tasks('status aplikasi', [
            [await res],
            ["pagi"]
          ]));
      return message;
    } else {
      Messages message = Messages(
          'Agent Setting',
          sender,
          "INFORM",
          Tasks('status aplikasi', [
            [await res],
            ["malam"]
          ]));
      return message;
    }
  }

  Future<Messages> saveData(dynamic data, String sender) async {
    final directory = await getApplicationDocumentsDirectory();
    var path = directory.path;

    if (await File('$path/login.txt').exists()) {
      final file = await File('$path/login.txt');

      await file.writeAsString(data[0]['_id'].toString());
    } else {
      final file = await File('$path/login.txt').create(recursive: true);

      await file.writeAsString('\n' + data[0]['_id'].toString());
    }

    Messages message = Messages(
        'Agent Setting', sender, "INFORM", Tasks('status aplikasi', "oke"));
    return message;
  }

  Future<Messages> logOut(dynamic data, String sender) async {
    final directory = await getApplicationDocumentsDirectory();
    var path = directory.path;

    final file = await File('$path/login.txt');
    await file.writeAsString("");

    Messages message = Messages(
        'Agent Setting', sender, "INFORM", Tasks('status aplikasi', "oke"));
    return message;
  }

  Messages rejectTask(dynamic task, sender) {
    Messages message = Messages(
        "Agent Setting",
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
        "Agent Setting",
        "INFORM",
        Tasks('error', [
          ['reject over time']
        ]));
    return message;
  }

  void _initAgent() {
    this.agentName = "Agent Setting";
    _plan = [
      Plan("setting user", "REQUEST", _estimatedTime),
      Plan("log out", "REQUEST", _estimatedTime),
      Plan("save data", "REQUEST", _estimatedTime),
    ];
    _goals = [
      Goals("setting user", List<List<dynamic>>, 12),
      Goals("log out", String, 6),
      Goals("save data", String, 6),
    ];
  }
}
