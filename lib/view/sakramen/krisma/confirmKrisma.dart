import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/view/sakramen/krisma/detailDaftarKrisma.dart';

class confirmKrisma {
  final idGereja;
  final iduser;
  final idKrisma;
  var hasil;

  var key = 0;
  confirmKrisma(this.iduser, this.idGereja, this.idKrisma);

  Future<List> callDb() async {
    Completer<void> completer = Completer<void>();
    Messages message = Messages('Agent Page', 'Agent Pencarian', "REQUEST",
        Tasks('cari pelayanan', ["krisma", "detail", idKrisma, idGereja]));

    MessagePassing messagePassing = MessagePassing();
    await messagePassing.sendMessage(message);
    hasil = await await AgentPage.getData();
    completer.complete();

    await completer.future;
    return await hasil;
  }

  Future daftar(idKrisma, iduser, kapasitas, context) async {
    Completer<void> completer = Completer<void>();
    Messages message = Messages('Agent Page', 'Agent Pencarian', "REQUEST",
        Tasks('check pendaftaran', ["krisma", idKrisma, iduser, kapasitas]));

    MessagePassing messagePassing = MessagePassing();
    await messagePassing.sendMessage(message);
    var hasilDaftar = await AgentPage.getData();

    completer.complete();

    await completer.future;
    if (hasilDaftar == 'oke') {
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
                detailDaftarKrisma(idGereja, iduser, idGereja)),
      );
    }
    if (hasilDaftar == 'sudah') {
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
                detailDaftarKrisma(idGereja, iduser, idGereja)),
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
                                    "Konfirmasi Pendaftaran Krisma \n Pada Gereja " +
                                        hasil[0][0]['GerejaKrisma'][0]['nama'] +
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
                            await daftar(idKrisma, iduser,
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
