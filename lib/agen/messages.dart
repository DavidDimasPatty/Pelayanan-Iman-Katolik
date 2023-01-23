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
  }

  receive() {
    return Data;
  }
}
