import 'dart:async';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/view/homePage.dart';
import 'package:pelayanan_iman_katolik/view/pelayanan/confirmPelayanan.dart';
import 'package:pelayanan_iman_katolik/view/profile/profile.dart';
import 'package:pelayanan_iman_katolik/view/setting/setting.dart';
import 'package:pelayanan_iman_katolik/view/tiketSaya.dart';
import 'package:photo_view/photo_view.dart';

class detailDaftarPelayanan extends StatefulWidget {
  final idGereja;
  final iduser;
  final idPelayanan;
  String jenisPelayanan;
  String jenisSelectedPelayanan;
  String jenisPencarian;
  final idImam;
  @override
  detailDaftarPelayanan(this.iduser, this.jenisPelayanan, this.jenisSelectedPelayanan, this.jenisPencarian, this.idGereja, this.idPelayanan, this.idImam);

  _detailDaftarPelayanan createState() => _detailDaftarPelayanan(this.iduser, this.jenisPelayanan, this.jenisSelectedPelayanan, this.jenisPencarian, this.idGereja, this.idPelayanan, this.idImam);
}

class _detailDaftarPelayanan extends State<detailDaftarPelayanan> {
  final idGereja;
  final idImam;
  final iduser;
  final idPelayanan;
  String jenisPelayanan;
  String jenisSelectedPelayanan;
  String jenisPencarian;
  var hasil;
  _detailDaftarPelayanan(this.iduser, this.jenisPelayanan, this.jenisSelectedPelayanan, this.jenisPencarian, this.idGereja, this.idPelayanan, this.idImam);
///////////////////////Fungsi////////////////////////
  Future callDb() async {
    Completer<void> completer = Completer<void>(); //variabel untuk menunggu
    Messages message;
    if (jenisPelayanan == "Umum") {
      message = Messages('Agent Page', 'Agent Pencarian', "REQUEST", Tasks('cari pelayanan', [jenisPelayanan, jenisPencarian, idPelayanan]));
    } else if (jenisSelectedPelayanan == "Perminyakan" || jenisSelectedPelayanan == "Tobat") {
      message = Messages('Agent Page', 'Agent Pencarian', "REQUEST", Tasks('cari pelayanan', [jenisSelectedPelayanan, jenisPencarian, idImam, idGereja]));
    } else {
      message = Messages('Agent Page', 'Agent Pencarian', "REQUEST", Tasks('cari pelayanan', [jenisSelectedPelayanan, jenisPencarian, idPelayanan, idGereja])); //Pembuatan pesan
    }
    MessagePassing messagePassing = MessagePassing(); //Memanggil distributor pesan
    await messagePassing.sendMessage(message); //Mengirim pesan ke distributor pesan
    hasil = await AgentPage.getData(); //Memanggil data yang tersedia di agen Page
    completer.complete(); //Batas pengerjaan yang memerlukan completer

    await completer.future; //Proses penungguan sudah selesai ketika varibel hasil
    //memiliki nilai
    return await hasil;
  }

  void showDirectionWithFirstMap(coordinates) async {
    final List<AvailableMap> availableMaps = await MapLauncher.installedMaps;
    await availableMaps.first.showDirections(
      destination: coordinates,
    );
  }

  Future pullRefresh() async {
    //Fungsi refresh halaman akan memanggil fungsi callDb
    setState(() {
      //Pemanggilan fungsi secara dinamis agar halaman terupdate secara otomatis
      callDb();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Widget untuk membangun struktur halaman
      //////////////////////////////////////Pembuatan Top Navigation Bar////////////////////////////////////////////////////////////////
      appBar: AppBar(
        // widget Top Navigation Bar
        shape: RoundedRectangleBorder(
          //Bentuk Top Navigation Bar: Rounded Rectangle
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text('Pendaftaran ' + jenisSelectedPelayanan),
        actions: <Widget>[
          //Tombol Top Navigation Bar
          IconButton(
            //Widget icon profile
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              //Jika ditekan akan mengarahkan ke halaman profile
              Navigator.push(
                //Widget navigator untuk memanggil kelas profile
                context,
                MaterialPageRoute(builder: (context) => profile(iduser)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => setting(iduser)),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
          //Widget untuk refresh body halaman
          onRefresh: pullRefresh,
          //Ketika halaman direfresh akan memanggil fungsi pullRefresh
          child: Column(
            children: [
              FutureBuilder(
                  future: callDb(),
                  builder: (context, AsyncSnapshot snapshot) {
                    //Pemanggilan fungsi, untuk mendapatkan data
                    //yang dibutuhkan oleh tampilan halaman
                    try {
                      if (jenisPelayanan == "Umum") {
                        return ListView(
                          //Struktur halaman akan dibuat list
                          //agar halaman bisa di scroll kebawah
                          shrinkWrap: true,
                          padding: EdgeInsets.all(20.0),
                          children: <Widget>[
                            /////////
                            ///

                            Center(
                                child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                ),
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomCenter, colors: [
                                            Colors.blueAccent,
                                            Colors.lightBlue,
                                          ]),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(0.0, 1.0), //(x,y)
                                              blurRadius: 6.0,
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          width: 350.0,
                                          height: 450.0,
                                          child: Center(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                if (snapshot.data[0]['picture'] == null)
                                                  CircleAvatar(
                                                    backgroundImage: AssetImage(''),
                                                    backgroundColor: Colors.greenAccent,
                                                    radius: 80.0,
                                                  ),
                                                if (snapshot.data[0]['picture'] != null)
                                                  Container(
                                                      width: 200,
                                                      height: 240,
                                                      child: PhotoView(
                                                        imageProvider: NetworkImage(snapshot.data[0]['picture']),
                                                      )),
                                                Text(
                                                  snapshot.data[0]['namaKegiatan'],
                                                  style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.w300),
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30.0),
                                                  ),
                                                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                                                  clipBehavior: Clip.antiAlias,
                                                  color: Colors.white,
                                                  elevation: 20.0,
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 22.0),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Column(
                                                            children: <Widget>[
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisSize: MainAxisSize.max,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Text(
                                                                    "Tema Kegiatan: ",
                                                                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                                  ),
                                                                  Text(
                                                                    snapshot.data[0]['temaKegiatan'] as String,
                                                                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                //Untuk memberi jarak
                                                                //antar widget
                                                                height: 8.0,
                                                              ),
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisSize: MainAxisSize.max,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Text(
                                                                    "Lokasi: ",
                                                                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                                  ),
                                                                  Text(
                                                                    snapshot.data[0]['lokasi'],
                                                                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                //Untuk memberi jarak
                                                                //antar widget
                                                                height: 8.0,
                                                              ),
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisSize: MainAxisSize.max,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Text(
                                                                    "Kapasitas: ",
                                                                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                                  ),
                                                                  Text(
                                                                    snapshot.data[0]['kapasitas'].toString(),
                                                                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                //Untuk memberi jarak
                                                                //antar widget
                                                                height: 8.0,
                                                              ),
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisSize: MainAxisSize.max,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Text(
                                                                    "Tanggal: ",
                                                                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                                  ),
                                                                  Text(
                                                                    snapshot.data[0]['tanggal'].toString().substring(0, 19),
                                                                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                //Untuk memberi jarak
                                                                //antar widget
                                                                height: 8.0,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ))),
                                SizedBox(
                                  height: 20.0,
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                RaisedButton(
                                    //Widget yang membuat tombol, pada widget ini
                                    //tombol memiliki aksi jika ditekan (onPressed),
                                    //dan memiliki dekorasi seperti(warna,child yang
                                    //berupa widgetText, dan bentuk tombol)
                                    onPressed: () async {
                                      confirmPelayanan(
                                        iduser,
                                        jenisPelayanan,
                                        jenisSelectedPelayanan,
                                        jenisPencarian,
                                        null,
                                        snapshot.data[0]['_id'],
                                      ).showDialogBox(context);
                                    },
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                    elevation: 0.0,
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.topLeft, colors: [
                                          Colors.blueAccent,
                                          Colors.lightBlue,
                                        ]),
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                      child: Container(
                                        constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Daftar " + jenisSelectedPelayanan,
                                          style: TextStyle(color: Colors.white, fontSize: 26.0, fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                    )),
                              ],
                            )),

                            /////////
                          ],
                        );
                      } else if (jenisSelectedPelayanan == "Tobat" || jenisSelectedPelayanan == "Perminyakan") {
                        return ListView(
                          //Struktur halaman akan dibuat list
                          //agar halaman bisa di scroll kebawah
                          shrinkWrap: true,
                          padding: EdgeInsets.all(20.0),
                          children: <Widget>[
                            Card(
                              //Membuat kartu berbentuk oval
                              //untuk tempat penampilan data
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                              clipBehavior: Clip.antiAlias,
                              color: Colors.white,
                              elevation: 20.0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 22.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      //Menampilkan data aturan pelayanan
                                      child: Column(
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Aturan " + jenisSelectedPelayanan + " Gereja: ",
                                                style: TextStyle(color: Colors.red, fontSize: 15.0, fontWeight: FontWeight.w600),
                                              ),
                                              if (jenisSelectedPelayanan == "Perminyakan")
                                                Text(
                                                  snapshot.data[1][0]['perminyakan'],
                                                  style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                ),
                                              if (jenisSelectedPelayanan == "Tobat")
                                                Text(
                                                  snapshot.data[1][0]['tobat'],
                                                  style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Center(
                                child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                ),
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomCenter, colors: [
                                            Colors.blueAccent,
                                            Colors.lightBlue,
                                          ]),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(0.0, 1.0), //(x,y)
                                              blurRadius: 6.0,
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          width: 350.0,
                                          height: 450.0,
                                          child: Center(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                if (snapshot.data[0][0]['picture'] == null)
                                                  //Jika data tidak mempunyai gambar ditampilkan
                                                  //gambar default
                                                  CircleAvatar(
                                                    backgroundImage: AssetImage(''),
                                                    backgroundColor: Colors.greenAccent,
                                                    radius: 80.0,
                                                  ),
                                                if (snapshot.data[0][0]['picture'] != null)
                                                  //Jika data mempunyai gambar ditampilkan
                                                  //gambar
                                                  CircleAvatar(
                                                    backgroundImage: NetworkImage(snapshot.data[0][0]['picture']),
                                                    backgroundColor: Colors.greenAccent,
                                                    radius: 80.0,
                                                  ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Text(
                                                  snapshot.data[0][0]['nama'],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.w300),
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30.0),
                                                  ),
                                                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                                                  clipBehavior: Clip.antiAlias,
                                                  color: Colors.white,
                                                  elevation: 20.0,
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 22.0),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Column(
                                                            children: <Widget>[
                                                              Text(
                                                                "Email : " + snapshot.data[0][0]['email'],
                                                                style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                              ),
                                                              SizedBox(
                                                                //Untuk memberi jarak
                                                                //antar widget
                                                                height: 10.0,
                                                              ),
                                                              Text(
                                                                "No Telepon : " + snapshot.data[0][0]['notelp'],
                                                                style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                              ),
                                                              SizedBox(
                                                                //Untuk memberi jarak
                                                                //antar widget
                                                                height: 10.0,
                                                              ),
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisSize: MainAxisSize.max,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Text(
                                                                    "Paroki : ",
                                                                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                                  ),
                                                                  Text(
                                                                    snapshot.data[0][0]['GerejaPelayanan'][0]['paroki'] as String,
                                                                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                //Untuk memberi jarak
                                                                //antar widget
                                                                height: 8.0,
                                                              ),
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisSize: MainAxisSize.max,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Text(
                                                                    "Alamat Gereja : ",
                                                                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                                  ),
                                                                  Text(
                                                                    snapshot.data[0][0]['GerejaPelayanan'][0]['address'],
                                                                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                //Untuk memberi jarak
                                                                //antar widget
                                                                height: 8.0,
                                                              ),
                                                              SizedBox(
                                                                //Untuk memberi jarak
                                                                //antar widget
                                                                height: 8.0,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ))),
                                SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            )),

                            /////////
                          ],
                        );
                      } else {
                        return Column(
                          children: <Widget>[
                            Center(
                                child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                ),
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomCenter, colors: [
                                            Colors.blueAccent,
                                            Colors.lightBlue,
                                          ]),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(0.0, 1.0), //(x,y)
                                              blurRadius: 6.0,
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          width: 350.0,
                                          height: 450.0,
                                          child: Center(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                if (snapshot.data[0][0]['GerejaPelayanan'][0]['gambar'] == null)
                                                  CircleAvatar(
                                                    backgroundImage: AssetImage(''),
                                                    backgroundColor: Colors.greenAccent,
                                                    radius: 80.0,
                                                  ),
                                                if (snapshot.data[0][0]['GerejaPelayanan'][0]['gambar'] != null)
                                                  CircleAvatar(
                                                    backgroundImage: NetworkImage(snapshot.data[0][0]['GerejaPelayanan'][0]['gambar']),
                                                    backgroundColor: Colors.greenAccent,
                                                    radius: 80.0,
                                                  ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Text(
                                                  snapshot.data[0][0]['GerejaPelayanan'][0]['nama'],
                                                  style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.w300),
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30.0),
                                                  ),
                                                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                                                  clipBehavior: Clip.antiAlias,
                                                  color: Colors.white,
                                                  elevation: 20.0,
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 22.0),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Column(
                                                            children: <Widget>[
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisSize: MainAxisSize.max,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Text(
                                                                    "Paroki: ",
                                                                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                                  ),
                                                                  Text(
                                                                    snapshot.data[0][0]['GerejaPelayanan'][0]['paroki'] as String,
                                                                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                //Untuk memberi jarak
                                                                //antar widget
                                                                height: 8.0,
                                                              ),
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisSize: MainAxisSize.max,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Text(
                                                                    "Alamat Gereja: ",
                                                                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                                  ),
                                                                  Text(
                                                                    snapshot.data[0][0]['GerejaPelayanan'][0]['address'],
                                                                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                //Untuk memberi jarak
                                                                //antar widget
                                                                height: 8.0,
                                                              ),
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisSize: MainAxisSize.max,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Text(
                                                                    "Kapasitas: ",
                                                                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                                  ),
                                                                  Text(
                                                                    snapshot.data[0][0]['kapasitas'].toString(),
                                                                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                //Untuk memberi jarak
                                                                //antar widget
                                                                height: 8.0,
                                                              ),
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisSize: MainAxisSize.max,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Text(
                                                                    "Jenis: ",
                                                                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                                  ),
                                                                  Text(
                                                                    snapshot.data[0][0]['jenis'],
                                                                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                //Untuk memberi jarak
                                                                //antar widget
                                                                height: 8.0,
                                                              ),
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisSize: MainAxisSize.max,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Text(
                                                                    "Tanggal Pembukaan: ",
                                                                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                                  ),
                                                                  Text(
                                                                    snapshot.data[0][0]['jadwalBuka'].toString().substring(0, 19),
                                                                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                //Untuk memberi jarak
                                                                //antar widget
                                                                height: 8.0,
                                                              ),
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisSize: MainAxisSize.max,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Text(
                                                                    "Tanggal Penutupan: ",
                                                                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                                  ),
                                                                  Text(
                                                                    snapshot.data[0][0]['jadwalTutup'].toString().substring(0, 19),
                                                                    style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ))),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                                  clipBehavior: Clip.antiAlias,
                                  color: Colors.white,
                                  elevation: 20.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 22.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "Aturan " + jenisSelectedPelayanan + " Gereja: ",
                                                    style: TextStyle(color: Colors.red, fontSize: 15.0, fontWeight: FontWeight.w600),
                                                  ),
                                                  if (jenisSelectedPelayanan == "Baptis")
                                                    Text(
                                                      snapshot.data[1][0]['baptis'],
                                                      style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                    ),
                                                  if (jenisSelectedPelayanan == "Komuni")
                                                    Text(
                                                      snapshot.data[1][0]['komuni'],
                                                      style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                    ),
                                                  if (jenisSelectedPelayanan == "Krisma")
                                                    Text(
                                                      snapshot.data[1][0]['krisma'],
                                                      style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                    ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 8.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                RaisedButton(
                                    //Widget yang membuat tombol, pada widget ini
                                    //tombol memiliki aksi jika ditekan (onPressed),
                                    //dan memiliki dekorasi seperti(warna,child yang
                                    //berupa widgetText, dan bentuk tombol)
                                    onPressed: () async {
                                      showDirectionWithFirstMap(Coords(snapshot.data[0][0]['GerejaPelayanan'][0]['lat'], snapshot.data[0][0]['GerejaPelayanan'][0]['lng']));
                                    },
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                    elevation: 0.0,
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.topLeft, colors: [
                                          Colors.blueAccent,
                                          Colors.lightBlue,
                                        ]),
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                      child: Container(
                                        constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Lokasi Gereja",
                                          style: TextStyle(color: Colors.white, fontSize: 26.0, fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                    )),
                                SizedBox(
                                  height: 20.0,
                                ),
                                RaisedButton(
                                    //Widget yang membuat tombol, pada widget ini
                                    //tombol memiliki aksi jika ditekan (onPressed),
                                    //dan memiliki dekorasi seperti(warna,child yang
                                    //berupa widgetText, dan bentuk tombol)
                                    onPressed: () async {
                                      confirmPelayanan(
                                        iduser,
                                        jenisPelayanan,
                                        jenisSelectedPelayanan,
                                        jenisPencarian,
                                        snapshot.data[0][0]['GerejaPelayanan'][0]['_id'],
                                        snapshot.data[0][0]['_id'],
                                      ).showDialogBox(context);
                                    },
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                    elevation: 0.0,
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.topLeft, colors: [
                                          Colors.blueAccent,
                                          Colors.lightBlue,
                                        ]),
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                      child: Container(
                                        constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Daftar " + jenisSelectedPelayanan,
                                          style: TextStyle(color: Colors.white, fontSize: 26.0, fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                    )),
                              ],
                            )),
                            SizedBox(
                              height: 20.0,
                            ),

                            /////////
                          ],
                        );
                      }
                    } catch (e) {
                      //Jika data yang ditampilkan masih menunggu/ salah dalam
                      //pemanggilan data
                      print(e);
                      return Center(child: CircularProgressIndicator());
                    }
                  })
            ],
          )),
//////////////////////////////////////Batas Akhir Pembuatan Body Halaman/////////////////////////////////////////////////////////////
      ///
      ///
      ///
/////////////////////////////////////////////////////////Pembuatan Bottom Navigation Bar////////////////////////////////////////
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          //Dekorasi Kontainer pada Bottom Navigation Bar : posisi, bentuk, dan bayangan.
          child: ClipRRect(
            //Membentuk posisi Bottom Navigation Bar agar bisa dipasangkan menu
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              //Widget untuk membuat tampilan Bottom Navigation Bar
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              unselectedItemColor: Colors.blue,
              //Konfigurasi Bottom Navigation Bar
              items: <BottomNavigationBarItem>[
                //Item yang terdapat pada Bottom Navigation Bar
                //Berisikan icon dan label
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.token, color: Color.fromARGB(255, 0, 0, 0)),
                  label: "Jadwalku",
                )
              ],
              onTap: (index) {
                if (index == 1) {
                  //Jika item kedua ditekan maka akan memanggil kelas tiketSaya
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => tiketSaya(iduser, "current")),
                  );
                } else if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => homePage(iduser)),
                  );
                }
              },
            ),
          )),
    );
  }
}
