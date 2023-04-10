import 'Task.dart';

class Messages {
  String sender;
  String receiver;
  Tasks task;
  dynamic protocol;

  Messages(this.sender, this.receiver, this.protocol, this.task);
}
