import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/homePage.dart';
import 'package:pelayanan_iman_katolik/profile.dart';
import 'package:pelayanan_iman_katolik/setting.dart';
import 'package:pelayanan_iman_katolik/tiketSaya.dart';

import 'DatabaseFolder/mongodb.dart';

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
      passBaruController.text = "";
      passUlBaruController.text = "";
      return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Password baru tidak sama'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      print(passLamaController.text);
      status = await MongoDatabase.findPassword(email, passLamaController.text)
          .then((value) async {
        if (value == "not") {
          return showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Password lama tidak cocok!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          await MongoDatabase.updatePassword(idUser, passBaruController.text)
              .then((value) {
            passLamaController.text = "";
            passBaruController.text = "";
            passUlBaruController.text = "";
            return showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Password Berhasil Diubah!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          });
        }
      });
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          openCamera();
        },
        tooltip: 'Increment',
        child: new Icon(Icons.camera_alt_rounded),
      ),
    );
  }
}
