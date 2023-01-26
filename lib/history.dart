import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/detailDaftarMisa.dart';
import 'package:pelayanan_iman_katolik/historyDetail.dart';
import 'package:pelayanan_iman_katolik/homePage.dart';
import 'package:pelayanan_iman_katolik/profile.dart';
import 'package:pelayanan_iman_katolik/setting.dart';
import 'package:pelayanan_iman_katolik/tiketSaya.dart';
import 'package:pelayanan_iman_katolik/tiketSayaBaptisHistory.dart';
import 'package:pelayanan_iman_katolik/tiketSayaDetail.dart';
import 'package:pelayanan_iman_katolik/tiketSayaDetailBaptis.dart';
import 'package:pelayanan_iman_katolik/tiketSayaDetailKegiatan.dart';
import 'package:pelayanan_iman_katolik/tiketSayaDetailKomuni.dart';
import 'package:pelayanan_iman_katolik/tiketSayaDetailKrisma.dart';
import 'package:pelayanan_iman_katolik/tiketSayaDetailPemberkatan.dart';
import 'package:pelayanan_iman_katolik/tiketSayaKomuniHistory.dart';

class history extends StatefulWidget {
  var names;
  var emails;

  final idUser;
  history(this.names, this.emails, this.idUser);
  @override
  _history createState() => _history(this.names, this.emails, this.idUser);
}

class _history extends State<history> {
  var names;
  var idUser;
  var emails;
  var tiketGereja;
  var tiket;
  var namaGereja;
  var hasil;
  var baptisUser;
  var komuniUser;

  _history(this.names, this.emails, this.idUser);

  Future<List> callDb() async {
    tiketGereja = await MongoDatabase.jadwalHistory(idUser);
    return tiketGereja;
  }

  Future<List> callDbBaptisDaftar() async {
    baptisUser = await MongoDatabase.baptisHistory(idUser);
    return baptisUser;
  }

  Future<List> callDbKomuniDaftar() async {
    komuniUser = await MongoDatabase.komuniHistory(idUser);
    return komuniUser;
  }

  Future<List> callInfoMisa(idMisa) async {
    tiket = await MongoDatabase.jadwalMisaku(idMisa);
    return tiket;
  }

  Future<List> callInfoGereja(idGereja) async {
    namaGereja = await MongoDatabase.cariGereja(idGereja);
    return namaGereja;
  }

  Future<List> callDbKegiatanDaftar() async {
    var kegiatanUser = await MongoDatabase.kegiatanHistory(idUser);
    print(kegiatanUser);
    return kegiatanUser;
  }

  Future<List> callDbPemberkatan() async {
    var pemberkatanUser = await MongoDatabase.pemberkatanHistory(idUser);
    return pemberkatanUser;
  }

  Future<List> callDbKrismaDaftar() async {
    var krismaUser = await MongoDatabase.krismaHistory(idUser);
    return krismaUser;
  }

  Future<List> addChild(idMisa) async {
    var temp;
    tiket = await callInfoMisa(idMisa).then((value) => temp = value);
    tiketGereja = await callInfoGereja(temp[0]['idGereja']);
    hasil = [
      temp[0]['jadwal'].toString().substring(0, 19),
      tiketGereja[0]['nama']
    ];
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
        title: Text('History Pendaftaran'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Profile(names, emails, idUser)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Settings(names, emails, idUser)),
              );
            },
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 10),
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Text(
                "Baptis yang Pernah Didaftar",
                style: TextStyle(color: Colors.black, fontSize: 23.0),
              )),
          FutureBuilder<List>(
              future: callDbBaptisDaftar(),
              builder: (context, AsyncSnapshot snapshot) {
                try {
                  return Column(children: <Widget>[
                    for (var i in snapshot.data)
                      InkWell(
                          borderRadius: new BorderRadius.circular(24),
                          onTap: () {
                            tiketSayaBaptisHistory(
                                    names,
                                    emails,
                                    idUser,
                                    i['UserBaptis'][0]['_id'],
                                    i['UserBaptis'][0]['idGereja'])
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
                                FutureBuilder<List>(
                                    future: callInfoGereja(
                                        i['UserBaptis'][0]['idGereja']),
                                    builder: (context, AsyncSnapshot snapshot) {
                                      try {
                                        return Text(
                                          "Nama Gereja : " +
                                              snapshot.data[0]['nama'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w300),
                                        );
                                      } catch (e) {
                                        print(e);
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                    }),
                                Text(
                                  i['status'] == "0"
                                      ? ' Status : Belum Hadir'
                                      : i['status'] == "-1"
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

                    Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        child: Text(
                          "Komuni yang Pernah Didaftar",
                          style: TextStyle(color: Colors.black, fontSize: 23.0),
                        )),
                    Column(
                      children: <Widget>[
                        for (var i in snapshot.data)
                          InkWell(
                              borderRadius: new BorderRadius.circular(24),
                              onTap: () {
                                tiketSayaKomuniHistory(
                                        names,
                                        emails,
                                        idUser,
                                        i['UserKomuni'][0]['_id'],
                                        i['UserKomuni'][0]['idGereja'])
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
                                          i['UserKomuni'][0]['jadwalBuka']
                                              .toString()
                                              .substring(0, 19) +
                                          " s/d " +
                                          i['UserKomuni'][0]['jadwalTutup']
                                              .toString()
                                              .substring(0, 19),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      "Nama Gereja : " +
                                          snapshot.data[0]['nama'].toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      i['status'] == "0"
                                          ? ' Status : Belum Hadir'
                                          : i['status'] == "-1"
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

                    Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        child: Text(
                          "Krisma yang Pernah Didaftar",
                          style: TextStyle(color: Colors.black, fontSize: 23.0),
                        )),
                    Column(
                      children: <Widget>[
                        for (var i in snapshot.data)
                          InkWell(
                              borderRadius: new BorderRadius.circular(24),
                              onTap: () {
                                tiketSayaDetailKrisma(
                                        names,
                                        emails,
                                        idUser,
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Jadwal : " +
                                          i['UserKrisma'][0]['jadwalBuka']
                                              .toString()
                                              .substring(0, 19) +
                                          " s/d " +
                                          i['UserKrisma'][0]['jadwalTutup']
                                              .toString()
                                              .substring(0, 19),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      "Nama Gereja : " +
                                          snapshot.data[0]['nama'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              )),

                        /////////
                      ],
                    ),

                    Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        child: Text(
                          "Kegiatan Umum yang Pernah Didaftar",
                          style: TextStyle(color: Colors.black, fontSize: 23.0),
                        )),
                    Column(children: <Widget>[
                      for (var i in snapshot.data)
                        InkWell(
                            borderRadius: new BorderRadius.circular(24),
                            onTap: () {
                              tiketSayaDetailKegiatan(
                                names,
                                emails,
                                idUser,
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
                                        i['UserKegiatan'][0]['namaKegiatan'],
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

                      Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          child: Text(
                            "Pemberkatan yang Pernah Didaftar",
                            style:
                                TextStyle(color: Colors.black, fontSize: 23.0),
                          )),
                      Column(
                        children: <Widget>[
                          for (var i in snapshot.data)
                            InkWell(
                                borderRadius: new BorderRadius.circular(24),
                                onTap: () {
                                  tiketSayaDetailPemberkatan(
                                    names,
                                    emails,
                                    idUser,
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
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
                    ])
                  ]);
                } catch (e) {
                  print(e);
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ],
      ),
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
                  icon: Icon(Icons.token, color: Color.fromARGB(255, 0, 0, 0)),
                  label: "Jadwalku",
                )
              ],
              onTap: (index) {
                if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => tiketSaya(names, emails, idUser)),
                  );
                } else if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(names, emails, idUser)),
                  );
                }
              },
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          openCamera();
        },
        tooltip: 'Increment',
        child: new Icon(Icons.camera_alt_rounded),
      ),
    );
  }
}
