import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/detailDaftarMisa.dart';
import 'package:pelayanan_iman_katolik/profile.dart';
import 'package:pelayanan_iman_katolik/setting.dart';
import 'tiketSaya.dart';
import 'homePage.dart';

class Misa extends StatefulWidget {
  var names;
  var emails;
  final idUser;
  Misa(this.names, this.emails, this.idUser);
  @override
  _Misa createState() => _Misa(this.names, this.emails, this.idUser);
}

class _Misa extends State<Misa> {
  var names;
  var emails;
  List daftarGereja = [];

  List dummyTemp = [];
  final idUser;
  _Misa(this.names, this.emails, this.idUser);

  Future<List> callDb() async {
    return await MongoDatabase.findGereja();
  }

  @override
  void initState() {
    super.initState();
    callDb().then((result) {
      setState(() {
        daftarGereja = result;
        dummyTemp = result;
      });
    });
  }

  filterSearchResults(String query) {
    setState(() {
      callDb().then((result) {
        setState(() {
          dummyTemp = result;
        });
      });
    });
    if (query.isNotEmpty) {
      List<Map<String, dynamic>> listOMaps = <Map<String, dynamic>>[];
      for (var item in dummyTemp) {
        if (item['nama'].toLowerCase().contains(query.toLowerCase())) {
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
        callDb().then((result) {
          setState(() {
            daftarGereja = result;
            dummyTemp = result;
          });
        });
      });
    }
  }

  TextEditingController editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text('Pendaftaran Misa'),
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
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        TextField(
          onChanged: (value) {
            filterSearchResults(value);
          },
          controller: editingController,
          decoration: InputDecoration(
              labelText: "Search",
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)))),
        ),
        ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(20.0),
          children: <Widget>[
            ///map////////
            for (var i in daftarGereja)
              InkWell(
                borderRadius: new BorderRadius.circular(24),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            detailDaftarMisa(names, emails, i['nama'], idUser)),
                  );
                },
                child: Container(
                    margin: EdgeInsets.all(20),
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
                        i['nama'],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.0,
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        'Paroki: ' + i['paroki'],
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Text(
                        'Alamat: ' + i['address'],
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ])),
              ),

            ///map////////
          ],
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
