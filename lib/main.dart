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

Future callDb() async {
  Completer<void> completer = Completer<void>();
  Messages message = Messages(
      'Agent Page', 'Agent Setting', "REQUEST", Tasks('setting user', null));

  MessagePassing messagePassing = MessagePassing();
  var data = await messagePassing.sendMessage(message);
  completer.complete();
  var hasil = await await AgentPage.getDataPencarian();
  await completer.future;
  return hasil;
}

callTampilan(tampilan) {
  if (tampilan[1][0] == "pagi") {
    try {
      if (tampilan[0][0].length != 0 && tampilan[0][0] != "nothing") {
        var object = tampilan[0][0][0]
            .toString()
            .substring(10, tampilan[0][0][0].length - 2);
        runApp(MaterialApp(
          title: 'Navigation Basics',
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.grey,
          ),
          home: HomePage(ObjectId.parse(object)),
        ));
      } else {
        print("Morning!");
        runApp(MaterialApp(
          title: 'Navigation Basics',
          theme: ThemeData(
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
          brightness: Brightness.light,
          primaryColor: Colors.grey,
        ),
        home: Login(),
      ));
    }
  } else {
    try {
      if (tampilan[0][0].length != 0 && tampilan[0][0] != "nothing") {
        var object = tampilan[0][0][0]
            .toString()
            .substring(10, tampilan[0][0][0].length - 2);
        print("Night!");
        runApp(MaterialApp(
          title: 'Navigation Basics',
          theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.grey,
          ),
          home: HomePage(ObjectId.parse(object)),
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

/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel? channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

void main() async {
  var data = await callDb();
  callTampilan(data);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel!);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification!;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin!.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel!.id,
              channel!.name,
              icon: 'launch_background',
            ),
          ));
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("Receive data from FCM");
    callTampilan(data);
  });
}
