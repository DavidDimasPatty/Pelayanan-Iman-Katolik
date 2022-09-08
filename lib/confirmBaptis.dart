import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/detailDaftarBaptis.dart';
import 'package:pelayanan_iman_katolik/profile.dart';

class confirmBaptis {
  final idGereja;
  final idUser;
  final idBaptis;
  var detailGereja;
  final name;
  final email;
  final namaGereja;
  var key = 0;
  confirmBaptis(this.idGereja, this.idUser, this.idBaptis, this.name,
      this.email, this.namaGereja);

  Future<List> callDb() async {
    detailGereja = await MongoDatabase.detailGerejaBaptis(idGereja);
    print(detailGereja);
    return detailGereja;
  }

  daftar(idBaptis, idUser, kapasitas, context) async {
    var daftarmisa =
        await MongoDatabase.daftarBaptis(idBaptis, idUser, kapasitas);

    if (daftarmisa == 'oke') {
      Fluttertoast.showToast(
          msg: "Berhasil Mendaftar Baptis",
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
                detailDaftarBaptis(name, email, namaGereja, idUser, idGereja)),
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
                          Text("Konfirmasi Pendaftaran Baptis \n Pada Gereja " +
                              detailGereja[0]['nama'] +
                              "\n" +
                              "Pada Tanggal " +
                              detailGereja[0]['GerejaBaptis'][0]['jadwalBuka']
                                  .toString()
                                  .substring(0, 19) +
                              " - " +
                              detailGereja[0]['GerejaBaptis'][0]['jadwalTutup']
                                  .toString()
                                  .substring(0, 19) +
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
                            await daftar(
                                idBaptis,
                                idUser,
                                detailGereja[0]['GerejaBaptis'][0]['kapasitas'],
                                context);
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
