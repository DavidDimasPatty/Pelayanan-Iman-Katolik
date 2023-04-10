import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';

import '../../tiketSaya.dart';

class tiketSayaPemberkatanHistory {
  var iduser;
  var tiket;
  var namaGereja;
  var idPemberkatan;
  tiketSayaPemberkatanHistory(this.iduser, this.idPemberkatan);

  Future<List> callDb() async {
    // tiket = await MongoDatabase.pemberkatanSpec(idPemberkatan);
    // return tiket;
    // Messages msg = new Messages();
    // msg.addReceiver("agenPencarian");
    // msg.setContent([
    //   ["cari Detail Jadwal Pemberkatan"],
    //   [idPemberkatan]
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
        Tasks('cari pelayanan', ["sakramentali", "history", idPemberkatan]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    var hasil = await AgentPage.getDataPencarian();
    completer.complete();

    await completer.future;
    return await hasil;
  }

  cancelDaftar(idMisa, context) async {
    // cancelPemberkatan = await MongoDatabase.cancelPemberkatan(idPemberkatan);

    Completer<void> completer = Completer<void>();
    Messages message = Messages('Agent Page', 'Agent Pendaftaran', "REQUEST",
        Tasks('cancel pelayanan', ["sakramentali", idPemberkatan]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    var hasil = await await AgentPage.getDataPencarian();
    completer.complete();
    await Future.delayed(Duration(seconds: 1));
    if (hasil == 'oke') {
      Fluttertoast.showToast(
          msg: "Berhasil Cancel Pemberkatan",
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
    // await callInfoPembarkatan(idPemberkatan);
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
                      print(snapshot.data[0]);
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
                                Text('Alamat: ' + snapshot.data[0]['alamat']),
                                Text('Nama Kegiatan: Pemberkatan ' +
                                    snapshot.data[0]['jenis']),
                                if (snapshot.data[0]['status'] == 0)
                                  Text(
                                    "Status : Menunggu",
                                  ),
                                if (snapshot.data[0]['status'] == 1)
                                  Text(
                                    "Status : Disetujui",
                                  ),
                                if (snapshot.data[0]['status'] == -1)
                                  Text(
                                    "Status : Ditolak",
                                  ),
                              ],
                            )
                          ]);
                    } catch (e) {
                      print(e);
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
              actions: <Widget>[]);
        });
  }
}
