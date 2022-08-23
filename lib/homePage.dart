import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pelayanan_iman_katolik/baptis.dart';
import 'package:pelayanan_iman_katolik/komuni.dart';
import 'package:pelayanan_iman_katolik/profile.dart';
import 'package:pelayanan_iman_katolik/setting.dart';
import 'package:pelayanan_iman_katolik/tiketSaya.dart';
import 'DatabaseFolder/mongodb.dart';
import 'ItemCard.dart';
import 'misa.dart';

Future<void> openCamera() async {
  //fuction openCamera();
  final pickedImage = await ImagePicker().getImage(source: ImageSource.camera);
}

class HomePage extends StatelessWidget {
  var names;
  var emails;
  var iduser;
  var dataUser;
  int _currentIndex = 0;
  List<String> cardList = [
    'https://cdn1-production-images-kly.akamaized.net/rWhC9IleD8e64WhGw-uOuWBfEvI=/383x288/smart/filters:quality(75):strip_icc():format(jpeg)/kly-media-production/medias/3652676/original/049623700_1638601766-AP21337638247495.jpg',
    'https://asset.kompas.com/crops/1ZoER_pFzpK32kBDeQrLiJlzPxI=/0x227:768x739/490x326/data/photo/2022/07/15/62d153c00ddd3.jpeg',
    'https://img.beritasatu.com/cache/beritasatu/320x220-2/1640103381.jpg',
    'https://assets.promediateknologi.com/crop/0x0:0x0/x/photo/2021/09/22/1506503095.jpg'
  ];

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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Profile(names, emails, iduser)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Settings(names, emails, iduser)),
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
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Profile(names, emails, iduser)),
                                  );
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4),
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
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Text(
                                          emails,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Text(
                                          'Paroki',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Text(
                                          'Lingkungan',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 7),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              tiketSaya(names, emails, iduser)),
                                    );
                                  },
                                  child: Container(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 4),
                                        ),
                                        Text(
                                          'Jadwal Terdekat:',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        FutureBuilder<List>(
                                            future: jadwalTerakhir(),
                                            builder: (context,
                                                AsyncSnapshot snapshot) {
                                              try {
                                                return Column(children: <
                                                    Widget>[
                                                  Text(
                                                    snapshot.data[0][0]['nama'],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                  Text(
                                                    snapshot.data[1][0]
                                                        ['jadwal'],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.w300),
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
                                  )),
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
                    color: Colors.lightBlueAccent, // button color
                    child: InkWell(
                      splashColor: Colors.green, // splash color
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Komuni(names, emails, iduser)),
                        );
                      }, // button pressed
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
                    color: Colors.greenAccent, // button color
                    child: InkWell(
                      splashColor: Colors.green, // splash color
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Baptis(names, emails, iduser)),
                        );
                      }, // button pressed
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          ),
          Container(
            child: Center(
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  pauseAutoPlayOnTouch: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.8,
                ),
                items: cardList.map((item) {
                  return ItemCard(images: item.toString());
                }).toList(),
              ),
            ),
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
                  icon: Icon(Icons.token, color: Color.fromARGB(255, 0, 0, 0)),
                  label: "Jadwalku",
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
        onPressed: () {
          openCamera();
        },
        tooltip: 'Increment',
        child: new Icon(Icons.camera_alt_rounded),
      ),
    );
  }
}
