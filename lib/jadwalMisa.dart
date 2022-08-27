import 'package:flutter/material.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/profile.dart';

class jadwalMisa {
  final idGereja;
  final idUser;
  var detailMisa;
  var key = 0;
  jadwalMisa(this.idGereja, this.idUser);

  Future<List> callDb() async {
    detailMisa = await MongoDatabase.jadwalGereja(idGereja);
    print(detailMisa);
    return detailMisa;
  }

  daftar(idMisa, idUser, context, kapasitas) async {
    var daftarmisa = await MongoDatabase.daftarMisa(idMisa, idUser, kapasitas);

    if (daftarmisa == 'oke') {
      return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Berhasil mendaftar'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void showDialogBox(BuildContext context) async {
    await callDb();
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              scrollable: true,
              insetPadding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
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
                              Text('Jadwal :'),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2),
                              ),
                              Text(i['jadwal'].toString().substring(0, 19)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                              ),
                              Text(i['KapasitasJadwal'].toString()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                              ),
                              RaisedButton(
                                  child: Text('Daftar'),
                                  textColor: Colors.white,
                                  color: Colors.blueAccent,
                                  onPressed: () async {
                                    var res = await daftar(i['_id'], idUser,
                                        context, i['KapasitasJadwal']);
                                  })
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
