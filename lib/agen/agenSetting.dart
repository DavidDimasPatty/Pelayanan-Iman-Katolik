import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/data.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:path_provider/path_provider.dart';

import 'messages.dart';

class AgenSetting {
  AgenSetting() {
    ReadyBehaviour();
    ResponsBehaviour();
  }

  var dataSetting;
  setDataTampilan(data) {
    dataSetting = data;
  }

  receiverTampilan() {
    return dataSetting;
  }

  ResponsBehaviour() {
    Messages msg = Messages();

    var data = msg.receive();
    action() async {
      try {
        if (data[0][0] == "setting User") {
          var res;
          try {
            final directory = await getApplicationDocumentsDirectory();
            var path = directory.path;

            final file = await File('$path/login.txt');

            // Read the file
            res = await file.readAsLines();
          } catch (e) {
            // If encountering an error, return 0
            res = "nothing";
          }

          var date = DateTime.now();
          var hour = date.hour;
          print(hour);
          if (hour >= 5 && hour <= 17) {
            msg.addReceiver("agenPage");
            msg.setContent([
              [res],
              ["pagi"]
            ]);
            await msg.send();
          }
          if (hour >= 18 || hour <= 4) {
            msg.addReceiver("agenPage");
            msg.setContent([
              [res],
              ["malam"]
            ]);
            await msg.send();
          }
        }
      } catch (e) {
        return 0;
      }
    }

    action();
  }

  ReadyBehaviour() {
    Messages msg = Messages();
    var data = msg.receive();
    action() {
      try {
        if (data == "ready") {
          print("Agen Setting Ready");
        }
      } catch (e) {
        return 0;
      }
    }

    action();
  }
}
