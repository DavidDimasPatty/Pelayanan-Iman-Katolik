import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/profile.dart';
import 'package:pelayanan_iman_katolik/tiketSaya.dart';
import 'DatabaseFolder/mongodb.dart';
import 'misa.dart';

class HomePage extends StatelessWidget {
  var names;
  var emails;
  var iduser;
  var dataUser;

  Future<List> callDb() async {
    dataUser = await MongoDatabase.getDataUser(iduser);
    return dataUser;
  }

  Future<List> jadwalTerakhir() async {
    var dataTerakhir = await MongoDatabase.jadwalku(iduser);
    var jadwalTerakhir =
        await MongoDatabase.jadwalMisaku(dataTerakhir[0]['idMisa']);
    var gerejaTerakhir =
        await MongoDatabase.cariGereja(jadwalTerakhir[0]['idGereja']);
    return [gerejaTerakhir, jadwalTerakhir];
  }

  HomePage(this.names, this.emails, this.iduser);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Welcome ' + names + ","),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
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
          FutureBuilder<List>(
              future: callDb(),
              builder: (context, AsyncSnapshot snapshot) {
                try {
                  return Card(
                      elevation: 20,
                      color: Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: SizedBox(
                          width: 300,
                          height: 190,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 7),
                                  ),
                                  if (snapshot.data[0]['picture'] == null)
                                    CircleAvatar(
                                      backgroundImage: AssetImage(''),
                                      backgroundColor: Colors.greenAccent,
                                      radius: 35,
                                    ),
                                  if (snapshot.data[0]['picture'] != null)
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          snapshot.data[0]['picture']),
                                      backgroundColor: Colors.greenAccent,
                                      radius: 35,
                                    ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        names,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        emails,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        'Paroki',
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        'Lingkungan',
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              Container(
                                height: 80,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.indigo[100],
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(20),
                                    top: Radius.circular(0),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                    ),
                                    Text(
                                      '        Jadwal Terdekat:',
                                      textAlign: TextAlign.center,
                                    ),
                                    FutureBuilder<List>(
                                        future: jadwalTerakhir(),
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
                                          try {
                                            return Column(children: <Widget>[
                                              Text(
                                                snapshot.data[0][0]['nama'],
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                snapshot.data[1][0]['jadwal'],
                                                textAlign: TextAlign.center,
                                              )
                                            ]);
                                          } catch (e) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        })
                                  ],
                                ),
                              )
                            ],
                          )));
                } catch (e) {
                  print(e);
                  return Center(child: CircularProgressIndicator());
                }
              }),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          ),
          Text(
            'Pilihan Layanan Menu',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox.fromSize(
                size: Size(60, 60), // button width and height
                child: ClipOval(
                  child: Material(
                    color: Colors.orange, // button color
                    child: InkWell(
                      splashColor: Colors.green, // splash color
                      onTap: () {}, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.settings_accessibility), // icon
                          Text(
                            "Komuni",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ), // text
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 11),
              ),
              SizedBox.fromSize(
                size: Size(60, 60), // button width and height
                child: ClipOval(
                  child: Material(
                    color: Colors.orange, // button color
                    child: InkWell(
                      splashColor: Colors.green, // splash color
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Misa(names, emails, iduser)),
                        );
                      }, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.church), // icon
                          Text(
                            "Misa",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ), // text
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 11),
              ),
              SizedBox.fromSize(
                size: Size(60, 60), // button width and height
                child: ClipOval(
                  child: Material(
                    color: Colors.orange, // button color
                    child: InkWell(
                      splashColor: Colors.green, // splash color
                      onTap: () {}, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.sign_language), // icon
                          Text(
                            "Baptis",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ), // text
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      )),
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
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: new FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: new Icon(Icons.camera_alt_rounded),
      ),
    );
  }
}
