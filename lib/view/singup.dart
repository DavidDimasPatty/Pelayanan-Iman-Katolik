import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/FadeAnimation.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/view/login.dart';

class SignUp extends StatelessWidget {
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController repasswordController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  checkSignUp(context) async {
    if (nameController.text == "" ||
        emailController.text == "" ||
        passwordController.text == "" ||
        repasswordController.text == "") {
      Fluttertoast.showToast(
          msg: "Mohon Mengisi Semua Data",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      emailController.clear();
      passwordController.clear();
    } else {
      var email = emailController.text;
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email);
      var nama = nameController.text;
      bool namaValid = RegExp(r'^[a-z A-Z,.\-]+$').hasMatch(nama);
      if (namaValid == false) {
        nameController.text = "";
        Fluttertoast.showToast(
            msg: "Nama Lengkap Tidak Valid",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        emailController.clear();
        passwordController.clear();
      } else if (passwordController.text != repasswordController.text) {
        passwordController.text = "";
        repasswordController.text = "";
        Fluttertoast.showToast(
            msg: "Password Tidak Sama",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        passwordController.clear();
      } else if (emailValid == false) {
        emailController.text = "";
        Fluttertoast.showToast(
            msg: "Email Tidak Valid",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        emailController.clear();
        passwordController.clear();
      } else if (emailValid == true &&
          namaValid == true &&
          passwordController.text == repasswordController.text) {
        Completer<void> completer = Completer<void>();
        Messages message = Messages(
            'Agent Page',
            'Agent Akun',
            "REQUEST",
            Tasks('sign up', [
              nameController.text,
              emailController.text,
              passwordController.text
            ]));

        MessagePassing messagePassing = MessagePassing();
        var data = await messagePassing.sendMessage(message);
        var hasil = await await AgentPage.getDataPencarian();
        completer.complete();

        await completer.future;
        if (hasil == "nama") {
          nameController.text = "";
          Fluttertoast.showToast(
              msg: "Nama Sudah Digunakan",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          emailController.clear();
          passwordController.clear();
        } else if (hasil == "email") {
          emailController.text = "";
          Fluttertoast.showToast(
              msg: "Email Sudah Digunakan",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          emailController.clear();
          passwordController.clear();
        } else if (hasil == 'oke') {
          Fluttertoast.showToast(
              msg: "Berhasil Sign Up",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pop(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  'https://firebasestorage.googleapis.com/v0/b/pelayananimankatolik.appspot.com/o/register.png?alt=media&token=c875ef67-9a3e-46ba-a96d-e3b5d83e0bb8'),
              fit: BoxFit.cover),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 35, top: 30),
                  child: FadeAnimation(
                      1.8,
                      Text(
                        'Create\nAccount',
                        style: TextStyle(color: Colors.white, fontSize: 33),
                      )),
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 35, right: 35),
                          child: Column(
                            children: [
                              FadeAnimation(
                                  1.8,
                                  TextField(
                                    controller: nameController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[a-zA-Z ]")),
                                    ],
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        hintText: "Masukan Nama Lengkap",
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                              FadeAnimation(
                                  1.8,
                                  TextField(
                                    controller: emailController,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        hintText: "Masukan Email Anda",
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                              FadeAnimation(
                                  1.8,
                                  TextField(
                                    controller: passwordController,
                                    style: TextStyle(color: Colors.white),
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        hintText: "Masukan Password Anda",
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                              FadeAnimation(
                                  1.8,
                                  TextField(
                                    controller: repasswordController,
                                    style: TextStyle(color: Colors.white),
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        hintText: "Ketik Kembali Password",
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                  )),
                              SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FadeAnimation(
                                      1.8,
                                      Text(
                                        'Sign Up',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 27,
                                            fontWeight: FontWeight.w700),
                                      )),
                                  FadeAnimation(
                                      1.8,
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Color(0xff4c505b),
                                        child: IconButton(
                                            color: Colors.white,
                                            onPressed: () async {
                                              checkSignUp(context);
                                            },
                                            icon: Icon(
                                              Icons.arrow_forward,
                                            )),
                                      ))
                                ],
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Login()),
                                      );
                                    },
                                    child: FadeAnimation(
                                        1.8,
                                        Text(
                                          'Sign In',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.white,
                                              fontSize: 18),
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
            )));
  }
}
