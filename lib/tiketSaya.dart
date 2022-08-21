import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/detailDaftarMisa.dart';
import 'package:pelayanan_iman_katolik/homePage.dart';
import 'package:pelayanan_iman_katolik/profile.dart';
import 'package:pelayanan_iman_katolik/setting.dart';
import 'package:pelayanan_iman_katolik/tiketSayaDetail.dart';
import 'package:pelayanan_iman_katolik/tiketSayaDetailBaptis.dart';
import 'package:pelayanan_iman_katolik/tiketSayaDetailKomuni.dart';

class tiketSaya extends StatelessWidget {
  var names;
  var idUser;
  var emails;
  var tiketGereja;
  var tiket;
  var namaGereja;
  var hasil;
  var baptisUser;
  var komuniUser;

  tiketSaya(this.names, this.emails, this.idUser);

  Future<List> callDb() async {
    tiketGereja = await MongoDatabase.jadwalku(idUser);
    return tiketGereja;
  }

  Future<List> callDbBaptisDaftar() async {
    baptisUser = await MongoDatabase.baptisTerdaftar(idUser);
    return baptisUser;
  }

  Future<List> callDbKomuniDaftar() async {
    komuniUser = await MongoDatabase.komuniTerdaftar(idUser);
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

  Future<List> addChild(idMisa) async {
    var temp;
    tiket = await callInfoMisa(idMisa).then((value) => temp = value);
    tiketGereja = await callInfoGereja(temp[0]['idGereja']);
    hasil = [temp[0]['jadwal'], tiketGereja[0]['nama']];
    return hasil;
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
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Text(
                "Misa Terdaftar",
                style: TextStyle(color: Colors.black, fontSize: 26.0),
              )),
          FutureBuilder<List>(
              future: callDb(),
              builder: (context, AsyncSnapshot snapshot) {
                try {
                  return ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(2.0),
                    children: <Widget>[
                      for (var i in snapshot.data)
                        InkWell(
                          borderRadius: new BorderRadius.circular(24),
                          onTap: () {
                            tiketSayaDetail(names, emails, idUser, i['idMisa'],
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
                              child: Column(children: <Widget>[
                                FutureBuilder<List>(
                                    future: addChild(i['idMisa']),
                                    builder: (context, AsyncSnapshot snapshot) {
                                      try {
                                        return Column(
                                          children: <Widget>[
                                            Text(
                                              "Jadwal : " + snapshot.data[0],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 26.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            Text(
                                              "Nama Gereja : " +
                                                  snapshot.data[1],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w300),
                                            )
                                          ],
                                        );
                                      } catch (e) {
                                        print(e);
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                    })
                              ])),
                        ),

                      ///map////////
                    ],
                  );
                } catch (e) {
                  print(e);
                  return Center(child: CircularProgressIndicator());
                }
              }),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Text(
                "Baptis Terdaftar",
                style: TextStyle(color: Colors.black, fontSize: 26.0),
              )),
          FutureBuilder<List>(
              future: callDbBaptisDaftar(),
              builder: (context, AsyncSnapshot snapshot) {
                try {
                  return ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(2.0),
                    children: <Widget>[
                      for (var i in snapshot.data)
                        InkWell(
                            borderRadius: new BorderRadius.circular(24),
                            onTap: () {
                              tiketSayaDetailBaptis(
                                      names,
                                      emails,
                                      idUser,
                                      snapshot.data[0]['UserBaptis'][0]['_id'],
                                      snapshot.data[0]['UserBaptis'][0]
                                          ['idGereja'])
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
                                        snapshot.data[0]['UserBaptis'][0]
                                            ['jadwalBuka'] +
                                        " s/d " +
                                        snapshot.data[0]['UserBaptis'][0]
                                            ['jadwalTutup'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  FutureBuilder<List>(
                                      future: callInfoGereja(snapshot.data[0]
                                          ['UserBaptis'][0]['idGereja']),
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
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
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      })
                                ],
                              ),
                            )),

                      ///map////////
                    ],
                  );
                } catch (e) {
                  print(e);
                  return Center(child: CircularProgressIndicator());
                }
              }),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Text(
                "Komuni Terdaftar",
                style: TextStyle(color: Colors.black, fontSize: 26.0),
              )),
          FutureBuilder<List>(
              future: callDbKomuniDaftar(),
              builder: (context, AsyncSnapshot snapshot) {
                try {
                  return ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(2.0),
                    children: <Widget>[
                      for (var i in snapshot.data)
                        InkWell(
                            borderRadius: new BorderRadius.circular(24),
                            onTap: () {
                              tiketSayaDetailKomuni(
                                      names,
                                      emails,
                                      idUser,
                                      snapshot.data[0]['UserKomuni'][0]['_id'],
                                      snapshot.data[0]['UserKomuni'][0]
                                          ['idGereja'])
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
                                        snapshot.data[0]['UserKomuni'][0]
                                            ['jadwalBuka'] +
                                        " s/d " +
                                        snapshot.data[0]['UserKomuni'][0]
                                            ['jadwalTutup'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  FutureBuilder<List>(
                                      future: callInfoGereja(snapshot.data[0]
                                          ['UserKomuni'][0]['idGereja']),
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
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
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      })
                                ],
                              ),
                            )),

                      ///map////////
                    ],
                  );
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
                  label: "TiketKu",
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
