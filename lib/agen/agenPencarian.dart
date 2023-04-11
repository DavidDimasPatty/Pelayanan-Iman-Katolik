import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import '../DatabaseFolder/data.dart';
import '../DatabaseFolder/mongodb.dart';
import 'Agent.dart';
import 'Goals.dart';
import 'MessagePassing.dart';
import 'Plan.dart';
import 'Task.dart';

class AgentPencarian extends Agent {
  AgentPencarian() {
    _initAgent();
  }

  List<Plan> _plan = [];
  List<Goals> _goals = [];
  int _estimatedTime = 5;
  bool stop = false;
  String agentName = "";
  List _Message = [];
  List _Sender = [];

  bool canPerformTask(dynamic message) {
    for (var p in _plan) {
      if (p.goals == message.task.action && p.protocol == message.protocol) {
        return true;
      }
    }
    return false;
  }

  Future<dynamic> receiveMessage(Messages msg, String sender) {
    print(agentName + ' received message from $sender');
    _Message.add(msg);
    _Sender.add(sender);
    return performTask();
  }

  Future<dynamic> performTask() async {
    Messages msg = _Message.last;
    String sender = _Sender.last;
    dynamic task = msg.task;
    var planQuest =
        _plan.where((element) => element.goals == task.action).toList();
    Plan p = planQuest[0];
    var goalsQuest =
        _goals.where((element) => element.request == p.goals).toList();
    int clock = goalsQuest[0].time;
    Goals goalquest = goalsQuest[0];

    Timer timer = Timer.periodic(Duration(seconds: clock), (timer) {
      stop = true;
      timer.cancel();

      MessagePassing messagePassing = MessagePassing();
      Messages msg = rejectTask(task, sender);
      messagePassing.sendMessage(msg);
      return;
    });

    Messages message = await action(p.goals, task.data, sender);

    if (stop == false) {
      if (timer.isActive) {
        timer.cancel();
        bool checkGoals = false;
        if (message.task.data.runtimeType == String &&
            message.task.data == "failed") {
          MessagePassing messagePassing = MessagePassing();
          Messages msg = rejectTask(task, sender);
          messagePassing.sendMessage(msg);
        } else {
          for (var g in _goals) {
            if (g.request == p.goals &&
                g.goals == message.task.data.runtimeType) {
              checkGoals = true;
              break;
            }
          }

          if (checkGoals == true) {
            print(agentName + ' returning data to ${message.receiver}');
            MessagePassing messagePassing = MessagePassing();
            messagePassing.sendMessage(message);
          } else {
            rejectTask(task, sender);
          }
        }
      }
    }
  }

  Future<Messages> action(String goals, dynamic data, String sender) async {
    switch (goals) {
      case "cari pengumuman":
        return cariPengumuman(data, sender);
      case "cari jadwal pendaftaran":
        return cariJadwalPendaftaran(data, sender);
      case "cari pelayanan":
        return cariPelayanan(data, sender);
      case "cari tampilan home":
        return cariTampilanHome(data, sender);
      case "check pendaftaran":
        return checkPendaftaran(data, sender);
      case "cari profile":
        return cariProfile(data, sender);
      default:
        return rejectTask(data, data);
    }
  }

  Future<Messages> cariProfile(dynamic data, String sender) async {
    var userKrismaCollection =
        MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
    var userBaptisCollection =
        MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
    var userKomuniCollection =
        MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
    var userPemberkatanCollection =
        MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
    var userKegiatanCollection =
        MongoDatabase.db.collection(USER_UMUM_COLLECTION);
    var pemberkatanCollection =
        MongoDatabase.db.collection(USER_UMUM_COLLECTION);
    var perkawinanCollection =
        MongoDatabase.db.collection(USER_UMUM_COLLECTION);
    var count = 0;

    var countKr = await userKrismaCollection
        .find({'idUser': data[0], 'status': 0}).length;

    var countB = await userBaptisCollection
        .find({'idUser': data[0], 'status': 0}).length;
    var countKo = await userKomuniCollection
        .find({'idUser': data[0], 'status': 0}).length;
    var countP = await userPemberkatanCollection
        .find({'idUser': data, 'status': 0}).length;
    var countKe = await userKegiatanCollection
        .find({'idUser': data[0], 'status': 0}).length;
    var countPem = await pemberkatanCollection
        .find({'idUser': data[0], 'status': 0}).length;
    var countPerk = await perkawinanCollection
        .find({'idUser': data[0], 'status': 0}).length;

    Messages message = Messages(
        agentName,
        sender,
        "INFORM",
        Tasks("hasil pencarian", [
          data[1],
          countKr + countB + countKo + countP + countKe + countPem + countPerk
        ]));
    return message;
  }

  Future<Messages> checkPendaftaran(dynamic data, String sender) async {
    var pelayananCollection;
    String id = "";
    if (data[0] == "baptis") {
      pelayananCollection = MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
      id = "idBaptis";
    }

    if (data[0] == "komuni") {
      pelayananCollection = MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
      id = "idKomuni";
    }
    if (data[0] == "krisma") {
      pelayananCollection = MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
      id = "idKrisma";
    }
    if (data[0] == "umum") {
      pelayananCollection = MongoDatabase.db.collection(USER_UMUM_COLLECTION);
      id = "idKegiatan";
    }

    var hasil = await pelayananCollection
        .find(where.eq(id, data[1]).eq("idUser", data[2]).eq("status", 0))
        .length;

    if (hasil == 0) {
      Completer<void> completer = Completer<void>();
      Messages message2 = Messages(sender, 'Agent Pendaftaran', "REQUEST",
          Tasks('enroll pelayanan', data));
      MessagePassing messagePassing2 = MessagePassing();
      await messagePassing2.sendMessage(message2);

      Messages message = Messages(
          agentName, sender, "INFORM", Tasks('wait', "Wait agent pendaftaran"));
      // Future.delayed(Duration(seconds: 1));
      completer.complete();

      await completer.future;
      return await message;
    } else {
      Messages message = Messages('Agent Pencarian', sender, "INFORM",
          Tasks('hasil pencarian', "sudah"));
      return message;
    }
  }

  Future<Messages> cariJadwalPendaftaran(dynamic data, String sender) async {
    dynamic statusQuery;
    dynamic statusPemPer;
    if (data[0] == "current") {
      statusQuery = where.eq('idUser', data[1]).eq('status', 0).map['\$query'];
      statusPemPer = {'idUser': data[1], 'status': 0};
    }
    if (data[0] == "history") {
      statusQuery = where.eq('idUser', data[1]).ne('status', 0).map['\$query'];
      statusPemPer = {'idUser': data[1]};
    }
    var userKegiatanCollection =
        MongoDatabase.db.collection(USER_UMUM_COLLECTION);
    final pipeline1 = AggregationPipelineBuilder()
        .addStage(
          Lookup(
              from: 'umum',
              localField: 'idKegiatan',
              foreignField: '_id',
              as: 'UserKegiatan'),
        )
        .addStage(Match(statusQuery))
        .build();
    var resUmum =
        await userKegiatanCollection.aggregateToStream(pipeline1).toList();
    //////////Krisma
    var userKrismaCollection =
        MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
    final pipeline2 = AggregationPipelineBuilder()
        .addStage(
          Lookup(
              from: 'krisma',
              localField: 'idKrisma',
              foreignField: '_id',
              as: 'UserKrisma'),
        )
        .addStage(Match(statusQuery))
        .build();
    var resKrisma =
        await userKrismaCollection.aggregateToStream(pipeline2).toList();
    //////////Baptis
    var userBaptisCollection =
        MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
    final pipeline3 = AggregationPipelineBuilder()
        .addStage(
          Lookup(
              from: 'baptis',
              localField: 'idBaptis',
              foreignField: '_id',
              as: 'UserBaptis'),
        )
        .addStage(Match(statusQuery))
        .build();
    var resBaptis =
        await userBaptisCollection.aggregateToStream(pipeline3).toList();
    //////////Komuni
    var userKomuniCollection =
        MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
    final pipeline4 = AggregationPipelineBuilder()
        .addStage(
          Lookup(
              from: 'komuni',
              localField: 'idKomuni',
              foreignField: '_id',
              as: 'UserKomuni'),
        )
        .addStage(Match(statusQuery))
        .build();
    var resKomuni =
        await userKomuniCollection.aggregateToStream(pipeline4).toList();
    //////////Pemberkatan
    var pemberkatanCollection =
        MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
    var resPemberkatan =
        await pemberkatanCollection.find(statusPemPer).toList();
    var perkawinanCollection =
        MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
    var resPerkawinan = await perkawinanCollection.find(statusPemPer).toList();

    Messages message = Messages(
        'Agent Pencarian',
        sender,
        "INFORM",
        Tasks('hasil pencarian', [
          resBaptis,
          resKomuni,
          resKrisma,
          resUmum,
          resPemberkatan,
          resPerkawinan
        ]));
    return message;
  }

  Future<Messages> cariTampilanHome(dynamic data, String sender) async {
    // var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    // var dataUser = await userCollection.find({'_id': data[0]}).toList();

    var userKrismaCollection =
        MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
    var userBaptisCollection =
        MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
    var userKomuniCollection =
        MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
    var perkawinanCollection =
        MongoDatabase.db.collection(PERKAWINAN_COLLECTION);

    var pemberkatanCollection =
        MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);

    var userKegiatanCollection =
        MongoDatabase.db.collection(USER_UMUM_COLLECTION);
    var dateKri = await userKrismaCollection
        .find(where
            .eq("idUser", data[0])
            .eq("status", 0)
            .sortBy('tanggalDaftar', descending: true)
            .limit(1))
        .toList();
    var dateBap = await userBaptisCollection
        .find(where
            .eq("idUser", data[0])
            .eq("status", 0)
            .sortBy('tanggalDaftar', descending: true)
            .limit(1))
        .toList();
    var dateKom = await userKomuniCollection
        .find(where
            .eq("idUser", data[0])
            .eq("status", 0)
            .sortBy('tanggalDaftar', descending: true)
            .limit(1))
        .toList();

    var dateKeg = await userKegiatanCollection
        .find(where
            .eq("idUser", data[0])
            .eq("status", 0)
            .sortBy('tanggalDaftar', descending: true)
            .limit(1))
        .toList();

    var datePem = await pemberkatanCollection
        .find(where
            .eq("idUser", data[0])
            .eq("status", 0)
            .sortBy('tanggal', descending: true)
            .limit(1))
        .toList();

    var datePerk = await perkawinanCollection
        .find(where
            .eq("idUser", data[0])
            .eq("status", 0)
            .sortBy('tanggal', descending: true)
            .limit(1))
        .toList();

    DateTime ans = DateTime.utc(1989, 11, 9);
    var hasil = null;
    try {
      if (ans.compareTo(
              DateTime.parse(dateBap[0]['tanggalDaftar'].toString())) <
          0) {
        ans = DateTime.parse(dateBap[0]['tanggalDaftar'].toString());
        hasil = dateBap;
      }
    } catch (e) {}

    try {
      if (ans.compareTo(
              DateTime.parse(dateKom[0]['tanggalDaftar'].toString())) <
          0) {
        ans = DateTime.parse(dateKom[0]['tanggalDaftar'].toString());
        hasil = dateKom;
      }
    } catch (e) {}
    try {
      if (ans.compareTo(
              DateTime.parse(dateKeg[0]['tanggalDaftar'].toString())) <
          0) {
        ans = DateTime.parse(dateKeg[0]['tanggalDaftar'].toString());
        hasil = dateKeg;
      }
    } catch (e) {}
    try {
      if (ans.compareTo(
              DateTime.parse(dateKri[0]['tanggalDaftar'].toString())) <
          0) {
        ans = DateTime.parse(dateKri[0]['tanggalDaftar'].toString());
        hasil = dateKri;
      }
    } catch (e) {}

    try {
      if (ans.compareTo(DateTime.parse(datePem[0]['tanggal'].toString())) < 0) {
        ans = DateTime.parse(datePem[0]['tanggal'].toString());
        hasil = datePem;
      }
    } catch (e) {}

    try {
      if (ans.compareTo(DateTime.parse(datePerk[0]['tanggal'].toString())) <
          0) {
        ans = DateTime.parse(datePerk[0]['tanggal'].toString());
        hasil = datePerk;
      }
    } catch (e) {}

    var gambarGerejaCollection =
        MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
    var connGambar = await gambarGerejaCollection
        .find(
            where.sortBy('tanggal', descending: false).eq("status", 0).limit(4))
        .toList();

    if (hasil != null) {
      var jadwalCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
      var conn =
          await jadwalCollection.find({'_id': hasil[0]['idGereja']}).toList();
      Messages message = Messages('Agent Pencarian', sender, "INFORM",
          Tasks('hasil pencarian', [data[1], conn, hasil, connGambar]));
      return message;
    } else {
      Messages message = Messages('Agent Pencarian', sender, "INFORM",
          Tasks('hasil pencarian', [data[1], null, hasil, connGambar]));
      return message;
    }
  }

  Future<Messages> cariPengumuman(dynamic data, String sender) async {
    var pengumumanCollection =
        MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
    if (data[0] == "general") {
      final pipeline = AggregationPipelineBuilder()
          .addStage(Lookup(
              from: 'Gereja',
              localField: 'idGereja',
              foreignField: '_id',
              as: 'GerejaPengumuman'))
          .addStage(Match(where.eq('status', 0).map['\$query']))
          .build();
      var conn =
          await pengumumanCollection.aggregateToStream(pipeline).toList();
      Messages message = Messages(
          'Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', conn));
      return message;
    } else {
      var pengumumanCollection =
          MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
      final pipeline = AggregationPipelineBuilder()
          .addStage(Lookup(
              from: 'Gereja',
              localField: 'idGereja',
              foreignField: '_id',
              as: 'GerejaPengumuman'))
          .addStage(Match(where.eq("_id", data[1]).map['\$query']))
          .build();
      var conn =
          await pengumumanCollection.aggregateToStream(pipeline).toList();
      Messages message = Messages(
          'Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', conn));
      return message;
    }
  }

  Future<Messages> cariPelayanan(dynamic data, String sender) async {
    var pelayananCollection;
    var aturanCollection =
        MongoDatabase.db.collection(ATURAN_PELAYANAN_COLLECTION);
    String as = "";
    //////BAPTIS ATAU KOMUNI ATAU KRISMA
    if (data[0] == "baptis" || data[0] == "krisma" || data[0] == "komuni") {
      if (data[0] == "baptis") {
        pelayananCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
        as = "GerejaBaptis";
      }

      if (data[0] == "komuni") {
        pelayananCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
        as = "GerejaKomuni";
      }
      if (data[0] == "krisma") {
        pelayananCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
        as = "GerejaKrisma";
      }
      if (data[1] == "general") {
        final pipeline = AggregationPipelineBuilder()
            .addStage(Match(where
                .eq('status', 0)
                .gt("kapasitas", 0)
                .gte("jadwalTutup", DateTime.now())
                .map['\$query']))
            .addStage(Lookup(
                from: 'Gereja',
                localField: 'idGereja',
                foreignField: '_id',
                as: as))
            .build();
        var conn =
            await pelayananCollection.aggregateToStream(pipeline).toList();
        Messages message = Messages('Agent Pencarian', sender, "INFORM",
            Tasks('hasil pencarian', conn));
        return message;
      } else {
        var aturan =
            await aturanCollection.find(where.eq("idGereja", data[3])).toList();

        final pipeline = AggregationPipelineBuilder()
            .addStage(Lookup(
                from: 'Gereja',
                localField: 'idGereja',
                foreignField: '_id',
                as: as))
            .addStage(Match(where.eq('_id', data[2]).map['\$query']))
            .build();
        var conn =
            await pelayananCollection.aggregateToStream(pipeline).toList();
        Messages message = Messages('Agent Pencarian', sender, "INFORM",
            Tasks('hasil pencarian', [conn, aturan]));
        return message;
      }
    }

    ////PERKAWINAN atau SAKRAMENTALI atau TOBAT atau PERMINYAKAN
    else if (data[0] == "perkawinan" ||
        data[0] == "sakramentali" ||
        data[0] == "tobat" ||
        data[0] == "perminyakan") {
      var pelayanan2Collection;
      String status = "";
      if (data[0] == "tobat") {
        pelayananCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
        as = "GerejaTobat";
        status = "statusTobat";
      }
      if (data[0] == "perminyakan") {
        pelayananCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
        as = "GerejaPerminyakan";
        status = "statusPerminyakan";
      }
      if (data[0] == "perkawinan") {
        pelayananCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
        pelayanan2Collection =
            MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
        as = "GerejaImam";
        status = "statusPerkawinan";
      }
      if (data[0] == "sakramentali") {
        pelayananCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
        pelayanan2Collection =
            MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
        as = "GerejaImam";
        status = "statusPemberkatan";
      }
      if (data[1] == "history") {
        var conn = await pelayanan2Collection.find({'_id': data[2]}).toList();
        Messages message = Messages('Agent Pencarian', sender, "INFORM",
            Tasks('hasil pencarian', conn));
        return message;
      } else if (data[1] == "general") {
        pelayananCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
        final pipeline = AggregationPipelineBuilder()
            .addStage(Lookup(
                from: 'imam',
                localField: '_id',
                foreignField: 'idGereja',
                as: as))
            .addStage(Match(where.eq("banned", 0).map['\$query']))
            .addStage(Match(where.eq('${as}.${status}', 0).map['\$query']))
            .build();
        var conn =
            await pelayananCollection.aggregateToStream(pipeline).toList();
        Messages message = Messages('Agent Pencarian', sender, "INFORM",
            Tasks('hasil pencarian', conn));
        return message;
      } else if (data[1] == "imam") {
        var conn = await pelayananCollection
            .find({'idGereja': data[2], status: 0, "banned": 0}).toList();
        Messages message = Messages('Agent Pencarian', sender, "INFORM",
            Tasks('hasil pencarian', conn));
        return message;
      } else {
        if (data[0] == "perminyakan" || data[0] == "tobat") {
          var aturan = await aturanCollection
              .find(where.eq("idGereja", data[3]))
              .toList();

          final pipeline = AggregationPipelineBuilder()
              .addStage(Lookup(
                  from: 'Gereja',
                  localField: 'idGereja',
                  foreignField: '_id',
                  as: as))
              .addStage(Match(where.eq('_id', data[2]).map['\$query']))
              .build();
          var conn =
              await pelayananCollection.aggregateToStream(pipeline).toList();
          Messages message = Messages('Agent Pencarian', sender, "INFORM",
              Tasks('hasil pencarian', [conn, aturan]));
          return message;
        } else {
          var aturan = await aturanCollection
              .find(where.eq("idGereja", data[2]))
              .toList();
          Messages message = Messages('Agent Pencarian', sender, "INFORM",
              Tasks('hasil pencarian', aturan));
          return message;
        }
      }
    }

    ////UMUM
    else {
      pelayananCollection = MongoDatabase.db.collection(UMUM_COLLECTION);

      if (data[1] == "detail") {
        final pipeline = AggregationPipelineBuilder()
            .addStage(Lookup(
                from: 'Gereja',
                localField: 'idGereja',
                foreignField: '_id',
                as: 'GerejaKegiatan'))
            .addStage(Match(where.eq('_id', data[2]).map['\$query']))
            .build();
        var conn =
            await pelayananCollection.aggregateToStream(pipeline).toList();

        Messages message = Messages('Agent Pencarian', sender, "INFORM",
            Tasks('hasil pencarian', conn));
        return message;
      } else {
        var conn = await pelayananCollection
            .find(where
                .eq('jenisKegiatan', data[2])
                .eq("status", 0)
                .gt("kapasitas", 0)
                .gte("tanggal", DateTime.now()))
            .toList();
        Messages message = Messages('Agent Pencarian', sender, "INFORM",
            Tasks('hasil pencarian', conn));
        return message;
      }
    }
  }

  Messages rejectTask(dynamic task, sender) {
    Messages message = Messages(
        agentName,
        sender,
        "INFORM",
        Tasks('error', [
          ['failed']
        ]));

    print(this.agentName + ' rejected task form $sender: ${task.action}');
    return message;
  }

  Messages overTime(sender) {
    Messages message = Messages(
        sender,
        agentName,
        "INFORM",
        Tasks('error', [
          ['reject over time']
        ]));
    return message;
  }

  void _initAgent() {
    this.agentName = "Agent Pencarian";
    _plan = [
      Plan("cari pengumuman", "REQUEST"),
      Plan("cari jadwal pendaftaran", "REQUEST"),
      Plan("cari pelayanan", "REQUEST"),
      Plan("cari tampilan home", "REQUEST"),
      Plan("check pendaftaran", "REQUEST"),
      Plan("cari profile", "REQUEST"),
    ];
    _goals = [
      Goals("cari pengumuman", List<Map<String, Object?>>, 5),
      Goals("cari jadwal pendaftaran", List<dynamic>, 5),
      Goals("cari pelayanan", List<Map<String, Object?>>, 5),
      Goals("cari pelayanan", List<dynamic>, 5),
      Goals("cari tampilan home", List<dynamic>, 5),
      Goals("check pendaftaran", List<dynamic>, 5),
      Goals("cari profile", List<dynamic>, 5),
      Goals("check pendaftaran", String, 5),
    ];
  }
}
