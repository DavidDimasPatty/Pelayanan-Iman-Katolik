import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';

import '../../tiketSaya.dart';

class tiketSayaPerkawinanHistory {
  var iduser;
  var tiket;
  var namaGereja;
  var idPerkawinan;
  var cancelPemberkatan;
  tiketSayaPerkawinanHistory(this.iduser, this.idPerkawinan);

  Future callDb() async {
    Completer<void> completer = Completer<void>();
    Messages message = Messages('Agent Page', 'Agent Pencarian', "REQUEST",
        Tasks('cari pelayanan', ["perkawinan", "history", idPerkawinan]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    var hasil = await await AgentPage.getDataPencarian();
    completer.complete();

    await completer.future;
    return await hasil;
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
    // await callInfoPembarkatan(idPerkawinan);
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              alignment: Alignment.center,
              content: FutureBuilder(
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
                                Text('Alamat: ' + snapshot.data[0]['alamat']),
                                Text(
                                  "Nama Pasangan : " +
                                      snapshot.data[0]['namaPria'] +
                                      " dan " +
                                      snapshot.data[0]['namaPerempuan'],
                                ),
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
                            ),
                            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
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
