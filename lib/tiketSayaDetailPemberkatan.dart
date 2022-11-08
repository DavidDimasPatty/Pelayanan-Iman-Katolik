import 'package:flutter/material.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/profile.dart';
import 'package:pelayanan_iman_katolik/tiketSaya.dart';

class tiketSayaDetailPemberkatan {
  var names;
  var idUser;
  var emails;
  var tiketGereja;
  var tiket;
  var namaGereja;
  var idPemberkatan;
  var idUmum;
  var idUserBaptis;
  var cancelPemberkatan;
  tiketSayaDetailPemberkatan(
      this.names, this.emails, this.idUser, this.idPemberkatan);

  Future<List> callInfoPembarkatan(idPemberkatan) async {
    tiket = await MongoDatabase.pemberkatanSpec(idPemberkatan);
    return tiket;
  }

  cancelDaftar(idMisa, context) async {
    cancelPemberkatan = await MongoDatabase.cancelPemberkatan(idPemberkatan);
    if (cancelPemberkatan == 'oke') {
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
    await callInfoPembarkatan(idPemberkatan);
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
                        Text('Alamat: ' + tiket[0]['alamat']),
                        Text('Nama Kegiatan: ' + tiket[0]['jenis']),
                        if (tiket[0]['status'] == 0)
                          Text(
                            "Status : Menunggu",
                          ),
                        if (tiket[0]['status'] == 1)
                          Text(
                            "Status : Disetujui",
                          ),
                        if (tiket[0]['status'] == -1)
                          Text(
                            "Status : Ditolak",
                          ),
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
                            await cancelDaftar(idPemberkatan, context);
                          }), // button 1
                    ])
              ]);
        });
  }
}
