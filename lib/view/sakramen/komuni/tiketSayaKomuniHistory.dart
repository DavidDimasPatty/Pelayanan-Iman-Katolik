import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';

import '../../tiketSaya.dart';

class tiketSayaKomuniHistory {
  var names;
  var idUser;
  var emails;
  var tiketGereja;
  var tiket;
  var namaGereja;
  var idKomuni;
  var idGereja;
  var idUserKomuni;
  var cancelKomuni;
  tiketSayaKomuniHistory(this.names, this.emails, this.idUser, this.idKomuni,
      this.idGereja, this.idUserKomuni);

  Future<List> callDb() async {
    // Messages msg = new Messages();
    // msg.addReceiver("agenPencarian");
    // msg.setContent([
    //   ["cari Detail Jadwal Komuni"],
    //   [idKomuni],
    //   [idGereja]
    // ]);

    // await msg.send().then((res) async {
    //   print("masuk");
    //   print(await AgenPage().receiverTampilan());
    // });
    // await Future.delayed(Duration(seconds: 1));
    // tiket = await AgenPage().receiverTampilan();

    // return tiket;
    // tiket = await MongoDatabase.jadwalBaptis(idBaptis);
    // return tiket;
    Completer<void> completer = Completer<void>();
    Messages message = Messages('Agent Page', 'Agent Pencarian', "REQUEST",
        Tasks('cari pelayanan', ["komuni", "detail", idKomuni, idGereja]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    var hasil = await await AgentPage.getDataPencarian();
    completer.complete();

    await completer.future;
    return await hasil;
  }

  cancelDaftar(kapasitas, context) async {
    // Messages msg = new Messages();
    // msg.addReceiver("agenPencarian");
    // msg.setContent([
    //   ["cancel Komuni"],
    //   [idUserKomuni],
    //   [idKomuni],
    //   [kapasitas]
    // ]);

    // await msg.send().then((res) async {
    //   print("masuk");
    //   print(await AgenPage().receiverTampilan());
    // });
    // await Future.delayed(Duration(seconds: 1));
    // cancelKomuni = await AgenPage().receiverTampilan();
    Completer<void> completer = Completer<void>();
    Messages message = Messages(
        'Agent Page',
        'Agent Pendaftaran',
        "REQUEST",
        Tasks(
            'cancel pelayanan', ["komuni", idUserKomuni, idKomuni, kapasitas]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    var hasil = await await AgentPage.getDataPencarian();
    completer.complete();

    await completer.future;
    if (hasil == 'oke') {
      Fluttertoast.showToast(
          msg: "Berhasil Cancel Komuni",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(
          context,
          MaterialPageRoute(
              builder: (context) => tiketSaya(names, emails, idUser)));
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
    // await callInfoGereja(idGereja);
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
                    print(snapshot.data);
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
                              Text('Waktu: ' +
                                  snapshot.data[0][0]['jadwalBuka']
                                      .toString()
                                      .substring(0, 19) +
                                  " s/d " +
                                  snapshot.data[0][0]['jadwalTutup']
                                      .toString()
                                      .substring(0, 19)),
                              Text('Nama Gereja: ' +
                                  snapshot.data[0][0]['GerejaKomuni'][0]
                                      ['nama']),
                              Text('Alamat Gereja: ' +
                                  snapshot.data[0][0]['GerejaKomuni'][0]
                                      ['address']),
                            ],
                          ),
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
