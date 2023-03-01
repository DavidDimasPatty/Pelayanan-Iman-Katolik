import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/messages.dart';

import '../homePage.dart';
import '../profile/profile.dart';
import '../tiketSaya.dart';

class notification extends StatefulWidget {
  final name;
  final email;
  final idUser;
  notification(this.name, this.email, this.idUser);
  @override
  _notifClass createState() => _notifClass(this.name, this.email, this.idUser);
}

class _notifClass extends State<notification> {
  final name;
  final email;
  final idUser;
  var checknotif;
  _notifClass(this.name, this.email, this.idUser);
  bool switch1 = false;
  void isSwitch() {
    switch1 = true;
  }

  bool switch2 = false;
  void isSwitch2() {
    switch2 = true;
  }

  Future callDb() async {
    Messages msg = new Messages();
    msg.addReceiver("agenAkun");
    msg.setContent([
      ["cari data user"],
      [idUser]
    ]);
    await msg.send().then((res) async {
      print("masuk");
      print(await AgenPage().receiverTampilan());
    });
    await Future.delayed(Duration(seconds: 1));
    checknotif = AgenPage().receiverTampilan();

    return checknotif;
  }

  Future updateNotifPg(notifPg) async {
    Messages msg = new Messages();
    msg.addReceiver("agenAkun");
    msg.setContent([
      ["update NotifPG"],
      [idUser],
      [notifPg]
    ]);

    await msg.send().then((res) async {
      print("masuk");
      print(await AgenPage().receiverTampilan());
    });
    await Future.delayed(Duration(seconds: 1));
    var daftarmisa = await AgenPage().receiverTampilan();

    if (daftarmisa == 'oke') {
      Fluttertoast.showToast(
          msg: "Berhasil Update Notif",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future updateNotifGd(notifGD) async {
    Messages msg = new Messages();
    msg.addReceiver("agenAkun");
    msg.setContent([
      ["update NotifGD"],
      [idUser],
      [notifGD]
    ]);

    await msg.send().then((res) async {
      print("masuk");
      print(await AgenPage().receiverTampilan());
    });
    await Future.delayed(Duration(seconds: 1));
    var daftarmisa = await AgenPage().receiverTampilan();

    if (daftarmisa == 'oke') {
      Fluttertoast.showToast(
          msg: "Berhasil Update Notif",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  // void initState() {
  //   super.initState();
  //   callDb();
  // }

  Future pullRefresh() async {
    setState(() {
      callDb();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
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
      body: RefreshIndicator(
        onRefresh: pullRefresh,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(right: 15, left: 15),
          children: <Widget>[
            FutureBuilder(
                future: callDb(),
                builder: (context, AsyncSnapshot snapshot) {
                  try {
                    switch1 = checknotif[0]['notifPG'];
                    switch2 = checknotif[0]['notifGD'];

                    return Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                        Row(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6)),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Pengingat Gereja',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 3)),
                                  Text(
                                    'Jika dimatikan tidak akan mendapatkan notifikasi gereja dimulai 1 jam sebelumnya',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                            Switch(
                              value: switch1,
                              onChanged: (value) {
                                setState(() async {
                                  switch1 = value;
                                  await updateNotifPg(switch1);
                                  // await callDb();
                                  setState(() {
                                    switch1 = checknotif[0]['notifPG'];
                                  });
                                });
                              },
                              activeTrackColor: Colors.lightGreenAccent,
                              activeColor: Colors.green,
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                        Row(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6)),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Misa di Gereja Terdekat',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 3)),
                                  Text(
                                    'Pemberitahuan Misa di Gereja Terdekat',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                            Switch(
                              value: switch2,
                              onChanged: (value) {
                                setState(() async {
                                  switch2 = value;
                                  await updateNotifGd(switch2);

                                  // await callDb();
                                  setState(() {
                                    switch2 = checknotif[0]['notifGD'];
                                  });
                                });
                              },
                              activeTrackColor: Colors.lightGreenAccent,
                              activeColor: Colors.green,
                            ),
                          ],
                        )
                      ],
                    );
                  } catch (e) {
                    print(e);
                    return Center(child: CircularProgressIndicator());
                  }
                }),
            /////////
          ],
        ),
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
