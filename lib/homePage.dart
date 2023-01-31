import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/messages.dart';
import 'package:pelayanan_iman_katolik/alkitabMenu.dart';
import 'package:pelayanan_iman_katolik/baptis.dart';
import 'package:pelayanan_iman_katolik/komuni.dart';
import 'package:pelayanan_iman_katolik/profile.dart';
import 'package:pelayanan_iman_katolik/sakramen.dart';
import 'package:pelayanan_iman_katolik/sakramentali.dart';
import 'package:pelayanan_iman_katolik/setting.dart';
import 'package:pelayanan_iman_katolik/tiketSaya.dart';
import 'package:pelayanan_iman_katolik/umum.dart';
import 'DatabaseFolder/mongodb.dart';
import 'ItemCard.dart';
import 'misa.dart';

Future<void> openCamera() async {
  //fuction openCamera();
  final pickedImage = await ImagePicker().getImage(source: ImageSource.camera);
}

class HomePage extends StatefulWidget {
  var names;
  var emails;
  var iduser;
  @override
  HomePage(this.names, this.emails, this.iduser);

  _HomePage createState() => _HomePage(this.names, this.emails, this.iduser);
}

class _HomePage extends State<HomePage> {
  var names;
  var emails;
  var iduser;
  var dataUser;
  int _currentIndex = 0;
  int indexCaption = -1;
  List hasil = [];
  List<String> cardList = [
    'https://cdn1-production-images-kly.akamaized.net/rWhC9IleD8e64WhGw-uOuWBfEvI=/383x288/smart/filters:quality(75):strip_icc():format(jpeg)/kly-media-production/medias/3652676/original/049623700_1638601766-AP21337638247495.jpg',
    'https://asset.kompas.com/crops/1ZoER_pFzpK32kBDeQrLiJlzPxI=/0x227:768x739/490x326/data/photo/2022/07/15/62d153c00ddd3.jpeg',
    'https://img.beritasatu.com/cache/beritasatu/320x220-2/1640103381.jpg',
    'https://assets.promediateknologi.com/crop/0x0:0x0/x/photo/2021/09/22/1506503095.jpg'
  ];

  List<String> caption = [
    "Gereja Pembukaan",
    "Umat Merayakan Hari Paskah",
    "Tanggapan Gereja Mengenai Isu Sara",
    "Tanggapan Umat Katolik Mengikuti Misa"
  ];

  Future<List> callDb() async {
    dataUser = await MongoDatabase.getDataUser(iduser);
    return dataUser;
  }

  Future<List> jadwalTerakhir() async {
    //var dataTerakhir = await MongoDatabase.jadwalku(iduser);
    var tanggalTerakhir = await MongoDatabase.latestJadwal(iduser);
    // print("tanggal=" + tanggalTerakhir.toString());
    // var jadwalTerakhir =
    //     await MongoDatabase.jadwalMisaku(tanggalTerakhir[0]['idMisa']);
    var gerejaTerakhir =
        await MongoDatabase.cariGereja(tanggalTerakhir[0]['idGereja']);
    print(gerejaTerakhir);
    return [tanggalTerakhir, gerejaTerakhir];
  }

  Future callTampilan() async {
    Messages msg = new Messages();
    msg.addReceiver("agenPencarian");
    msg.setContent([
      ["cari tampilan homepage"],
      [iduser]
    ]);
    await msg.send().then((res) async {
      print("masuk");
      print(await AgenPage().receiverTampilan());
    });
    await Future.delayed(Duration(seconds: 1));
    hasil = AgenPage().receiverTampilan();
    print(hasil);
    return hasil;
  }

  Future pullRefresh() async {
    setState(() {
      callTampilan();
      indexCaption = -1;
    });
  }

  _HomePage(this.names, this.emails, this.iduser);
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
      body: RefreshIndicator(
          onRefresh: pullRefresh,
          child: ListView(children: <Widget>[
            Center(
                child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                ),
                FutureBuilder(
                    future: callTampilan(),
                    builder: (context, AsyncSnapshot snapshot) {
                      try {
                        print(snapshot.data);
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
                                              builder: (context) => Profile(
                                                  names, emails, iduser)),
                                        );
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 4),
                                          ),
                                          if (hasil[0][0][0]['picture'] == null)
                                            CircleAvatar(
                                              backgroundImage: AssetImage(''),
                                              backgroundColor:
                                                  Colors.greenAccent,
                                              radius: 35,
                                            ),
                                          if (hasil[0][0][0]['picture'] != null)
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  hasil[0][0][0]['picture']),
                                              backgroundColor:
                                                  Colors.greenAccent,
                                              radius: 35,
                                            ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5),
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                names,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22.0,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              Text(
                                                emails,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              Text(
                                                'Paroki',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              Text(
                                                'Lingkungan',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 7),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => tiketSaya(
                                                    names, emails, iduser)),
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
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4),
                                              ),
                                              Text(
                                                'Jadwal Terdekat:',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              if (hasil[2][0] == null)
                                                Text(
                                                  'Belum ada Pendaftaran',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              if (hasil[2][0] != null)
                                                Column(children: <Widget>[
                                                  if (hasil[2][0][0]
                                                          ['idKrisma'] !=
                                                      null)
                                                    Text(
                                                      'Krisma',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  if (hasil[2][0][0]
                                                          ['idKomuni'] !=
                                                      null)
                                                    Text(
                                                      'Komuni',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  if (hasil[2][0][0]
                                                          ['idBaptis'] !=
                                                      null)
                                                    Text(
                                                      'Baptis',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  if (hasil[2][0][0]
                                                          ['idKegiatan'] !=
                                                      null)
                                                    Text(
                                                      'Kegiatan Umum',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  if (hasil[2][0][0]
                                                          ['tanggalDaftar'] !=
                                                      null)
                                                    Text(
                                                      hasil[2][0][0]
                                                              ['tanggalDaftar']
                                                          .toString()
                                                          .substring(0, 19),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                ])
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
                      size: Size(75, 75), // button width and height
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
                                        Sakramen(names, emails, iduser)),
                              );
                            }, // button pressed
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.settings_accessibility,
                                    size: 30), // icon
                                Text(
                                  "Sakramen",
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
                      size: Size(75, 75), // button width and height
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
                                        Sakramentali(names, emails, iduser)),
                              );
                            }, // button pressed
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.sign_language, size: 30), // icon
                                Text(
                                  "Sakramentali",
                                  style: TextStyle(
                                    fontSize: 10.5,
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
                      size: Size(75, 75), // button width and height
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
                                        Umum(names, emails, iduser)),
                              );
                            }, // button pressed
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.church,
                                  size: 30,
                                ), // icon
                                Text(
                                  "Umum",
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
                    // SizedBox.fromSize(
                    //   size: Size(75, 75), // button width and height
                    //   child: ClipOval(
                    //     child: Material(
                    //       color: Colors.brown, // button color
                    //       child: InkWell(
                    //         splashColor: Colors.green, // splash color
                    //         onTap: () {
                    //           Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) =>
                    //                     Alkitab(names, emails, iduser)),
                    //           );
                    //         }, // button pressed
                    //         child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: <Widget>[
                    //             Icon(Icons.book, size: 30), // icon
                    //             Text(
                    //               "Alkitab",
                    //               style: TextStyle(
                    //                 fontSize: 12,
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //               textAlign: TextAlign.center,
                    //             ), // text
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
                        return ItemCard(
                            images: item.toString(),
                            captions:
                                caption[cardList.indexOf(item)].toString());
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ))
          ])),
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
