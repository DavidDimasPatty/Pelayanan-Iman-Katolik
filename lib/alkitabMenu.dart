import 'dart:convert';
import 'dart:ui';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/detailDaftarKomuni.dart';
import 'package:pelayanan_iman_katolik/detailDaftarMisa.dart';
import 'package:pelayanan_iman_katolik/profile.dart';
import 'package:pelayanan_iman_katolik/setting.dart';
import 'tiketSaya.dart';
import 'homePage.dart';
import 'package:http/http.dart' as http;

class Alkitab extends StatefulWidget {
  var names;
  var emails;
  final idUser;

  Alkitab(this.names, this.emails, this.idUser);
  _Alkitab createState() => _Alkitab(this.names, this.emails, this.idUser);
}

class _Alkitab extends State<Alkitab> {
  var dropdownvalue = "Kejadian";
  var injil = [
    "Kejadian",
    "Keluaran",
    "Imamat",
    "Bilangan",
    "Ulangan",
    "Yosua",
    "Hakim-Hakim",
    "Rut",
    "1 Samuel",
    "2 Samuel",
    "1 Raja-Raja",
    "2 Raja-Raja",
    "1 Tawarikh",
    "2 Tawarikh",
    "Ezra",
    "Nehemia",
    "Ester",
    "Ayub",
    "Mazmur",
    "Amsal",
    "Pengkhotbah",
    "Kidung Agung",
    "Yesaya",
    "Yeremia",
    "Ratapan",
    "Yehezkiel",
    "Daniel",
    "Hosea",
    "Yoel",
    "Amos",
    "Obaja",
    "Yunus",
    "Mikha",
    "Nahum",
    "Habakuk",
    "Zefanya",
    "Hagai",
    "Maleakhi",
    "Matius",
    "Markus",
    "Lukas",
    "Yohanes",
    "Kisah Para Rasul",
    "Roma",
    "1 Korintus",
    "2 Korintus",
    "Galatia",
    "Efesus",
    "Filipi",
    "Kolose",
    "1 Tesalonika",
    "2 Tesalonika",
    "1 Timotius",
    "2 Timotius",
    "Titus",
    "Filemon",
    "Ibrani",
    "Yakobus",
    "1 Petrus",
    "2 Petrus",
    "1 Yohanes",
    "2 Yohanes",
    "3 Yohanes",
    "Yudas",
    "Wahyu",
  ];
  bool _folded = true;
  int size = 0;
  List<Map<String, dynamic>> textAlkitab = <Map<String, dynamic>>[];
  Future loadAlkitab() async {
    final url = Uri.parse(
        "https://api-alkitab.herokuapp.com/v3/passage/Kejadian/1?ver=tb");
    var response = await http.get(
      url,
    );
    return response;
  }

  @override
  void initState() {
    super.initState();
    loadAlkitab().then((response) {
      Map<String, dynamic> jsonResponse =
          new Map<String, dynamic>.from(json.decode(response.body));

      setState(() {
        textAlkitab.add(jsonResponse);
        print(textAlkitab[0]);
        size = textAlkitab[0]['verses'].length;
      });
    });
  }

  var names;
  var emails;
  final idUser;
  _Alkitab(this.names, this.emails, this.idUser);

  TextEditingController editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text('Alkitab'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Profile(names, emails, idUser)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Settings(names, emails, idUser)),
              );
            },
          ),
        ],
      ),
      body: ListView(padding: EdgeInsets.symmetric(horizontal: 20), children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _folded = !_folded;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 400),
                width: _folded ? 56 : 200,
                height: _folded ? 56 : 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: Colors.white,
                    boxShadow: kElevationToShadow[6]),
                child: Row(children: [
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.only(left: 16),
                    child: _folded
                        ? Text("Cari Ayat Alkitab")
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              DropdownButton(
                                // Initial Value
                                value: dropdownvalue,

                                // Down Arrow Icon
                                icon: const Icon(Icons.keyboard_arrow_down),

                                // Array list of items
                                items: injil.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownvalue = newValue!;
                                  });
                                },
                              ),
                              DropdownButton(
                                // Initial Value
                                value: dropdownvalue,

                                // Down Arrow Icon
                                icon: const Icon(Icons.keyboard_arrow_down),

                                // Array list of items
                                items: injil.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownvalue = newValue!;
                                  });
                                },
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  SizedBox(
                                    width: 80.0,
                                    child: DropdownButton(
                                      isExpanded: true,
                                      // Initial Value
                                      value: dropdownvalue,

                                      // Down Arrow Icon
                                      // icon: const Icon(Icons.keyboard_arrow_down),

                                      // Array list of items
                                      items: injil.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                      // After selecting the desired option,it will
                                      // change button value to selected value
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownvalue = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40.0,
                                  ),
                                  SizedBox(
                                    width: 80.0,
                                    child: DropdownButton(
                                      isExpanded: true,
                                      // Initial Value
                                      value: dropdownvalue,

                                      // Down Arrow Icon
                                      // icon: const Icon(Icons.keyboard_arrow_down),

                                      // Array list of items
                                      items: injil.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                      // After selecting the desired option,it will
                                      // change button value to selected value
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownvalue = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(32),
                                      boxShadow: kElevationToShadow[6]),
                                  child: Center(
                                    child: Text(
                                      "Cari",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  width: 40,
                                  height: 30,
                                ),
                                onTap: () {
                                  setState(() {
                                    _folded = !_folded;
                                  });
                                },
                              )
                            ],
                          ),
                  )),
                  AnimatedContainer(
                      duration: Duration(milliseconds: 400),
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.search,
                            color: Colors.blue[900],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _folded = !_folded;
                          });
                        },
                      ))
                ]),
              ),
            )),
        for (int i = 0; i < size; i++)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textAlkitab[0]['verses'][i]['verse'].toString(),
                style: TextStyle(
                  fontSize: 13,
                  fontFeatures: [
                    FontFeature.enable('sups'),
                  ],
                ),
              ),
              Text("   " + textAlkitab[0]['verses'][i]['content'])
            ],
          ),
        Padding(padding: EdgeInsets.symmetric(vertical: 20))
      ]),
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
                        builder: (context) => tiketSaya(names, emails, idUser)),
                  );
                } else if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(names, emails, idUser)),
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
