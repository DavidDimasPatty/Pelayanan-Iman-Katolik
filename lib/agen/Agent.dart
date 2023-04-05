import 'dart:async';

import 'Message.dart';

abstract class Agent {
  bool canPerformTask(dynamic task);

  Future<dynamic> receiveMessage(Message msg, String sender);

  Future<dynamic> performTask();

  void rejectTask(dynamic task, String sender);
  void action(String goals, dynamic data, String sender);
}
