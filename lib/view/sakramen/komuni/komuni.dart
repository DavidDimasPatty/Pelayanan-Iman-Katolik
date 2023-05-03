import 'dart:async';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/view/sakramen/komuni/detailDaftarKomuni.dart';
import 'package:pelayanan_iman_katolik/view/settings/setting.dart';

import '../../homePage.dart';
import '../../profile/profile.dart';
import '../../tiketSaya.dart';

class Komuni extends StatefulWidget {
  final iduser;
  Komuni(this.iduser);
  @override
  _Komuni createState() => _Komuni(this.iduser);
}

class _Komuni extends State<Komuni> {
  var distance;
  List hasil = [];
  List dummyTemp = [];
  final iduser;
  StreamController _controller = StreamController();
  ScrollController _scrollController = ScrollController();
  int data = 5;
  _Komuni(this.iduser);

  Future<List> callDb() async {
    Completer<void> completer = Completer<void>(); //variabel untuk menunggu
    Messages message = Messages('Agent Page', 'Agent Pencarian', "REQUEST",
        Tasks('cari pelayanan', ["komuni", "general"])); //Pembuatan pesan

    MessagePassing messagePassing =
        MessagePassing(); //Memanggil distributor pesan
    await messagePassing
        .sendMessage(message); //Mengirim pesan ke distributor pesan
    var hasilPencarian =
        await AgentPage.getData(); //Memanggil data yang tersedia di agen Page
    completer
        .complete(); //Pengiriman pesan sudah berhasil, tapi masih harus menunggu

    await completer
        .future; //Proses penungguan sudah selesai ketika varibel hasil
    //memiliki nilai
    return await hasilPencarian;
  }

  @override
  void initState() {
    super.initState();
    callDb().then((result) {
      setState(() {
        hasil.addAll(result);
        dummyTemp.addAll(result);
        _controller.add(result);
      });
    });
  }

  Future jarak(lat, lang) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    double distanceInMeters = Geolocator.distanceBetween(
        lat, lang, position.latitude, position.longitude);

    if (distanceInMeters > 1000) {
      distanceInMeters = distanceInMeters / 1000;
      distance = distanceInMeters.toInt().toString() + " KM";
    } else {
      distance = distanceInMeters.toInt().toString() + " M";
    }
    return distance;
  }

  filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<Map<String, dynamic>> listOMaps = <Map<String, dynamic>>[];
      for (var item in dummyTemp) {
        if (item['GerejaKomuni'][0]['nama']
            .toLowerCase()
            .contains(query.toLowerCase())) {
          listOMaps.add(item);
        }
      }
      setState(() {
        hasil.clear();
        hasil.addAll(listOMaps);
      });
      return hasil; //Mengembalikan variabel hasil
    } else {
      setState(() {
        hasil.clear();
        hasil.addAll(dummyTemp);
      });
    }
  }

  Future pullRefresh() async {
    callDb().then((result) {
      setState(() {
        data = 5;
        hasil.clear();
        dummyTemp.clear();
        hasil.clear();
        hasil.addAll(result);
        dummyTemp.addAll(result);
        _controller.add(result);
      });
    });
  }

  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _searchController.addListener(() async {
      await filterSearchResults(_searchController.text);
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          data = data + 5;
        });
      }
    });
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text('Pendaftaran Komuni'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => profile(this.iduser)),
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
          controller: _scrollController,
          shrinkWrap: true,
          padding: EdgeInsets.only(right: 15, left: 15),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 10, left: 10),
              child: AnimSearchBar(
                autoFocus: false,
                width: 400,
                rtl: true,
                helpText: 'Cari Gereja',
                textController: _searchController,
                onSuffixTap: () {
                  setState(() {
                    _searchController.clear();
                  });
                },
              ),
            ),

            /////////
            StreamBuilder(
                stream: _controller.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  try {
                    return Column(children: [
                      for (var i in hasil.take(data))
                        if (i['kapasitas'] <= 0)
                          InkWell(
                            borderRadius: new BorderRadius.circular(24),
                            onTap: () {
                              Fluttertoast.showToast(
                                  msg: "Maaf Komuni Penuh",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            },
                            child: Container(
                                margin: EdgeInsets.only(
                                    right: 15, left: 15, bottom: 20),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  border: Border.all(
                                    color: Colors.lightBlue,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Column(children: <Widget>[
                                  //Color(Colors.blue);

                                  Text(
                                    i['GerejaKomuni'][0]['nama'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26.0,
                                        fontWeight: FontWeight.w300),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    'Paroki: ' + i['GerejaKomuni'][0]['paroki'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  Text(
                                    'Alamat: ' +
                                        i['GerejaKomuni'][0]['address'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  Text(
                                    'Kapasitas Tersedia: ' +
                                        i['kapasitas'].toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  Text(
                                    'Jenis: ' + i['jenis'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  FutureBuilder(
                                      future: jarak(i['GerejaKomuni'][0]['lat'],
                                          i['GerejaKomuni'][0]['lng']),
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
                                        try {
                                          return Column(children: <Widget>[
                                            Text(
                                              snapshot.data,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            )
                                          ]);
                                        } catch (e) {
                                          print(e);
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      }),
                                ])),
                          ),
                      for (var i in hasil.take(data))
                        if ((i['kapasitas'] > 0))
                          InkWell(
                            borderRadius: new BorderRadius.circular(24),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => detailDaftarKomuni(
                                        iduser,
                                        i['GerejaKomuni'][0]['_id'],
                                        i['_id'])),
                              );
                            },
                            child: Container(
                                margin: EdgeInsets.only(
                                    right: 15, left: 15, bottom: 20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.topLeft,
                                      colors: [
                                        Colors.blueGrey,
                                        Colors.lightBlue,
                                      ]),
                                  border: Border.all(
                                    color: Colors.lightBlue,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Column(children: <Widget>[
                                  //Color(Colors.blue);

                                  Text(
                                    i['GerejaKomuni'][0]['nama'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26.0,
                                        fontWeight: FontWeight.w300),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    'Paroki: ' + i['GerejaKomuni'][0]['paroki'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  Text(
                                    'Alamat: ' +
                                        i['GerejaKomuni'][0]['address'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  Text(
                                    'Kapasitas Tersedia: ' +
                                        i['kapasitas'].toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  Text(
                                    'Jenis: ' + i['jenis'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  FutureBuilder(
                                      future: jarak(i['GerejaKomuni'][0]['lat'],
                                          i['GerejaKomuni'][0]['lng']),
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
                                        try {
                                          return Column(children: <Widget>[
                                            Text(
                                              snapshot.data,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            )
                                          ]);
                                        } catch (e) {
                                          print(e);
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      }),
                                ])),
                          ),
                    ]);
                  } catch (e) {
                    print(e);
                    return Center(child: CircularProgressIndicator());
                  }
                }),
            /////////
          ],
        ),
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
                        builder: (context) => tiketSaya(this.iduser)),
                  );
                } else if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => homePage(this.iduser)),
                  );
                }
              },
            ),
          )),
    );
  }
}
