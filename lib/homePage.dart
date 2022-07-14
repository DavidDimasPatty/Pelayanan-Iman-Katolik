import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/profile.dart';
import 'package:pelayanan_iman_katolik/tiketSaya.dart';
import 'misa.dart';

class HomePage extends StatelessWidget {
  var names;
  var emails;
  var iduser;

  HomePage(this.names, this.emails, this.iduser);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Welcome ' + names + ","),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            tooltip: 'Show Snackbar',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Profile(names, emails, iduser)),
              );
            },
          ),
        ],
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          ),
          Text(
            'Pilih Menu',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: RaisedButton(
                child: Text("Pendaftaran Misa"),
                textColor: Colors.white,
                color: Colors.blueAccent,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Misa(names, emails, iduser)),
                  );
                }),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: RaisedButton(
                child: Text("Pendaftaran Baptis"),
                textColor: Colors.white,
                color: Colors.blueAccent,
                onPressed: () {}),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: RaisedButton(
                child: Text("Pendaftaran Komuni"),
                textColor: Colors.white,
                color: Colors.blueAccent,
                onPressed: () {}),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: RaisedButton(
                child: Text("Pendaftaran Krisma"),
                textColor: Colors.white,
                color: Colors.blueAccent,
                onPressed: () {}),
          ),
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
                  builder: (context) => tiketSaya(names, emails, iduser)),
            );
          } else if (index == 0) {}
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
