import 'dart:async';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/view/homePage.dart';
import 'package:pelayanan_iman_katolik/view/profile/profile.dart';
import 'package:pelayanan_iman_katolik/view/sakramentali/formulirPemberkatan.dart';
import 'package:pelayanan_iman_katolik/view/settings/setting.dart';
import 'package:pelayanan_iman_katolik/view/tiketSaya.dart';

class ImamPemberkatan extends StatefulWidget {
  final iduser;
  final idGereja;
  ImamPemberkatan(this.iduser, this.idGereja);
  @override
  _ImamPemberkatan createState() =>
      _ImamPemberkatan(this.iduser, this.idGereja);
}

class _ImamPemberkatan extends State<ImamPemberkatan> {
  List hasil = [];
  StreamController _controller = StreamController();
  ScrollController _scrollController = ScrollController();
  int data = 5;
  List dummyTemp = [];
  final iduser;
  final idGereja;
  _ImamPemberkatan(this.iduser, this.idGereja);

  Future<List> callDb() async {
    Completer<void> completer = Completer<void>(); //variabel untuk menunggu
    Messages message = Messages(
        'Agent Page',
        'Agent Pencarian',
        "REQUEST",
        Tasks('cari pelayanan',
            ["sakramentali", "imam", idGereja])); //Pembuatan pesan

    MessagePassing messagePassing =
        MessagePassing(); //Memanggil distributor pesan
    await messagePassing
        .sendMessage(message); //Mengirim pesan ke distributor pesan
    var hasilPencarian =
        await AgentPage.getData(); //Memanggil data yang tersedia di agen Page
    completer.complete(); //Batas pengerjaan yang memerlukan completer

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
      // Widget untuk membangun struktur halaman
      //////////////////////////////////////Pembuatan Top Navigation Bar////////////////////////////////////////////////////////////////
      appBar: AppBar(
        // widget Top Navigation Bar
        shape: RoundedRectangleBorder(
          //Bentuk Top Navigation Bar: Rounded Rectangle
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text('Imam Pemberkatan'),
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
            //Widget icon Setting
            icon: const Icon(Icons.settings),
            onPressed: () {
              //Jika ditekan akan mengarahkan ke halaman setting
              Navigator.push(
                //Widget navigator untuk memanggil kelas setting
                context,
                MaterialPageRoute(builder: (context) => Settings(iduser)),
              );
            },
          ),
        ],
      ),
//////////////////////////////////////Batas Akhir Pembuatan Top Navigation Bar//////////////////////////////////////////////////////////
      ///
//////
//////
//////////////////////////////////////Pembuatan Body Halaman////////////////////////////////////////////////////////////////
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
                        InkWell(
                          borderRadius: new BorderRadius.circular(24),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FormulirPemberkatan(
                                      iduser, i['idGereja'], i['_id'])),
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
                                  i['nama'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  i['statusPemberkatan'] == 0
                                      ? ' Status : Bersedia'
                                      : i['status'] == -1
                                          ? ' Status : Tidak Bersedia'
                                          : ' Status : Sedang Melakukan Pelayanan',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w300),
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
//////////////////////////////////////Batas Akhir Pembuatan Body Halaman/////////////////////////////////////////////////////////////
      ///
      ///
      ///
/////////////////////////////////////////////////////////Pembuatan Bottom Navigation Bar////////////////////////////////////////
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
      /////////////////////////////////////////////////////////Batas Akhir Pembuatan Bottom Navigation Bar////////////////////////////////////////
    );
  }
}
