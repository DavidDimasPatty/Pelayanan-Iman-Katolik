// import 'dart:async';

// import 'package:anim_search_bar/anim_search_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
// import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
// import 'package:pelayanan_iman_katolik/agen/Task.dart';
// import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
// import 'package:pelayanan_iman_katolik/agen/Message.dart';
// import 'package:pelayanan_iman_katolik/view/sakramen/krisma/detailDaftarKrisma.dart';
// import 'package:pelayanan_iman_katolik/view/settings/setting.dart';

// import '../../homePage.dart';
// import '../../profile/profile.dart';
// import '../../tiketSaya.dart';

// class Krisma extends StatefulWidget {
//   final iduser;
//   Krisma(this.iduser);
//   @override
//   _Krisma createState() => _Krisma(this.iduser);
// }

// class _Krisma extends State<Krisma> {
//   ///////////////////////////////////
//   ////
//   ///
//   //////////Inisialisasi Variabel///////////
//   var distance;
//   List hasil = [];
//   StreamController _controller = StreamController();
//   ScrollController _scrollController = ScrollController();
//   int data = 5;
//   TextEditingController _searchController = TextEditingController();
//   List dummyTemp = [];
//   final iduser;
//   ///////////////////////////////////////////
//   ///
//   ///
//   ///
//   ///
//   _Krisma(this.iduser);

// ///////////////////////Fungsi////////////////////////
//   Future callDb() async {
//     Completer<void> completer = Completer<void>(); //variabel untuk menunggu
//     Messages message = Messages('Agent Page', 'Agent Pencarian', "REQUEST",
//         Tasks('cari pelayanan', ["krisma", "general"]));
//     MessagePassing messagePassing =
//         MessagePassing(); //Memanggil distributor pesan
//     await messagePassing
//         .sendMessage(message); //Mengirim pesan ke distributor pesan
//     var hasilPencarian =
//         await AgentPage.getData(); //Memanggil data yang tersedia di agen Page
//     completer.complete(); //Batas pengerjaan yang memerlukan completer

//     await completer
//         .future; //Proses penungguan sudah selesai ketika varibel hasil
//     //memiliki nilai
//     return await hasilPencarian;
//   }

//   @override
//   void initState() {
//     //Saat kelas dipanggil fungsi ini akan dijalankan
//     //untuk mendapatkan data halaman yang diperoleh
//     //dari fungsi callDb
//     super.initState();
//     callDb().then((result) {
//       setState(() {
//         hasil.addAll(result); //variabel hasil akan bernilai hasil dari call db
//         dummyTemp.addAll(
//             result); //variabel dummyTemp akan bernilai hasil dari call db
//         _controller.add(
//             result); //variabel controller akan terisi yang menandakan streamer mendapatkan sinyal data
//       });
//     });
//   }

//   Future jarak(lat, lang) async {
//     //Fungsi untuk menghitung jarak pengguna terhadap lokasi Gereja
//     //Berdasarkan GPS Device
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high); // Mendapatkan posisi pengguna

//     double distanceInMeters = Geolocator.distanceBetween(
//         lat, lang, position.latitude, position.longitude); //Mengkalkulasikan
//     //jarak antara pengguna dengan lokasi Gereja
//     if (distanceInMeters > 1000) {
//       //Jarak dijadikan KM atau M jika kurang dari 1 KM
//       distanceInMeters = distanceInMeters / 1000;
//       distance = distanceInMeters.toInt().toString() + " KM";
//     } else {
//       distance = distanceInMeters.toInt().toString() + " M";
//     }
//     return distance;
//   }

//   filterSearchResults(String query) {
//     //Fungsi untuk melakukan filter data berdasarkan input pengguna
//     //yang akan ditampilkan pada halaman
//     if (query.isNotEmpty) {
//       List<Map<String, dynamic>> listOMaps = <Map<String, dynamic>>[];
//       //variabel untuk menyimpan data sementara

//       for (var item in dummyTemp) {
//         //Setiap isi pada variabel dummyTemp akan diiterasi dan dicari
//         // berdasarkan parameter pencarian
//         if (item['GerejaKrisma'][0]['nama']
//             .toLowerCase()
//             .contains(query.toLowerCase())) {
//           listOMaps.add(item);
//           //Jika terdapat data yang sama, maka dimasukan ke variabel lisOMaps
//           //Jika terdapat data yang sama, maka dimasukan ke variabel lisOMaps
//         }
//       }
//       setState(() {
//         // Secara dinamis data pada halaman akan berubah, caranya
//         // dengan menghapus seluruh nilai pada variabel hasil dan
//         // mengganti nilai dari variabel hasil dengan
//         // nilai pada variabel listOMaps
//         hasil.clear();
//         hasil.addAll(listOMaps);
//       });
//     } else {
//       //Jika tidak ada input dari user maka data akan dikembalikan seperti
//       //semula secara dinamis
//       setState(() {
//         hasil.clear();
//         hasil.addAll(dummyTemp);
//       });
//     }
//   }

//   Future pullRefresh() async {
//     //Fungsi refresh halaman akan memanggil fungsi callDb
//     callDb().then((result) {
//       setState(() {
//         //Pemanggilan fungsi secara dinamis agar halaman terupdate secara otomatis
//         //Pada pemanggilan ini nilai pada variabel hasil dan dummyTemp dihapus semua
//         //agar dapat diisi dengan data yang baru, dan jumlah data di set menjadi 5
//         // secara default, lalu stream ditambah data agar mendapatkan sinyal
//         data = 5;
//         hasil.clear();
//         dummyTemp.clear();
//         hasil.clear();
//         hasil.addAll(result);
//         dummyTemp.addAll(result);
//         _controller.add(result);
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     _searchController.addListener(() {
//       //Listener untuk mendengarkan setiap perubahan pada input field
//       filterSearchResults(_searchController.text);
//     });
//     _scrollController.addListener(() {
//       //Listener untuk mendeteksi jika pengguna sudah sampai batas bawah halaman
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         setState(() {
//           //Jika sudah sampai bawah halaman data akan ditambah 5 secara dinamis
//           data = data + 5;
//         });
//       }
//     });
//     return Scaffold(
//       // Widget untuk membangun struktur halaman
//       //////////////////////////////////////Pembuatan Top Navigation Bar////////////////////////////////////////////////////////////////
//       appBar: AppBar(
//         // widget Top Navigation Bar
//         shape: RoundedRectangleBorder(
//           //Bentuk Top Navigation Bar: Rounded Rectangle
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
//         ),
//         title: Text('Pendaftaran Krisma'),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.account_circle_rounded),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => profile(this.iduser)),
//               );
//             },
//           ),
//           IconButton(
//             //Widget icon Setting
//             icon: const Icon(Icons.settings),
//             onPressed: () {
//               //Jika ditekan akan mengarahkan ke halaman setting
//               Navigator.push(
//                 //Widget navigator untuk memanggil kelas setting
//                 context,
//                 MaterialPageRoute(builder: (context) => Settings(iduser)),
//               );
//             },
//           ),
//         ],
//       ),
// //////////////////////////////////////Batas Akhir Pembuatan Top Navigation Bar//////////////////////////////////////////////////////////
//       ///
// //////
// //////
// //////////////////////////////////////Pembuatan Body Halaman////////////////////////////////////////////////////////////////
//       body: RefreshIndicator(
//         //Widget untuk refresh body halaman
//         onRefresh: pullRefresh,
//         //Ketika halaman direfresh akan memanggil fungsi pullRefresh
//         child: ListView(
//           //Widget ListView untuk wadah menampilkan data
//           controller: _scrollController,
//           //Controller untuk mendeteksi pergerakan pengguna pada listview
//           shrinkWrap: true,
//           //Memfitkan listview dengan halaman
//           padding: EdgeInsets.only(right: 15, left: 15),
//           children: <Widget>[
//             Padding(
//               padding: EdgeInsets.only(right: 10, left: 10),
//               child: AnimSearchBar(
//                 //Widget AnimSearchBar digunakan untuk menampilkan inputfield
//                 //yang dianimasikan pada halaman
//                 autoFocus: false,
//                 width: 400,
//                 rtl: true,
//                 helpText: 'Cari Gereja',
//                 textController: _searchController,
//                 onSuffixTap: () {
//                   setState(() {
//                     //Jika tombol pada widget ini ditekan maka isi dari variabel
//                     //searchContoller akan dihapus
//                     _searchController.clear();
//                   });
//                 },
//               ),
//             ),

//             StreamBuilder(
//                 //Widget stream untuk mendapatkan data jika variabel stream terdapat
//                 //penambahan data
//                 stream: _controller.stream,
//                 //inisialisasi variabel stream sebagai sinyal
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     //Jika terdapat error pada variabel stream
//                     //mengembalikan widget loading
//                     return Center(
//                       child: Text('Error: ${snapshot.error}'),
//                     );
//                   }
//                   try {
//                     return Column(children: [
//                       //Stream builder akan membangun widget Column dengan
//                       //komponen widget children didalamnya, jika tidak ada error
//                       for (var i in hasil.take(data))
//                         //Iterasi sebanyak nilai variabel data pada nilai hasil
//                         //Iterasi sebanyak data
//                         InkWell(
//                           //Widget InkWell agar widget Container bisa ditekan oleh pengguna
//                           borderRadius: new BorderRadius.circular(24),
//                           onTap: () {
//                             //Jika Container ditekan maka akan dipanggil kelas
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => detailDaftarKrisma(
//                                       iduser,
//                                       i['GerejaKrisma'][0]['_id'],
//                                       i['_id'])),
//                             );
//                           },
//                           child: Container(
//                               //Widget Container yang membungkus data yang ditampilkan
//                               // pada setiap iterasi
//                               margin: EdgeInsets.only(
//                                   right: 15, left: 15, bottom: 20),
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                     begin: Alignment.topRight,
//                                     end: Alignment.topLeft,
//                                     colors: [
//                                       Colors.blueGrey,
//                                       Colors.lightBlue,
//                                     ]),
//                                 border: Border.all(
//                                   color: Colors.lightBlue,
//                                 ),
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(10)),
//                               ),
//                               //Dekorasi Container(warna, bentuk, gradient, margin)
//                               child: Column(children: <Widget>[
//                                 //Didalam Container terdapat column agar
//                                 //data yang ditampilkan kebawah di dalam Container
//                                 //
//                                 //
//                                 ///Setiap data ditampilkan dalam widget Text
//                                 ///dan mempunyai dekorasi(ukuran, warna, posisi)

//                                 Text(
//                                   i['GerejaKrisma'][0]['nama'],
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 26.0,
//                                       fontWeight: FontWeight.w300),
//                                   textAlign: TextAlign.left,
//                                 ),
//                                 Text(
//                                   'Paroki: ' + i['GerejaKrisma'][0]['paroki'],
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 12),
//                                 ),
//                                 Text(
//                                   'Alamat: ' + i['GerejaKrisma'][0]['address'],
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 12),
//                                 ),
//                                 Text(
//                                   'Kapasitas Tersedia: ' +
//                                       i['kapasitas'].toString(),
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 12),
//                                 ),
//                                 Text(
//                                   'Jenis: ' + i['jenis'],
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 12),
//                                 ),
//                                 FutureBuilder(
//                                     //Widget FutureBuilder untuk mendapatkan data
//                                     //dari fungsi jarak
//                                     future: jarak(i['GerejaKrisma'][0]['lat'],
//                                         i['GerejaKrisma'][0]['lng']),
//                                     builder: (context, AsyncSnapshot snapshot) {
//                                       try {
//                                         return Column(children: <Widget>[
//                                           Text(
//                                             //Text yang berisi jarak pengguna dengan
//                                             //lokasi gereja

//                                             snapshot.data,
//                                             style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 12),
//                                           )
//                                         ]);
//                                       } catch (e) {
//                                         //Jika data error atau masih proses pengerjaan
//                                         print(e);
//                                         return Center(
//                                             child: CircularProgressIndicator());
//                                       }
//                                     }),
//                               ])),
//                         ),
//                     ]);
//                   } catch (e) {
//                     //Jika terdapat salah penunjukan key pada map saat
//                     //pengambilan data
//                     //mengembalikan widget loading
//                     print(e);
//                     return Center(child: CircularProgressIndicator());
//                   }
//                 }),
//             /////////
//           ],
//         ),
//       ),
// //////////////////////////////////////Batas Akhir Pembuatan Body Halaman/////////////////////////////////////////////////////////////
//       ///
//       ///
//       ///
// /////////////////////////////////////////////////////////Pembuatan Bottom Navigation Bar////////////////////////////////////////
//       bottomNavigationBar: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(30), topLeft: Radius.circular(30)),
//             boxShadow: [
//               BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(30.0),
//               topRight: Radius.circular(30.0),
//             ),
//             child: BottomNavigationBar(
//               type: BottomNavigationBarType.fixed,
//               showUnselectedLabels: true,
//               unselectedItemColor: Colors.blue,
//               items: <BottomNavigationBarItem>[
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.home, color: Color.fromARGB(255, 0, 0, 0)),
//                   label: "Home",
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.token, color: Color.fromARGB(255, 0, 0, 0)),
//                   label: "Jadwalku",
//                 )
//               ],
//               onTap: (index) {
//                 if (index == 1) {
//                   //Jika item kedua ditekan maka akan memanggil kelas tiketSaya
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => tiketSaya(iduser, "current")),
//                   );
//                 } else if (index == 0) {
//                   //Jika item pertama ditekan maka akan memanggil kelas homePage
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => homePage(iduser)),
//                   );
//                 }
//               },
//             ),
//           )),
//       /////////////////////////////////////////////////////////Batas Akhir Pembuatan Bottom Navigation Bar////////////////////////////////////////
//     );
//   }
// }
