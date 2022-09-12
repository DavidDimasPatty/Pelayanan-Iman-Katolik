import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/detailDaftarKomuni.dart';
import 'package:pelayanan_iman_katolik/detailDaftarMisa.dart';
import 'package:pelayanan_iman_katolik/profile.dart';
import 'package:pelayanan_iman_katolik/setting.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
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
  bool ddalkitab = false;
  bool ddbab = false;
  bool isLoading = false;
  bool isLoadingText = false;
  var dropdownvalue = "Kejadian";
  var dropdownbab = 1;
  var dropdownverse = 1;
  final scrollDirection = Axis.vertical;

  late AutoScrollController controller;
  bool _folded = true;
  int size = 0;
  List<Map<String, dynamic>> textAlkitab = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> judulAlkitab = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> verseAlkitab = <Map<String, dynamic>>[];
  List<String> book = [];
  List<int> bab = [];
  List<int> verse = [];
  Future loadAlkitab() async {
    final url = Uri.parse(
        "https://api-alkitab.herokuapp.com/v3/passage/Kejadian/1?ver=tb");
    var response = await http.get(
      url,
    );
    return response;
  }

  Future loadBab() async {
    final url = Uri.parse("https://api-alkitab.herokuapp.com/v2/passage/list");
    var response = await http.get(
      url,
    );
    return response;
  }

  Future loadSearch() async {
    setState(() {
      isLoadingText = true;
    });

    final url = Uri.parse("https://api-alkitab.herokuapp.com/v2/passage/" +
        dropdownvalue +
        "/" +
        (int.parse(dropdownbab.toString())).toString() +
        "?ver=tb");
    var response = await http.get(
      url,
    );
    Map<String, dynamic> jsonResponse =
        new Map<String, dynamic>.from(json.decode(response.body));

    setState(() {
      textAlkitab.clear();
      textAlkitab.add(jsonResponse);
      size = textAlkitab[0]['verses'].length;
      isLoadingText = false;
      print(textAlkitab[0]);
    });
    print(size);
  }

  Future loadVerse() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse("https://api-alkitab.herokuapp.com/v2/passage/" +
        dropdownvalue +
        "/" +
        (int.parse(dropdownbab.toString()) - 1).toString() +
        "?ver=tb");
    var response = await http.get(
      url,
    );
    Map<String, dynamic> jsonResponse =
        new Map<String, dynamic>.from(json.decode(response.body));

    verseAlkitab.add(jsonResponse);
    var sizeAll = verseAlkitab[0]['verses'].length;
    setState(() {
      isLoading = false;
      for (int i = 0; i < sizeAll; i++) {
        verse.add(i + 1);
      }
    });

    print(verse);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoadingText = true;
    });
    loadBab().then((response) {
      Map<String, dynamic> jsonResponse =
          new Map<String, dynamic>.from(json.decode(response.body));

      setState(() {
        judulAlkitab.add(jsonResponse);
        var sizeAll = judulAlkitab[0]['passage_list'].length;
        print(sizeAll);
        for (int i = 0; i < sizeAll; i++) {
          book.add(judulAlkitab[0]['passage_list'][i]['book_name']);
        }
        print(book);
      });
    });

    loadAlkitab().then((response) {
      Map<String, dynamic> jsonResponse =
          new Map<String, dynamic>.from(json.decode(response.body));

      setState(() {
        textAlkitab.add(jsonResponse);
        isLoadingText = false;
        print(textAlkitab[0]);
        size = textAlkitab[0]['verses'].length;
      });
    });

    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
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
      body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          shrinkWrap: true,
          scrollDirection: scrollDirection,
          controller: controller,
          children: [
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
                    height: _folded ? 56 : 220,
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
                                    // items: null,
                                    items: book.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    // After selecting the desired option,it will
                                    // change button value to selected value
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        bab.clear();
                                        dropdownverse = 1;
                                        dropdownbab = 1;
                                        int sizebab = judulAlkitab[0]
                                                    ['passage_list'][
                                                book.indexOf(
                                                    newValue.toString())]
                                            ['total_chapter'];
                                        for (int i = 0; i < sizebab; i++) {
                                          bab.add(i + 1);
                                        }
                                        ddalkitab = true;
                                        ddbab = false;
                                        dropdownvalue = newValue!;
                                      });
                                    },
                                  ),
                                  DropdownButton(
                                    // Initial Value
                                    value: dropdownbab,

                                    // Down Arrow Icon
                                    icon: const Icon(Icons.keyboard_arrow_down),

                                    // Array list of items
                                    items: bab.map((int items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items.toString()),
                                      );
                                    }).toList(),
                                    // After selecting the desired option,it will
                                    // change button value to selected value
                                    onChanged: ddalkitab
                                        ? (int? newValue) {
                                            setState(() {
                                              ddbab = true;
                                              verse.clear();
                                              ddbab = true;
                                              loadVerse();

                                              dropdownbab = newValue!;
                                            });
                                          }
                                        : null,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  isLoading
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : DropdownButton(
                                          // Initial Value
                                          value: dropdownverse,
                                          // Down Arrow Icon
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),

                                          // Array list of items

                                          items: verse.map((int items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items.toString()),
                                            );
                                          }).toList(),
                                          // }).toList(),
                                          // After selecting the desired option,it will
                                          // change button value to selected value
                                          onChanged: ddbab
                                              ? (int? newValue) {
                                                  setState(() {
                                                    dropdownverse = newValue!;
                                                  });
                                                }
                                              : null,
                                        ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blueAccent,
                                          borderRadius:
                                              BorderRadius.circular(32),
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
                                    onTap: () async {
                                      await loadSearch();

                                      setState(() {
                                        _folded = !_folded;
                                        controller.scrollToIndex(dropdownverse,
                                            preferPosition:
                                                AutoScrollPosition.middle);
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
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
            isLoadingText
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      for (int i = 0; i < size; i++)
                        AutoScrollTag(
                          key: ValueKey(i),
                          controller: controller,
                          index: i,
                          child: i == dropdownverse - 1
                              ? Container(
                                  color: Colors.yellowAccent,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          textAlkitab[0]['verses'][i]['verse']
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFeatures: [
                                              FontFeature.enable('sups'),
                                            ],
                                          ),
                                        ),
                                        Text("   " +
                                            textAlkitab[0]['verses'][i]
                                                ['content'])
                                      ]))
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Text(
                                        textAlkitab[0]['verses'][i]['verse']
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFeatures: [
                                            FontFeature.enable('sups'),
                                          ],
                                        ),
                                      ),
                                      Text("   " +
                                          textAlkitab[0]['verses'][i]
                                              ['content'])
                                    ]),
                        )
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
