import 'package:flutter/material.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/profile.dart';
import 'package:pelayanan_iman_katolik/tiketSaya.dart';

class tiketSayaDetailKegiatan {
  var names;
  var idUser;
  var emails;
  var tiketGereja;
  var tiket;
  var namaGereja;
  var idKegiatan;
  var idGereja;
  var idUmum;
  var idUserBaptis;
  var cancelBaptis;
  tiketSayaDetailKegiatan(
      this.names, this.emails, this.idUser, this.idKegiatan, this.idUmum);

  Future<List> callInfoKegiatan(idBaptis) async {
    tiket = await MongoDatabase.jadwalKegiatan(idUmum);
    return tiket;
  }

  cancelDaftar(idMisa, context) async {
    cancelBaptis = await MongoDatabase.cancelDaftarKegiatan(idKegiatan);
    if (cancelBaptis == 'oke') {
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
    await callInfoKegiatan(idKegiatan);
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
                    Column(
                      children: <Widget>[
                        _getCloseButton(context),
                        Text(
                          "Detail Jadwal",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w300),
                        ),
                        Text('Jadwal: ' +
                            tiket[0]['tanggal'].toString().substring(0, 19)),
                        Text('Lokasi: ' + tiket[0]['lokasi']),
                        Text('Nama Kegiatan: ' + tiket[0]['namaKegiatan']),
                        Text('Tema Kegiatan: ' + tiket[0]['temaKegiatan']),
                      ],
                    )
                  ]),
              actions: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                          child: Text('Batalkan Mendaftar'),
                          textColor: Colors.white,
                          color: Colors.blueAccent,
                          onPressed: () async {
                            await cancelDaftar(idUserBaptis, context);
                          }), // button 1
                    ])
              ]);
        });
  }
}
