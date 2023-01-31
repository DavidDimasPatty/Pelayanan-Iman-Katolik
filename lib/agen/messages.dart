import 'package:pelayanan_iman_katolik/agen/agenAkun.dart';
import 'package:pelayanan_iman_katolik/agen/agenPendaftaran.dart';

import 'agenPage.dart';
import 'agenPencarian.dart';

class Messages {
  String Agen = "";
  static var Data;

  addReceiver(agen) async {
    this.Agen = agen;
  }

  setContent(data) async {
    Data = data;
  }

  send() async {
    if (this.Agen == "agenPencarian") {
      await AgenPencarian();
    }
    if (this.Agen == "agenPage") {
      await AgenPage();
    }
    if (this.Agen == "agenPendaftaran") {
      await AgenPendaftaran();
    }
    if (this.Agen == "agenAkun") {
      await AgenAkun();
    }
  }

  receive() {
    return Data;
  }
}
