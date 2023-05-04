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
import 'package:pelayanan_iman_katolik/view/logIn.dart';

////////////Kelas Main
///////////////////////Fungsi////////////////////////
Future callDb() async {
  //Mengirim pesan untuk settingan aplikasi saat diluncurkan
  Completer<void> completer =
      Completer<void>(); //variabel untuk menunggu //variabel untuk menunggu

  Messages message = Messages('Agent Page', 'Agent Setting', "REQUEST",
      Tasks('setting user', null)); //Pembuatan Pesan

  MessagePassing messagePassing =
      MessagePassing(); //Memanggil distributor pesan
  await messagePassing
      .sendMessage(message); //Mengirim pesan ke distributor pesan
  completer.complete(); //Batas pengerjaan yang memerlukan completer
  // sampai agen Page memiliki data
  var hasil =
      await AgentPage.getData(); //Memanggil data yang tersedia di agen Page
  await completer.future; //Proses penungguan sudah selesai ketika varibel hasil
  //memiliki nilai

  return hasil; //Mengembalikan variabel hasil //Mengembalikan variabel hasil
}

callTampilan(tampilan) {
  //Fungsi untuk menampilkan halaman ketika settingan aplikasi sudah beres dan
  ////halaman siap ditampilkan
  if (tampilan[1][0] == "pagi") {
    //Jika data memiliki String pagi
    try {
      if (tampilan[0][0].length != 0 && tampilan[0][0] != "nothing") {
        //Jika data akun pengguna tersimpan pada lokal file
        var object = tampilan[0][0][0]
            .toString()
            .substring(10, tampilan[0][0][0].length - 2); //Mendapatkan data id
        //pengguna yang tersimpan pada lokal file
        runApp(MaterialApp(
          //tema aplikasi akan terang karena pagi
          title: 'Navigation Basics',
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.grey,
          ),
          home:
              homePage(ObjectId.parse(object)), // Memanggil halaman home dengan
          //parameter variabel object
        ));
        //Maka akan ditampilkan halaman home
      } else {
        //Jika data akun pengguna tidak tersimpan pada lokal file
        runApp(MaterialApp(
          title: 'Navigation Basics',
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.grey,
          ),
          home: logIn(),
        ));
        //Maka akan ditampilkan halaman login
      }
    } catch (e) {
      //Jika ada data error yang diterima saat setting aplikasi
      runApp(MaterialApp(
        title: 'Navigation Basics',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.grey,
        ),
        home: logIn(),
      ));
      //Pengguna akan ditampilkan halaman login
    }
  } else {
    //Jika data memiliki String selain pagi
    try {
      if (tampilan[0][0].length != 0 && tampilan[0][0] != "nothing") {
        //Jika data akun pengguna tersimpan pada lokal file
        var object = tampilan[0][0][0]
            .toString()
            .substring(10, tampilan[0][0][0].length - 2); //Mendapatkan data id
        //pengguna yang tersimpan pada lokal file

        runApp(MaterialApp(
          //tema aplikasi akan gelap karena malam
          title: 'Navigation Basics',
          theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.grey,
          ),
          home:
              homePage(ObjectId.parse(object)), // Memanggil halaman home dengan
          //parameter variabel object
        ));
      } else {
        //Jika data akun pengguna tidak tersimpan pada lokal file
        runApp(MaterialApp(
          title: 'Navigation Basics',
          theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.grey,
          ),
          home: logIn(),
        ));
        //Maka akan ditampilkan halaman login
      }
    } catch (e) {
      //Jika ada data error yang diterima saat setting aplikasi
      runApp(MaterialApp(
        title: 'Navigation Basics',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.grey,
        ),
        home: logIn(),
      ));
      //Pengguna akan ditampilkan halaman login
    }
  }
}

/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel? channel; //variabel yang mendengarkan notifikasi

/// Initialize the [FlutterLocalNotificationsPlugin] package
FlutterLocalNotificationsPlugin?
    flutterLocalNotificationsPlugin; //variabel notifikasi

void main() async {
  var data = await callDb(); // Memanggil callDb saat peluncuran aplikasi
  callTampilan(data); // Memanggil callDb saat peluncuran aplikasi

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
    );
//Mengecek apakah aplikasi berjalan di dalam web atau tidak
//Jika tidak, maka akan dilakukan konfigurasi notifikasi pada Android

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//variabel untuk menampilkan notifikasi pada Android

    await flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel!);
//Variabel untuk membuat channel notifikasi pada Android

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  //opsi notifikasi pada saat aplikasi berjalan di foreground

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//Mengaktifkan listener untuk menerima pesan dari FCM
    RemoteNotification? notification = message.notification!;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null && !kIsWeb) {
      //Mengecek apakah pesan memiliki notifikasi dan informasi Android,
      // dan aplikasi bukan berjalan di dalam web
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
    //Menampilkan notifikasi dengan parameter hashcode notifikasi,
    //judul dan isi notifikasi, serta detail notifikasi
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //Mengaktifkan listener untuk membuka aplikasi melalui notifikasi push
    print("Receive data from FCM");
    callTampilan(data);
    //Ketika aplikasi dibuka, memanggil fungsi callTampilan()
    //dengan data notifikasi yang diterima
  });
}
