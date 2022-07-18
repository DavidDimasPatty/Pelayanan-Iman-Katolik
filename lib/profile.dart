import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/login.dart';
import 'homePage.dart';
import 'tiketSaya.dart';

class Profile extends StatelessWidget {
  final name;
  final email;
  final idUser;

  Profile(this.name, this.email, this.idUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: <Widget>[],
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          ),
          CircleAvatar(
            backgroundImage: AssetImage(''),
            backgroundColor: Colors.greenAccent,
            radius: 120,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          ),
          Text(
            'User Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          ),
          Row(
            children: <Widget>[
              Text("Nama: "),
              Text(name),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          ),
          Row(
            children: <Widget>[
              Text("Email: "),
              Text(email),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          ),
          Row(
            children: <Widget>[
              Text("Address: "),
              Text(" "),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          ),
          Row(
            children: <Widget>[
              Text("Phone Number: "),
              Text(" "),
            ],
          ),
          RaisedButton(
              child: Text("Log Out"),
              textColor: Colors.white,
              color: Colors.blueAccent,
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              })
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.blue,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color.fromARGB(255, 0, 0, 0)),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded,
                color: Color.fromARGB(255, 0, 0, 0)),
            label: "TiketKu",
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: new FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: new Icon(Icons.camera_alt_rounded),
      ),
    );
  }
}
