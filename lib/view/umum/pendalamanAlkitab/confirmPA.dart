import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/messages.dart';
import 'package:pelayanan_iman_katolik/view/umum/pendalamanAlkitab/detailDaftarPA.dart';

class confirmPA {
  final name;
  final email;
  final idUser;
  final idKegiatan;
  var detailGereja;
  confirmPA(this.idUser, this.idKegiatan, this.name, this.email);

  Future<List> callDb() async {
    Messages msg = new Messages();
    msg.addReceiver("agenPencarian");
    msg.setContent([
      ["cari Detail Kegiatan"],
      [idKegiatan]
    ]);
    List k = [];
    await msg.send().then((res) async {
      print("masuk");
      print(await AgenPage().receiverTampilan());
    });
    await Future.delayed(Duration(seconds: 1));
    detailGereja = await AgenPage().receiverTampilan();

    return detailGereja;
  }

  Future daftar(idKegiatan, idUser, kapasitas, context) async {
    Messages msg = new Messages();
    msg.addReceiver("agenPendaftaran");
    msg.setContent([
      ["enroll Kegiatan"],
      [idKegiatan],
      [idUser],
      [kapasitas]
    ]);

    await msg.send().then((res) async {
      print("masuk");
      print(await AgenPage().receiverTampilan());
    });
    await Future.delayed(Duration(seconds: 2));
    var daftarmisa = await AgenPage().receiverTampilan();

    if (daftarmisa == 'oke') {
      Fluttertoast.showToast(
          msg: "Berhasil Mendaftar Pendalaman Alkitab",
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
                detailDaftarPA(name, email, idUser, idKegiatan)),
      );
    }
    if (daftarmisa == 'sudah') {
      Fluttertoast.showToast(
          msg: "Sudah Mendaftar Kegiatan ini",
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
                detailDaftarPA(name, email, idUser, idKegiatan)),
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
                                      "Konfirmasi Pendaftaran Pendalaman Alkitab\n " +
                                          i['namaKegiatan'] +
                                          "\n" +
                                          "Pada Tanggal " +
                                          i['tanggal']
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
