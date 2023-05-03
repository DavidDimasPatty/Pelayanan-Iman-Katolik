import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/view/settings/privacySafety.dart';

import '../homePage.dart';
import '../profile/profile.dart';
import '../tiketSaya.dart';

class gantiPassword extends StatelessWidget {
  final iduser;
  var status;
  gantiPassword(this.iduser);

  @override
  TextEditingController passLamaController = new TextEditingController();
  TextEditingController passBaruController = new TextEditingController();
  TextEditingController passUlBaruController = new TextEditingController();

  checkPassword(context) async {
    if (passBaruController.text != passUlBaruController.text) {
      Fluttertoast.showToast(
          msg: "Password Baru Tidak Cocok",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      passLamaController.text = "";
      passBaruController.text = "";
      passUlBaruController.text = "";
    } else if (passBaruController.text == passLamaController.text) {
      Fluttertoast.showToast(
          msg: "Password Baru Tidak Boleh Sama dengan Password Lama",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      passLamaController.text = "";
      passBaruController.text = "";
      passUlBaruController.text = "";
    } else {
      Completer<void> completer = Completer<void>(); //variabel untuk menunggu
      Messages message = Messages('Agent Page', 'Agent Akun', "REQUEST",
          Tasks('find password', [iduser, passLamaController.text]));

      MessagePassing messagePassing =
          MessagePassing(); //Memanggil distributor pesan
      await messagePassing
          .sendMessage(message); //Mengirim pesan ke distributor pesan
      completer
          .complete(); //Pengiriman pesan sudah berhasil, tapi masih harus menunggu
      var value =
          await AgentPage.getData(); //Memanggil data yang tersedia di agen Page

      await completer
          .future; //Proses penungguan sudah selesai ketika varibel hasil
      //memiliki nilai

      if (value == "not") {
        Fluttertoast.showToast(
            msg: "Password Lama Tidak Cocok",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        passLamaController.text = "";
        passBaruController.text = "";
        passUlBaruController.text = "";
      } else {
        Completer<void> completer = Completer<void>(); //variabel untuk menunggu
        Messages message = Messages('Agent Page', 'Agent Akun', "REQUEST",
            Tasks('change password', [iduser, passBaruController.text]));

        MessagePassing messagePassing =
            MessagePassing(); //Memanggil distributor pesan
        await messagePassing
            .sendMessage(message); //Mengirim pesan ke distributor pesan
        completer
            .complete(); //Pengiriman pesan sudah berhasil, tapi masih harus menunggu
        var value = await AgentPage
            .getData(); //Memanggil data yang tersedia di agen Page

        await completer
            .future; //Proses penungguan sudah selesai ketika varibel hasil
        //memiliki nilai

        passLamaController.text = "";
        passBaruController.text = "";
        passUlBaruController.text = "";
        Fluttertoast.showToast(
            msg: "Berhasil Ganti Password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(
          context,
          MaterialPageRoute(builder: (context) => privacySafety(iduser)),
        );
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ganti Password'),
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
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 9)),
              Text(
                'Password Lama',
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: passLamaController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Masukan password lama anda',
                  ),
                ),
              ),
              Text(
                'Password Baru',
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: passBaruController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Masukan password baru anda',
                  ),
                ),
              ),
              Text(
                'Ketik Ulang Password Baru',
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: passUlBaruController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Ketik ulang password baru anda',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: ButtonBar(
                  alignment: MainAxisAlignment.center,
                  buttonPadding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  children: [
                    RaisedButton(
                        child: Text("Ganti Password"),
                        textColor: Colors.white,
                        color: Colors.blueAccent,
                        onPressed: () async {
                          checkPassword(context);
                        }),
                  ],
                ),
              ),
            ],
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
    );
  }
}
