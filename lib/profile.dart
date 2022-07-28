import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/login.dart';
import 'package:pelayanan_iman_katolik/setting.dart';
import 'DatabaseFolder/fireBase.dart';
import 'homePage.dart';
import 'tiketSaya.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Profile extends StatelessWidget {
  final name;
  final email;
  final idUser;
  var dataUser;

  Future selectFile(context) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    File file;
    final path = result.files.single.path;
    file = File(path!);
    uploadFile(file, context);
  }

  Future<List> callDb() async {
    dataUser = await MongoDatabase.getDataUser(idUser);
    return dataUser;
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

  Profile(this.name, this.email, this.idUser);

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
      body: Center(
          child: Column(
        children: <Widget>[
          FutureBuilder<List>(
              future: callDb(),
              builder: (context, AsyncSnapshot snapshot) {
                try {
                  return Column(children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    ),
                    if (snapshot.data[0]['picture'] == null)
                      CircleAvatar(
                        backgroundImage: AssetImage(''),
                        backgroundColor: Colors.greenAccent,
                        radius: 120,
                      ),
                    if (snapshot.data[0]['picture'] != null)
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(snapshot.data[0]['picture']),
                        backgroundColor: Colors.greenAccent,
                        radius: 120,
                      ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    ),
                    Text(
                      'User Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    ),
                    Row(
                      children: <Widget>[
                        Text("Nama: "),
                        Text(snapshot.data[0]['name']),
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    ),
                    Row(
                      children: <Widget>[
                        Text("Email: "),
                        Text(snapshot.data[0]['email']),
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    ),
                    Row(
                      children: <Widget>[
                        Text("Address: "),
                        Text(" "),
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    ),
                    Row(
                      children: <Widget>[
                        Text("Phone Number: "),
                        Text(" "),
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    ),
                    RaisedButton(
                        child: Text("Change Profile Picture"),
                        textColor: Colors.white,
                        color: Colors.blueAccent,
                        onPressed: () async {
                          //await ImagePicker().pickImage(source: ImageSource.gallery);
                          await selectFile(context);
                        }),
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
