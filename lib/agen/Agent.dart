import 'dart:async';

import 'package:pelayanan_iman_katolik/agen/Goals.dart';

import 'Message.dart';
import 'Plan.dart';

abstract class Agent {
  List<Plan> plan = [];
  List<Goals> goals = [];
  List Message = [];
  List Sender = [];
  String agentName = "";
  bool stop = false;

  bool canPerformTask(dynamic task);

  Future<dynamic> receiveMessage(Messages msg, String sender);

  Future<dynamic> performTask();

  Messages rejectTask(dynamic task, String sender);
  Messages overTime(dynamic task, sender);
  action(String goals, dynamic data, String sender);
}
