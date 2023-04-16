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

  @override
  Future performTask() async {
    Messages msg = MessageList.last;
    String sender = SenderList.last;
    dynamic task = msg.task;
    for (var p in plan) {
      action(p.goals, task.data, sender);
      print("View can use data store in " + agentName);
    }
  }

  static _messageSetData(task) {
    dataView.add(task);
  }

  static Future getDataPencarian() async {
    return dataView.last;
  }

  void _initAgent() {
    agentName = "Agent Page";
    plan = [
      Plan("status modifikasi data", "INFORM"), //come from agen Pendaftaran
      Plan("hasil pencarian", "INFORM"), //come from agen Pencarian
      Plan("status aplikasi", "INFORM"), //come from agen Setting
      Plan("status modifikasi/ pencarian data akun",
          "INFORM"), //come from agen Akun
    ];
    goals = [
      Goals("status modifikasi data", String, 1),
      Goals("hasil pencarian", String, 1),
      Goals("status aplikasi", String, 1),
      Goals("status modifikasi/ pencarian data akun", String, 1),
    ];
  }

  @override
  action(String goals, data, String sender) {
    _messageSetData(data);
  }

  @override
  Messages overTime(task, sender) {
    // TODO: implement overTime
    throw UnimplementedError();
  }

  @override
  addEstimatedTime() {
    // TODO: implement addEstimatedTime
    throw UnimplementedError();
  }
}
