import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/agenSetting.dart';
import 'package:pelayanan_iman_katolik/agen/messages.dart';
import 'package:pelayanan_iman_katolik/homePage.dart';
import 'package:pelayanan_iman_katolik/login.dart';

// void main() {
//   runApp(MyApp());
// }

Future callDb() async {
  Messages msg = new Messages();
  msg.addReceiver("agenSetting");
  msg.setContent([
    ["setting User"]
  ]);
  await msg.send().then((res) async {});
  await Future.delayed(Duration(seconds: 1));
  var k = await AgenPage().receiverTampilan();

  return k;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  await MongoDatabase.connect();
  LocationPermission permission = await Geolocator.checkPermission();
  print(permission);
  if (permission == LocationPermission.denied) {
    LocationPermission permission = await Geolocator.requestPermission();
    LocationPermission permission2 = await Geolocator.checkPermission();
    print(permission2);
  }
  var tampilan = await callDb();

  if (tampilan[1][0] == "pagi") {
    print(tampilan[0][0]);
    if (tampilan[0][0].length != 0 && tampilan[0][0][0] != " ") {
      var object = tampilan[0][0][2]
          .toString()
          .substring(10, tampilan[0][0][2].length - 2);
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
            tampilan[0][0][0], tampilan[0][0][1], ObjectId.parse(object)),
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
    if (tampilan[0][0].length != 0 && tampilan[0][0][0] != " ") {
      var object = tampilan[0][0][2]
          .toString()
          .substring(10, tampilan[0][0][2].length - 2);
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
        home: HomePage(
            tampilan[0][0][0], tampilan[0][0][1], ObjectId.parse(object)),
      ));
    } else {
      runApp(MaterialApp(
        title: 'Navigation Basics',
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.dark,
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
  }
}
