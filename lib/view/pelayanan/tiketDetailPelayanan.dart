import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/view/tiketSaya.dart';

class tiketSayaDetailPelayanan {
  var iduser;
  var idPelayanan;
  var idGereja;
  var idUserPelayanan;
  String jenisSelectedPelayanan;
  String jenisPencarian;
  tiketSayaDetailPelayanan(
      this.iduser,
      this.idGereja,
      this.jenisSelectedPelayanan,
      this.jenisPencarian,
      this.idPelayanan,
      this.idUserPelayanan);

///////////////////////Fungsi////////////////////////
  Future callDb() async {
    Completer<void> completer = Completer<void>(); //variabel untuk menunggu
    Messages message = Messages(
        'Agent Page',
        'Agent Pencarian',
        "REQUEST",
        Tasks('cari pelayanan', [
          jenisSelectedPelayanan,
          jenisPencarian,
          idPelayanan,
          idGereja
        ])); //Pembuatan pesan

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
        Tasks('cancel pelayanan', [
          jenisSelectedPelayanan,
          idUserPelayanan,
          idPelayanan,
          kapasitas,
          iduser
        ])); //Pembuatan pesan

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
    //Pembuatan dialog box dan pemanggilan data
    //yang dibutuhkan pada dialog box
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
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              _getCloseButton(
                                  context), //Menampilkan tombol close dialog box
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
                          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                          RaisedButton(
                              //Widget yang membuat tombol, pada widget ini
                              //tombol memiliki aksi jika ditekan (onPressed),
                              //dan memiliki dekorasi seperti(warna,child yang
                              //berupa widgetText, dan bentuk tombol)
                              onPressed: () async {
                                cancelDaftar(
                                    snapshot.data[0][0]['kapasitas'], context);
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
