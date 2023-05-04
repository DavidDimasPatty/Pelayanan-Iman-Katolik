import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/view/profile/editProfile.dart';
import 'package:pelayanan_iman_katolik/view/profile/history.dart';
import '../homePage.dart';
import '../settings/setting.dart';
import '../tiketSaya.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class profile extends StatefulWidget {
  final iduser;
  profile(this.iduser);

  _profile createState() => _profile(this.iduser);
}

class _profile extends State<profile> {
  final iduser;

  Future selectFile(context) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    File file;
    final path = result.files.single.path;
    file = File(path!);
    uploadFile(file, context);
  }

  ///////////////////////Fungsi////////////////////////
  Future callDb() async {
    Completer<void> completer = Completer<void>(); //variabel untuk menunggu
    Messages message = Messages('Agent Page', 'Agent Akun', "REQUEST",
        Tasks('cari profile', iduser)); //Pembuatan pesan

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

  Future uploadFile(File file, context) async {
    Completer<void> completer = Completer<void>(); //variabel untuk menunggu
    Messages message = Messages('Agent Page', 'Agent Akun', "REQUEST",
        Tasks('change profile picture', [iduser, file])); //Pembuatan pesan

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
          msg: "Berhasil Ganti Profile Picture",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => profile(iduser)),
      );
    }
    if (hasilDaftar == 'failed') {
      Fluttertoast.showToast(
          /////// Widget toast untuk menampilkan pesan pada halaman
          msg: "Gagal Ganti Profile Picture",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
          /////Konfigurasi widget toast, untuk toast ini dibuat konfigurasi error
          );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => profile(iduser)),
      );
    }
  }

  _profile(this.iduser);
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
        title: const Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {},
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
          //Widget untuk refresh body halaman
          onRefresh: pullRefresh,
          //Ketika halaman direfresh akan memanggil fungsi pullRefresh
          child: ListView(
            children: <Widget>[
              FutureBuilder(
                  future: callDb(),
                  builder: (context, AsyncSnapshot snapshot) {
                    try {
                      return Column(children: <Widget>[
                        Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                        Column(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 10)),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomCenter,
                                          colors: [
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
                                      height: 350.0,
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            if (snapshot.data[0][0]
                                                    ['picture'] ==
                                                null)
                                              CircleAvatar(
                                                backgroundImage: AssetImage(''),
                                                backgroundColor:
                                                    Colors.greenAccent,
                                                radius: 80.0,
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
                                                radius: 80.0,
                                              ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Text(
                                              snapshot.data[0][0]['nama'],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24.0,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 20.0,
                                                  vertical: 5.0),
                                              clipBehavior: Clip.antiAlias,
                                              color: Colors.white,
                                              elevation: 20.0,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 7.0,
                                                        vertical: 22.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Column(
                                                        children: <Widget>[
                                                          Text(
                                                            "Kunjungan Gereja Terdaftar :",
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .redAccent,
                                                              fontSize: 20.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          if (snapshot
                                                                  .data[1] ==
                                                              null)
                                                            Text(
                                                              "0",
                                                              style: TextStyle(
                                                                fontSize: 20.0,
                                                                color: Colors
                                                                    .pinkAccent,
                                                              ),
                                                            ),
                                                          if (snapshot
                                                                  .data[1] !=
                                                              null)
                                                            Text(
                                                              snapshot.data[1]
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 20.0,
                                                                color: Colors
                                                                    .pinkAccent,
                                                              ),
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
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                            ),
                            Container(
                              width: 350.0,
                              height: 350.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.grey,
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
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 35.0, horizontal: 16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "User Information:",
                                      style: TextStyle(
                                          color: Colors.pinkAccent,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 18.0),
                                    ),
                                    SizedBox(
                                      height: 18.0,
                                    ),

                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "Email: ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 2.0,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data[0][0]['email'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 2.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 12),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "Alamat: ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 2.0,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data[0][0]['alamat'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 2.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 12),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "Paroki: ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 2.0,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data[0][0]['paroki'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 2.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 12),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "Lingkungan: ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 2.0,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data[0][0]['lingkungan'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 2.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 12),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "Nomor Telepon: ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 2.0,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data[0][0]['notelp'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 2.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Text(
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 12),
                            ),
                            Container(
                              width: 300.00,
                              child: RaisedButton(
                                  onPressed: () async {
                                    await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);
                                    await selectFile(context);
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(80.0)),
                                  elevation: 0.0,
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
                                          maxWidth: 300.0, minHeight: 50.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Change Profile Picture",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 26.0,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  )),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 10)),
                            Container(
                              width: 300.00,
                              child: RaisedButton(
                                  onPressed: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              editProfile(iduser)),
                                    );
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(80.0)),
                                  elevation: 0.0,
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
                                          maxWidth: 300.0, minHeight: 50.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Edit Profile",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 26.0,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  )),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 10)),
                            Container(
                              width: 300.00,
                              child: RaisedButton(
                                  onPressed: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              history(iduser)),
                                    );
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(80.0)),
                                  elevation: 0.0,
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
                                          maxWidth: 300.0, minHeight: 50.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "History Pendaftaran",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 26.0,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  )),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 25)),
                          ],
                        )
                      ]);
                    } catch (e) {
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
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
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
                    MaterialPageRoute(builder: (context) => tiketSaya(iduser)),
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
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: new FloatingActionButton(
      //   onPressed: () {
      //     openCamera();
      //   },
      //   tooltip: 'Increment',
      //   child: new Icon(Icons.camera_alt_rounded),
      // ),
    );
  }
}
