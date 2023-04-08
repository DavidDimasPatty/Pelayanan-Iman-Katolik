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
  var names;
  var idUser;
  var emails;
  var tiket;
  var namaGereja;
  var idPerkawinan;
  var cancelPemberkatan;
  tiketSayaPerkawinanHistory(
      this.names, this.emails, this.idUser, this.idPerkawinan);

  Future callDb() async {
    // tiket = await MongoDatabase.pemberkatanSpec(idPerkawinan);
    // return tiket;
    // Messages msg = new Messages();
    // msg.addReceiver("agenPencarian");
    // msg.setContent([
    //   ["cari Detail Jadwal Pemberkatan"],
    //   [idPerkawinan]
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
        Tasks('cari pelayanan', ["perkawinan", "history", idPerkawinan]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    var hasil = await await AgentPage.getDataPencarian();
    completer.complete();

    await completer.future;
    return await hasil;
  }

  // cancelDaftar(context) async {
  //   // cancelPemberkatan = await MongoDatabase.cancelPemberkatan(idPerkawinan);
  //   // Messages msg = new Messages();
  //   // msg.addReceiver("agenPendaftaran");
  //   // msg.setContent([
  //   //   ["cancel Pemberkatan"],
  //   //   [idPerkawinan]
  //   // ]);

  //   // await msg.send().then((res) async {
  //   //   print("masuk");
  //   //   print(await AgenPage().receiverTampilan());
  //   // });
  //   // await Future.delayed(Duration(seconds: 1));
  //   // cancelPemberkatan = await AgenPage().receiverTampilan();
  //   // cancelKrisma = await AgenPage().receiverTampilan();
  //   Completer<void> completer = Completer<void>();
  //   Messages message = Messages('Agent Page', 'Agent Pendaftaran', "REQUEST",
  //       Tasks('cancel pelayanan', ["perkawinan", idPerkawinan, idUser]));

  //   MessagePassing messagePassing = MessagePassing();
  //   var data = await messagePassing.sendMessage(message);
  //   var hasil = await await AgentPage.getDataPencarian();
  //   completer.complete();

  //   await completer.future;
  //   if (hasil == 'oke') {
  //     Fluttertoast.showToast(
  //         msg: "Berhasil Cancel Perkawinan",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 2,
  //         backgroundColor: Colors.green,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //     Navigator.pop(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => tiketSaya(names, emails, idUser)));
  //   }
  // }

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
                            // RaisedButton(
                            //     onPressed: () async {
                            //       cancelDaftar(context);
                            //     },
                            //     shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(80.0)),
                            //     elevation: 10.0,
                            //     padding: EdgeInsets.all(0.0),
                            //     child: Ink(
                            //       decoration: BoxDecoration(
                            //         gradient: LinearGradient(
                            //             begin: Alignment.topRight,
                            //             end: Alignment.topLeft,
                            //             colors: [
                            //               Colors.blueAccent,
                            //               Colors.lightBlue,
                            //             ]),
                            //         borderRadius: BorderRadius.circular(30.0),
                            //       ),
                            //       child: Container(
                            //         constraints: BoxConstraints(
                            //             maxWidth: double.maxFinite,
                            //             minHeight: 50.0),
                            //         alignment: Alignment.center,
                            //         child: Text(
                            //           "Cancel Pendaftaran",
                            //           style: TextStyle(
                            //               color: Colors.white,
                            //               fontSize: 26.0,
                            //               fontWeight: FontWeight.w300),
                            //         ),
                            //       ),
                            //     )),
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
