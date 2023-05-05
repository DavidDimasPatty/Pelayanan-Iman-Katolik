import 'Task.dart';

class Messages {
  //Kelas merepresentasikan pesan
  String sender; //Pengirim pesan
  String receiver; //Penerima pesan
  Tasks task; //Tugas dengan kelas Tasks
  dynamic protocol; //INFORM atau REQUEST

  //Konstruktor
  Messages(this.sender, this.receiver, this.protocol, this.task);
}
