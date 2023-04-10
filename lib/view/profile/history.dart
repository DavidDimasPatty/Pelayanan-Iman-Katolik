import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/view/profile/profile.dart';
import 'package:pelayanan_iman_katolik/view/sakramen/perkawinan/tiketSayaDetailPerkawinan.dart';
import 'package:pelayanan_iman_katolik/view/sakramen/perkawinan/tiketSayaPerkawinanHistory.dart';
import 'package:pelayanan_iman_katolik/view/umum/tiketSayaDetailKegiatan.dart';
import 'package:pelayanan_iman_katolik/view/umum/tiketSayaKegiatanHistory.dart';

import '../homePage.dart';
import '../sakramen/baptis/tiketSayaBaptisHistory.dart';
import '../sakramen/komuni/tiketSayaKomuniHistory.dart';
import '../sakramen/krisma/tiketSayaKrismaHistory.dart';
import '../sakramentali/pemberkatan/tiketSayaPemberkatanHistory.dart';
import '../settings/setting.dart';
import '../tiketSaya.dart';

class history extends StatefulWidget {
  final iduser;
  history(this.iduser);
  @override
  _history createState() => _history(this.iduser);
}

class _history extends State<history> {
  var iduser;

  _history(this.iduser);

  Future<List> callDb() async {
    // Messages msg = new Messages();
    // msg.addReceiver("agenPencarian");
    // msg.setContent([
    //   ["cari Enroll History Done"],
    //   [idUser]
    // ]);
    // List k = [];
    // await msg.send().then((res) async {
    //   print("masuk");
    //   print(await AgenPage().receiverTampilan());
    // });
    // await Future.delayed(Duration(seconds: 1));
    // k = await AgenPage().receiverTampilan();

    // return k;
    Completer<void> completer = Completer<void>();
    Messages message = Messages('Agent Page', 'Agent Pencarian', "REQUEST",
        Tasks('cari jadwal pendaftaran', ["history", iduser]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    var hasil = await await AgentPage.getDataPencarian();
    completer.complete();

    await completer.future;
    return hasil;
  }

  Future pullRefresh() async {
    setState(() {
      callDb();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text('Jadwal Saya'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile(this.iduser)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings(this.iduser)),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
          onRefresh: pullRefresh,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(right: 15, top: 10, left: 15),
            children: <Widget>[
              FutureBuilder<List>(
                  future: callDb(),
                  builder: (context, AsyncSnapshot snapshot) {
                    try {
                      return Column(children: <Widget>[
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 8),
                            child: Text(
                              "Baptis yang Terdaftar",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 23.0),
                            )),
                        if (snapshot.data.length == 0)
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 8),
                              child: Text(
                                "Tidak Ada Baptis yang Didaftar",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 15.0),
                              )),
                        if (snapshot.data[0].length != 0)
                          for (var i in snapshot.data[0])
                            InkWell(
                                borderRadius: new BorderRadius.circular(24),
                                onTap: () {
                                  tiketSayaBaptisHistory(
                                          iduser,
                                          i['UserBaptis'][0]['_id'],
                                          i['UserBaptis'][0]['idGereja'],
                                          i['_id'])
                                      .showDialogBox(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.topLeft,
                                        colors: [
                                          Colors.blueAccent,
                                          Colors.lightBlue,
                                        ]),
                                    border: Border.all(
                                      color: Colors.lightBlue,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Jadwal : " +
                                            i['UserBaptis'][0]['jadwalBuka']
                                                .toString()
                                                .substring(0, 19) +
                                            " s/d " +
                                            i['UserBaptis'][0]['jadwalTutup']
                                                .toString()
                                                .substring(0, 19),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      Text(
                                        i['status'] == 0
                                            ? ' Status : Belum Hadir'
                                            : i['status'] == -1
                                                ? ' Status : Dibatalkan'
                                                : ' Status : Sudah Dihadiri',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                )),

                        /////////

                        Column(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 8),
                                child: Text(
                                  "Komuni yang Terdaftar",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 23.0),
                                )),
                            if (snapshot.data[1].length == 0)
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 8),
                                  child: Text(
                                    "Tidak Ada Komuni yang Didaftar",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15.0),
                                  )),
                            if (snapshot.data[1].length != 0)
                              for (var i in snapshot.data[1])
                                InkWell(
                                    borderRadius: new BorderRadius.circular(24),
                                    onTap: () {
                                      tiketSayaKomuniHistory(
                                              iduser,
                                              i['UserKomuni'][0]['_id'],
                                              i['UserKomuni'][0]['idGereja'],
                                              i['_id'])
                                          .showDialogBox(context);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.topLeft,
                                            colors: [
                                              Colors.blueAccent,
                                              Colors.lightBlue,
                                            ]),
                                        border: Border.all(
                                          color: Colors.lightBlue,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Jadwal : " +
                                                i['UserKomuni'][0]['jadwalBuka']
                                                    .toString()
                                                    .substring(0, 19) +
                                                " s/d " +
                                                i['UserKomuni'][0]
                                                        ['jadwalTutup']
                                                    .toString()
                                                    .substring(0, 19),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          // Text(
                                          //   "Nama Gereja : " +
                                          //       snapshot.data[0]['nama']
                                          //           .toString(),
                                          //   style: TextStyle(
                                          //       color: Colors.white,
                                          //       fontSize: 15.0,
                                          //       fontWeight: FontWeight.w300),
                                          // ),
                                          Text(
                                            i['status'] == 0
                                                ? ' Status : Belum Hadir'
                                                : i['status'] == -1
                                                    ? ' Status : Dibatalkan'
                                                    : ' Status : Sudah Dihadiri',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    )),

                            /////////
                          ],
                        ),

                        Column(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 8),
                                child: Text(
                                  "Krisma yang Terdaftar",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 23.0),
                                )),
                            if (snapshot.data[2].length == 0)
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 8),
                                  child: Text(
                                    "Tidak Ada Krisma yang Didaftar",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15.0),
                                  )),
                            if (snapshot.data[2].length != 0)
                              for (var i in snapshot.data[2])
                                InkWell(
                                    borderRadius: new BorderRadius.circular(24),
                                    onTap: () {
                                      tiketSayaKrismaHistory(
                                              iduser,
                                              i['UserKrisma'][0]['_id'],
                                              i['UserKrisma'][0]['idGereja'],
                                              i['_id'])
                                          .showDialogBox(context);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.topLeft,
                                            colors: [
                                              Colors.blueAccent,
                                              Colors.lightBlue,
                                            ]),
                                        border: Border.all(
                                          color: Colors.lightBlue,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Jadwal : " +
                                                i['UserKrisma'][0]['jadwalBuka']
                                                    .toString()
                                                    .substring(0, 19) +
                                                " s/d " +
                                                i['UserKrisma'][0]
                                                        ['jadwalTutup']
                                                    .toString()
                                                    .substring(0, 19),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          // Text(
                                          //   "Nama Gereja : " +
                                          //       snapshot.data[0]['nama'],
                                          //   style: TextStyle(
                                          //       color: Colors.white,
                                          //       fontSize: 15.0,
                                          //       fontWeight: FontWeight.w300),
                                          // ),
                                          Text(
                                            i['status'] == 0
                                                ? ' Status : Belum Hadir'
                                                : i['status'] == -1
                                                    ? ' Status : Dibatalkan'
                                                    : ' Status : Sudah Dihadiri',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    )),

                            /////////
                          ],
                        ),

                        Column(children: <Widget>[
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 8),
                              child: Text(
                                "Kegiatan Umum yang Terdaftar",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20.0),
                              )),
                          if (snapshot.data[3].length == 0)
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 8),
                                child: Text(
                                  "Tidak Ada Kegiatan Umum yang Didaftar",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 15.0),
                                )),
                          if (snapshot.data[3].length != 0)
                            for (var i in snapshot.data[3])
                              InkWell(
                                  borderRadius: new BorderRadius.circular(24),
                                  onTap: () {
                                    tiketSayaKegiatanHistory(
                                      iduser,
                                      i['_id'],
                                      i['UserKegiatan'][0]['_id'],
                                    ).showDialogBox(context);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.topLeft,
                                          colors: [
                                            Colors.blueAccent,
                                            Colors.lightBlue,
                                          ]),
                                      border: Border.all(
                                        color: Colors.lightBlue,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          "Jadwal : " +
                                              i['UserKegiatan'][0]['tanggal']
                                                  .toString()
                                                  .substring(0, 19),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Text(
                                          "Nama Kegiatan : " +
                                              i['UserKegiatan'][0]
                                                  ['namaKegiatan'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Text(
                                          "Lokasi : " +
                                              i['UserKegiatan'][0]['lokasi'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                  )),

                          /////////

                          Column(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 8),
                                  child: Text(
                                    "Pemberkatan yang Terdaftar",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 23.0),
                                  )),
                              if (snapshot.data[4].length == 0)
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 8),
                                    child: Text(
                                      "Tidak Ada Pemberkatan yang Didaftar",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15.0),
                                    )),
                              if (snapshot.data[4].length != 0)
                                for (var i in snapshot.data[4])
                                  InkWell(
                                      borderRadius:
                                          new BorderRadius.circular(24),
                                      onTap: () {
                                        tiketSayaPemberkatanHistory(
                                          iduser,
                                          i['_id'],
                                        ).showDialogBox(context);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.topLeft,
                                              colors: [
                                                Colors.blueAccent,
                                                Colors.lightBlue,
                                              ]),
                                          border: Border.all(
                                            color: Colors.lightBlue,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "Jadwal : " +
                                                  i['tanggal']
                                                      .toString()
                                                      .substring(0, 19),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            Text(
                                              "Nama Kegiatan : Pemberkatan " +
                                                  i['jenis'],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            if (i['status'] == 0)
                                              Text(
                                                "Status : Menunggu",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            if (i['status'] == 1)
                                              Text(
                                                "Status : Disetujui",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            if (i['status'] == -1)
                                              Text(
                                                "Status : Ditolak",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                          ],
                                        ),
                                      )),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 8),
                              ),
                              /////////
                            ],
                          )
                        ]),
                        Column(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 8),
                                child: Text(
                                  "Pernikahan yang Terdaftar",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 23.0),
                                )),
                            if (snapshot.data[5].length == 0)
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 8),
                                  child: Text(
                                    "Tidak Ada Pernikahan yang Didaftar",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15.0),
                                  )),
                            if (snapshot.data[5].length != 0)
                              for (var i in snapshot.data[5])
                                InkWell(
                                    borderRadius: new BorderRadius.circular(24),
                                    onTap: () {
                                      tiketSayaPerkawinanHistory(
                                        iduser,
                                        i['_id'],
                                      ).showDialogBox(context);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.topLeft,
                                            colors: [
                                              Colors.blueAccent,
                                              Colors.lightBlue,
                                            ]),
                                        border: Border.all(
                                          color: Colors.lightBlue,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Jadwal : " +
                                                i['tanggal']
                                                    .toString()
                                                    .substring(0, 19),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          Text(
                                            "Nama Pasangan : " +
                                                i['namaPria'] +
                                                " dan " +
                                                i['namaPerempuan'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          if (i['status'] == 0)
                                            Text(
                                              "Status : Menunggu",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          if (i['status'] == 1)
                                            Text(
                                              "Status : Disetujui",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          if (i['status'] == -1)
                                            Text(
                                              "Status : Ditolak",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                        ],
                                      ),
                                    )),

                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 8),
                            ),
                            /////////
                          ],
                        )
                      ]);
                    } catch (e) {
                      print(e);
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            ],
          )),
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              unselectedItemColor: Colors.blue,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: Color.fromARGB(255, 0, 0, 0)),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.token),
                  label: "Jadwalku",
                )
              ],
              onTap: (index) {
                if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => tiketSaya(this.iduser)),
                  );
                } else if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(this.iduser)),
                  );
                }
              },
            ),
          )),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: new FloatingActionButton(
      //   onPressed: () {
      //     openCamera();
      //   },
      //   tooltip: 'Increment',
      //   child: new Icon(Icons.camera_alt_rounded),
      // ),
    );
  }
}
