import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/messages.dart';
import 'package:pelayanan_iman_katolik/detailDaftarBaptis.dart';
import 'package:pelayanan_iman_katolik/detailDaftarKrisma.dart';
import 'package:pelayanan_iman_katolik/profile.dart';

class confirmKrisma {
  final idGereja;
  final idUser;
  final idKrisma;
  var detailGereja;
  final name;
  final email;
  final namaGereja;
  var key = 0;
  confirmKrisma(this.idGereja, this.idUser, this.idKrisma, this.name,
      this.email, this.namaGereja);

  Future<List> callDb() async {
    Messages msg = new Messages();
    msg.addReceiver("agenPencarian");
    msg.setContent([
      ["cari Detail Krisma"],
      [idKrisma]
    ]);

    await msg.send().then((res) async {
      print("masuk");
      print(await AgenPage().receiverTampilan());
    });
    await Future.delayed(Duration(seconds: 1));
    detailGereja = await AgenPage().receiverTampilan();

    return detailGereja;
  }

  daftar(idKrisma, idUser, kapasitas, context) async {
    Messages msg = new Messages();
    msg.addReceiver("agenPencarian");
    msg.setContent([
      ["enroll Krisma"],
      [idKrisma],
      [idUser],
      [kapasitas]
    ]);

    await msg.send().then((res) async {
      print("masuk");
      print(await AgenPage().receiverTampilan());
    });
    await Future.delayed(Duration(seconds: 1));
    var daftarmisa = await AgenPage().receiverTampilan();

    if (daftarmisa == 'oke') {
      Fluttertoast.showToast(
          msg: "Berhasil Mendaftar Krisma",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(
        context,
        MaterialPageRoute(
            builder: (context) =>
                detailDaftarKrisma(name, email, namaGereja, idUser, idGereja)),
      );
    }
    if (daftarmisa == 'sudah') {
      Fluttertoast.showToast(
          msg: "Sudah Mendaftar Krisma ini",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(
        context,
        MaterialPageRoute(
            builder: (context) =>
                detailDaftarKrisma(name, email, namaGereja, idUser, idGereja)),
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
              content: FutureBuilder<List>(
                  future: callDb(),
                  builder: (context, AsyncSnapshot snapshot) {
                    try {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            for (var i in detailGereja)
                              Column(
                                children: <Widget>[
                                  Text(
                                      "Konfirmasi Pendaftaran Krisma \n Pada Gereja " +
                                          detailGereja[0]['GerejaKrisma'][0]
                                              ['nama'] +
                                          "\n" +
                                          "Pada Tanggal " +
                                          detailGereja[0]['jadwalBuka']
                                              .toString()
                                              .substring(0, 19) +
                                          " - " +
                                          detailGereja[0]['jadwalTutup']
                                              .toString()
                                              .substring(0, 19) +
                                          " ?")
                                ],
                              )
                          ]);
                    } catch (e) {
                      print(e);
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
              actions: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                          child: Text('Confirm'),
                          textColor: Colors.white,
                          color: Colors.blueAccent,
                          onPressed: () async {
                            await daftar(idKrisma, idUser,
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
