import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/view/profile/profile.dart';
import 'package:pelayanan_iman_katolik/view/settings/setting.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'tiketSaya.dart';
import 'homePage.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';

class Alkitab extends StatefulWidget {
  final iduser;

  Alkitab(this.iduser);

  _Alkitab createState() => _Alkitab(this.iduser);
}

class _Alkitab extends State<Alkitab> {
  var iduser;
  _Alkitab(this.iduser);
  String dropdowninjil = "Pilih Injil";
  int dropdownpasal = 0;
  int dropdownayat = 0;
  int higlight = 0;
  final scrollDirection = Axis.vertical;
  StreamController _controllerStream = StreamController();
  late AutoScrollController controller;
  List<String> injil = [];
  List<int> pasal = [];
  List<int> pasalSelected = [];
  List<int> ayat = [];
  List<String> isi = [];

  Future loadInjil() async {
    //Pengiriman pesan untuk mendapatkan data yang diperlukan
    //untuk tampilan halaman
    Completer<void> completer = Completer<void>(); //variabel untuk menunggu
    Messages message = Messages('Agent Page', 'Agent Pencarian', "REQUEST",
        Tasks('cari alkitab', ["load data"])); //Pembuatan pesan

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

  Future loadSearch() async {
    //Pengiriman pesan untuk mendapatkan data yang diperlukan
    //untuk tampilan halaman
    Completer<void> completer = Completer<void>(); //variabel untuk menunggu
    Messages message = Messages(
        'Agent Page',
        'Agent Pencarian',
        "REQUEST",
        Tasks('cari alkitab',
            ["cari ayat", dropdowninjil, dropdownpasal])); //Pembuatan pesan

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
    loadInjil().then((response) {
      setState(() {
        for (var i in response[0]['data']) {
          injil.add(i['name']);
          pasal.add(i['chapter']);
        }
        _controllerStream.add(response);
      });
    });

    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
  }

  TextEditingController editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text('Alkitab'),
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
      body: StreamBuilder(
          //Widget stream untuk mendapatkan data jika variabel stream terdapat
          //penambahan data
          stream: _controllerStream.stream,
          //inisialisasi variabel stream sebagai sinyal
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              //Jika terdapat error pada variabel stream
              //mengembalikan widget loading
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData) {
              //Jika variabel stream tidak mempunyai data atau menunggu data
              //mengembalikan widget loading
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            try {
              return ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  shrinkWrap: true,
                  scrollDirection: scrollDirection,
                  controller: controller,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        Text(
                          "Pilih Injil",
                          textAlign: TextAlign.left,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        DropdownSearch<dynamic>(
                          selectedItem: dropdowninjil,
                          items: injil,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              hintText: "Pilih Injil",
                            ),
                          ),
                          onChanged: (dynamic? data) {
                            setState(() {
                              dropdowninjil = data;
                              pasalSelected.clear();
                              ayat.clear();
                              isi.clear();
                              dropdownpasal = 0;
                              dropdownayat = 0;
                              higlight = 0;

                              for (int i = 1;
                                  i < pasal[injil.indexOf(data)] + 1;
                                  i++) {
                                pasalSelected.add(i);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        Text(
                          "Pilih Pasal",
                          textAlign: TextAlign.left,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        DropdownSearch<dynamic>(
                          selectedItem: dropdownpasal,
                          items: pasalSelected,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              hintText: "Pilih Pasal",
                            ),
                          ),
                          onChanged: (dynamic? data) {
                            setState(() {
                              dropdownpasal = data;
                              ayat.clear();
                              isi.clear();
                              dropdownayat = 0;
                              higlight = 0;
                              loadSearch().then((response) {
                                setState(() {
                                  for (int i = 1;
                                      i < response[0]["data"]['verses'].length;
                                      i++) {
                                    ayat.add(i);
                                    isi.add(response[0]["data"]['verses'][i]
                                                ['verse']
                                            .toString() +
                                        ". " +
                                        response[0]["data"]['verses'][i]
                                                ['content']
                                            .toString());
                                  }
                                  _controllerStream.add(response);
                                });
                              });
                            });
                          },
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        Text(
                          "Pilih Ayat",
                          textAlign: TextAlign.left,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        DropdownSearch<dynamic>(
                          selectedItem: dropdownayat,
                          items: ayat,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              hintText: "Pilih Ayat",
                            ),
                          ),
                          onChanged: (dynamic? data) {
                            setState(() {
                              higlight = data - 1;
                              dropdownayat = data;
                              controller.scrollToIndex(higlight,
                                  preferPosition: AutoScrollPosition.middle);
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isi.length == 0)
                            Center(
                              child: Text(
                                "Cari ayat alkitab",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20.0),
                              ),
                            ),
                          if (isi.length > 0)
                            for (int i = 0; i < isi.length; i++)
                              if (i == higlight)
                                AutoScrollTag(
                                  key: ValueKey(i),
                                  controller: controller,
                                  index: i,
                                  child: Text(
                                    isi[i],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        backgroundColor: Colors.yellow),
                                  ),
                                )
                              else if (i != higlight)
                                AutoScrollTag(
                                  key: ValueKey(i),
                                  controller: controller,
                                  index: i,
                                  child: Text(
                                    isi[i],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18.0),
                                  ),
                                )
                        ]),
                    SizedBox(
                      height: 10,
                    ),
                  ]);
            } catch (e) {
              //Jika terdapat salah penunjukan key pada map saat
              //pengambilan data
              //mengembalikan widget loading
              print(e);
              return Center(child: CircularProgressIndicator());
            }
          }),
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
