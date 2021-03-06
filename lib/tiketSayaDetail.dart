import 'package:flutter/material.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/profile.dart';

class tiketSayaDetail {
  var names;
  var idUser;
  var emails;
  var tiketGereja;
  var tiket;
  var namaGereja;
  var idMisa;
  tiketSayaDetail(this.names, this.emails, this.idUser, this.idMisa);

  Future<List> callDb() async {
    tiketGereja = await MongoDatabase.jadwalku(idUser);
    return tiketGereja;
  }

  Future<List> callInfoMisa(idMisa) async {
    tiket = await MongoDatabase.jadwalMisaku(idMisa);
    return tiket;
  }

  Future<List> callInfoGereja(idGereja) async {
    namaGereja = await MongoDatabase.cariGereja(idGereja);
    return namaGereja;
  }

  void showDialogBox(BuildContext context) async {
    await callDb();
    await callInfoMisa(idMisa);
    await callInfoGereja(tiket[0]['idGereja']);
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              alignment: Alignment.center,
              title: Text("Detail Jadwal"),
              content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text('Waktu: ' + tiket[0]['jadwal']),
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
