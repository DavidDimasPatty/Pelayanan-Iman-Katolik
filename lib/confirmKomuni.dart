import 'package:flutter/material.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/profile.dart';

class confirmKomuni {
  final idGereja;
  final idUser;
  final idKomuni;
  var detailGereja;
  var key = 0;
  confirmKomuni(this.idGereja, this.idUser, this.idKomuni);

  Future<List> callDb() async {
    detailGereja = await MongoDatabase.detailGerejaKomuni(idGereja);
    print(detailGereja);
    return detailGereja;
  }

  daftar(idKomuni, idUser, context) async {
    var daftarmisa = await MongoDatabase.daftarKomuni(idKomuni, idUser);

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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              alignment: Alignment.center,
              title: Text("Konfirmasi Pendaftaran"),
              content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    for (var i in detailGereja)
                      Column(
                        children: <Widget>[
                          Text("Konfirmasi Pendaftaran Komuni \n Pada Gereja " +
                              detailGereja[0]['nama'] +
                              "\n" +
                              "Pada Tanggal " +
                              detailGereja[0]['GerejaKomuni'][0]['jadwalBuka']
                                  .toString() +
                              "- " +
                              detailGereja[0]['GerejaKomuni'][0]['jadwalTutup']
                                  .toString() +
                              " ?")
                        ],
                      )
                  ]),
              actions: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                          child: Text('Confirm'),
                          textColor: Colors.white,
                          color: Colors.blueAccent,
                          onPressed: () async {
                            await daftar(idKomuni, idUser, context);
                          }),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
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
