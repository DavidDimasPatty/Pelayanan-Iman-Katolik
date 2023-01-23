import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/messages.dart';
import 'package:pelayanan_iman_katolik/history.dart';
import 'package:pelayanan_iman_katolik/login.dart';
import 'package:pelayanan_iman_katolik/setting.dart';
import 'DatabaseFolder/fireBase.dart';
import 'homePage.dart';
import 'tiketSaya.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  final name;
  final email;
  final idUser;
  Profile(this.name, this.email, this.idUser);

  _Profile createState() => _Profile(this.name, this.email, this.idUser);
}

class _Profile extends State<Profile> {
  final name;
  final email;
  final idUser;
  var dataUser;
  var totalGereja;

  Future selectFile(context) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    File file;
    final path = result.files.single.path;
    file = File(path!);
    uploadFile(file, context);
  }

  Future<List> callDb() async {
    Messages msg = new Messages();
    msg.addReceiver("agenPencarian");
    msg.setContent([
      ["cari tampilan Profile"],
      [idUser]
    ]);
    List k = [];
    await msg.send().then((res) async {
      print("masuk");
      print(await AgenPage().receiverTampilan());
    });
    await Future.delayed(Duration(seconds: 1));
    k = await AgenPage().receiverTampilan();

    return k;
  }

  Future uploadFile(File file, context) async {
    if (file == null) return;
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    final filename = date.toString();
    final destination = 'files/$filename';
    UploadTask? task = FirebaseApi.uploadFile(destination, file);
    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    await MongoDatabase.updateProfilePicture(idUser, urlDownload).then((value) {
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Profile(name, email, idUser)),
      );
    });

    //print('Download-Link: $urlDownload');
  }

  _Profile(this.name, this.email, this.idUser);
  Future pullRefresh() async {
    setState(() {
      callDb();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: const Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Settings(name, email, idUser)),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
          onRefresh: pullRefresh,
          child: ListView(
            children: <Widget>[
              FutureBuilder<List>(
                  future: callDb(),
                  builder: (context, AsyncSnapshot snapshot) {
                    try {
                      // print("work");
                      // print(snapshot.data[0][0]);
                      return Column(children: <Widget>[
                        Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                        Column(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 10)),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.blueAccent,
                                            Colors.lightBlue,
                                          ]),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0.0, 1.0), //(x,y)
                                          blurRadius: 6.0,
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      width: 350.0,
                                      height: 350.0,
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            if (snapshot.data[0][0][0]
                                                    ['picture'] ==
                                                null)
                                              CircleAvatar(
                                                backgroundImage: AssetImage(''),
                                                backgroundColor:
                                                    Colors.greenAccent,
                                                radius: 80.0,
                                              ),
                                            if (snapshot.data[0][0][0]
                                                    ['picture'] !=
                                                null)
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    snapshot.data[0][0][0]
                                                        ['picture']),
                                                backgroundColor:
                                                    Colors.greenAccent,
                                                radius: 80.0,
                                              ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Text(
                                              snapshot.data[0][0][0]['name'],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 20.0,
                                                  vertical: 5.0),
                                              clipBehavior: Clip.antiAlias,
                                              color: Colors.white,
                                              elevation: 20.0,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 7.0,
                                                        vertical: 22.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Column(
                                                        children: <Widget>[
                                                          Text(
                                                            "Kunjungan Gereja Terdaftar :",
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .redAccent,
                                                              fontSize: 20.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          Text(
                                                            snapshot.data[1][0]
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 20.0,
                                                              color: Colors
                                                                  .pinkAccent,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ))),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 35.0, horizontal: 16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "User Information:",
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 18.0),
                                    ),
                                    SizedBox(
                                      height: 18.0,
                                    ),

                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "Email: ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black,
                                            letterSpacing: 2.0,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data[0][0][0]['email'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black,
                                            letterSpacing: 2.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 12),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "Address: ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black,
                                            letterSpacing: 2.0,
                                          ),
                                        ),
                                        Text(
                                          " ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black,
                                            letterSpacing: 2.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 12),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "Phone Number: ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black,
                                            letterSpacing: 2.0,
                                          ),
                                        ),
                                        Text(
                                          " ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black,
                                            letterSpacing: 2.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Text(
                                    //   'My name is Alice and I am  a freelance mobile app developper.\n'
                                    //   'if you need any mobile app for your company then contact me for more informations',
                                    //   style: TextStyle(
                                    //     fontSize: 14,
                                    //     fontStyle: FontStyle.italic,
                                    //     fontWeight: FontWeight.w300,
                                    //     color: Colors.black,
                                    //     letterSpacing: 2.0,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              width: 300.00,
                              child: RaisedButton(
                                  onPressed: () async {
                                    await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);
                                    await selectFile(context);
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(80.0)),
                                  elevation: 0.0,
                                  padding: EdgeInsets.all(0.0),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.topLeft,
                                          colors: [
                                            Colors.blueAccent,
                                            Colors.lightBlue,
                                          ]),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: 300.0, minHeight: 50.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Change Profile Picture",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 26.0,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  )),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 10)),
                            Container(
                              width: 300.00,
                              child: RaisedButton(
                                  onPressed: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              history(name, email, idUser)),
                                    );
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(80.0)),
                                  elevation: 0.0,
                                  padding: EdgeInsets.all(0.0),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.topLeft,
                                          colors: [
                                            Colors.blueAccent,
                                            Colors.lightBlue,
                                          ]),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: 300.0, minHeight: 50.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "History Pendaftaran",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 26.0,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  )),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 25)),
                          ],
                        )
                      ]);
                    } catch (e) {
                      print(e);
                      return Center(child: CircularProgressIndicator());
                    }
                  })
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
//  return Column(children: <Widget>[
//                     Padding(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//                     ),
//                     if (snapshot.data[0]['picture'] == null)
//                       CircleAvatar(
//                         backgroundImage: AssetImage(''),
//                         backgroundColor: Colors.greenAccent,
//                         radius: 120,
//                       ),
//                     if (snapshot.data[0]['picture'] != null)
//                       CircleAvatar(
//                         backgroundImage:
//                             NetworkImage(snapshot.data[0]['picture']),
//                         backgroundColor: Colors.greenAccent,
//                         radius: 120,
//                       ),
//                     Padding(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//                     ),
//                     Text(
//                       'User Information',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Padding(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//                     ),
//                     Row(
//                       children: <Widget>[
//                         Text("Nama: "),
//                         Text(snapshot.data[0]['name']),
//                       ],
//                     ),
//                     Padding(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//                     ),
//                     Row(
//                       children: <Widget>[
//                         Text("Email: "),
//                         Text(snapshot.data[0]['email']),
//                       ],
//                     ),
//                     Padding(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//                     ),
//                     Row(
//                       children: <Widget>[
//                         Text("Address: "),
//                         Text(" "),
//                       ],
//                     ),
//                     Padding(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//                     ),
//                     Row(
//                       children: <Widget>[
//                         Text("Phone Number: "),
//                         Text(" "),
//                       ],
//                     ),
//                     Padding(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//                     ),
//                     RaisedButton(
//                         child: Text("Change Profile Picture"),
//                         textColor: Colors.white,
//                         color: Colors.blueAccent,
//                         onPressed: () async {
//                           //await ImagePicker().pickImage(source: ImageSource.gallery);
//                           await selectFile(context);
//                         }),
//                   ]);
