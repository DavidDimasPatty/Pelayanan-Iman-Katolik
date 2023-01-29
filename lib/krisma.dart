import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/messages.dart';
import 'package:pelayanan_iman_katolik/detailDaftarBaptis.dart';
import 'package:pelayanan_iman_katolik/detailDaftarKrisma.dart';
import 'package:pelayanan_iman_katolik/detailDaftarMisa.dart';
import 'package:pelayanan_iman_katolik/profile.dart';
import 'package:pelayanan_iman_katolik/setting.dart';
import 'tiketSaya.dart';
import 'homePage.dart';

class Krisma extends StatefulWidget {
  var names;
  var emails;
  final idUser;
  Krisma(this.names, this.emails, this.idUser);
  @override
  _Krisma createState() => _Krisma(this.names, this.emails, this.idUser);
}

class _Krisma extends State<Krisma> {
  var names;
  var emails;
  var distance;
  List daftarGereja = [];

  List dummyTemp = [];
  final idUser;
  _Krisma(this.names, this.emails, this.idUser);

  Future<List> callDb() async {
    Messages msg = new Messages();
    msg.addReceiver("agenPencarian");
    msg.setContent([
      ["cari Krisma"]
    ]);
    List k = [];
    await msg.send().then((res) async {
      print("masuk");
      print(await AgenPage().receiverTampilan());
    });
    await Future.delayed(Duration(seconds: 1));
    k = await AgenPage().receiverTampilan();

    return k;
  }

  @override
  void initState() {
    super.initState();
    callDb().then((result) {
      setState(() {
        daftarGereja.addAll(result);
        dummyTemp.addAll(result);
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
        if (item['GerejaKrisma'][0]['nama']
            .toLowerCase()
            .contains(query.toLowerCase())) {
          listOMaps.add(item);
        }
      }
      setState(() {
        daftarGereja.clear();
        daftarGereja.addAll(listOMaps);
      });
      return daftarGereja;
    } else {
      setState(() {
        daftarGereja.clear();
        daftarGereja.addAll(dummyTemp);
      });
    }
  }

  Future pullRefresh() async {
    setState(() {
      callDb().then((result) {
        setState(() {
          daftarGereja.clear();
          dummyTemp.clear();
          daftarGereja.addAll(result);
          dummyTemp.addAll(result);
          filterSearchResults(editingController.text);
        });
      });
      ;
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
        title: Text('Pendaftaran Krisma'),
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
                      for (var i in daftarGereja)
                        if (i['kapasitas'] <= 0)
                          InkWell(
                            borderRadius: new BorderRadius.circular(24),
                            onTap: () {
                              Fluttertoast.showToast(
                                  msg: "Maaf Krisma Penuh",
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
                                    i['GerejaKrisma'][0]['nama'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26.0,
                                        fontWeight: FontWeight.w300),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    'Paroki: ' + i['GerejaKrisma'][0]['paroki'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  Text(
                                    'Alamat: ' +
                                        i['GerejaKrisma'][0]['address'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  Text(
                                    'Kapasitas Tersedia: ' +
                                        i['kapasitas'].toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  FutureBuilder(
                                      future: jarak(i['GerejaKrisma'][0]['lat'],
                                          i['GerejaKrisma'][0]['lng']),
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
                      for (var i in daftarGereja)
                        if (i['kapasitas'] > 0)
                          InkWell(
                            borderRadius: new BorderRadius.circular(24),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => detailDaftarKrisma(
                                        names,
                                        emails,
                                        i['GerejaKrisma'][0]['nama'],
                                        idUser,
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
                                    i['GerejaKrisma'][0]['nama'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26.0,
                                        fontWeight: FontWeight.w300),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    'Paroki: ' + i['GerejaKrisma'][0]['paroki'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  Text(
                                    'Alamat: ' +
                                        i['GerejaKrisma'][0]['address'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  Text(
                                    'Kapasitas Tersedia: ' +
                                        i['kapasitas'].toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  FutureBuilder(
                                      future: jarak(i['GerejaKrisma'][0]['lat'],
                                          i['GerejaKrisma'][0]['lng']),
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
