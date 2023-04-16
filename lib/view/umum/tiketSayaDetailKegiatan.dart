import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';

import '../tiketSaya.dart';

class tiketSayaDetailKegiatan {
  var iduser;
  var idUmum;
  var idUserUmum;
  tiketSayaDetailKegiatan(this.iduser, this.idUserUmum, this.idUmum);

  Future<List> callDb() async {
    Completer<void> completer = Completer<void>();
    Messages message = Messages('Agent Page', 'Agent Pencarian', "REQUEST",
        Tasks('cari pelayanan', ["umum", "detail", idUmum]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    var hasil = await await AgentPage.getDataPencarian();
    completer.complete();

    await completer.future;
    return await hasil;
  }

  cancelDaftar(kapasitas, context) async {
    Completer<void> completer = Completer<void>();
    Messages message = Messages(
        'Agent Page',
        'Agent Pendaftaran',
        "REQUEST",
        Tasks('cancel pelayanan',
            ["umum", idUserUmum, idUmum, kapasitas, iduser]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    var hasilDaftar = await await AgentPage.getDataPencarian();
    completer.complete();

    await completer.future;
    if (hasilDaftar == 'oke') {
      Fluttertoast.showToast(
          msg: "Berhasil Cancel Kegiatan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context,
          MaterialPageRoute(builder: (context) => tiketSaya(this.iduser)));
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

    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            alignment: Alignment.center,
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
                              _getCloseButton(context),
                              Text(
                                "Detail Jadwal",
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w300),
                              ),
                              Text('Jadwal: ' +
                                  snapshot.data[0]['tanggal']
                                      .toString()
                                      .substring(0, 19)),
                              Text('Lokasi: ' + snapshot.data[0]['lokasi']),
                              Text('Nama Kegiatan: ' +
                                  snapshot.data[0]['namaKegiatan']),
                              Text('Tema Kegiatan: ' +
                                  snapshot.data[0]['temaKegiatan']),
                            ],
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                          RaisedButton(
                              onPressed: () async {
                                cancelDaftar(
                                    snapshot.data[0]['kapasitas'], context);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80.0)),
                              elevation: 10.0,
                              padding: EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.topLeft,
                                      colors: [
                                        Colors.blueAccent,
                                        Colors.lightBlue,
                                      ]),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth: double.maxFinite,
                                      minHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Cancel Pendaftaran",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              )),
                        ]);
                  } catch (e) {
                    print(e);
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          );
        });
  }
}
