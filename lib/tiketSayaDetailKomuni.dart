import 'package:flutter/material.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/profile.dart';

class tiketSayaDetailKomuni {
  var names;
  var idUser;
  var emails;
  var tiketGereja;
  var tiket;
  var namaGereja;
  var idKomuni;
  var idGereja;
  tiketSayaDetailKomuni(
      this.names, this.emails, this.idUser, this.idKomuni, this.idGereja);

  Future<List> callInfoKomuni(idKomuni) async {
    tiket = await MongoDatabase.jadwalKomuni(idKomuni);
    return tiket;
  }

  Future<List> callInfoGereja(idGereja) async {
    namaGereja = await MongoDatabase.cariGereja(idGereja);
    return namaGereja;
  }

  void showDialogBox(BuildContext context) async {
    await callInfoKomuni(idKomuni);
    await callInfoGereja(idGereja);
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              alignment: Alignment.center,
              title: Text(
                "Detail Jadwal Komuni",
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
