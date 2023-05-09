// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/material.dart';
// import 'package:pelayanan_iman_katolik/view/umum/pendalamanAlkitab/pendalamanAlkitab.dart';
// import 'package:pelayanan_iman_katolik/view/umum/rekoleksi/rekoleksi.dart';
// import 'package:pelayanan_iman_katolik/view/umum/retret/retret.dart';

// import '../homePage.dart';
// import '../profile/profile.dart';
// import '../tiketSaya.dart';

// class Umum extends StatelessWidget {
//   final iduser;
//   Umum(this.iduser);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Widget untuk membangun struktur halaman
//       //////////////////////////////////////Pembuatan Top Navigation Bar////////////////////////////////////////////////////////////////
//       appBar: AppBar(
//         // widget Top Navigation Bar
//         title: Text('Umum'),
//         shape: RoundedRectangleBorder(
//           //Bentuk Top Navigation Bar: Rounded Rectangle
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
//         ),
//         actions: <Widget>[
//           //Tombol Top Navigation Bar
//           IconButton(
//             //Widget icon profile
//             icon: const Icon(Icons.account_circle_rounded),
//             onPressed: () {
//               //Jika ditekan akan mengarahkan ke halaman profile
//               Navigator.push(
//                 //Widget navigator untuk memanggil kelas profile
//                 context,
//                 MaterialPageRoute(builder: (context) => profile(iduser)),
//               );
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.settings),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: ListView(
//         shrinkWrap: true,
//         padding: EdgeInsets.only(right: 15, left: 15),
//         children: <Widget>[
//           Padding(padding: EdgeInsets.symmetric(vertical: 10)),
//           InkWell(
//             borderRadius: new BorderRadius.circular(24),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => PendalamanAlkitab(iduser)),
//               );
//             },
//             child: Container(
//                 margin: EdgeInsets.only(right: 15, left: 15, bottom: 20),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                       begin: Alignment.topRight,
//                       end: Alignment.topLeft,
//                       colors: [
//                         Colors.blueGrey,
//                         Colors.lightBlue,
//                       ]),
//                   border: Border.all(
//                     color: Colors.lightBlue,
//                   ),
//                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                 ),
//                 child: Text(
//                   'Pendalaman Kitab Suci',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 26.0,
//                       fontWeight: FontWeight.w300),
//                   textAlign: TextAlign.center,
//                 )),
//           ),
//           InkWell(
//             borderRadius: new BorderRadius.circular(24),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => Rekoleksi(iduser)),
//               );
//             },
//             child: Container(
//                 margin: EdgeInsets.only(right: 15, left: 15, bottom: 20),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                       begin: Alignment.topRight,
//                       end: Alignment.topLeft,
//                       colors: [
//                         Colors.blueGrey,
//                         Colors.lightBlue,
//                       ]),
//                   border: Border.all(
//                     color: Colors.lightBlue,
//                   ),
//                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                 ),
//                 child: Text(
//                   'Rekoleksi',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 26.0,
//                       fontWeight: FontWeight.w300),
//                   textAlign: TextAlign.center,
//                 )),
//           ),
//           InkWell(
//             borderRadius: new BorderRadius.circular(24),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => Retret(iduser)),
//               );
//             },
//             child: Container(
//                 margin: EdgeInsets.only(right: 15, left: 15, bottom: 20),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                       begin: Alignment.topRight,
//                       end: Alignment.topLeft,
//                       colors: [
//                         Colors.blueGrey,
//                         Colors.lightBlue,
//                       ]),
//                   border: Border.all(
//                     color: Colors.lightBlue,
//                   ),
//                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                 ),
//                 child: Text(
//                   'Retret',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 26.0,
//                       fontWeight: FontWeight.w300),
//                   textAlign: TextAlign.center,
//                 )),
//           ),
//         ],
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
//           //Dekorasi Kontainer pada Bottom Navigation Bar : posisi, bentuk, dan bayangan.
//           child: ClipRRect(
//             //Membentuk posisi Bottom Navigation Bar agar bisa dipasangkan menu
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(30.0),
//               topRight: Radius.circular(30.0),
//             ),
//             child: BottomNavigationBar(
//               //Widget untuk membuat tampilan Bottom Navigation Bar
//               type: BottomNavigationBarType.fixed,
//               showUnselectedLabels: true,
//               unselectedItemColor: Colors.blue,
//               //Konfigurasi Bottom Navigation Bar
//               items: <BottomNavigationBarItem>[
//                 //Item yang terdapat pada Bottom Navigation Bar
//                 //Berisikan icon dan label
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.home),
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
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => homePage(iduser)),
//                   );
//                 }
//               },
//             ),
//           )),
//     );
//   }
// }
