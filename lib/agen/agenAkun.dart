import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/fireBase.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/modelDB.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:http/http.dart' as http;
import '../DatabaseFolder/data.dart';
import '../DatabaseFolder/mongodb.dart';
import 'Agent.dart';
import 'Goals.dart';
import 'MessagePassing.dart';
import 'Plan.dart';

class AgentAkun extends Agent {
  AgentAkun() {
    //Konstruktor agen memanggil fungsi initAgent
    _initAgent();
  }

  static int _estimatedTime = 5;
  //Batas waktu awal pengerjaan seluruh tugas agen
  static Map<String, int> _timeAction = {
    "login": _estimatedTime,
    "sign up": _estimatedTime,
    "cari user": _estimatedTime,
    "cari profile": _estimatedTime,
    "cari tampilan home": _estimatedTime,
    "edit profile": _estimatedTime,
    "update notification": _estimatedTime,
    "find password": _estimatedTime,
    "change password": _estimatedTime,
    "change profile picture": _estimatedTime,
    "log out": _estimatedTime,
    "lupa password": _estimatedTime
  };

  //Daftar batas waktu pengerjaan masing-masing tugas

  Future<Messages> action(String goals, dynamic data, String sender) async {
    //Daftar tindakan yang bisa dilakukan oleh agen, fungsi ini memilih tindakan
    //berdasarkan tugas yang berada pada isi pesan
    switch (goals) {
      case "login":
        return _logIn(data.task.data, sender);
      case "cari user":
        return _cariUser(data.task.data, sender);
      case "cari profile":
        return _cariProfile(data.task.data, sender);
      case "cari tampilan home":
        return _cariTampilanHome(data.task.data, sender);
      case "edit profile":
        return _editProfile(data.task.data, sender);
      case "update notification":
        return _updateNotification(data.task.data, sender);
      case "find password":
        return _cariPassword(data.task.data, sender);
      case "change password":
        return _gantiPassword(data.task.data, sender);
      case "change profile picture":
        return _changeProfilePicture(data.task.data, sender);
      case "log out":
        return _logout(data.task.data, sender);
      case "sign up":
        return _signup(data.task.data, sender);
      case "lupa password":
        return _lupaPassword(data.task.data, sender);

      default:
        return rejectTask(data, sender);
    }
  }

  Future<Messages> _lupaPassword(dynamic data, String sender) async {
    //Fungsi tindakan yang digunakan untuk melakukan pengecekan pada collection imam dan
    //mengirim email
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var checkEmail;
    //////////Melakukan pengecekan pada data  email di collection user
    checkEmail = await userCollection.find({'email': data[0]}).toList();
    if (checkEmail.length == 0) {
      //Jika data email sudah digunakan
      Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "email"));
      return message;
    }

    try {
      //Mengirim ke endpoint email js
      final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json', 'origin': 'http://localhost'},
          body: jsonEncode({
            'service_id': dotenv.env['service_id'].toString(),
            'template_id': dotenv.env['template_id'].toString(),
            'user_id': dotenv.env['user_id'].toString(),
            'template_params': {'user_name': data[0], 'user_email': data[0], 'user_subject': 'Lupa Password', 'password': checkEmail[0]['password']}
          }));
      Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "oke"));
      return message;
    } catch (e) {
      Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "failed"));
      return message;
    }
  }

  Future<Messages> _signup(dynamic data, String sender) async {
    //Fungsi tindakan yang digunakan untuk melakukan pengecekan pada collection user dan
    //menambahkan data
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var checkEmail;
    var checkName;
    //////////Melakukan pengecekan pada data nama dan email di collection user
    await userCollection.find({'nama': data[0]}).toList().then((res) async {
          checkName = res;
          checkEmail = await userCollection.find({'email': data[1]}).toList();
        });
    ///////////////////////////////////
    try {
      if (checkName.length > 0) {
        //Jika data nama sudah digunakan
        Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "nama"));
        return message;
      } else if (checkEmail.length > 0) {
        //Jika data email sudah digunakan
        Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "email"));
        return message;
      } else {
        //Jika data nama dan email belum digunakan
        //////Menambahkan data baru pada collection user//////////////////////
        var configJson = modelDB.user(data[0], data[1], data[2], "", 0, false, DateTime.now(), "", "", "", "", "", DateTime.now());
        var add = await userCollection.insertOne(configJson);
        //////////////////////////////////////////////////////////////////////
        if (add.isSuccess) {
          Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "oke"));
          return message;
        } else {
          Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "failed"));
          return message;
        }
      }
    } catch (e) {
      Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "failed"));
      return message;
    }
  }

  Future<Messages> _cariUser(dynamic data, String sender) async {
    //Fungsi tindakan yang digunakan untuk melakukan pencarian pada collection user
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var conn = await userCollection.find({'_id': data}).toList(); //Pencarian berdasarkan id
    Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", conn));
    return message;
  }

  Future<Messages> _logIn(dynamic data, String sender) async {
    //Fungsi tindakan yang digunakan saat pengguna login
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var conn = await userCollection.find({'email': data[0], 'password': data[1]}).toList(); //Pencarian berdasarkan
    //password dan email

    if (conn.length != 0) {
      //Jika email dan password ditemukan
      var conn2 = await userCollection.updateOne(
          //Mengupdate data token pada collection user
          where.eq('email', data[0]).eq('password', data[1]),
          modify.set('token', await FirebaseMessaging.instance.getToken()));
      print("Get data from collection user and ready to send it to agent setting");
      sendToAgenSettinglogIn(conn, agentName); //Berkoordinasi dengan agen Setting
    }

    Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", conn));
    return message;
  }

  Future<Messages> _logout(dynamic data, String sender) async {
    //Fungsi tindakan yang digunakan untuk melakukan pembaruan pada data token
    //di collection user dan berkoordinasi dengan agen Setting
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var update = await userCollection.updateOne(where.eq('_id', data), modify.set('token', "")); //Token diperbarui menjadi kosong

    sendToAgenSettingLogout(null, agentName); //Fungsi tindakan mengirim pesan kepada agen Setting
    if (update.isSuccess) {
      //Jika pembaruan berhasil
      Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "oke"));
      return message;
    } else {
      //Jika pembaruan gagal
      Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "failed"));
      return message;
    }
  }

  sendToAgenSettinglogIn(dynamic data, String sender) async {
    //Fungsi tindakan yang membuat pesan dengan tugas "save data" untuk dikirim ke agen Setting
    Messages message = Messages(sender, "Agent Setting", "REQUEST", Tasks('save data', data));
    MessagePassing messagePassing = MessagePassing(); //Memanggil distributor pesan
    messagePassing.sendMessage(message);
  }

  sendToAgenSettingLogout(dynamic data, String sender) async {
    //Fungsi tindakan yang membuat pesan dengan tugas "log out" untuk dikirim ke agen Setting
    Messages message = Messages(sender, "Agent Setting", "REQUEST", Tasks('log out', data));
    MessagePassing messagePassing = MessagePassing(); //Memanggil distributor pesan
    messagePassing.sendMessage(message);
  }

  Future<Messages> _cariProfile(dynamic data, String sender) async {
    //Fungsi tindakan untuk mencari tampilan halaman profile dan berkooperasi dengan
    //agen Pencarian
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var conn = await userCollection.find({'_id': data}).toList();
    //Pencarian pada collection user berdasarkan id
    Messages message2 = Messages(sender, 'Agent Pencarian', "REQUEST", Tasks('cari profile', [data, conn]));
    // Membuat pesan dengan tugas "cari profile" untuk dikirim ke agen Pencarian
    MessagePassing messagePassing2 = MessagePassing();
    await messagePassing2.sendMessage(message2);
    //Mengirim pesan ke agen Pencarian

    Messages message = Messages(agentName, sender, "INFORM", Tasks("done", "wait"));
    return message;
  }

  Future<Messages> _cariTampilanHome(dynamic data, String sender) async {
    //Fungsi tindakan untuk mencari tampilan halaman home dan berkooperasi dengan
    //agen Pencarian
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var conn = await userCollection.find({'_id': data}).toList();
    //Pencarian pada collection user berdasarkan id
    Messages message2 = Messages(sender, 'Agent Pencarian', "REQUEST", Tasks('cari tampilan home', [data, conn]));
    // Membuat pesan dengan tugas "cari tampilan home" untuk dikirim ke agen Pencarian
    MessagePassing messagePassing2 = MessagePassing();
    await messagePassing2.sendMessage(message2);
    //Mengirim pesan ke agen Pencarian

    Messages message = Messages(agentName, sender, "INFORM", Tasks("done", "wait"));
    return message;
  }

  Future<Messages> _editProfile(dynamic data, String sender) async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var checkEmail;
    var checkName;

    checkName = await userCollection.find(where.eq('nama', data[1]).ne('_id', data[0])).toList(); //Check nama apakah sudah digunakan atau belum selain
    //pada data dengan id data[0] di collection User

    checkEmail = await userCollection.find(where.eq('email', data[2]).ne('_id', data[0])).toList(); //Check email apakah sudah digunakan atau belum selain
    //pada data dengan id data[0] User

    if (checkName.length > 0) {
      //Jika nama sudah digunakan
      Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "nama"));
      return message;
    } else if (checkEmail.length > 0) {
      //Jika email sudah digunakan
      Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "email"));
      return message;
    }
    //Jika belum digunakan maka pembaruan pada collection user berdasarkan id data[0]
    var update = await userCollection.updateOne(
        where.eq('_id', data[0]),
        modify
            .set('nama', data[1])
            .set('email', data[2])
            .set('paroki', data[3])
            .set(
              'lingkungan',
              data[4],
            )
            .set('notelp', data[5])
            .set('alamat', data[6])
            .set('updatedAt', DateTime.now()));

    if (update.isSuccess) {
      //Jika pembaruan berhasil
      Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "oke"));
      return message;
    } else {
      //Jika pembaruan gagal
      Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "failed"));
      return message;
    }
  }

  Future<Messages> _updateNotification(dynamic data, String sender) async {
    //pembaruan data notifikasiGD pada collection user
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var update = await userCollection.updateOne(where.eq('_id', data[0]), modify.set('notifGD', data[1]).set('updatedAt', DateTime.now()));
    //pembaruan data notifGD dan updatedAt berdasarkan id dengan data[0]
    if (update.isSuccess) {
      //Jika pembaruan berhasil
      Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "oke"));
      return message;
    } else {
      //Jika pembaruan gagal
      Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "failed"));
      return message;
    }
  }

  Future<Messages> _cariPassword(dynamic data, String sender) async {
    //Fungsi tindakan tindakan untuk melakuka pengecekan saat pengguna ganti
    //passowrd
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var conn = await userCollection.find({'_id': data[0], 'password': data[1]}).toList();
    //Pencarian pada collection user berdasarkan id data[0] dan password data[1]
    try {
      if (conn[0]['_id'] == null) {
        //Jika tidak ditemukan
        Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "not"));
        return message;
      } else {
        //Jika ditemukan
        Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "found"));
        return message;
      }
    } catch (e) {
      //Jika tidak ditemukan dan error
      Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "not"));
      return message;
    }
  }

  Future<Messages> _gantiPassword(dynamic data, String sender) async {
    //pembaruan data password pada collection user
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var update = await userCollection.updateOne(where.eq('_id', data[0]), modify.set('password', data[1]).set('updatedAt', DateTime.now()));
    //pembaruan data password dan updatedAt berdasarkan id dengan data[0]
    if (update.isSuccess) {
      //Jika pembaruan berhasil
      Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "not"));
      return message;
    } else {
      //Jika pembaruan gagal
      Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "found"));
      return message;
    }
  }

  Future<Messages> _changeProfilePicture(dynamic data, String sender) async {
    //pembaruan data picture pada collection user dan menambahkan data baru pada
    //firebase
    var urlDownload = await FirebaseApi.configureUpload('files/Pelayanan Imam Katolik/', data[1]); //Memanggil fungsi pada kelas
    //firebase dengan parameter path penyimpanan pada firebase dan data[1] sebagai file

    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var conn = await userCollection.updateOne(where.eq('_id', data[0]), modify.set('picture', urlDownload).set('updatedAt', DateTime.now()));
    //pembaruan data picture dan updatedAt berdasarkan id dengan data[0] dan
    //data picture dari hasil penyimpanan firebase
    if (conn.isSuccess) {
      //Jika pembaruan berhasil
      Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "not"));
      return message;
    } else {
      //Jika pembaruan gagal
      Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "found"));
      return message;
    }
  }

  @override
  addEstimatedTime(String goals) {
    //Fungsi menambahkan batas waktu pengerjaan tugas dengan 1 detik
    _timeAction[goals] = _timeAction[goals]! + 1;
  }

  void _initAgent() {
    //Inisialisasi identitas agen
    this.agentName = "Agent Akun";
    //nama agen
    plan = [
      Plan("login", "REQUEST"),
      Plan("sign up", "REQUEST"),
      Plan("cari user", "REQUEST"),
      Plan("cari profile", "REQUEST"),
      Plan("cari tampilan home", "REQUEST"),
      Plan("edit profile", "REQUEST"),
      Plan("update notification", "REQUEST"),
      Plan("find password", "REQUEST"),
      Plan("change password", "REQUEST"),
      Plan("change profile picture", "REQUEST"),
      Plan("log out", "REQUEST"),
      Plan("lupa password", "REQUEST"),
    ];
    //Perencanaan agen
    goals = [
      Goals("login", List<Map<String, Object?>>, _timeAction["login"]),
      Goals("cari user", List<Map<String, Object?>>, _timeAction["cari user"]),
      Goals("cari profile", List<dynamic>, _timeAction["cari profile"]),
      Goals("cari tampilan home", List<dynamic>, _timeAction["cari tampilan home"]),
      Goals("edit profile", String, _timeAction["edit profile"]),
      Goals("update notification", String, _timeAction["update notification"]),
      Goals("find password", String, _timeAction["find password"]),
      Goals("change password", String, _timeAction["change password"]),
      Goals("change profile picture", String, _timeAction["change profile picture"]),
      Goals("log out", String, _timeAction["log out"]),
      Goals("sign up", String, _timeAction["sign up"]),
      Goals("lupa password", String, _timeAction["lupa password"]),
    ]; //goals agen
  }
}
