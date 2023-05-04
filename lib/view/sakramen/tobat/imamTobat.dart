import 'dart:async';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/view/sakramen/tobat/detailTobat.dart';

import '../../homePage.dart';
import '../../profile/profile.dart';
import '../../settings/setting.dart';
import '../../tiketSaya.dart';

class ImamTobat extends StatefulWidget {
  final iduser;
  final idGereja;
  ImamTobat(this.iduser, this.idGereja);
  @override
  _ImamTobat createState() => _ImamTobat(this.iduser, this.idGereja);
}

class _ImamTobat extends State<ImamTobat> {
  ///////////////////////////////////
  ////
  ///
  //////////Inisialisasi Variabel///////////
  var distance;
  List hasil = [];
  StreamController _controller = StreamController();
  ScrollController _scrollController = ScrollController();
  int data = 5;
  List dummyTemp = [];
  final iduser;
  final idGereja;
  _ImamTobat(this.iduser, this.idGereja);

  ///////////////////////Fungsi////////////////////////
  ///////////////////////Fungsi////////////////////////
  Future callDb() async {
    // return k;
    Completer<void> completer = Completer<void>(); //variabel untuk menunggu
    Messages message = Messages('Agent Page', 'Agent Pencarian', "REQUEST",
        Tasks('cari pelayanan', ["tobat", "imam", idGereja])); //Pembuatan pesan

    MessagePassing messagePassing =
        MessagePassing(); //Memanggil distributor pesan
    await messagePassing
        .sendMessage(message); //Mengirim pesan ke distributor pesan
    var hasilPencarian =
        await AgentPage.getData(); //Memanggil data yang tersedia di agen Page
    completer.complete(); //Batas pengerjaan yang memerlukan completer

    await completer
        .future; //Proses penungguan sudah selesai ketika varibel hasil
    //memiliki nilai
    return await hasilPencarian;
  }

  @override
  void initState() {
    //Saat kelas dipanggil fungsi ini akan dijalankan
    //untuk mendapatkan data halaman yang diperoleh
    //dari fungsi callDb
    super.initState();
    callDb().then((result) {
      setState(() {
        hasil.addAll(result); //variabel hasil akan bernilai hasil dari call db
        dummyTemp.addAll(
            result); //variabel dummyTemp akan bernilai hasil dari call db
        _controller.add(
            result); //variabel controller akan terisi yang menandakan streamer mendapatkan sinyal data
      });
    });
  }

  filterSearchResults(String query) {
    //Fungsi untuk melakukan filter data berdasarkan input pengguna
    //yang akan ditampilkan pada halaman
    if (query.isNotEmpty) {
      List<Map<String, dynamic>> listOMaps = <Map<String, dynamic>>[];
      //variabel untuk menyimpan data sementara

      for (var item in dummyTemp) {
        //Setiap isi pada variabel dummyTemp akan diiterasi dan dicari
        // berdasarkan parameter pencarian
        if (item['nama'].toLowerCase().contains(query.toLowerCase())) {
          listOMaps.add(item);
          //Jika terdapat data yang sama, maka dimasukan ke variabel lisOMaps
          //Jika terdapat data yang sama, maka dimasukan ke variabel lisOMaps
        }
      }
      setState(() {
        // Secara dinamis data pada halaman akan berubah, caranya
        // dengan menghapus seluruh nilai pada variabel hasil dan
        // mengganti nilai dari variabel hasil dengan
        // nilai pada variabel listOMaps
        hasil.clear();
        hasil.addAll(listOMaps);
      });
      return hasil; //Mengembalikan variabel hasil
    } else {
      //Jika tidak ada input dari user maka data akan dikembalikan seperti
      //semula secara dinamis
      setState(() {
        hasil.clear();
        hasil.addAll(dummyTemp);
      });
    }
  }

  Future pullRefresh() async {
    //Fungsi refresh halaman akan memanggil fungsi callDb
    callDb().then((result) {
      setState(() {
        //Pemanggilan fungsi secara dinamis agar halaman terupdate secara otomatis
        //Pada pemanggilan ini nilai pada variabel hasil dan dummyTemp dihapus semua
        //agar dapat diisi dengan data yang baru, dan jumlah data di set menjadi 5
        // secara default, lalu stream ditambah data agar mendapatkan sinyal
        data = 5;
        hasil.clear();
        dummyTemp.clear();
        hasil.clear();
        hasil.addAll(result);
        dummyTemp.addAll(result);
        _controller.add(result);
      });
    });
  }

  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _searchController.addListener(() {
      //Listener untuk mendengarkan setiap perubahan pada input field
      filterSearchResults(_searchController.text);
    });
    _scrollController.addListener(() {
      //Listener untuk mendeteksi jika pengguna sudah sampai batas bawah halaman
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          //Jika sudah sampai bawah halaman data akan ditambah 5 secara dinamis
          data = data + 5;
        });
      }
    });
    return Scaffold(
      // Widget untuk membangun struktur halaman
      //////////////////////////////////////Pembuatan Top Navigation Bar////////////////////////////////////////////////////////////////
      appBar: AppBar(
        // widget Top Navigation Bar
        shape: RoundedRectangleBorder(
          //Bentuk Top Navigation Bar: Rounded Rectangle
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text('Imam Tobat'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => profile(this.iduser)),
              );
            },
          ),
          IconButton(
            //Widget icon Setting
            icon: const Icon(Icons.settings),
            onPressed: () {
              //Jika ditekan akan mengarahkan ke halaman setting
              Navigator.push(
                //Widget navigator untuk memanggil kelas setting
                context,
                MaterialPageRoute(builder: (context) => Settings(iduser)),
              );
            },
          ),
        ],
      ),
//////////////////////////////////////Batas Akhir Pembuatan Top Navigation Bar//////////////////////////////////////////////////////////
      ///
//////
//////
//////////////////////////////////////Pembuatan Body Halaman////////////////////////////////////////////////////////////////
      body: RefreshIndicator(
        onRefresh: pullRefresh,
        child: ListView(
          controller: _scrollController,
          shrinkWrap: true,
          padding: EdgeInsets.only(right: 15, left: 15),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 10, left: 10),
              child: AnimSearchBar(
                autoFocus: false,
                width: 400,
                rtl: true,
                helpText: 'Cari Gereja',
                textController: _searchController,
                onSuffixTap: () {
                  setState(() {
                    _searchController.clear();
                  });
                },
              ),
            ),

            /////////
            StreamBuilder(
                stream: _controller.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  try {
                    return Column(children: [
                      for (var i in hasil.take(data))
                        InkWell(
                          borderRadius: new BorderRadius.circular(24),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => detailTobat(
                                      iduser, i['idGereja'], i['_id'])),
                            );
                          },
                          child: Container(
                              margin: EdgeInsets.only(
                                  right: 15, left: 15, bottom: 20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.topLeft,
                                    colors: [
                                      Colors.blueGrey,
                                      Colors.lightBlue,
                                    ]),
                                border: Border.all(
                                  color: Colors.lightBlue,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(children: <Widget>[
                                //Color(Colors.blue);

                                Text(
                                  i['nama'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  i['statusTobat'] == 0
                                      ? ' Status : Bersedia'
                                      : i['status'] == -1
                                          ? ' Status : Tidak Bersedia'
                                          : ' Status : Sedang Melakukan Pelayanan',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w300),
                                ),
                              ])),
                        ),
                    ]);
                  } catch (e) {
                    print(e);
                    return Center(child: CircularProgressIndicator());
                  }
                }),
            /////////
          ],
        ),
      ),
//////////////////////////////////////Batas Akhir Pembuatan Body Halaman/////////////////////////////////////////////////////////////
      ///
      ///
      ///
/////////////////////////////////////////////////////////Pembuatan Bottom Navigation Bar////////////////////////////////////////
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
                  //Jika item kedua ditekan maka akan memanggil kelas tiketSaya
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => tiketSaya(iduser)),
                  );
                } else if (index == 0) {
                  //Jika item pertama ditekan maka akan memanggil kelas homePage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => homePage(iduser)),
                  );
                }
              },
            ),
          )),
      /////////////////////////////////////////////////////////Batas Akhir Pembuatan Bottom Navigation Bar////////////////////////////////////////
    );
  }
}
