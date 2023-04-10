import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/view/sakramen/komuni/detailDaftarKomuni.dart';

class confirmKomuni {
  final idGereja;
  final iduser;
  final idKomuni;
  var hasil;
  confirmKomuni(this.iduser, this.idGereja, this.idKomuni);

  Future<List> callDb() async {
    // Messages msg = new Messages();
    // msg.addReceiver("agenPencarian");
    // msg.setContent([
    //   ["cari Detail Komuni"],
    //   [idKomuni],
    //   [idGereja]
    // ]);

    // await msg.send().then((res) async {
    //   print("masuk");
    //   print(await AgenPage().receiverTampilan());
    // });
    // await Future.delayed(Duration(seconds: 1));
    // detailGereja = await AgenPage().receiverTampilan();

    // return detailGereja;
    Completer<void> completer = Completer<void>();
    Messages message = Messages('Agent Page', 'Agent Pencarian', "REQUEST",
        Tasks('cari pelayanan', ["komuni", "detail", idKomuni, idGereja]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    hasil = await await AgentPage.getDataPencarian();
    completer.complete();

    await completer.future;
    return await hasil;
  }

  Future daftar(idKomuni, idUser, kapasitas, context) async {
    // Messages msg = new Messages();
    // msg.addReceiver("agenPendaftaran");
    // msg.setContent([
    //   ["enroll Komuni"],
    //   [idKomuni],
    //   [idUser],
    //   [kapasitas]
    // ]);

    // await msg.send().then((res) async {
    //   print("masuk");
    //   print(await AgenPage().receiverTampilan());
    // });
    // await Future.delayed(Duration(seconds: 2));
    // var daftarmisa = await AgenPage().receiverTampilan();
    Completer<void> completer = Completer<void>();
    Messages message = Messages('Agent Page', 'Agent Pencarian', "REQUEST",
        Tasks('check pendaftaran', ["komuni", idKomuni, idUser, kapasitas]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    var hasilDaftar = await AgentPage.getDataPencarian();

    completer.complete();
    print(hasilDaftar);
    await completer.future;

    if (hasilDaftar == 'oke') {
      Fluttertoast.showToast(
          msg: "Berhasil Mendaftar Komuni",
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
                detailDaftarKomuni(idGereja, idUser, idKomuni)),
      );
    }
    if (hasilDaftar == 'sudah') {
      Fluttertoast.showToast(
          msg: "Sudah Mendaftar Komuni ini",
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
                detailDaftarKomuni(idGereja, idUser, idKomuni)),
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
                            Column(
                              children: <Widget>[
                                Text(
                                    "Konfirmasi Pendaftaran Komuni \n Pada Gereja " +
                                        hasil[0][0]['GerejaKomuni'][0]['nama'] +
                                        "\n" +
                                        "Pada Tanggal " +
                                        hasil[0][0]['jadwalBuka']
                                            .toString()
                                            .substring(0, 19) +
                                        " - " +
                                        hasil[0][0]['jadwalTutup']
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
                            await daftar(idKomuni, iduser,
                                hasil[0][0]['kapasitas'], context);
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
