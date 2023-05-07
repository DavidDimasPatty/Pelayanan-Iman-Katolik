import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/view/sakramen/komuni/detailDaftarKomuni.dart';

class confirmKomuni {
  final idGereja;
  final iduser;
  final idKomuni;
  var hasil;
  confirmKomuni(this.iduser, this.idGereja, this.idKomuni);

  ///////////////////////Fungsi////////////////////////
  Future callDb() async {
    Completer<void> completer = Completer<void>(); //variabel untuk menunggu
    Messages message = Messages(
        'Agent Page',
        'Agent Pencarian',
        "REQUEST",
        Tasks('cari pelayanan',
            ["komuni", "detail", idKomuni, idGereja])); //Pembuatan pesan

    MessagePassing messagePassing =
        MessagePassing(); //Memanggil distributor pesan
    await messagePassing
        .sendMessage(message); //Mengirim pesan ke distributor pesan
    hasil =
        await AgentPage.getData(); //Memanggil data yang tersedia di agen Page
    completer.complete(); //Batas pengerjaan yang memerlukan completer

    await completer
        .future; //Proses penungguan sudah selesai ketika varibel hasil
    //memiliki nilai
    return await hasil;
  }

  Future daftar(idKomuni, idUser, kapasitas, context) async {
    Completer<void> completer = Completer<void>(); //variabel untuk menunggu
    Messages message = Messages(
        'Agent Page',
        'Agent Pencarian',
        "REQUEST",
        Tasks('check pendaftaran',
            ["komuni", idKomuni, idUser, kapasitas])); //Pembuatan pesan

    MessagePassing messagePassing =
        MessagePassing(); //Memanggil distributor pesan
    await messagePassing
        .sendMessage(message); //Mengirim pesan ke distributor pesan
    var hasilDaftar =
        await AgentPage.getData(); //Memanggil data yang tersedia di agen Page

    completer.complete(); //Batas pengerjaan yang memerlukan completer

    await completer
        .future; //Proses penungguan sudah selesai ketika varibel hasil
    //memiliki nilai

    if (hasilDaftar == 'oke') {
      Fluttertoast.showToast(
          /////// Widget toast untuk menampilkan pesan pada halaman
          msg: "Berhasil Mendaftar Komuni",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(
        context,
        MaterialPageRoute(
            builder: (context) =>
                detailDaftarKomuni(idGereja, idUser, idKomuni)),
      );
    }
    if (hasilDaftar == 'sudah') {
      Fluttertoast.showToast(
          /////// Widget toast untuk menampilkan pesan pada halaman
          msg: "Sudah Mendaftar Komuni ini",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
          /////Konfigurasi widget toast, untuk toast ini dibuat konfigurasi error
          );
      Navigator.pop(
        context,
        MaterialPageRoute(
            builder: (context) =>
                detailDaftarKomuni(idGereja, idUser, idKomuni)),
      );
    }
  }

  void showDialogBox(BuildContext context) async {
    //Pembuatan dialog box dan pemanggilan data
    //yang dibutuhkan pada dialog box
    await callDb();
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              alignment: Alignment.center,
              title: Text("Konfirmasi Pendaftaran"),
              content: FutureBuilder(
                  future: callDb(),
                  builder: (context, AsyncSnapshot snapshot) {
                    //Pemanggilan fungsi, untuk mendapatkan data
                    //yang dibutuhkan oleh tampilan halaman
                    try {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                    "Konfirmasi Pendaftaran Komuni \n Pada Gereja " +
                                        hasil[0][0]['GerejaKomuni'][0]['nama'] +
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
                      //Jika data yang ditampilkan masih menunggu/ salah dalam
                      //pemanggilan data
                      print(e);
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
              actions: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                          //Widget yang membuat tombol, pada widget ini
                          //tombol memiliki aksi jika ditekan (onPressed),
                          //dan memiliki dekorasi seperti(warna,child yang
                          //berupa widgetText, dan bentuk tombol)
                          child: Text('Confirm'),
                          textColor: Colors.white,
                          color: Colors.blueAccent,
                          onPressed: () async {
                            await daftar(idKomuni, iduser,
                                hasil[0][0]['kapasitas'], context);
                          }),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                      RaisedButton(
                          //Widget yang membuat tombol, pada widget ini
                          //tombol memiliki aksi jika ditekan (onPressed),
                          //dan memiliki dekorasi seperti(warna,child yang
                          //berupa widgetText, dan bentuk tombol)
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
