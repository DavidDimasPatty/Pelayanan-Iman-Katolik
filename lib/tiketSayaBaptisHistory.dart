import 'package:flutter/material.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/profile.dart';

class tiketSayaBaptisHistory {
  var names;
  var idUser;
  var emails;
  var tiketGereja;
  var tiket;
  var namaGereja;
  var idBaptis;
  var idGereja;
  tiketSayaBaptisHistory(
      this.names, this.emails, this.idUser, this.idBaptis, this.idGereja);

  Future<List> callInfoBaptis(idBaptis) async {
    tiket = await MongoDatabase.jadwalBaptis(idBaptis);
    return tiket;
  }

  Future<List> callInfoGereja(idGereja) async {
    namaGereja = await MongoDatabase.cariGereja(idGereja);
    return namaGereja;
  }

  void showDialogBox(BuildContext context) async {
    await callInfoBaptis(idBaptis);
    await callInfoGereja(idGereja);
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              alignment: Alignment.center,
              title: Text(
                "Detail Jadwal Baptis",
                textAlign: TextAlign.center,
              ),
              content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text('Waktu: ' +
                            tiket[0]['jadwalBuka'] +
                            " s/d " +
                            tiket[0]['jadwalTutup']),
                        Text('Nama Gereja: ' + namaGereja[0]['nama']),
                        Text('Alamat Gereja: ' + namaGereja[0]['address']),
                      ],
                    )
                  ]),
              actions: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                          child: Text('Close'),
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
