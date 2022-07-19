import 'package:flutter/material.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/jadwalMisa.dart';
import 'package:pelayanan_iman_katolik/profile.dart';
import 'tiketSaya.dart';
import 'homePage.dart';

class detailDaftarMisa extends StatelessWidget {
  final name;
  final email;
  final namaGereja;
  var detailGereja;
  final idUser;

  Future<List> callDb() async {
    detailGereja = await MongoDatabase.detailGereja(namaGereja);
    print(detailGereja);
    return detailGereja;
  }

  detailDaftarMisa(this.name, this.email, this.namaGereja, this.idUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendaftaran Misa'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Profile(name, email, idUser)),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List>(
          future: callDb(),
          builder: (context, AsyncSnapshot snapshot) {
            try {
              return ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(20.0),
                children: <Widget>[
                  ///map////////
                  ///

                  Center(
                      child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      ),
                      CircleAvatar(
                        backgroundImage: AssetImage(''),
                        backgroundColor: Colors.greenAccent,
                        radius: 120,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      ),
                      Text(
                        'Gereja Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      ),
                      Row(
                        children: <Widget>[
                          Text("Nama Gereja: "),
                          Text(detailGereja[0]['nama'] as String),
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      ),
                      Row(
                        children: <Widget>[
                          Text("Paroki: "),
                          Text(detailGereja[0]['paroki'] as String),
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      ),
                      Row(
                        children: <Widget>[
                          Text("Alamat Gereja: "),
                          Text(detailGereja[0]['address']),
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      ),
                      Row(
                        children: <Widget>[
                          Text("Kapasitas: "),
                          Text(detailGereja[0]['kapasitas']),
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: RaisedButton(
                            child: Text("Daftar Misa"),
                            textColor: Colors.white,
                            color: Colors.blueAccent,
                            onPressed: () {
                              jadwalMisa(detailGereja[0]['_id'], idUser)
                                  .showDialogBox(context);
                            }),
                      ),
                    ],
                  )),

                  ///map////////
                ],
              );
            } catch (e) {
              print(e);
              return Center(child: CircularProgressIndicator());
            }
          }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.blue,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color.fromARGB(255, 0, 0, 0)),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded,
                color: Color.fromARGB(255, 0, 0, 0)),
            label: "TiketKu",
          )
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => tiketSaya(name, email, idUser)),
            );
          } else if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(name, email, idUser)),
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: new FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: new Icon(Icons.camera_alt_rounded),
      ),
    );
  }
}
