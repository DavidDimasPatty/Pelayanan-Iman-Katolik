import 'package:flutter/material.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/profile.dart';
import 'package:pelayanan_iman_katolik/tiketSaya.dart';

class tiketSayaDetail {
  var names;
  var idUser;
  var emails;
  var tiketGereja;
  var tiket;
  var namaGereja;
  var idMisa;
  var daftarmisa;
  var idTiket;
  tiketSayaDetail(
      this.names, this.emails, this.idUser, this.idMisa, this.idTiket);

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

  cancelDaftar(idMisa, context) async {
    daftarmisa = await MongoDatabase.cancelDaftar(idMisa);
    if (daftarmisa == 'oke') {
      return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Berhasil Membatalkan'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => tiketSaya(names, emails, idUser)),
              ),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  _getCloseButton(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          alignment: FractionalOffset.topRight,
          child: GestureDetector(
            child: Icon(
              Icons.clear,
              color: Colors.blue,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  void showDialogBox(BuildContext context) async {
    await callDb();
    await callInfoMisa(idMisa);
    await callInfoGereja(tiket[0]['idGereja']);
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              alignment: Alignment.center,
              content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _getCloseButton(context),
                    Text(
                      "Detail Jadwal",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w300),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 12)),
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
                          child: Text('Batalkan Pendaftaran'),
                          textColor: Colors.white,
                          color: Colors.blueAccent,
                          onPressed: () async {
                            await cancelDaftar(idTiket, context);
                          }), // button 1
                    ])
              ]);
        });
  }
}
