import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/detailDaftarMisa.dart';
import 'package:pelayanan_iman_katolik/profile.dart';

class tiketSaya extends StatelessWidget {
  var names;
  var idUser;
  var emails;
  var tiketGereja;
  var tiket;
  var namaGereja;
  tiketSaya(this.names, this.emails, this.idUser);

  Future<List> callDb() async {
    tiketGereja = await MongoDatabase.jadwalku(idUser);
    return tiketGereja;
  }

  Future<List> callInfoMisa(idMisa) async {
    tiket = await MongoDatabase.jadwalMisaku(idMisa);
    return tiket;
  }

  Future<List> callInfoGereja(idGereja) async {
    namaGereja = await MongoDatabase.jadwalMisaku(idGereja);
    return namaGereja;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jadwal Saya'),
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
                  for (var i in tiketGereja)
                    InkWell(
                      borderRadius: new BorderRadius.circular(24),
                      onTap: () {},
                      child: Container(
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.lightBlue,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Column(children: <Widget>[
                            FutureBuilder<List>(
                                future: callInfoMisa(i['idMisa']),
                                builder: (context, AsyncSnapshot snapshot) {
                                  try {
                                    return Column(
                                      children: <Widget>[
                                        FutureBuilder<List>(
                                            future: callInfoGereja(
                                                tiket['idGereja']),
                                            builder: (context,
                                                AsyncSnapshot snapshot) {
                                              try {
                                                return Column(
                                                  children: <Widget>[],
                                                );
                                              } catch (e) {
                                                print(e);
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }
                                            }),
                                      ],
                                    );
                                  } catch (e) {
                                    print(e);
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                }),
                          ])),
                    ),

                  ///map////////
                ],
              );
            } catch (e) {
              print(e);
              return Center(child: CircularProgressIndicator());
            }
          }),
      // body: ListView(
      //   shrinkWrap: true,
      //   padding: EdgeInsets.all(20.0),
      //   children: <Widget>[
      //     ///map////////
      //     ///
      //     ...daftarGereja((i) => <Widget>[
      //           InkWell(
      //             borderRadius: new BorderRadius.circular(24),
      //             onTap: () => () {},
      //             child: Column(children: <Widget>[
      //               //Color(Colors.blue);
      //               Text(
      //                 i['nama'],
      //                 style: TextStyle(color: Colors.red, fontSize: 12),
      //                 textAlign: TextAlign.left,
      //               ),
      //               Text(
      //                 i['address'],
      //                 style: TextStyle(color: Colors.red, fontSize: 12),
      //               ),
      //               Text(
      //                 i['paroki'],
      //                 style: TextStyle(color: Colors.red, fontSize: 12),
      //               ),
      //               Text(
      //                 i['kapasitas'],
      //                 style: TextStyle(color: Colors.red, fontSize: 12),
      //               ),
      //             ]),
      //           ),
      //         ])

      //     ///map////////
      //   ],
      // )
    );
  }
}
