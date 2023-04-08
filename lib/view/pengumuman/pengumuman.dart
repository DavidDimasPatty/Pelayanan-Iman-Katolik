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

import '../homePage.dart';
import '../profile/profile.dart';
import '../settings/setting.dart';
import '../tiketSaya.dart';
import 'detailPengumuman.dart';

class Pengumuman extends StatefulWidget {
  var names;
  var emails;

  final idUser;
  Pengumuman(this.names, this.emails, this.idUser);
  @override
  _Pengumuman createState() =>
      _Pengumuman(this.names, this.emails, this.idUser);
}

class _Pengumuman extends State<Pengumuman> {
  // var distance;
  var names;
  var emails;
  List hasil = [];
  StreamController _controller = StreamController();
  List dummyTemp = [];
  final idUser;
  _Pengumuman(this.names, this.emails, this.idUser);

  Future<List> callDb() async {
    // Messages msg = new Messages();
    // msg.addReceiver("agenPencarian");
    // msg.setContent([
    //   ["cari Pengumuman"]
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
        Tasks('cari pengumuman', ["general"]));

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

  // Future jarak(lat, lang) async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   print(position.toString());
  //   double distanceInMeters = Geolocator.distanceBetween(
  //       lat, lang, position.latitude, position.longitude);
  //   print(distanceInMeters.toString());
  //   if (distanceInMeters > 1000) {
  //     distanceInMeters = distanceInMeters / 1000;
  //     distance = distanceInMeters.toInt().toString() + " KM";
  //   } else {
  //     distance = distanceInMeters.toInt().toString() + " M";
  //   }
  //   return distance;
  // }

  filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<Map<String, dynamic>> listOMaps = <Map<String, dynamic>>[];
      for (var item in dummyTemp) {
        if (item['title'].toLowerCase().contains(query.toLowerCase())) {
          listOMaps.add(item);
        } else if (item['GerejaPengumuman'][0]['nama']
            .toLowerCase()
            .contains(query.toLowerCase())) {
          listOMaps.add(item);
        }
      }
      setState(() {
        hasil.clear();
        hasil.addAll(listOMaps);
      });
    } else {
      setState(() {
        hasil.clear();
        hasil.addAll(dummyTemp);
      });
    }
  }

  Future pullRefresh() async {
    callDb();
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
        title: Text('Daftar Pengumuman'),
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
      body: RefreshIndicator(
        onRefresh: pullRefresh,
        child: ListView(
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
            FutureBuilder(
                future: callDb(),
                builder: (context, AsyncSnapshot snapshot) {
                  try {
                    return Column(children: [
                      for (var i in hasil)
                        InkWell(
                          borderRadius: new BorderRadius.circular(24),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => detailPengumuman(
                                      names, emails, idUser, i['_id'])),
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
                                CircleAvatar(
                                  backgroundImage: NetworkImage(i['gambar']),
                                  backgroundColor: Colors.greenAccent,
                                  radius: 35,
                                ),
                                Text(
                                  i['title'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  'Gereja: ' + i['GerejaPengumuman'][0]['nama'],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
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
