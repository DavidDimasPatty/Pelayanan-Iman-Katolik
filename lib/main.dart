import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel? channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      // 'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel!);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

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
    if (tampilan[0][0].length != 0 && tampilan[0][0] != "nothing") {
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
    if (tampilan[0][0].length != 0 && tampilan[0][0] != "nothing") {
      var object = tampilan[0][0][2]
          .toString()
          .substring(10, tampilan[0][0][2].length - 2);
      print("Night!");
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
