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
              title: Text("Jadwal Misa Tersedia"),
              content: Column(children: <Widget>[
                for (var i in detailMisa)
                  Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Text('Jadwal'),
                          Text(i['jadwal']),
                          Text(i['KapasitasJadwal']),
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
                // usually buttons at the bottom of the dialog
                new RaisedButton(
                  child: Text("close"),
                  textColor: Colors.white,
                  color: Colors.blueAccent,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]);
        });
  }
}
