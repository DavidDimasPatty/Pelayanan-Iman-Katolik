// void main() {
//   runApp(MyApp());
// }

import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/view/homePage.dart';
import 'package:pelayanan_iman_katolik/view/login.dart';

var tampilan;

Future callDb() async {
  // Messages msg = new Messages();
  // await msg.addReceiver("agenSetting");
  // await msg.setContent([
  //   ["setting User"]
  // ]);
  // await msg.send().then((res) async {});
  // await Future.delayed(Duration(seconds: 2));
  // return await AgenPage().receiverTampilan();
  Completer<void> completer = Completer<void>();
  Messages message = Messages(
      'Agent Page', 'Agent Setting', "REQUEST", Tasks('setting user', null));

  MessagePassing messagePassing = MessagePassing();
  var data = await messagePassing.sendMessage(message);
  completer.complete();
  var hasil = await await AgentPage.getDataPencarian();
  return hasil;
}

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();
//   // print(message.from);
//   // print(message.data);

//   print('Handling a background message ${message.messageId}');
// }

/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel? channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

void main() async {
  var tampilan = await callDb();
  // WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");
  // await Firebase.initializeApp();

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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

  // await MongoDatabase.connect();
  // LocationPermission permission = await Geolocator.checkPermission();
  // print(permission);
  // if (permission == LocationPermission.denied) {
  //   LocationPermission permission = await Geolocator.requestPermission();
  //   LocationPermission permission2 = await Geolocator.checkPermission();
  //   print(permission2);
  // }

  if (tampilan[1] == "pagi") {
    try {
      if (tampilan[0][0].length != 0 && tampilan[0][0] != "nothing") {
        var object =
            tampilan[0][2].toString().substring(10, tampilan[0][2].length - 2);
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
          home:
              HomePage(tampilan[0][0], tampilan[0][1], ObjectId.parse(object)),
        ));
      } else {
        print("Morning!");
        runApp(MaterialApp(
          title: 'Navigation Basics',
          theme: ThemeData(
            // Define the default brightness and colors.
            brightness: Brightness.light,
            primaryColor: Colors.grey,
          ),
          home: Login(),
        ));
      }
    } catch (e) {
      runApp(MaterialApp(
        title: 'Navigation Basics',
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.grey,
        ),
        home: Login(),
      ));
    }
  } else {
    try {
      if (tampilan[0][0].length != 0 && tampilan[0][0] != "nothing") {
        var object =
            tampilan[0][2].toString().substring(10, tampilan[0][2].length - 2);
        print("Night!");
        runApp(MaterialApp(
          title: 'Navigation Basics',
          theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.grey,
            // ),
          ),
          home:
              HomePage(tampilan[0][0], tampilan[0][1], ObjectId.parse(object)),
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
    } catch (e) {
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
