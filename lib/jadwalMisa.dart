import 'package:flutter/material.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/profile.dart';

class jadwalMisa {
  final idGereja;
  var detailMisa;
  var key = 0;
  jadwalMisa(this.idGereja);

  Future<List> callDb() async {
    detailMisa = await MongoDatabase.jadwalGereja(idGereja);
    print(detailMisa);
    return detailMisa;
  }

  void showDialogBox(BuildContext context) async {
    await callDb();
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              alignment: Alignment.center,
              title: Text("Jadwal Tersedia"),
              content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    for (var i in detailMisa)
                      Column(
                        children: <Widget>[
                          Row(
                            children: [
                              Text('Jadwal'),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                              ),
                              Text(i['jadwal']),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                              ),
                              Text(i['KapasitasJadwal']),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                              ),
                              RaisedButton(
                                  child: Text('Daftar'),
                                  textColor: Colors.white,
                                  color: Colors.blueAccent,
                                  onPressed: () {})
                            ],
                          )
                        ],
                      )
                  ]),
              actions: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                          child: Text('Cancel'),
                          textColor: Colors.white,
                          color: Colors.blueAccent,
                          onPressed: () {
                            Navigator.of(context).pop();
                          }), // button 1
                    ])
              ]);
        });
  }
}
