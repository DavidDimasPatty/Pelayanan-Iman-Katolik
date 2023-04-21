import 'dart:async';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/view/sakramen/perkawinan/perkawinan.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter/material.dart';

import '../../homePage.dart';
import '../../profile/profile.dart';
import '../../tiketSaya.dart';

class FormulirPerkawinan extends StatefulWidget {
  final iduser;
  final idGereja;
  final idImam;

  FormulirPerkawinan(this.iduser, this.idGereja, this.idImam);
  @override
  _FormulirPerkawinan createState() =>
      _FormulirPerkawinan(this.iduser, this.idGereja, this.idImam);
}

class _FormulirPerkawinan extends State<FormulirPerkawinan> {
  final iduser;
  final idGereja;
  final idImam;
  var ready = false;
  _FormulirPerkawinan(this.iduser, this.idGereja, this.idImam);

  @override
  TextEditingController namaPriaController = new TextEditingController();
  TextEditingController namaWanitaController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController notelpController = new TextEditingController();
  TextEditingController alamatController = new TextEditingController();
  TextEditingController noteController = new TextEditingController();
  String _selectedDate = '';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _selectedDate = args.value.toString();
    });
  }

  Future<List> callDb() async {
    Completer<void> completer = Completer<void>();
    Messages message = Messages('Agent Page', 'Agent Pencarian', "REQUEST",
        Tasks('cari pelayanan', ["perkawinan", "detail", idGereja]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    var hasil = await await AgentPage.getData();
    completer.complete();

    await completer.future;
    return await hasil;
  }

  void submitForm(
      namap, namaw, notelp, alamat, email, note, tanggal, context) async {
    if (namaPriaController.text != "" &&
        namaWanitaController.text != "" &&
        emailController.text != "" &&
        notelpController.text != "" &&
        alamatController.text != "" &&
        _selectedDate != "" &&
        noteController.text != "") {
      Completer<void> completer = Completer<void>();
      Messages message = Messages(
          'Agent Page',
          'Agent Pendaftaran',
          "REQUEST",
          Tasks('enroll pelayanan', [
            "perkawinan",
            iduser,
            namap,
            namaw,
            notelp,
            alamat,
            email,
            tanggal,
            note,
            idGereja,
            idImam
          ]));

      MessagePassing messagePassing = MessagePassing();
      var data = await messagePassing.sendMessage(message);
      var hasil = await await AgentPage.getData();
      completer.complete();

      await completer.future;
      if (hasil == 'oke') {
        Fluttertoast.showToast(
            msg: "Berhasil Mendaftar Perkawinan",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(
          context,
          MaterialPageRoute(builder: (context) => Perkawinan(iduser)),
        );
      }
    } else {
      Fluttertoast.showToast(
          msg: "Lengkapi semua isi form",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulir Perkawinan'),
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
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(right: 15, left: 15),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 11),
          ),
          FutureBuilder<List>(
              future: callDb(),
              builder: (context, AsyncSnapshot snapshot) {
                try {
                  return Column(
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.white,
                        elevation: 20.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7.0, vertical: 22.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Aturan Perkawinan Gereja: ",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          snapshot.data[0]['perkawinan'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w300),
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
                        height: 30.0,
                      ),

                      /////////
                    ],
                  );
                } catch (e) {
                  print(e);
                  return Center(child: CircularProgressIndicator());
                }
              }),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nama Lengkap Pria",
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
              ),
              TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                ],
                controller: namaPriaController,
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
                    hintText: "Masukan Nama Lengkap Pria",
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
                "Nama Lengkap Wanita",
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
              ),
              TextField(
                controller: namaWanitaController,
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
                    hintText: "Masukan Nama Lengkap Wanita",
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
                "Nomor Telepon yang bisa dihubungi",
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
              ),
              TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
                controller: notelpController,
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
                    hintText: "Masukan Nomor Telepon",
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
                "Email yang digunakan",
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
                "Alamat Acara Pernikahan",
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
                    hintText: "Masukan Alamat Pernikahan",
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
                "Tanggal",
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
              ),
              SfDateRangePicker(
                view: DateRangePickerView.month,
                onSelectionChanged: _onSelectionChanged,
                monthViewSettings:
                    DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
              )
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
                "Note Tambahan",
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
              ),
              TextField(
                controller: noteController,
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
                    hintText: "Masukan Notes",
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
                submitForm(
                    namaPriaController.text,
                    namaWanitaController.text,
                    notelpController.text,
                    alamatController.text,
                    emailController.text,
                    noteController.text,
                    _selectedDate,
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
                      maxWidth: double.maxFinite, minHeight: 50.0),
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
          ),
        ],
      ),
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
