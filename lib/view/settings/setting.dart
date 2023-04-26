import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';

import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';

import 'package:pelayanan_iman_katolik/view/settings/gantiPasword.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pelayanan_iman_katolik/view/settings/aboutus.dart';
import 'package:pelayanan_iman_katolik/view/settings/customerService.dart';
import 'dart:io';

import 'package:pelayanan_iman_katolik/view/settings/privacySafety.dart';
import 'package:pelayanan_iman_katolik/view/settings/termsCondition.dart';

import '../homePage.dart';
import '../logIn.dart';
import '../profile/profile.dart';
import '../tiketSaya.dart';

class Settings extends StatelessWidget {
  final iduser;

  Future LogOut(context) async {
    Completer<void> completer = Completer<void>();
    Messages message = Messages(
        'Agent Page', 'Agent Akun', "REQUEST", Tasks('log out', iduser));

    MessagePassing messagePassing = MessagePassing();
    await messagePassing.sendMessage(message);
    var hasil = await await AgentPage.getData();
    completer.complete();

    await completer.future;
    if (hasil == 'oke') {
      Fluttertoast.showToast(
          msg: "Berhasil Log Out",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => logIn()),
      );
    }
  }

  Settings(this.iduser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              Navigator.push(
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
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => privacySafety(this.iduser)));
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                elevation: 10.0,
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
                        maxWidth: double.maxFinite, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Privacy & Safety",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26.0,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                )),
            Padding(padding: EdgeInsets.symmetric(vertical: 14)),
            // RaisedButton(
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => termsCondition(this.iduser)));
            //     },
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(80.0)),
            //     elevation: 10.0,
            //     padding: EdgeInsets.all(0.0),
            //     child: Ink(
            //       decoration: BoxDecoration(
            //         gradient: LinearGradient(
            //             begin: Alignment.topRight,
            //             end: Alignment.topLeft,
            //             colors: [
            //               Colors.blueAccent,
            //               Colors.lightBlue,
            //             ]),
            //         borderRadius: BorderRadius.circular(30.0),
            //       ),
            //       child: Container(
            //         constraints: BoxConstraints(
            //             maxWidth: double.maxFinite, minHeight: 50.0),
            //         alignment: Alignment.center,
            //         child: Text(
            //           "Terms & Conditions",
            //           style: TextStyle(
            //               color: Colors.white,
            //               fontSize: 26.0,
            //               fontWeight: FontWeight.w300),
            //         ),
            //       ),
            //     )),
            // Padding(padding: EdgeInsets.symmetric(vertical: 14)),
            // RaisedButton(
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => aboutus(this.iduser)));
            //     },
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(80.0)),
            //     elevation: 10.0,
            //     padding: EdgeInsets.all(0.0),
            //     child: Ink(
            //       decoration: BoxDecoration(
            //         gradient: LinearGradient(
            //             begin: Alignment.topRight,
            //             end: Alignment.topLeft,
            //             colors: [
            //               Colors.blueAccent,
            //               Colors.lightBlue,
            //             ]),
            //         borderRadius: BorderRadius.circular(30.0),
            //       ),
            //       child: Container(
            //         constraints: BoxConstraints(
            //             maxWidth: double.maxFinite, minHeight: 50.0),
            //         alignment: Alignment.center,
            //         child: Text(
            //           "About Us",
            //           style: TextStyle(
            //               color: Colors.white,
            //               fontSize: 26.0,
            //               fontWeight: FontWeight.w300),
            //         ),
            //       ),
            //     )),
            // Padding(padding: EdgeInsets.symmetric(vertical: 14)),

            // RaisedButton(
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => customerService(this.iduser)));
            //     },
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(80.0)),
            //     elevation: 10.0,
            //     padding: EdgeInsets.all(0.0),
            //     child: Ink(
            //       decoration: BoxDecoration(
            //         gradient: LinearGradient(
            //             begin: Alignment.topRight,
            //             end: Alignment.topLeft,
            //             colors: [
            //               Colors.blueAccent,
            //               Colors.lightBlue,
            //             ]),
            //         borderRadius: BorderRadius.circular(30.0),
            //       ),
            //       child: Container(
            //         constraints: BoxConstraints(
            //             maxWidth: double.maxFinite, minHeight: 50.0),
            //         alignment: Alignment.center,
            //         child: Text(
            //           "Customer Service",
            //           style: TextStyle(
            //               color: Colors.white,
            //               fontSize: 26.0,
            //               fontWeight: FontWeight.w300),
            //         ),
            //       ),
            //     )),
            // Padding(padding: EdgeInsets.symmetric(vertical: 14)),
            RaisedButton(
                onPressed: () async {
                  await LogOut(context);
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => logIn()),
                  // );
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                elevation: 10.0,
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
                        maxWidth: double.maxFinite, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Log Out",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26.0,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                )),

            /////////
          ],
        )
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
                    MaterialPageRoute(builder: (context) => tiketSaya(iduser)),
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
