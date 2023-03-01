import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/view/umum/pendalamanAlkitab/pendalamanAlkitab.dart';
import 'package:pelayanan_iman_katolik/view/umum/rekoleksi/rekoleksi.dart';
import 'package:pelayanan_iman_katolik/view/umum/retret/retret.dart';

import '../homePage.dart';
import '../profile/profile.dart';
import '../tiketSaya.dart';

class Umum extends StatelessWidget {
  final name;
  final email;
  final idUser;
  Umum(this.name, this.email, this.idUser);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Umum'),
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
        shrinkWrap: true,
        padding: EdgeInsets.only(right: 15, left: 15),
        children: <Widget>[
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          InkWell(
            borderRadius: new BorderRadius.circular(24),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PendalamanAlkitab(name, email, idUser)),
              );
            },
            child: Container(
                margin: EdgeInsets.only(right: 15, left: 15, bottom: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.topLeft,
                      colors: [
                        Colors.blueGrey,
                        Colors.lightBlue,
                      ]),
                  border: Border.all(
                    color: Colors.lightBlue,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text(
                  'Pendalaman Kitab Suci',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.0,
                      fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,
                )),
          ),
          InkWell(
            borderRadius: new BorderRadius.circular(24),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Rekoleksi(name, email, idUser)),
              );
            },
            child: Container(
                margin: EdgeInsets.only(right: 15, left: 15, bottom: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.topLeft,
                      colors: [
                        Colors.blueGrey,
                        Colors.lightBlue,
                      ]),
                  border: Border.all(
                    color: Colors.lightBlue,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text(
                  'Rekoleksi',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.0,
                      fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,
                )),
          ),
          InkWell(
            borderRadius: new BorderRadius.circular(24),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Retret(name, email, idUser)),
              );
            },
            child: Container(
                margin: EdgeInsets.only(right: 15, left: 15, bottom: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.topLeft,
                      colors: [
                        Colors.blueGrey,
                        Colors.lightBlue,
                      ]),
                  border: Border.all(
                    color: Colors.lightBlue,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text(
                  'Retret',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.0,
                      fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,
                )),
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
