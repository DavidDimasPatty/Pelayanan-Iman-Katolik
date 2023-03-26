import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:pelayanan_iman_katolik/view/homePage.dart';

import '../view/login.dart';
import 'messages.dart';

class AgenPage {
  static var dataTampilan;
  AgenPage() {
    //measure
    ReadyBehaviour();
    //SendBehaviour();
    ResponsBehaviour();
  }
  setDataTampilan(data) async {
    dataTampilan = await data;
  }

  receiverTampilan() async {
    return await dataTampilan;
  }

  ResponsBehaviour() async {
    Messages msg = Messages();
    var data = msg.receive();

    action() async {
      try {
        if (data.runtimeType == List<Map<String, Object?>>) {
          await setDataTampilan(data);
        }
        if (data.runtimeType == String) {
          await setDataTampilan(data);
        }
        if (data.runtimeType == List<dynamic>) {
          await setDataTampilan(data);
        }
        if (data.runtimeType == List<List<dynamic>>) {
          await setDataTampilan(data);
        }
      } catch (error) {
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
        if (data[0][0] == "Application Setting Ready") {
          if (data[2][0] == "pagi") {
            if (data[1][0].length != 0 && data[1][0] != "nothing") {
              var object = data[1][0][2]
                  .toString()
                  .substring(10, data[1][0][2].length - 2);
              runApp(MaterialApp(
                title: 'Navigation Basics',
                theme: ThemeData(
                  // Define the default brightness and colors.
                  brightness: Brightness.light,
                  primaryColor: Colors.grey,

                  // Define the default font family.
                  // fontFamily: 'Georgia',

                  // Define the default `TextTheme`. Use this to specify the default
                  // text styling for headlines, titles, bodies of text, and more.
                  // textTheme: const TextTheme(
                  //   displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
                  //   titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
                  //   bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
                  // ),
                ),
                home: HomePage(
                    data[0][0][0], data[0][0][1], ObjectId.parse(object)),
              ));
            } else {
              print("Morning!");
              runApp(MaterialApp(
                title: 'Navigation Basics',
                theme: ThemeData(
                  // Define the default brightness and colors.
                  brightness: Brightness.light,
                  primaryColor: Colors.grey,

                  // Define the default font family.
                  // fontFamily: 'Georgia',

                  // Define the default `TextTheme`. Use this to specify the default
                  // text styling for headlines, titles, bodies of text, and more.
                  // textTheme: const TextTheme(
                  //   displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
                  //   titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
                  //   bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
                  // ),
                ),
                home: Login(),
              ));
            }
          } else {
            if (data[1][0].length != 0 && data[1][0] != "nothing") {
              var object = data[1][0][2]
                  .toString()
                  .substring(10, data[1][0][2].length - 2);
              print("Night!");
              runApp(MaterialApp(
                title: 'Navigation Basics',
                theme: ThemeData(
                  brightness: Brightness.dark,
                  primaryColor: Colors.grey,
                  // ),
                ),
                home: HomePage(
                    data[1][0][0], data[1][0][1], ObjectId.parse(object)),
              ));
            } else {
              runApp(MaterialApp(
                title: 'Navigation Basics',
                theme: ThemeData(
                  brightness: Brightness.dark,
                  primaryColor: Colors.grey,
                ),
                home: Login(),
              ));
            }
          }
        }
      } catch (error) {
        return 0;
      }
    }

    action();
  }
}
