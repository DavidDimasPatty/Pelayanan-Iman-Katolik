import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/detailDaftarKomuni.dart';
import 'package:pelayanan_iman_katolik/detailDaftarPA.dart';
import 'package:pelayanan_iman_katolik/detailDaftarRekoleksi.dart';
import 'package:pelayanan_iman_katolik/detailDaftarRetret.dart';
import 'package:pelayanan_iman_katolik/profile.dart';

class confirmRetret {
  final name;
  final email;
  final idUser;
  final idKegiatan;
  var detailGereja;
  var key = 0;
  confirmRetret(this.idUser, this.idKegiatan, this.name, this.email);

  Future<List> callDb() async {
    detailGereja = await MongoDatabase.detailRekoleksi(idKegiatan);
    return detailGereja;
  }

  daftar(idKegiatan, idUser, kapasitas, context) async {
    var daftarmisa =
        await MongoDatabase.daftarKegiatan(idKegiatan, idUser, kapasitas);

    if (daftarmisa == 'oke') {
      Fluttertoast.showToast(
          msg: "Berhasil Mendaftar Retret",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                detailDaftarRetret(name, email, idUser, idKegiatan)),
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
                          Text("Konfirmasi Pendaftaran Retret \n  " +
                              i['namaKegiatan'] +
                              "\n" +
                              "Pada Tanggal " +
                              i['tanggal'].toString().substring(0, 19) +
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
                            await daftar(idKegiatan, idUser,
                                detailGereja[0]['kapasitas'], context);
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
