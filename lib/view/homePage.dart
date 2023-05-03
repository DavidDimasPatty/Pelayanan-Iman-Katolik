import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/main.dart';
import 'package:pelayanan_iman_katolik/view/logIn.dart';
import 'package:pelayanan_iman_katolik/view/pengumuman/detailPengumuman.dart';
import 'package:pelayanan_iman_katolik/view/pengumuman/pengumuman.dart';
import 'package:pelayanan_iman_katolik/view/profile/profile.dart';
import 'package:pelayanan_iman_katolik/view/sakramen/sakramen.dart';
import 'package:pelayanan_iman_katolik/view/sakramentali/sakramentali.dart';
import 'package:pelayanan_iman_katolik/view/settings/setting.dart';
import 'package:pelayanan_iman_katolik/view/tiketSaya.dart';
import 'package:pelayanan_iman_katolik/view/umum/umum.dart';

import '../ItemCard.dart';

// Future<void> openCamera() async {
//   //fuction openCamera();
//   final pickedImage = await ImagePicker().getImage(source: ImageSource.camera);
// }

class homePage extends StatefulWidget {
  var iduser;
  @override
  homePage(this.iduser);

  _homePage createState() => _homePage(this.iduser);
}

class _homePage extends State<homePage> {
  var iduser;

  // int indexCaption = -1;
  List hasil = [];
  List<String> cardList = [];

  List<String> caption = [];

  List idImage = [];

  Future callTampilan() async {
    //Pengiriman pesan untuk mendapatkan data yang diperlukan
    //untuk tampilan halaman home
    Completer<void> completer = Completer<void>(); //variabel untuk menunggu
    Messages message = Messages('Agent Page', 'Agent Akun', "REQUEST",
        Tasks('cari tampilan home', iduser)); //Pembuatan pesan

    MessagePassing messagePassing =
        MessagePassing(); //Memanggil distributor pesan
    await messagePassing
        .sendMessage(message); //Mengirim pesan ke distributor pesan
    var hasil =
        await AgentPage.getData(); //Memanggil data yang tersedia di agen Page
    completer
        .complete(); //Pengiriman pesan sudah berhasil, tapi masih harus menunggu

    await completer
        .future; //Proses penungguan sudah selesai ketika varibel hasil
    //memiliki nilai
    return hasil; //Mengembalikan variabel hasil
  }

  Future LogOut(context) async {
    Completer<void> completer = Completer<void>(); //variabel untuk menunggu
    Messages message = Messages('Agent Page', 'Agent Akun', "REQUEST",
        Tasks('log out', iduser)); //Pembuatan pesan

    MessagePassing messagePassing =
        MessagePassing(); //Memanggil distributor pesan
    await messagePassing
        .sendMessage(message); //Mengirim pesan ke distributor pesan
    var hasil =
        await AgentPage.getData(); //Memanggil data yang tersedia di agen Page
    completer
        .complete(); //Pengiriman pesan sudah berhasil, tapi masih harus menunggu

    await completer
        .future; //Proses penungguan sudah selesai ketika varibel hasil
    //memiliki nilai
    if (hasil == 'oke') {
      Fluttertoast.showToast(
          msg: "Akun anda telah dibanned",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => logIn()),
      );
    }
  }

  Future pullRefresh() async {
    //Fungsi refresh halaman akan memanggil fungsi callDb
    setState(() {
      //Pemanggilan fungsi secara dinamis agar halaman terupdate secara otomatis
      callTampilan();
    });
  }

  _homePage(this.iduser);
  @override
  Widget build(BuildContext context) {
    //Fungsi untuk membangun halaman home
    return Scaffold(
      // Widget untuk membangun struktur halaman
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Selamat Datang!'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              Navigator.push(
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
                MaterialPageRoute(builder: (context) => Settings(iduser)),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
          onRefresh: pullRefresh,
          child: ListView(children: <Widget>[
            Center(
                child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                ),
                FutureBuilder(
                    future: callTampilan(),
                    builder: (context, AsyncSnapshot snapshot) {
                      try {
                        if (snapshot.data[0][0]['banned'] == 1) {
                          LogOut(context);
                        }

                        for (var i = 0; i < snapshot.data[3].length; i++) {
                          cardList.add(snapshot.data[3][i]['gambar']);
                          caption.add(snapshot.data[3][i]['title']);
                          idImage.add(snapshot.data[3][i]['_id']);
                        }
                        return Column(children: [
                          Card(
                              elevation: 20,
                              color: Colors.lightBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: SizedBox(
                                  width: 300,
                                  height: 190,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    profile(iduser)),
                                          );
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4),
                                            ),
                                            if (snapshot.data[0][0]
                                                    ['picture'] ==
                                                null)
                                              CircleAvatar(
                                                backgroundImage: AssetImage(''),
                                                backgroundColor:
                                                    Colors.greenAccent,
                                                radius: 35,
                                              ),
                                            if (snapshot.data[0][0]
                                                    ['picture'] !=
                                                null)
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    snapshot.data[0][0]
                                                        ['picture']),
                                                backgroundColor:
                                                    Colors.greenAccent,
                                                radius: 35,
                                              ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                            ),
                                            Column(
                                              children: <Widget>[
                                                Text(
                                                  snapshot.data[0][0]['nama'],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 22.0,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                Text(
                                                  snapshot.data[0][0]['email'],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  snapshot.data[0][0]['paroki'],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  snapshot.data[0][0]
                                                      ['lingkungan'],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 7),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      tiketSaya(iduser)),
                                            );
                                          },
                                          child: Container(
                                            height: 80,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.indigo[100],
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                bottom: Radius.circular(20),
                                                top: Radius.circular(0),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 4),
                                                ),
                                                Text(
                                                  'Jadwal Terdekat:',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                if (snapshot.data[2] == null)
                                                  Text(
                                                    'Belum ada Pendaftaran',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                if (snapshot.data[2] != null)
                                                  Column(children: <Widget>[
                                                    if (snapshot.data[2][0]
                                                            ['idKrisma'] !=
                                                        null)
                                                      Text(
                                                        'Krisma',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                    if (snapshot.data[2][0]
                                                            ['idKomuni'] !=
                                                        null)
                                                      Text(
                                                        'Komuni',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                    if (snapshot.data[2][0]
                                                            ['idBaptis'] !=
                                                        null)
                                                      Text(
                                                        'Baptis',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                    if (snapshot.data[2][0]
                                                            ['idKegiatan'] !=
                                                        null)
                                                      Text(
                                                        'Kegiatan Umum',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                    if (snapshot.data[2][0]
                                                            ['namaLengkap'] !=
                                                        null)
                                                      Text(
                                                        'Pemberkatan',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                    if (snapshot.data[2][0]
                                                            ['namaPria'] !=
                                                        null)
                                                      Text(
                                                        'Perkawinan',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                    if (snapshot.data[2][0]
                                                            ['tanggalDaftar'] !=
                                                        null)
                                                      Text(
                                                        snapshot.data[2][0][
                                                                'tanggalDaftar']
                                                            .toString()
                                                            .substring(0, 19),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                    if (snapshot.data[2][0]
                                                                ['tanggal'] !=
                                                            null &&
                                                        snapshot.data[2][0]
                                                                ['idImam'] !=
                                                            null)
                                                      Text(
                                                        snapshot.data[2][0]
                                                                ['tanggal']
                                                            .toString()
                                                            .substring(0, 19),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                  ])
                                              ],
                                            ),
                                          )),
                                    ],
                                  ))),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                          ),
                          Text(
                            'Pilihan Layanan Menu',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 10),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox.fromSize(
                                size: Size(75, 75), // button width and height
                                child: ClipOval(
                                  child: Material(
                                    color:
                                        Colors.lightBlueAccent, // button color
                                    child: InkWell(
                                      splashColor: Colors.green, // splash color
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Sakramen(iduser)),
                                        );
                                      }, // button pressed
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.settings_accessibility,
                                              size: 30), // icon
                                          Text(
                                            "Sakramen",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ), // text
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 11),
                              ),
                              SizedBox.fromSize(
                                size: Size(75, 75), // button width and height
                                child: ClipOval(
                                  child: Material(
                                    color: Colors.greenAccent, // button color
                                    child: InkWell(
                                      splashColor: Colors.green, // splash color
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  sakramentali(iduser)),
                                        );
                                      }, // button pressed
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.sign_language,
                                              size: 30), // icon
                                          Text(
                                            "sakramentali",
                                            style: TextStyle(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ), // text
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 11),
                              ),
                              SizedBox.fromSize(
                                size: Size(75, 75), // button width and height
                                child: ClipOval(
                                  child: Material(
                                    color: Colors.orange, // button color
                                    child: InkWell(
                                      splashColor: Colors.green, // splash color
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Umum(iduser)),
                                        );
                                      }, // button pressed
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.church,
                                            size: 30,
                                          ), // icon
                                          Text(
                                            "Umum",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ), // text
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 11),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 7),
                          ),
                          new GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          pengumuman(this.iduser)),
                                );
                              },
                              child: Text(
                                "pengumuman",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                          ),
                          Container(
                            child: Center(
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 3),
                                  autoPlayAnimationDuration:
                                      Duration(milliseconds: 800),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  pauseAutoPlayOnTouch: true,
                                  enlargeCenterPage: true,
                                  viewportFraction: 0.8,
                                ),
                                items: cardList.map((item) {
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  detailPengumuman(
                                                      iduser,
                                                      idImage[cardList
                                                          .indexOf(item)])),
                                        );
                                      },
                                      child: ItemCard(
                                          images: item.toString(),
                                          captions:
                                              caption[cardList.indexOf(item)]
                                                  .toString()));
                                }).toList(),
                              ),
                            ),
                          )
                        ]);
                      } catch (e) {
                        print(e);
                        return Center(child: CircularProgressIndicator());
                      }
                    }),
              ],
            ))
          ])),
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              unselectedItemColor: Colors.blue,
              items: <BottomNavigationBarItem>[
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => tiketSaya(this.iduser)),
                  );
                } else if (index == 0) {}
              },
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
