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
import 'package:pelayanan_iman_katolik/view/sakramen/perkawinan/imamPerkawinan.dart';

import '../../homePage.dart';
import '../../profile/profile.dart';
import '../../settings/setting.dart';
import '../../tiketSaya.dart';

class Perkawinan extends StatefulWidget {
  final iduser;
  Perkawinan(this.iduser);
  @override
  _Perkawinan createState() => _Perkawinan(this.iduser);
}

class _Perkawinan extends State<Perkawinan> {
  var distance;

  List hasil = [];
  StreamController _controller = StreamController();
  ScrollController _scrollController = ScrollController();
  int data = 5;
  List dummyTemp = [];
  final iduser;
  _Perkawinan(this.iduser);

  Future<List> callDb() async {
    Completer<void> completer = Completer<void>();
    Messages message = Messages('Agent Page', 'Agent Pencarian', "REQUEST",
        Tasks('cari pelayanan', ["perkawinan", "general"]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    var hasilPencarian = await AgentPage.getDataPencarian();
    completer.complete();

    await completer.future;
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
    print(position.toString());
    double distanceInMeters = Geolocator.distanceBetween(
        lat, lang, position.latitude, position.longitude);
    print(distanceInMeters.toString());
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
        if (item['nama'].toLowerCase().contains(query.toLowerCase())) {
          listOMaps.add(item);
        }
      }
      setState(() {
        hasil.clear();
        hasil.addAll(listOMaps);
      });
      return hasil;
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

  TextEditingController editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    editingController.addListener(() async {
      await filterSearchResults(editingController.text);
    });
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text('Gereja Perkawinan'),
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
                textController: editingController,
                onSuffixTap: () {
                  setState(() {
                    editingController.clear();
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
                        InkWell(
                          borderRadius: new BorderRadius.circular(24),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ImamPerkawinan(iduser, i['_id'])),
                            );
                          },
                          child: Container(
                              margin: EdgeInsets.only(
                                  right: 15, left: 15, bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(
                                  color: Colors.lightBlue,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(children: <Widget>[
                                //Color(Colors.blue);

                                Text(
                                  i['nama'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  'Paroki: ' + i['paroki'],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                Text(
                                  'Alamat: ' + i['address'],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),

                                FutureBuilder(
                                    future: jarak(i['lat'], i['lng']),
                                    builder: (context, AsyncSnapshot snapshot) {
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
                                            child: CircularProgressIndicator());
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
                        builder: (context) => HomePage(this.iduser)),
                  );
                }
              },
            ),
          )),
    );
  }
}
