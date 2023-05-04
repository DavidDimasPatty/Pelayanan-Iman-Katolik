import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';

import '../../tiketSaya.dart';

class tiketSayaBaptisHistory {
  var iduser;
  var idBaptis;
  var idGereja;
  var idUserBaptis;
  tiketSayaBaptisHistory(
      this.iduser, this.idGereja, this.idBaptis, this.idUserBaptis);

  ///////////////////////Fungsi////////////////////////
  ///////////////////////Fungsi////////////////////////
  Future callDb() async {
    Completer<void> completer = Completer<void>(); //variabel untuk menunggu
    Messages message = Messages(
        'Agent Page',
        'Agent Pencarian',
        "REQUEST",
        Tasks('cari pelayanan',
            ["baptis", "detail", idBaptis, idGereja])); //Pembuatan pesan

    MessagePassing messagePassing =
        MessagePassing(); //Memanggil distributor pesan
    await messagePassing
        .sendMessage(message); //Mengirim pesan ke distributor pesan
    var hasil =
        await AgentPage.getData(); //Memanggil data yang tersedia di agen Page
    completer.complete(); //Batas pengerjaan yang memerlukan completer

    await completer
        .future; //Proses penungguan sudah selesai ketika varibel hasil
    //memiliki nilai
    return await hasil;
  }

  cancelDaftar(kapasitas, context) async {
    Completer<void> completer = Completer<void>(); //variabel untuk menunggu
    Messages message = Messages(
        'Agent Page',
        'Agent Pendaftaran',
        "REQUEST",
        Tasks('cancel pelayanan',
            ["baptis", idUserBaptis, idBaptis, kapasitas])); //Pembuatan pesan

    MessagePassing messagePassing =
        MessagePassing(); //Memanggil distributor pesan
    await messagePassing
        .sendMessage(message); //Mengirim pesan ke distributor pesan
    var hasil =
        await AgentPage.getData(); //Memanggil data yang tersedia di agen Page
    completer.complete(); //Batas pengerjaan yang memerlukan completer

    await completer
        .future; //Proses penungguan sudah selesai ketika varibel hasil
    //memiliki nilai

    if (hasil == 'oke') {
      Fluttertoast.showToast(
          /////// Widget toast untuk menampilkan pesan pada halaman
          msg: "Berhasil Cancel Baptis",
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
    // await callInfoGereja(idGereja);
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
                                  snapshot.data[0][0]['GerejaBaptis'][0]
                                      ['nama']),
                              Text('Alamat Gereja: ' +
                                  snapshot.data[0][0]['GerejaBaptis'][0]
                                      ['address']),
                            ],
                          ),
                        ]);
                  } catch (e) {
                    //Jika terdapat salah penunjukan key pada map saat
                    //pengambilan data
                    //mengembalikan widget loading
                    print(e);
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          );
        });
  }
}
