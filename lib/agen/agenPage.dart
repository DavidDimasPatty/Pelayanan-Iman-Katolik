import 'dart:async';
import 'package:pelayanan_iman_katolik/agen/Message.dart';

import 'Agent.dart';
import 'Goals.dart';
import 'Plan.dart';
import 'Task.dart';

class AgentPage extends Agent {
  AgentPage() {
    //Konstruktor agen memanggil fungsi initAgent
    _initAgent();
  }
  static List<dynamic> dataView = [];

  @override
  int canPerformTask(Messages message) {
    if (message.task.action == "error") {
      return 1;
    } else {
      for (var p in plan) {
        if (p.goals == message.task.action && p.protocol == message.protocol) {
          return 1;
        }
      }
    }
    return -1;
  }

  @override
  Future performTask() async {
    Messages msg = MessageList.last;
    String sender = SenderList.last;
    dynamic task = msg.task;
    for (var p in plan) {
      if (p.goals == msg.task.action) {
        action(p.goals, task.data, sender);
        print("View can use data store in " + agentName);
        break;
      }
    }
  }

  static void _messageSetData(task) {
    dataView.add(task);
  }

  static Future getData() async {
    return dataView.last;
  }

  void _initAgent() {
    //Inisialisasi identitas agen
    agentName = "Agent Page";
    //nama agen
    plan = [
      Plan("status modifikasi data", "INFORM"), //come from agen Pendaftaran
      Plan("hasil pencarian", "INFORM"), //come from agen Pencarian
      Plan("status aplikasi", "INFORM"), //come from agen Setting
      Plan("status modifikasi/ pencarian data akun",
          "INFORM"), //come from agen Akun
      Plan("error", "INFORM")
    ];
    //Perencanaan agen
    goals = [
      Goals("status modifikasi data", String, 1),
      Goals("hasil pencarian", String, 1),
      Goals("status aplikasi", String, 1),
      Goals("status modifikasi/ pencarian data akun", String, 1),
      Goals("error", String, 1),
    ];
  }

  action(String goals, data, String sender) {
    //Daftar tindakan yang bisa dilakukan oleh agen, fungsi ini memilih tindakan
    //berdasarkan tugas yang berada pada isi pesan
    _messageSetData(data);
  }

  @override
  Messages overTime(task, sender) {
    // TODO: implement overTime
    throw UnimplementedError();
  }

  @override
  addEstimatedTime(String goals) {
    // TODO: implement addEstimatedTime
    throw UnimplementedError();
  }
}
