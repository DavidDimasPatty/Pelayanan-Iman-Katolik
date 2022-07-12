import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/profile.dart';
import 'misa.dart';

class HomePage extends StatelessWidget {
  var names;
  var emails;

  HomePage(this.names, this.emails);
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
                MaterialPageRoute(builder: (context) => Profile(names, emails)),
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
                        builder: (context) => Misa(names, emails)),
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
    );
  }
}
