import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/messages.dart';

import '../../tiketSaya.dart';

class tiketSayaPemberkatanHistory {
  var names;
  var idUser;
  var emails;
  var tiketGereja;
  var tiket;
  var namaGereja;
  var idPemberkatan;
  var idUmum;
  var idUserBaptis;
  var cancelPemberkatan;
  tiketSayaPemberkatanHistory(
      this.names, this.emails, this.idUser, this.idPemberkatan);

  Future<List> callDb() async {
    // tiket = await MongoDatabase.pemberkatanSpec(idPemberkatan);
    // return tiket;
    Messages msg = new Messages();
    msg.addReceiver("agenPencarian");
    msg.setContent([
      ["cari Detail Jadwal Pemberkatan"],
      [idPemberkatan]
    ]);

    await msg.send().then((res) async {
      print("masuk");
      print(await AgenPage().receiverTampilan());
    });
    await Future.delayed(Duration(seconds: 1));
    tiket = await AgenPage().receiverTampilan();

    return tiket;
    // tiket = await MongoDatabase.jadwalBaptis(idBaptis);
    // return tiket;
  }

  cancelDaftar(idMisa, context) async {
    // cancelPemberkatan = await MongoDatabase.cancelPemberkatan(idPemberkatan);
    Messages msg = new Messages();
    msg.addReceiver("agenPencarian");
    msg.setContent([
      ["cancel Pemberkatan"],
      [idPemberkatan]
    ]);

    await msg.send().then((res) async {
      print("masuk");
      print(await AgenPage().receiverTampilan());
    });
    await Future.delayed(Duration(seconds: 1));
    cancelPemberkatan = await AgenPage().receiverTampilan();
    if (cancelPemberkatan == 'oke') {
      Fluttertoast.showToast(
          msg: "Berhasil Cancel Pemberkatan",
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
                                Text('Jadwal: ' +
                                    tiket[0]['tanggal']
                                        .toString()
                                        .substring(0, 19)),
                                Text('Alamat: ' + tiket[0]['alamat']),
                                Text('Nama Kegiatan: Pemberkatan ' +
                                    tiket[0]['jenis']),
                                if (tiket[0]['status'] == 0)
                                  Text(
                                    "Status : Menunggu",
                                  ),
                                if (tiket[0]['status'] == 1)
                                  Text(
                                    "Status : Disetujui",
                                  ),
                                if (tiket[0]['status'] == -1)
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