// import 'dart:async';

// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
// import 'package:pelayanan_iman_katolik/agen/Task.dart';
// import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
// import 'package:pelayanan_iman_katolik/agen/Message.dart';
// import 'package:pelayanan_iman_katolik/view/homePage.dart';
// import 'package:pelayanan_iman_katolik/view/profile/profile.dart';
// import 'package:pelayanan_iman_katolik/view/sakramentali/pemberkatan.dart';
// import 'package:pelayanan_iman_katolik/view/tiketSaya.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import 'package:flutter/material.dart';

// class FormulirPemberkatan extends StatefulWidget {
//   final iduser;
//   final idGereja;
//   final idImam;

//   FormulirPemberkatan(this.iduser, this.idGereja, this.idImam);
//   @override
//   _FormulirPemberkatan createState() =>
//       _FormulirPemberkatan(this.iduser, this.idGereja, this.idImam);
// }

// class _FormulirPemberkatan extends State<FormulirPemberkatan> {
//   final iduser;
//   final idGereja;
//   final idImam;
//   var ready = false;
//   _FormulirPemberkatan(this.iduser, this.idGereja, this.idImam);

//   @override
//   var jenisPemberkatan = ['Gedung', 'Rumah', 'Barang', 'Doa Arwah'];
//   // var selectedJenis;
//   String ddValue = "Gedung";
//   // var dateValue;
//   TextEditingController namaController = new TextEditingController();
//   TextEditingController parokiController = new TextEditingController();
//   TextEditingController lingkunganController = new TextEditingController();
//   TextEditingController notelpController = new TextEditingController();
//   TextEditingController alamatController = new TextEditingController();
//   TextEditingController noteController = new TextEditingController();
//   String _selectedDate = '';

//   void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
//     setState(() {
//       if (args.value is DateTime) {
//         _selectedDate = args.value.toString();
//       }
//     });
//   }

// ///////////////////////Fungsi////////////////////////
//   Future callDb() async {
//     Completer<void> completer = Completer<void>(); //variabel untuk menunggu
//     Messages message = Messages(
//         'Agent Page',
//         'Agent Pencarian',
//         "REQUEST",
//         Tasks('cari pelayanan',
//             ["sakramentali", "detail", idGereja])); //Pembuatan pesan

//     MessagePassing messagePassing =
//         MessagePassing(); //Memanggil distributor pesan
//     await messagePassing
//         .sendMessage(message); //Mengirim pesan ke distributor pesan
//     var hasil =
//         await AgentPage.getData(); //Memanggil data yang tersedia di agen Page
//     completer.complete(); //Batas pengerjaan yang memerlukan completer

//     await completer
//         .future; //Proses penungguan sudah selesai ketika varibel hasil
//     //memiliki nilai
//     return await hasil;
//   }

//   void submitForm(nama, paroki, lingkungan, notelp, alamat, jenis, tanggal,
//       note, context) async {
//     if (namaController.text != "" &&
//         parokiController.text != "" &&
//         lingkunganController.text != "" &&
//         notelpController.text != "" &&
//         alamatController.text != "" &&
//         ddValue != "" &&
//         _selectedDate != "" &&
//         noteController.text != "") {
//       Completer<void> completer = Completer<void>(); //variabel untuk menunggu
//       Messages message = Messages(
//           'Agent Page',
//           'Agent Pendaftaran',
//           "REQUEST",
//           Tasks('enroll pelayanan', [
//             "sakramentali",
//             iduser,
//             nama,
//             paroki,
//             lingkungan,
//             notelp,
//             alamat,
//             jenis,
//             tanggal,
//             note,
//             idGereja,
//             idImam
//           ]));

//       MessagePassing messagePassing =
//           MessagePassing(); //Memanggil distributor pesan
//       await messagePassing
//           .sendMessage(message); //Mengirim pesan ke distributor pesan
//       var hasil =
//           await AgentPage.getData(); //Memanggil data yang tersedia di agen Page
//       completer.complete(); //Batas pengerjaan yang memerlukan completer

//       await completer
//           .future; //Proses penungguan sudah selesai ketika varibel hasil
//       //memiliki nilai

//       if (hasil == 'oke') {
//         Fluttertoast.showToast(
//             /////// Widget toast untuk menampilkan pesan pada halaman
//             msg: "Berhasil Mendaftar Pemberkatan",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.CENTER,
//             timeInSecForIosWeb: 2,
//             backgroundColor: Colors.green,
//             textColor: Colors.white,
//             fontSize: 16.0);
//         Navigator.pop(
//           context,
//           MaterialPageRoute(builder: (context) => Pemberkatan(iduser)),
//         );
//       }
//     } else {
//       Fluttertoast.showToast(
//           /////// Widget toast untuk menampilkan pesan pada halaman
//           msg: "Lengkapi semua isi form",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//           timeInSecForIosWeb: 2,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           fontSize: 16.0
//           /////Konfigurasi widget toast, untuk toast ini dibuat konfigurasi error
//           );
//     }
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Widget untuk membangun struktur halaman
//       //////////////////////////////////////Pembuatan Top Navigation Bar////////////////////////////////////////////////////////////////
//       appBar: AppBar(
//         // widget Top Navigation Bar
//         title: Text('Formulir Pemberkatan'),
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
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 11),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               FutureBuilder(
//                   future: callDb(),
//                   builder: (context, AsyncSnapshot snapshot) {
//                     //Pemanggilan fungsi, untuk mendapatkan data
//                     //yang dibutuhkan oleh tampilan halaman
//                     try {
//                       return Column(
//                         children: <Widget>[
//                           /////////
//                           ///
//                           Card(
//                             //Membuat kartu berbentuk oval
//                             //untuk tempat penampilan data
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30.0),
//                             ),
//                             margin: EdgeInsets.symmetric(
//                                 horizontal: 20.0, vertical: 5.0),
//                             clipBehavior: Clip.antiAlias,
//                             color: Colors.white,
//                             elevation: 20.0,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 7.0, vertical: 22.0),
//                               child: Row(
//                                 children: <Widget>[
//                                   Expanded(
//                                     //Menampilkan data aturan pelayanan
//                                     child: Column(
//                                       children: <Widget>[
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           mainAxisSize: MainAxisSize.max,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: <Widget>[
//                                             Text(
//                                               "Aturan Pemberkatan Gereja: ",
//                                               style: TextStyle(
//                                                   color: Colors.red,
//                                                   fontSize: 15.0,
//                                                   fontWeight: FontWeight.w600),
//                                             ),
//                                             Text(
//                                               snapshot.data[0]['pemberkatan'],
//                                               style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: 15.0,
//                                                   fontWeight: FontWeight.w300),
//                                             ),
//                                           ],
//                                         ),
//                                         SizedBox(
//                                           height: 8.0,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 30.0,
//                           ),

//                           /////////
//                         ],
//                       );
//                     } catch (e) {
//                       //Jika data yang ditampilkan masih menunggu/ salah dalam
//                       //pemanggilan data
//                       print(e);
//                       return Center(child: CircularProgressIndicator());
//                     }
//                   }),
//               Text(
//                 "Nama Lengkap",
//                 textAlign: TextAlign.left,
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 5),
//               ),
//               TextField(
//                 inputFormatters: [
//                   FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
//                 ],
//                 controller: namaController,
//                 style: TextStyle(color: Colors.black),
//                 decoration: InputDecoration(
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide(
//                         color: Colors.blue,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide(
//                         color: Colors.black,
//                       ),
//                     ),
//                     hintText: "Masukan Nama Lengkap",
//                     hintStyle: TextStyle(color: Colors.grey),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     )),
//               ),
//             ],
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 11),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Paroki",
//                 textAlign: TextAlign.left,
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 5),
//               ),
//               TextField(
//                 controller: parokiController,
//                 style: TextStyle(color: Colors.black),
//                 decoration: InputDecoration(
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide(
//                         color: Colors.blue,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide(
//                         color: Colors.black,
//                       ),
//                     ),
//                     hintText: "Masukan Nama Paroki",
//                     hintStyle: TextStyle(color: Colors.grey),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     )),
//               ),
//             ],
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 11),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Lingkungan",
//                 textAlign: TextAlign.left,
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 5),
//               ),
//               TextField(
//                 controller: lingkunganController,
//                 style: TextStyle(color: Colors.black),
//                 decoration: InputDecoration(
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide(
//                         color: Colors.blue,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide(
//                         color: Colors.black,
//                       ),
//                     ),
//                     hintText: "Masukan Nama Lingkungan",
//                     hintStyle: TextStyle(color: Colors.grey),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     )),
//               ),
//             ],
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 11),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Nomor Telephone",
//                 textAlign: TextAlign.left,
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 5),
//               ),
//               TextField(
//                 inputFormatters: [
//                   FilteringTextInputFormatter.allow(RegExp("[0-9]")),
//                 ],
//                 controller: notelpController,
//                 style: TextStyle(color: Colors.black),
//                 decoration: InputDecoration(
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide(
//                         color: Colors.blue,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide(
//                         color: Colors.black,
//                       ),
//                     ),
//                     hintText: "Masukan Nomor Telephone",
//                     hintStyle: TextStyle(color: Colors.grey),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     )),
//               ),
//             ],
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 11),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Alamat Lengkap",
//                 textAlign: TextAlign.left,
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 5),
//               ),
//               TextField(
//                 controller: alamatController,
//                 style: TextStyle(color: Colors.black),
//                 decoration: InputDecoration(
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide(
//                         color: Colors.blue,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide(
//                         color: Colors.black,
//                       ),
//                     ),
//                     hintText: "Masukan Alamat",
//                     hintStyle: TextStyle(color: Colors.grey),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     )),
//               ),
//             ],
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 11),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Jenis Pemberkatan",
//                 textAlign: TextAlign.left,
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 5),
//               ),
//               DropdownButton(
//                 // Initial Value
//                 value: ddValue,
//                 hint: Text("Pilih Jenis Pemberkatan"),
//                 // Down Arrow Icon
//                 icon: const Icon(Icons.keyboard_arrow_down),

//                 items: jenisPemberkatan.map((String items) {
//                   return DropdownMenuItem(
//                     value: items,
//                     child: Text(items),
//                   );
//                 }).toList(),
//                 // After selecting the desired option,it will
//                 // change button value to selected value
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     ddValue = newValue!;
//                   });
//                 },
//               ),
//             ],
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 11),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Tanggal",
//                 textAlign: TextAlign.left,
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 5),
//               ),
//               SfDateRangePicker(
//                 view: DateRangePickerView.month,
//                 onSelectionChanged: _onSelectionChanged,
//                 monthViewSettings:
//                     DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
//               )
//             ],
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 11),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Note Tambahan",
//                 textAlign: TextAlign.left,
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 5),
//               ),
//               TextField(
//                 controller: noteController,
//                 style: TextStyle(color: Colors.black),
//                 decoration: InputDecoration(
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide(
//                         color: Colors.blue,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide(
//                         color: Colors.black,
//                       ),
//                     ),
//                     hintText: "Masukan Notes",
//                     hintStyle: TextStyle(color: Colors.grey),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     )),
//               ),
//             ],
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 11),
//           ),
//           RaisedButton(
//               //Widget yang membuat tombol, pada widget ini
//               //tombol memiliki aksi jika ditekan (onPressed),
//               //dan memiliki dekorasi seperti(warna,child yang
//               //berupa widgetText, dan bentuk tombol)
//               onPressed: () async {
//                 submitForm(
//                     namaController.text,
//                     parokiController.text,
//                     lingkunganController.text,
//                     notelpController.text,
//                     alamatController.text,
//                     ddValue,
//                     _selectedDate,
//                     noteController.text,
//                     context);
//               },
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(80.0)),
//               elevation: 10.0,
//               padding: EdgeInsets.all(0.0),
//               child: Ink(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                       begin: Alignment.topRight,
//                       end: Alignment.topLeft,
//                       colors: [
//                         Colors.blueAccent,
//                         Colors.lightBlue,
//                       ]),
//                   borderRadius: BorderRadius.circular(30.0),
//                 ),
//                 child: Container(
//                   constraints: BoxConstraints(
//                       maxWidth: double.maxFinite, minHeight: 50.0),
//                   alignment: Alignment.center,
//                   child: Text(
//                     "Submit Form",
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 26.0,
//                         fontWeight: FontWeight.w300),
//                   ),
//                 ),
//               )),
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 20),
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
