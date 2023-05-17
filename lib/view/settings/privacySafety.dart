import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/view/settings/gantiPasword.dart';
import 'package:pelayanan_iman_katolik/view/settings/notification.dart';
import '../homePage.dart';
import '../profile/profile.dart';
import '../tiketSaya.dart';

class privacySafety extends StatelessWidget {
  final iduser;
  var dataUser;
  privacySafety(this.iduser);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Widget untuk membangun struktur halaman
      //////////////////////////////////////Pembuatan Top Navigation Bar////////////////////////////////////////////////////////////////
      appBar: AppBar(
        // widget Top Navigation Bar
        title: Text('Privacy & Safety'),
        shape: RoundedRectangleBorder(
          //Bentuk Top Navigation Bar: Rounded Rectangle
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: <Widget>[
          //Tombol Top Navigation Bar
          IconButton(
            //Widget icon profile
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              //Jika ditekan akan mengarahkan ke halaman profile
              Navigator.push(
                //Widget navigator untuk memanggil kelas profile
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
      body: Center(
          child: Column(children: <Widget>[
        ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(20.0),
          children: <Widget>[
            RaisedButton(
                //Widget yang membuat tombol, pada widget ini
                //tombol memiliki aksi jika ditekan (onPressed),
                //dan memiliki dekorasi seperti(warna,child yang
                //berupa widgetText, dan bentuk tombol)
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => gantiPassword(this.iduser)),
                  );
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                elevation: 10.0,
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.topLeft, colors: [
                      Colors.blueAccent,
                      Colors.lightBlue,
                    ]),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: double.maxFinite, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Ganti Password",
                      style: TextStyle(color: Colors.white, fontSize: 26.0, fontWeight: FontWeight.w300),
                    ),
                  ),
                )),
            Padding(padding: EdgeInsets.symmetric(vertical: 14)),
            RaisedButton(
                //Widget yang membuat tombol, pada widget ini
                //tombol memiliki aksi jika ditekan (onPressed),
                //dan memiliki dekorasi seperti(warna,child yang
                //berupa widgetText, dan bentuk tombol)
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => notification(this.iduser)));
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                elevation: 10.0,
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.topLeft, colors: [
                      Colors.blueAccent,
                      Colors.lightBlue,
                    ]),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: double.maxFinite, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Notification",
                      style: TextStyle(color: Colors.white, fontSize: 26.0, fontWeight: FontWeight.w300),
                    ),
                  ),
                )),

            /////////
          ],
        )
      ])),
//////////////////////////////////////Batas Akhir Pembuatan Body Halaman/////////////////////////////////////////////////////////////
      ///
      ///
      ///
/////////////////////////////////////////////////////////Pembuatan Bottom Navigation Bar////////////////////////////////////////
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          //Dekorasi Kontainer pada Bottom Navigation Bar : posisi, bentuk, dan bayangan.
          child: ClipRRect(
            //Membentuk posisi Bottom Navigation Bar agar bisa dipasangkan menu
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              //Widget untuk membuat tampilan Bottom Navigation Bar
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              unselectedItemColor: Colors.blue,
              //Konfigurasi Bottom Navigation Bar
              items: <BottomNavigationBarItem>[
                //Item yang terdapat pada Bottom Navigation Bar
                //Berisikan icon dan label
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.token, color: Color.fromARGB(255, 0, 0, 0)),
                  label: "Jadwalku",
                )
              ],
              onTap: (index) {
                if (index == 1) {
                  //Jika item kedua ditekan maka akan memanggil kelas tiketSaya
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => tiketSaya(iduser, "current")),
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
