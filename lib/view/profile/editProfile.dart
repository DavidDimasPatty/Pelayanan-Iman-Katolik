import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/view/profile/profile.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../homePage.dart';
import '../tiketSaya.dart';

class EditProfile extends StatefulWidget {
  final iduser;

  EditProfile(this.iduser);
  @override
  _EditProfile createState() => _EditProfile(this.iduser);
}

class _EditProfile extends State<EditProfile> {
  final iduser;
  _EditProfile(this.iduser);

  @override
  TextEditingController namaController = new TextEditingController();
  TextEditingController parokiController = new TextEditingController();
  TextEditingController lingkunganController = new TextEditingController();
  TextEditingController notelpController = new TextEditingController();
  TextEditingController alamatController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  Future<List> callDb() async {
    Completer<void> completer = Completer<void>();
    Messages message = Messages(
        'Agent Page', 'Agent Akun', "REQUEST", Tasks('cari user', iduser));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    var hasil = await await AgentPage.getDataPencarian();
    completer.complete();
    await completer.future;
    return hasil;
  }

  submitForm(nama, email, paroki, lingkungan, notelp, alamat, context) async {
    if (namaController.text != "" &&
        emailController.text != "" &&
        parokiController.text != "" &&
        lingkunganController.text != "" &&
        notelpController.text != "" &&
        alamatController.text != "") {
      Completer<void> completer = Completer<void>();
      Messages message = Messages(
          'Agent Page',
          'Agent Akun',
          "REQUEST",
          Tasks('edit profile',
              [iduser, nama, email, paroki, lingkungan, notelp, alamat]));

      MessagePassing messagePassing = MessagePassing();
      var data = await messagePassing.sendMessage(message);
      var hasil = await await AgentPage.getDataPencarian();
      completer.complete();
      if (hasil == 'oke') {
        Fluttertoast.showToast(
            msg: "Berhasil Edit Profile",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Profile(iduser)),
        );
      }
    } else {
      Fluttertoast.showToast(
          msg: "Lengkapi semua bidang",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future pullRefresh() async {
    setState(() {
      callDb();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile(iduser)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
          onRefresh: pullRefresh,
          child: ListView(
            children: <Widget>[
              FutureBuilder<List>(
                  future: callDb(),
                  builder: (context, AsyncSnapshot snapshot) {
                    try {
                      print(snapshot.data);
                      if (snapshot.data[0]['name'] != null) {
                        namaController.text = snapshot.data[0]['name'];
                      }
                      if (snapshot.data[0]['email'] != null) {
                        emailController.text = snapshot.data[0]['email'];
                      }
                      if (snapshot.data[0]['paroki'] != null) {
                        parokiController.text = snapshot.data[0]['paroki'];
                      }
                      if (snapshot.data[0]['lingkungan'] != null) {
                        lingkunganController.text =
                            snapshot.data[0]['lingkungan'];
                      }
                      if (snapshot.data[0]['notelp'] != null) {
                        notelpController.text = snapshot.data[0]['notelp'];
                      }
                      if (snapshot.data[0]['alamat'] != null) {
                        alamatController.text = snapshot.data[0]['alamat'];
                      }
                      return Column(children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 11),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nama Lengkap",
                              textAlign: TextAlign.left,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                            ),
                            TextField(
                              controller: namaController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z ]")),
                              ],
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Masukan Nama Lengkap",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 11),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email",
                              textAlign: TextAlign.left,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                            ),
                            TextField(
                              controller: emailController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Masukan Email",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 11),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Paroki",
                              textAlign: TextAlign.left,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                            ),
                            TextField(
                              controller: parokiController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Masukan Nama Paroki",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 11),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lingkungan",
                              textAlign: TextAlign.left,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                            ),
                            TextField(
                              controller: lingkunganController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Masukan Nama Lingkungan",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 11),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nomor Telephone",
                              textAlign: TextAlign.left,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                            ),
                            TextField(
                              controller: notelpController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]")),
                              ],
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Masukan Nomor Telephone",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 11),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Alamat Lengkap",
                              textAlign: TextAlign.left,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                            ),
                            TextField(
                              controller: alamatController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Masukan Alamat",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 11),
                        ),
                        RaisedButton(
                            onPressed: () async {
                              await submitForm(
                                  namaController.text,
                                  emailController.text,
                                  parokiController.text,
                                  lingkunganController.text,
                                  notelpController.text,
                                  alamatController.text,
                                  context);
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
                                  "Submit Form",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            )),
                        Padding(padding: EdgeInsets.symmetric(vertical: 15))
                      ]);
                    } catch (e) {
                      print(e);
                      return Center(child: CircularProgressIndicator());
                    }
                  })
            ],
          )),
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
                  icon: Icon(Icons.home, color: Color.fromARGB(255, 0, 0, 0)),
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
                    MaterialPageRoute(builder: (context) => tiketSaya(iduser)),
                  );
                } else if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage(iduser)),
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
