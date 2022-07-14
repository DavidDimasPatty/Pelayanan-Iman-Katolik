import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/detailDaftarMisa.dart';
import 'package:pelayanan_iman_katolik/profile.dart';

class Misa extends StatelessWidget {
  var names;
  var emails;
  var daftarGereja;
  final idUser;
  Misa(this.names, this.emails, this.idUser);

  Future<List> callDb() async {
    daftarGereja = await MongoDatabase.findGereja();
    return daftarGereja;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  for (var i in daftarGereja)
                    InkWell(
                      borderRadius: new BorderRadius.circular(24),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => detailDaftarMisa(
                                  names, emails, i['nama'], idUser)),
                        );
                      },
                      child: Container(
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.lightBlue,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Column(children: <Widget>[
                            //Color(Colors.blue);

                            Text(
                              'Nama Gereja: ' + i['nama'],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              'Paroki: ' + i['paroki'],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                            Text(
                              'Alamat: ' + i['address'],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                            Text(
                              'Kapasitas Tersedia: ' + i['kapasitas'],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
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
