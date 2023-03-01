import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/messages.dart';

import '../../tiketSaya.dart';

class tiketSayaDetailKrisma {
  var names;
  var idUser;
  var emails;
  var tiketGereja;
  var tiket;
  var namaGereja;
  var idKrisma;
  var idGereja;
  var idUserKrisma;
  var cancelKrisma;
  tiketSayaDetailKrisma(this.names, this.emails, this.idUser, this.idKrisma,
      this.idGereja, this.idUserKrisma);

  Future<List> callDb() async {
    Messages msg = new Messages();
    msg.addReceiver("agenPencarian");
    msg.setContent([
      ["cari Detail Jadwal Krisma"],
      [idKrisma],
      [idGereja]
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

  cancelDaftar(kapasitas, context) async {
    Messages msg = new Messages();
    msg.addReceiver("agenPendaftaran");
    msg.setContent([
      ["cancel Krisma"],
      [idUserKrisma],
      [idKrisma],
      [kapasitas]
    ]);

    await msg.send().then((res) async {
      print("masuk");
      print(await AgenPage().receiverTampilan());
    });
    await Future.delayed(Duration(seconds: 1));
    cancelKrisma = await AgenPage().receiverTampilan();
    if (cancelKrisma == 'oke') {
      Fluttertoast.showToast(
          msg: "Berhasil Cancel Krisma",
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
                                  snapshot.data[0][0][0]['jadwalBuka']
                                      .toString()
                                      .substring(0, 19) +
                                  " s/d " +
                                  snapshot.data[0][0][0]['jadwalTutup']
                                      .toString()
                                      .substring(0, 19)),
                              Text('Nama Gereja: ' +
                                  snapshot.data[1][0][0]['nama']),
                              Text('Alamat Gereja: ' +
                                  snapshot.data[1][0][0]['address']),
                            ],
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                RaisedButton(
                                    child: Text('Batalkan Mendaftar'),
                                    textColor: Colors.white,
                                    color: Colors.blueAccent,
                                    onPressed: () async {
                                      await cancelDaftar(
                                          snapshot.data[0][0][0]['kapasitas'],
                                          context);
                                    }), // button 1
                              ])
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
