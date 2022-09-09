import 'dart:convert';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/detailDaftarKomuni.dart';
import 'package:pelayanan_iman_katolik/detailDaftarMisa.dart';
import 'package:pelayanan_iman_katolik/profile.dart';
import 'package:pelayanan_iman_katolik/setting.dart';
import 'tiketSaya.dart';
import 'homePage.dart';
import 'package:http/http.dart' as http;

class Alkitab extends StatefulWidget {
  var names;
  var emails;
  final idUser;

  Alkitab(this.names, this.emails, this.idUser);
  _Alkitab createState() => _Alkitab(this.names, this.emails, this.idUser);
}

class _Alkitab extends State<Alkitab> {
  bool _folded = true;
  Map<String, dynamic> textAlkitab = new Map<String, dynamic>();
  Future loadAlkitab() async {
    final url = Uri.parse(
        "https://api-alkitab.herokuapp.com/v3/passage/Kejadian/1?ver=tb");
    var response = await http.get(
      url,
    );
    return response;
  }

  @override
  void initState() {
    super.initState();
    loadAlkitab().then((response) {
      Map<String, dynamic> jsonResponse =
          new Map<String, dynamic>.from(json.decode(response.body));

      setState(() {
        textAlkitab.addAll(jsonResponse);
        print(textAlkitab);
      });
    });
  }

  var names;
  var emails;
  final idUser;
  _Alkitab(this.names, this.emails, this.idUser);

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
      body: ListView(children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 100),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 400),
            width: _folded ? 56 : 200,
            height: _folded ? 56 : 180,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: Colors.white,
                boxShadow: kElevationToShadow[6]),
            child: Row(children: [
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(left: 16),
                child: _folded
                    ? null
                    : Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(hintText: 'Cari Injil'),
                          ),
                          TextField(
                            decoration: InputDecoration(hintText: 'Ayat Mulai'),
                          ),
                          TextField(
                            decoration: InputDecoration(hintText: 'Ayat Akhir'),
                          ),
                        ],
                      ),
              )),
              AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.blue[900],
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _folded = !_folded;
                      });
                    },
                  ))
            ]),
          ),
        ),
        for (var i in textAlkitab['verses'])
          Column(
            children: [Text(i['content'].toString())],
          )
      ]),
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
