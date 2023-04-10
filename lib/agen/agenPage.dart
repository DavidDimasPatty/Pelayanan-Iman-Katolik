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

  Future performTask() async {
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

  // waitData(data) async {
  //   await Future.delayed(data);
  // }

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
      Plan("status modifikasi/ pencarian data akun", "INFORM", _estimatedTime),
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
