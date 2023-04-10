import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/view/sakramen/baptis/baptis.dart';

class confirmBaptis {
  final idGereja;
  final iduser;
  final idBaptis;
  var hasil;
  confirmBaptis(this.idGereja, this.iduser, this.idBaptis);

  Future<List> callDb() async {
    // Messages msg = new Messages();
    // msg.addReceiver("agenPencarian");
    // msg.setContent([
    //   ["cari Detail Baptis"],
    //   [idBaptis],
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
        Tasks('cari pelayanan', ["baptis", "detail", idBaptis, idGereja]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    hasil = await await AgentPage.getDataPencarian();
    completer.complete();

    await completer.future;
    return await hasil;
  }

  Future daftar(idBaptis, idUser, kapasitas, context) async {
    // Messages msg = new Messages();
    // msg.addReceiver("agenPendaftaran");
    // msg.setContent([
    //   ["enroll Baptis"],
    //   [idBaptis],
    //   [idUser],
    //   [kapasitas]
    // ]);

    // await msg.send();
    // await Future.delayed(Duration(seconds: 2));
    // var daftarmisa = await AgenPage().receiverTampilan();
    Completer<void> completer = Completer<void>();
    Messages message = Messages('Agent Page', 'Agent Pencarian', "REQUEST",
        Tasks('check pendaftaran', ["baptis", idBaptis, idUser, kapasitas]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    var hasilDaftar = await AgentPage.getDataPencarian();

    completer.complete();
    print(hasilDaftar);
    await completer.future;

    if (hasilDaftar == 'oke') {
      Fluttertoast.showToast(
          msg: "Berhasil Mendaftar Baptis",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(
        context,
        MaterialPageRoute(builder: (context) => Baptis(iduser)),
      );
    }

    if (hasilDaftar == 'sudah') {
      Fluttertoast.showToast(
          msg: "Sudah Mendaftar Baptis ini",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(
        context,
        MaterialPageRoute(builder: (context) => Baptis(iduser)),
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
                                    "Konfirmasi Pendaftaran Baptis \n Pada Gereja " +
                                        hasil[0][0]['GerejaBaptis'][0]['nama'] +
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
                            await daftar(idBaptis, iduser,
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
