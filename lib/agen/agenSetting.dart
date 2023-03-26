import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
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

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
    // print(message.from);
    // print(message.data);

    print('Handling a background message ${message.messageId}');
  }

  /// Create a [AndroidNotificationChannel] for heads up notifications
  AndroidNotificationChannel? channel;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  ResponsBehaviour() {
    Messages msg = Messages();

    var data = msg.receive();
    action() async {
      try {
        if (data[0][0] == "save data") {
          final directory = await getApplicationDocumentsDirectory();
          var path = directory.path;

          if (await File('$path/login.txt').exists()) {
            final file = await File('$path/login.txt');
            print("found file");
            print(data[1][0][0]);
            await file.writeAsString(data[1][0][0]['name']);
            await file.writeAsString('\n' + data[1][0][0]['email'],
                mode: FileMode.append);

            await file.writeAsString('\n' + data[1][0][0]['_id'].toString(),
                mode: FileMode.append);
          } else {
            print("file not found");
            final file = await File('$path/login.txt').create(recursive: true);
            await file.writeAsString(data[1][0][0]['name']);
            await file.writeAsString('\n' + data[1][0][0]['email'],
                mode: FileMode.append);

            await file.writeAsString('\n' + data[1][0][0]['_id'].toString(),
                mode: FileMode.append);
          }
        }

        if (data[0][0] == "setting User") {
          var date = DateTime.now();
          var hour = date.hour;
          WidgetsFlutterBinding.ensureInitialized();
          await dotenv.load(fileName: ".env");
          await Firebase.initializeApp();
          await MongoDatabase.connect();
          // FirebaseMessaging.onBackgroundMessage(
          //     _firebaseMessagingBackgroundHandler);
          // if (!kIsWeb) {
          //   channel = const AndroidNotificationChannel(
          //     'high_importance_channel', // id
          //     'High Importance Notifications', // title
          //     // 'This channel is used for important notifications.', // description
          //     importance: Importance.high,
          //   );

          //   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

          //   /// Create an Android Notification Channel.
          //   ///
          //   /// We use this channel in the `AndroidManifest.xml` file to override the
          //   /// default FCM channel to enable heads up notifications.
          //   await flutterLocalNotificationsPlugin!
          //       .resolvePlatformSpecificImplementation<
          //           AndroidFlutterLocalNotificationsPlugin>()
          //       ?.createNotificationChannel(channel!);

          //   /// Update the iOS foreground notification presentation options to allow
          //   /// heads up notifications.
          //   await FirebaseMessaging.instance
          //       .setForegroundNotificationPresentationOptions(
          //     alert: true,
          //     badge: true,
          //     sound: true,
          //   );
          // }
          LocationPermission permission = await Geolocator.checkPermission();
          print(permission);
          if (permission == LocationPermission.denied) {
            LocationPermission permission =
                await Geolocator.requestPermission();
            LocationPermission permission2 = await Geolocator.checkPermission();
            print(permission2);
          }
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

          print(hour);
          if (hour >= 5 && hour <= 17) {
            msg.addReceiver("agenPage");
            msg.setContent([
              ["Application Setting Ready"],
              [res],
              ["pagi"]
            ]);
            await msg.send();
          }
          if (hour >= 18 || hour <= 4) {
            msg.addReceiver("agenPage");
            msg.setContent([
              ["Application Setting Ready"],
              [res],
              ["malam"]
            ]);
            await msg.send();
          }
        }

        if (data[0][0] == "log out akun") {
          final directory = await getApplicationDocumentsDirectory();
          var path = directory.path;
          print("cobaaaa");
          final file = await File('$path/login.txt');
          await file.writeAsString("");
          print("log out");
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
