import 'dart:async';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import '../DatabaseFolder/mongodb.dart';
import 'Agent.dart';
import 'Goals.dart';
import 'Plan.dart';
import 'Task.dart';

class AgentSetting extends Agent {
  AgentSetting() {
    _initAgent();
  }

  static int _estimatedTime = 10;
  static Map<String, int> _timeAction = {
    "setting user": _estimatedTime,
    "log out": _estimatedTime,
    "save data": _estimatedTime,
  };

  Future<Messages> action(String goals, dynamic data, String sender) async {
    switch (goals) {
      case "setting user":
        return _settingUser(data.task.data, sender);

      case "save data":
        return _saveData(data.task.data, sender);

      case "log out":
        return _logOut(data.task.data, sender);

      default:
        return rejectTask(data.task.data, sender);
    }
  }

  Future<Messages> _settingUser(dynamic data, String sender) async {
    var date = DateTime.now();
    var hour = date.hour;
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");
    await Firebase.initializeApp();
    await MongoDatabase.connect();

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      LocationPermission permission = await Geolocator.requestPermission();
      LocationPermission permission2 = await Geolocator.checkPermission();
    }
    var res;
    try {
      final directory = await getApplicationDocumentsDirectory();
      var path = directory.path;

      final file = await File('$path/login.txt');

      res = await file.readAsLines();
    } catch (e) {
      res = "nothing";
    }

    if (hour >= 5 && hour <= 17) {
      Messages message = Messages(
          agentName,
          sender,
          "INFORM",
          Tasks('status aplikasi', [
            [await res],
            ["pagi"]
          ]));
      return message;
    } else {
      Messages message = Messages(
          agentName,
          sender,
          "INFORM",
          Tasks('status aplikasi', [
            [await res],
            ["malam"]
          ]));
      return message;
    }
  }

  Future<Messages> _saveData(dynamic data, String sender) async {
    final directory = await getApplicationDocumentsDirectory();
    var path = directory.path;

    if (await File('$path/login.txt').exists()) {
      final file = await File('$path/login.txt');
      await file.writeAsString("");
      await file.writeAsString(data[0]['_id'].toString());
    } else {
      final file = await File('$path/login.txt').create(recursive: true);
      await file.writeAsString("");
      await file.writeAsString('\n' + data[0]['_id'].toString());
    }

    Messages message =
        Messages(agentName, sender, "INFORM", Tasks('status aplikasi', "oke"));
    return message;
  }

  Future<Messages> _logOut(dynamic data, String sender) async {
    final directory = await getApplicationDocumentsDirectory();
    var path = directory.path;

    final file = await File('$path/login.txt');
    await file.writeAsString("");

    Messages message =
        Messages(agentName, sender, "INFORM", Tasks('status aplikasi', "oke"));
    return message;
  }

  @override
  addEstimatedTime(String goals) {
    _timeAction[goals] = _timeAction[goals]! + 1;
  }

  _initAgent() {
    this.agentName = "Agent Setting";
    plan = [
      Plan("setting user", "REQUEST"),
      Plan("log out", "REQUEST"),
      Plan("save data", "REQUEST"),
    ];
    goals = [
      Goals("setting user", List<List<dynamic>>, _timeAction["setting user"]),
      Goals("log out", String, _timeAction["log out"]),
      Goals("save data", String, _timeAction["save data"]),
    ];
  }
}
