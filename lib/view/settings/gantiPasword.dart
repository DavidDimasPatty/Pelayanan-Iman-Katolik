import 'dart:async';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/view/settings/privacySafety.dart';

import '../../DatabaseFolder/mongodb.dart';
import '../homePage.dart';
import '../profile/profile.dart';
import '../tiketSaya.dart';

class gantiPassword extends StatelessWidget {
  final name;
  final email;
  final idUser;
  var status;
  gantiPassword(this.name, this.email, this.idUser);

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
    } else {
      print(passLamaController.text);
      // Messages msg = new Messages();
      // msg.addReceiver("agenAkun");
      // msg.setContent([
      //   ["find Password"],
      //   [idUser],
      //   [passLamaController.text],
      // ]);

      // await msg.send().then((res) async {
      //   print("masuk");
      //   print(await AgenPage().receiverTampilan());
      // });
      // await Future.delayed(Duration(seconds: 1));
      // var value = await AgenPage().receiverTampilan();

      Completer<void> completer = Completer<void>();
      Messages message = Messages('Agent Page', 'Agent Akun', "REQUEST",
          Tasks('find password', [idUser, passLamaController.text]));

      MessagePassing messagePassing = MessagePassing();
      var data = await messagePassing.sendMessage(message);
      completer.complete();
      var value = await await AgentPage.getDataPencarian();

      await completer.future;

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
        // Messages msg = new Messages();
        // msg.addReceiver("agenAkun");
        // msg.setContent([
        //   ["ganti Password"],
        //   [idUser],
        //   [passBaruController.text],
        // ]);

        // await msg.send().then((res) async {
        //   print("masuk");
        //   print(await AgenPage().receiverTampilan());
        // });
        // await Future.delayed(Duration(seconds: 1));
        // var value = await AgenPage().receiverTampilan();
        Completer<void> completer = Completer<void>();
        Messages message = Messages('Agent Page', 'Agent Akun', "REQUEST",
            Tasks('change password', [idUser, passBaruController.text]));

        MessagePassing messagePassing = MessagePassing();
        var data = await messagePassing.sendMessage(message);
        completer.complete();
        var value = await await AgentPage.getDataPencarian();

        await completer.future;

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
          MaterialPageRoute(
              builder: (context) => privacySafety(name, email, idUser)),
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
                MaterialPageRoute(
                    builder: (context) => Profile(name, email, idUser)),
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
                    MaterialPageRoute(
                        builder: (context) => tiketSaya(name, email, idUser)),
                  );
                } else if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(name, email, idUser)),
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
