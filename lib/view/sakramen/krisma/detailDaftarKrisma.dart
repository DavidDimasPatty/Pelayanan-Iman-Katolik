import 'dart:async';

import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/view/sakramen/krisma/confirmKrisma.dart';
import 'package:pelayanan_iman_katolik/view/settings/setting.dart';

import '../../homePage.dart';
import '../../profile/profile.dart';
import '../../tiketSaya.dart';

class detailDaftarKrisma extends StatefulWidget {
  final idGereja;
  var detailGereja;
  final iduser;
  final idKrisma;
  @override
  detailDaftarKrisma(this.iduser, this.idGereja, this.idKrisma);

  _detailDaftarKrisma createState() =>
      _detailDaftarKrisma(this.iduser, this.idGereja, this.idKrisma);
}

class _detailDaftarKrisma extends State<detailDaftarKrisma> {
  final idGereja;
  var detailGereja;
  final iduser;
  final idKrisma;
  var hasil;

  Future<List> callDb() async {
    Completer<void> completer = Completer<void>();
    Messages message = Messages('Agent Page', 'Agent Pencarian', "REQUEST",
        Tasks('cari pelayanan', ["krisma", "detail", idKrisma, idGereja]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    hasil = await await AgentPage.getDataPencarian();
    completer.complete();

    await completer.future;
    return await hasil;
  }

  showDirectionWithFirstMap(coordinates) async {
    final List<AvailableMap> availableMaps = await MapLauncher.installedMaps;
    await availableMaps.first.showDirections(
      destination: coordinates,
    );
  }

  _detailDaftarKrisma(this.iduser, this.idGereja, this.idKrisma);
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
        title: const Text('Pendaftaran Krisma'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile(iduser)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings(iduser)),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
          onRefresh: pullRefresh,
          child: ListView(
            children: [
              FutureBuilder<List>(
                  future: callDb(),
                  builder: (context, AsyncSnapshot snapshot) {
                    try {
                      return Column(
                        // shrinkWrap: true,
                        // padding: EdgeInsets.all(20.0),
                        children: <Widget>[
                          /////////
                          ///

                          Center(
                              child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16),
                              ),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.blueAccent,
                                              Colors.lightBlue,
                                            ]),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(0.0, 1.0), //(x,y)
                                            blurRadius: 6.0,
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        width: 350.0,
                                        height: 450.0,
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              if (snapshot.data[0][0]
                                                          ['GerejaKrisma'][0]
                                                      ['gambar'] ==
                                                  null)
                                                CircleAvatar(
                                                  backgroundImage:
                                                      AssetImage(''),
                                                  backgroundColor:
                                                      Colors.greenAccent,
                                                  radius: 80.0,
                                                ),
                                              if (snapshot.data[0][0]
                                                          ['GerejaKrisma'][0]
                                                      ['gambar'] !=
                                                  null)
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      snapshot.data[0][0]
                                                              ['GerejaKrisma']
                                                          [0]['gambar']),
                                                  backgroundColor:
                                                      Colors.greenAccent,
                                                  radius: 80.0,
                                                ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Text(
                                                snapshot.data[0][0]
                                                    ['GerejaKrisma'][0]['nama'],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 24.0,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                ),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 5.0),
                                                clipBehavior: Clip.antiAlias,
                                                color: Colors.white,
                                                elevation: 20.0,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 7.0,
                                                      vertical: 22.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Column(
                                                          children: <Widget>[
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Paroki: ",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                ),
                                                                Text(
                                                                  snapshot.data[0][0]['GerejaKrisma']
                                                                              [
                                                                              0]
                                                                          [
                                                                          'paroki']
                                                                      as String,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 8.0,
                                                            ),
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Alamat Gereja: ",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                ),
                                                                Text(
                                                                  snapshot.data[0]
                                                                              [
                                                                              0]
                                                                          [
                                                                          'GerejaKrisma'][0]
                                                                      [
                                                                      'address'],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 8.0,
                                                            ),
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Kapasitas: ",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                ),
                                                                Text(
                                                                  snapshot
                                                                      .data[0]
                                                                          [0][
                                                                          'kapasitas']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 8.0,
                                                            ),
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Tanggal Pembukaan: ",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                ),
                                                                Text(
                                                                  snapshot
                                                                      .data[0]
                                                                          [0][
                                                                          'jadwalBuka']
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          19),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 8.0,
                                                            ),
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Tanggal Penutupan: ",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                ),
                                                                Text(
                                                                  snapshot
                                                                      .data[0]
                                                                          [0][
                                                                          'jadwalTutup']
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          19),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ))),
                              SizedBox(
                                height: 10.0,
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5.0),
                                clipBehavior: Clip.antiAlias,
                                color: Colors.white,
                                elevation: 20.0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7.0, vertical: 22.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  "Aturan Krisma Gereja: ",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  snapshot.data[1][0]['krisma'],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              RaisedButton(
                                  onPressed: () async {
                                    showDirectionWithFirstMap(Coords(
                                        snapshot.data[0][0]['GerejaKrisma'][0]
                                            ['lat'],
                                        snapshot.data[0][0]['GerejaKrisma'][0]
                                            ['lng']));
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(80.0)),
                                  elevation: 0.0,
                                  padding: EdgeInsets.all(0.0),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.topLeft,
                                          colors: [
                                            Colors.blueAccent,
                                            Colors.lightBlue,
                                          ]),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: 300.0, minHeight: 50.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Lokasi Gereja",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 26.0,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                height: 20.0,
                              ),
                              RaisedButton(
                                  onPressed: () async {
                                    confirmKrisma(
                                      iduser,
                                      snapshot.data[0][0]['GerejaKrisma'][0]
                                          ['_id'],
                                      snapshot.data[0][0]['_id'],
                                    ).showDialogBox(context);
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(80.0)),
                                  elevation: 0.0,
                                  padding: EdgeInsets.all(0.0),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.topLeft,
                                          colors: [
                                            Colors.blueAccent,
                                            Colors.lightBlue,
                                          ]),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: 300.0, minHeight: 50.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Daftar Krisma",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 26.0,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                height: 20.0,
                              ),
                            ],
                          )),

                          /////////
                        ],
                      );
                    } catch (e) {
                      print(e);
                      return Center(child: CircularProgressIndicator());
                    }
                  })
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
                  icon: Icon(Icons.token, color: Color.fromARGB(255, 0, 0, 0)),
                  label: "Jadwalku",
                )
              ],
              onTap: (index) {
                if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => tiketSaya(iduser)),
                  );
                } else if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage(iduser)),
                  );
                }
              },
            ),
          )),
    );
  }
}
