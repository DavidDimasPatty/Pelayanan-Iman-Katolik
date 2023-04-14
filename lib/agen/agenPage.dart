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

  static List<dynamic> dataView = [];

  int _estimatedTime = 1;

  bool canPerformTask(dynamic message) {
    for (var p in plan) {
      if (p.goals == message.task.action && p.protocol == message.protocol) {
        return true;
      }
    }
    return false;
  }

  Future<dynamic> receiveMessage(Messages msg, String sender) {
    print(agentName + ' received message from $sender');
    Message.add(msg);
    Sender.add(sender);
    return performTask();
  }

  Future performTask() async {
    Messages msgCome = Message.last;
    String sender = Sender.last;
    dynamic task = msgCome.task;
    for (var p in plan) {
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

    print(agentName + ' rejected task from $sender: ${task}');
    return message;
  }

  void _initAgent() {
    this.agentName = "Agent Page";
    plan = [
      Plan(
        "status modifikasi data",
        "INFORM",
      ), //come from agen Pendaftaran
      Plan(
        "hasil pencarian",
        "INFORM",
      ), //come from agen Pencarian
      Plan("status aplikasi", "INFORM"), //come from agen Setting
      Plan("status modifikasi/ pencarian data akun", "INFORM"),
    ];
    goals = [
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

  @override
  Messages overTime(task, sender) {
    // TODO: implement overTime
    throw UnimplementedError();
  }
}
