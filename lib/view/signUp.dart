import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pelayanan_iman_katolik/FadeAnimation.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/view/logIn.dart';

class signUp extends StatelessWidget {
////////Inisialisasi variabel untuk mengkontrol input field//////////////
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController repasswordController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
//////////////////////////////////////////////////////////////////////////

  Future checksignUp(context) async {
    ///Fungsi pengiriman pesan untuk melakukan pengecekan kepada input field
    ///pegguna, melakukan pengecekan pada collection user
    /// dan menambahkan data baru pada collection user
    ///
    if (nameController.text == "" || emailController.text == "" || passwordController.text == "" || repasswordController.text == "") {
      //////Jika input field tidak diisi semua
      Fluttertoast.showToast(
          /////// Widget toast untuk menampilkan pesan pada halaman
          msg: "Mohon Mengisi Semua Bidang",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
          /////Konfigurasi widget toast, untuk toast ini dibuat konfigurasi error
          );
    } else {
      //////Jika input field diisi semua
      ///Melakukan pengecekan format email dengan regex/////////
      var email = emailController.text;
      bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
      ////////////////////////////////////////////
      ///
      ///Melakukan pengecekan format nama dengan regex/////////
      var nama = nameController.text;
      bool namaValid = RegExp(r'^[a-z A-Z,.\-]+$').hasMatch(nama);
      ////////////////////////////////////////////
      if (namaValid == false) {
        /////////Jika nama tidak valid
        Fluttertoast.showToast(
            /////// Widget toast untuk menampilkan pesan pada halaman
            msg: "Nama Lengkap Tidak Valid",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
            /////Konfigurasi widget toast, untuk toast ini dibuat konfigurasi error
            );
        //Menghapus input field pengguna///
        nameController.clear();
        //////////////////////////////////////
      } else if (passwordController.text.length < 6) {
        /////////Jika password dan ketik ulang password tidak sama
        Fluttertoast.showToast(
            /////// Widget toast untuk menampilkan pesan pada halaman
            msg: "Password harus lebih panjang dari 6 karakter",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
            /////Konfigurasi widget toast, untuk toast ini dibuat konfigurasi error
            );
        //Menghapus input field pengguna///
        repasswordController.clear();
        passwordController.clear();
        //////////////////////////////////////
      } else if (passwordController.text != repasswordController.text) {
        /////////Jika password dan ketik ulang password tidak sama
        Fluttertoast.showToast(
            /////// Widget toast untuk menampilkan pesan pada halaman
            msg: "Password Tidak Sama",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
            /////Konfigurasi widget toast, untuk toast ini dibuat konfigurasi error
            );
        //Menghapus input field pengguna///
        repasswordController.clear();
        passwordController.clear();
        //////////////////////////////////////
      } else if (emailValid == false) {
        /////////Jika email tidak valid
        Fluttertoast.showToast(
            /////// Widget toast untuk menampilkan pesan pada halaman
            msg: "Email Tidak Valid",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
            /////Konfigurasi widget toast, untuk toast ini dibuat konfigurasi error
            );
        //Menghapus input field pengguna///
        emailController.clear();
        //////////////////////////////////////
      } else if (emailValid == true && namaValid == true && passwordController.text == repasswordController.text) {
        Completer<void> completer = Completer<void>(); //variabel untuk menunggu
        Messages message = Messages('Agent Page', 'Agent Akun', "REQUEST", Tasks('sign up', [nameController.text, emailController.text, passwordController.text])); //Pembuatan pesan

        MessagePassing messagePassing = MessagePassing(); //Memanggil distributor pesan
        await messagePassing.sendMessage(message); //Mengirim pesan ke distributor pesan
        var hasil = await AgentPage.getData(); //Memanggil data yang tersedia di agen Page
        completer.complete(); //Batas pengerjaan yang memerlukan completer

        await completer.future; //Proses penungguan sudah selesai ketika varibel hasil
        //memiliki nilai
        if (hasil == "nama") {
          //Jika nama sudah digunakan
          Fluttertoast.showToast(
              /////// Widget toast untuk menampilkan pesan pada halaman
              msg: "Nama Sudah Digunakan",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          //Menghapus input field pengguna///
          nameController.clear();
          //////////////////////////////////////
        } else if (hasil == "email") {
          //Jika email sudah digunakan
          Fluttertoast.showToast(
              /////// Widget toast untuk menampilkan pesan pada halaman
              msg: "Email Sudah Digunakan",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          //Menghapus input field pengguna///
          emailController.clear();
          //////////////////////////////////////
        } else if (hasil == 'oke') {
          Fluttertoast.showToast(
              /////// Widget toast untuk menampilkan pesan pada halaman
              msg: "Berhasil Sign Up",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0
              /////Konfigurasi widget toast, untuk toast ini dibuat konfigurasi success
              );
          Navigator.pop(
            //Memanggil kelas login
            context,
            MaterialPageRoute(builder: (context) => logIn()),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //Fungsi untuk membangun halaman sign up
    return Container(
        //Halaman dibangun dengan container
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/pelayananimankatolik.appspot.com/o/register.png?alt=media&token=c875ef67-9a3e-46ba-a96d-e3b5d83e0bb8'),
              fit: BoxFit.cover),
        ),
        //Konfigurasi background halaman
        child: Scaffold(
            backgroundColor: Colors.transparent,
            //////////////////////////////////////Pembuatan Top Navigation Bar////////////////////////////////////////////////////////////////
            appBar: AppBar(
              // widget Top Navigation Bar
              automaticallyImplyLeading: false, //mematikan tombol back
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            //////////////////////////////////////Batas Akhir Pembuatan Top Navigation Bar////////////////////////////////////////////////////////////////

            //////////////////////////////////////Pembuatan Body Halaman////////////////////////////////////////////////////////////////
            body: Stack(
              ////Widget Stack digunakan untuk menumpuk background dengan widget
              ///children pada widget Stack
              children: [
                Container(
                  //Container untuk judul halaman
                  padding: EdgeInsets.only(left: 35, top: 30),
                  child: FadeAnimation(
                      1.8,
                      Text(
                        'Create\nAccount',
                        style: TextStyle(color: Colors.white, fontSize: 33),
                      )),
                ),
                //
                SingleChildScrollView(
                  // Widget SingleChildScrollView agar halaman sign up bisa dilakukan
                  // scroll oleh pengguna
                  child: Container(
                    //Container untuk membungkus semua input field
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.28),
                    //Konfigurasi batas halaman dengan child pada Container
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //Widget Column agar semua input field kebawah, dan input field
                      //dimulai dari kiri/ awal
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 35, right: 35),
                          child: Column(
                            children: [
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
                                  TextField(
                                    maxLength: 19,
                                    controller: nameController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                                    ],
                                    //Format input user untuk nama
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        //Dekorasi input field(warna, hint, bentuk, border)
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        hintText: "Masukan Nama Lengkap",
                                        hintStyle: TextStyle(color: Colors.white),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        )),
                                  )),

                              SizedBox(
                                height: 15,
                              ),
                              //Batas antara input field
                              //
                              FadeAnimation(
                                  1.8,
                                  TextField(
                                    controller: emailController,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        //Dekorasi input field(warna, hint, bentuk, border)
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        hintText: "Masukan Email Anda",
                                        hintStyle: TextStyle(color: Colors.white),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        )),
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                              //Batas antara input field
                              //
                              FadeAnimation(
                                  1.8,
                                  TextField(
                                    controller: passwordController,
                                    style: TextStyle(color: Colors.white),
                                    obscureText: true,
                                    //Teks input user akan ditutup
                                    decoration: InputDecoration(
                                        //Dekorasi input field(warna, hint, bentuk, border)
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        hintText: "Masukan Password Anda",
                                        hintStyle: TextStyle(color: Colors.white),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        )),
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                              //Batas antara input field
                              //
                              FadeAnimation(
                                  1.8,
                                  TextField(
                                    controller: repasswordController,
                                    style: TextStyle(color: Colors.white),
                                    obscureText: true,
                                    //Teks input user akan ditutup
                                    decoration: InputDecoration(
                                        //Dekorasi input field(warna, hint, bentuk, border)
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        hintText: "Ketik Kembali Password",
                                        hintStyle: TextStyle(color: Colors.white),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        )),
                                  )),
///////////////////////////////////////////Batas Akhir Pembuatan Input Field/////////////////////////////////////////////////////////

                              SizedBox(
                                height: 40,
                              ),
                              //Batas antara widget
                              //
                              Row(
                                //Row digunakan agar teks bersebelahan dengan
                                //ikon arrow yang bisa ditekan untuk sign up
                                //pengguna
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  FadeAnimation(
                                      1.8,
                                      Text(
                                        'Sign Up',
                                        style: TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w700),
                                      )),
                                  FadeAnimation(
                                      1.8,

                                      ////////Pembuatan tombol Sign Up/////////
                                      CircleAvatar(
                                        ///Untuk membulatkan ikon dan
                                        /// jika ditekan oleh pengguna akan
                                        /// memanggil fungsi checkSignUp
                                        radius: 30,
                                        backgroundColor: Color(0xff4c505b),
                                        child: IconButton(
                                            color: Colors.white,
                                            onPressed: () async {
                                              checksignUp(context);
                                            },
                                            icon: Icon(
                                              Icons.arrow_forward,
                                            )),
                                      ))
                                  ////////Batas akhir Pembuatan tombol Sign Up/////////
                                ],
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              //Batas antara widget
                              //
                              Row(
                                //Row digunakan untuk menaruh widget textButton
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //Row memiliki komponen spaceBetween diantara
                                //children
                                children: [
                                  TextButton(
                                    //Widget yang digunakan untuk pengguna
                                    //kembali ke halaman login
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => logIn()),
                                      );
                                    },
                                    child: FadeAnimation(
                                        1.8,
                                        Text(
                                          'Sign In',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(decoration: TextDecoration.underline, color: Colors.white, fontSize: 18),
                                        )),
                                    style: ButtonStyle(),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
            //////////////////////////////////////Batas Akhir Pembuatan Body Halaman////////////////////////////////////////////////////////////////
            ));
  }
}
