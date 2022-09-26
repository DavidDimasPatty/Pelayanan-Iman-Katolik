import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/detailDaftarBaptis.dart';
import 'package:pelayanan_iman_katolik/detailDaftarMisa.dart';
import 'package:pelayanan_iman_katolik/detailDaftarPA.dart';
import 'package:pelayanan_iman_katolik/profile.dart';
import 'package:pelayanan_iman_katolik/setting.dart';
import 'tiketSaya.dart';
import 'homePage.dart';

class PendalamanAlkitab extends StatefulWidget {
  var names;
  var emails;
  final idUser;
  PendalamanAlkitab(this.names, this.emails, this.idUser);
  @override
  _PendalamanAlkitab createState() =>
      _PendalamanAlkitab(this.names, this.emails, this.idUser);
}

class _PendalamanAlkitab extends State<PendalamanAlkitab> {
  var names;
  var emails;
  List daftarKegiatan = [];

  List dummyTemp = [];
  final idUser;
  _PendalamanAlkitab(this.names, this.emails, this.idUser);

  Future<List> callDb() async {
    return await MongoDatabase.findPA();
  }

  @override
  void initState() {
    super.initState();
    callDb().then((result) {
      setState(() {
        daftarKegiatan.addAll(result);
        dummyTemp.addAll(result);
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
        daftarKegiatan.clear();
        daftarKegiatan.addAll(listOMaps);
      });
      return daftarKegiatan;
    } else {
      setState(() {
        daftarKegiatan.clear();
        daftarKegiatan.addAll(dummyTemp);
      });
    }
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
        title: Text('Pendaftaran PA'),
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
        ListView(
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
            for (var i in daftarKegiatan)
              InkWell(
                borderRadius: new BorderRadius.circular(24),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            detailDaftarPA(names, emails, idUser, i['_id'])),
                  );
                },
                child: Container(
                    margin: EdgeInsets.only(right: 15, left: 15, bottom: 20),
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
                      borderRadius: BorderRadius.all(Radius.circular(10)),
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
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Text(
                        'Alamat: ' + i['lokasi'],
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Text(
                        'Kapasitas Tersedia: ' + i['kapasitas'].toString(),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ])),
              ),

            /////////
          ],
        ),
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