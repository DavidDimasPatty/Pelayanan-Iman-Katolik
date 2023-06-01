import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/FadeAnimation.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pelayanan_iman_katolik/view/forgetPassword.dart';
import 'package:pelayanan_iman_katolik/view/homePage.dart';
import 'package:pelayanan_iman_katolik/view/signUp.dart';

class logIn extends StatelessWidget {
  ////////Inisialisasi variabel untuk mengkontrol input field//////////////
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  //////////////////////////////////////////////////////////////////////////

  Future logInCheck(id, password) async {
    ///Fungsi pengiriman pesan untuk melakukan pengecekan kepada input field
    ///pegguna dan melakukan pengecekan pada collection user
    ///
    Completer<void> completer = Completer<void>(); //variabel untuk menunggu
    Messages message = Messages('Agent Page', 'Agent Akun', "REQUEST", Tasks('login', [id, password])); //Pembuatan pesan

    MessagePassing messagePassing = MessagePassing(); //Memanggil distributor pesan
    await messagePassing.sendMessage(message); //Mengirim pesan ke distributor pesan
    var hasil = await agenPage.getData(); //Memanggil data yang tersedia di agen Page
    completer.complete(); //Batas pengerjaan yang memerlukan completer
    await completer.future; //Proses penungguan sudah selesai ketika varibel hasil
    //memiliki nilai
    return await hasil;
  }

  @override
  Widget build(BuildContext context) {
    //Fungsi untuk membangun halaman login
    return Scaffold(
        // Widget untuk membangun struktur halaman
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          //Widget SingleChildScrollView digunakan agar halaman login bisa discroll
          child: Container(
            child: Column(
              //Widget Column digunakan untuk tempat widget berada pada children
              children: <Widget>[
                Container(
                  //Container digunakan untuk tempat dekorasi halaman login
                  height: 400,
                  decoration: BoxDecoration(
                      //Background halaman login
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/pelayananimankatolik.appspot.com/o/imageedit_2_4702386825.png?alt=media&token=53776f41-1d60-4057-adeb-899f82d0ae67'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    //Widget Stack agar widget saling bertumpuk satu sama lain
                    //khususnya dengan background halaman login
                    children: <Widget>[
                      Positioned(
                        //Widget Positioned untuk memposisikan gambar pada halaman login
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeAnimation(
                            //Animasi  untuk widget
                            1,
                            Container(
                              //Gambar akan dibungkus dengan container
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://firebasestorage.googleapis.com/v0/b/pelayananimankatolik.appspot.com/o/light-1.png?alt=media&token=0d0ab37a-ebca-4259-881c-dd4e1ba844bd'))),
                            )),
                      ),
                      Positioned(
                        //Widget Positioned untuk memposisikan gambar pada halaman login
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(
                            //Animasi  untuk widget
                            1.3,
                            Container(
                              //Gambar akan dibungkus dengan container
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://firebasestorage.googleapis.com/v0/b/pelayananimankatolik.appspot.com/o/light-2.png?alt=media&token=fe4a055f-63fe-4d76-afb8-8fae5d353cdb'))),
                            )),
                      ),
                      Positioned(
                        //Widget Positioned untuk memposisikan gambar pada halaman login
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(
                            //Animasi untuk widget
                            1.5,
                            Container(
                              //Gambar akan dibungkus dengan container
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://firebasestorage.googleapis.com/v0/b/pelayananimankatolik.appspot.com/o/clock.png?alt=media&token=d1a161d5-ca29-4d5c-9a4d-e8a02f26cb09'))),
                            )),
                      ),
                      Positioned(
                        //Widget Positioned untuk memposisikan gambar pada halaman login
                        child: FadeAnimation(
                          //Animasi untuk widget
                          1.6,
                          Container(
                            //Kontainer berisi text pada halaman login
                            margin: EdgeInsets.only(top: 85),
                            child: Center(
                              child: Text(
                                'Halo, Umat Katolik!',
                                style: GoogleFonts.davidLibre(
                                  textStyle: TextStyle(fontSize: 30, color: Colors.white, letterSpacing: .5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  //Padding tempat untuk input field
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    //Input field akan dibungkus dengan kolom agar
                    //tampilan input field kebawah
                    children: <Widget>[
///////////////////////////////////////////Pembuatan Input Field///////////////////////////////////////////////////////////////////////////////
                      ///Setiap Input Field akan dianimasikan oleh
                      ///dari itu menggunakan widget FadeAnimation,
                      ///dimana memiliki parameter waktu animasi dan
                      ///widget TextField sebagai input field
                      ///di dalam masing-masing widget textfield terdapat komponen
                      ///controller untuk mengkontrol input user (mendapatkan nilai,
                      ///menghapus nilai)
                      FadeAnimation(
                          1.8,
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(color: Color.fromRGBO(143, 148, 251, .2), blurRadius: 20.0, offset: Offset(0, 10))]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  //Membungkus input field untuk merapihkan posisi
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
                                  child: TextField(
                                    //Dekorasi input field(warna, hint, bentuk, border)
                                    controller: emailController,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(border: InputBorder.none, hintText: "Email", hintStyle: TextStyle(color: Colors.grey[400])),
                                  ),
                                ),
                                Container(
                                  //Membungkus input field untuk merapihkan posisi
                                  padding: EdgeInsets.all(8.0),
                                  child: TextField(
                                    //Dekorasi input field(warna, hint, bentuk, border)
                                    style: TextStyle(color: Colors.black),
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    controller: passwordController,
                                    decoration: InputDecoration(border: InputBorder.none, hintText: "Password", hintStyle: TextStyle(color: Colors.grey[400])),
                                  ),
                                )
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 30,
                      ),
///////////////////////////////////////////Batas Akhir Pembuatan Input Field/////////////////////////////////////////////////////////

                      FadeAnimation(
                          //Animasi untuk tombol login
                          2,
                          SizedBox(
                            width: double.infinity,
                            child: RaisedButton(
                                //Widget yang membuat tombol, pada widget ini
                                //tombol memiliki aksi jika ditekan (onPressed),
                                //dan memiliki dekorasi seperti(warna,child yang
                                //berupa widgetText, dan bentuk tombol)
                                textColor: Colors.white,
                                color: Colors.lightBlue,
                                child: Text("logIn"),
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                onPressed: () async {
                                  //Pengecekan jika email dan password kosong
                                  if (emailController.text == "" || passwordController.text == "") {
                                    Fluttertoast.showToast(
                                        /////// Widget toast untuk menampilkan pesan pada halaman
                                        msg: "Email atau Password Tidak Boleh Kosong",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 2,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    emailController.clear();
                                    passwordController.clear();
                                  } else {
                                    //Jika email dan password tidak kosong
                                    var ret = await logInCheck(emailController.text, passwordController.text);

                                    if (ret.runtimeType == String) {
                                      //Jika terjadi error pada pengerjaan
                                      Fluttertoast.showToast(
                                          /////// Widget toast untuk menampilkan pesan pada halaman
                                          msg: "Connection Problem",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 2,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      emailController.clear();
                                      passwordController.clear();
                                    } else if (ret.runtimeType != String && ret.length > 0) {
                                      //Jika berhasil login maka akan
                                      //dipanggil kelas homePage
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => homePage(
                                                  ret[0]['_id'],
                                                )),
                                      );
                                    } else {
                                      //Jika terjadi password dan email akun
                                      //tidak terdaftar
                                      Fluttertoast.showToast(
                                          /////// Widget toast untuk menampilkan pesan pada halaman
                                          msg: "Email dan Password Salah",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 2,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      emailController.clear();
                                      passwordController.clear();
                                    }
                                  }
                                }),
                          )),
                      SizedBox(
                        height: 50,
                      ),
                      FadeAnimation(
                        //Widget animasi untuk text yang bisa ditekan dan
                        //memanggil kelas signUp
                        1.5,
                        new GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => signUp()),
                              );
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.lightBlue,
                                decoration: TextDecoration.underline,
                              ),
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FadeAnimation(
                        //Widget animasi untuk text yang bisa ditekan dan
                        //memanggil kelas signUp
                        1.5,
                        new GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => forgetPassword()),
                              );
                            },
                            child: Text(
                              "Lupa Password",
                              style: TextStyle(
                                color: Colors.lightBlue,
                                decoration: TextDecoration.underline,
                              ),
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
