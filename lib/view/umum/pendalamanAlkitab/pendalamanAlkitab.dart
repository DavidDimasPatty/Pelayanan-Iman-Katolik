import 'dart:async';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/view/umum/pendalamanAlkitab/detailDaftarPA.dart';

import '../../homePage.dart';
import '../../profile/profile.dart';
import '../../settings/setting.dart';
import '../../tiketSaya.dart';

class PendalamanAlkitab extends StatefulWidget {
  final iduser;
  PendalamanAlkitab(this.iduser);
  @override
  _PendalamanAlkitab createState() => _PendalamanAlkitab(this.iduser);
}

class _PendalamanAlkitab extends State<PendalamanAlkitab> {
  List hasil = [];
  StreamController _controller = StreamController();
  ScrollController _scrollController = ScrollController();
  int data = 5;

  List dummyTemp = [];
  final iduser;
  _PendalamanAlkitab(this.iduser);

  Future<List> callDb() async {
    Completer<void> completer = Completer<void>();
    Messages message = Messages('Agent Page', 'Agent Pencarian', "REQUEST",
        Tasks('cari pelayanan', ["umum", "general", "Pendalaman Alkitab"]));

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

  filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<Map<String, dynamic>> listOMaps = <Map<String, dynamic>>[];
      for (var item in dummyTemp) {
        if (item['namaKegiatan'].toLowerCase().contains(query.toLowerCase())) {
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
        title: Text('Pendaftaran PA'),
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
                helpText: 'Cari Kegiatan Umum',
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
                        if (i['kapasitas'] <= 0)
                          InkWell(
                            borderRadius: new BorderRadius.circular(24),
                            onTap: () {
                              Fluttertoast.showToast(
                                  msg: "Maaf Kegiatan Penuh",
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
                                    i['namaKegiatan'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26.0,
                                        fontWeight: FontWeight.w300),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    'Tema Kegiatan: ' + i['temaKegiatan'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  Text(
                                    'Alamat: ' + i['lokasi'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  Text(
                                    'Kapasitas Tersedia: ' +
                                        i['kapasitas'].toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ])),
                          ),
                      for (var i in hasil.take(data))
                        if (i['kapasitas'] > 0)
                          InkWell(
                            borderRadius: new BorderRadius.circular(24),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        detailDaftarPA(iduser, i['_id'])),
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
                                    i['namaKegiatan'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26.0,
                                        fontWeight: FontWeight.w300),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    'Tema Kegiatan: ' + i['temaKegiatan'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  Text(
                                    'Alamat: ' + i['lokasi'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  Text(
                                    'Kapasitas Tersedia: ' +
                                        i['kapasitas'].toString(),
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
