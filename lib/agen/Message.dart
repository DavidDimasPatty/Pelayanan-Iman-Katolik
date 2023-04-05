// import 'package:pelayanan_iman_katolik/agen/agenAkun.dart';
// import 'package:pelayanan_iman_katolik/agen/agenPendaftaran.dart';
// import 'package:pelayanan_iman_katolik/agen/agenSetting.dart';

// import 'agenPage.dart';
// import 'agenPencarian.dart';

// class Messages {
//   static var Agen = [];
//   static var Data = [];

//   addReceiver(agen) {
//     if (Agen.length >= 1) {
//       Agen.add(agen);
//       // Agen.removeAt(0);
//     } else {
//       Agen.add(agen);
//     }
//   }

//   setContent(data) {
//     if (Data.length >= 1) {
//       Data.add(data);
//       // Data.removeAt(0);
//     } else {
//       Data.add(data);
//     }
//   }

//   send() async {
//     if (Agen.last == "agenPencarian") {
//       await AgenPencarian();
//     }
//     if (Agen.last == "agenPage") {
//       await AgenPage();
//     }
//     if (Agen.last == "agenPendaftaran") {
//       await AgenPendaftaran();
//     }
//     if (Agen.last == "agenAkun") {
//       await AgenAkun();
//     }
//     if (Agen.last == "agenSetting") {
//       await AgenSetting();
//     }
//   }

//   receive() {
//     return Data.last;
//   }
// }
import 'Task.dart';

class Messages {
  String sender;
  String receiver;
  Tasks task;
  dynamic protocol;

  Messages(this.sender, this.receiver, this.protocol, this.task);
}
