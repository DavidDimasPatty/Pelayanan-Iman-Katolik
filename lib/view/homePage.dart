import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pelayanan_iman_katolik/agen/MessagePassing.dart';
import 'package:pelayanan_iman_katolik/agen/Task.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/view/Alkitab.dart';
import 'package:pelayanan_iman_katolik/view/logIn.dart';
import 'package:pelayanan_iman_katolik/view/pelayanan/pelayanan.dart';
import 'package:pelayanan_iman_katolik/view/profile/profile.dart';
import 'package:pelayanan_iman_katolik/view/setting/setting.dart';
import 'package:pelayanan_iman_katolik/view/tiketSaya.dart';

class homePage extends StatefulWidget {
  final iduser;
////////////Konstruktor Stateful Widget////////////
  homePage(this.iduser);
  _homePage createState() => _homePage(this.iduser);
///////////////////////////////////
}

class _homePage extends State<homePage> {
////////////Konstruktor////////////
  _homePage(this.iduser);
///////////////////////////////////
  ///
  ///
//////////Inisialisasi Variabel///////////
  var iduser;
  List hasil = [];
  List<String> cardList = [];
  List<String> caption = [];
  List idImage = [];
///////////////////////////////////////////
  ///
  ///
  ///
///////////////////////Fungsi////////////////////////
  Future callTampilan() async {
    //Pengiriman pesan untuk mendapatkan data yang diperlukan
    //untuk tampilan halaman home
    Completer<void> completer = Completer<void>(); //variabel untuk menunggu
    Messages message = Messages('Agent Page', 'Agent Akun', "REQUEST", Tasks('cari tampilan home', iduser)); //Pembuatan pesan

    MessagePassing messagePassing = MessagePassing(); //Memanggil distributor pesan
    await messagePassing.sendMessage(message); //Mengirim pesan ke distributor pesan
    var hasil = await AgentPage.getData(); //Memanggil data yang tersedia di agen Page
    completer.complete(); //Batas pengerjaan yang memerlukan completer

    await completer.future; //Proses penungguan sudah selesai ketika varibel hasil
    //memiliki nilai
    return hasil; //Mengembalikan variabel hasil
  }

  Future LogOut(context) async {
    Completer<void> completer = Completer<void>(); //variabel untuk menunggu
    Messages message = Messages('Agent Page', 'Agent Akun', "REQUEST", Tasks('log out', iduser)); //Pembuatan pesan

    MessagePassing messagePassing = MessagePassing(); //Memanggil distributor pesan
    await messagePassing.sendMessage(message); //Mengirim pesan ke distributor pesan
    var hasil = await AgentPage.getData(); //Memanggil data yang tersedia di agen Page
    completer.complete(); //Batas pengerjaan yang memerlukan completer

    await completer.future; //Proses penungguan sudah selesai ketika varibel hasil
    //memiliki nilai
    if (hasil == 'oke') {
      Fluttertoast.showToast(
          /////// Widget toast untuk menampilkan pesan pada halaman
          msg: "Akun anda telah dibanned",
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

  Future pullRefresh() async {
    //Fungsi refresh halaman akan memanggil fungsi callDb
    setState(() {
      //Pemanggilan fungsi secara dinamis agar halaman terupdate secara otomatis
      callTampilan();
    });
  }

////////////////////////////////Batas Akhir Fungsi////////////////////////////////////////////////
  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    //Fungsi untuk membangun halaman home
    return Scaffold(
      // Widget untuk membangun struktur halaman
      //////////////////////////////////////Pembuatan Top Navigation Bar////////////////////////////////////////////////////////////////
      appBar: AppBar(
        // widget Top Navigation Bar
        // widget Top Navigation Bar
        automaticallyImplyLeading: false,
        //Tombol back halaman dimatikan
        title: Text('Selamat Datang!'),
        //Judul Top Navigation Bar
        shape: RoundedRectangleBorder(
          //Bentuk Top Navigation Bar: Rounded Rectangle
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: <Widget>[
          //Tombol Top Navigation Bar
          IconButton(
            //Widget icon profile
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              //Jika ditekan akan mengarahkan ke halaman profile
              Navigator.push(
                //Widget navigator untuk memanggil kelas profile
                context,
                MaterialPageRoute(builder: (context) => profile(iduser)),
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
                MaterialPageRoute(builder: (context) => setting(iduser)),
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
//////////////////////////////////////Batas Akhir Pembuatan Top Navigation Bar//////////////////////////////////////////////////////////
      ///
//////
//////
//////////////////////////////////////Pembuatan Body Halaman////////////////////////////////////////////////////////////////
      body: RefreshIndicator(
          //Widget untuk refresh body halaman
          onRefresh: pullRefresh,
          //Ketika halaman direfresh akan memanggil fungsi pullRefresh
          child: ListView(children: <Widget>[
            //Halaman akan dibungkus dengan widget ListView
            Center(
                //Adjustment posisi tengah untuk child
                child: Column(
              children: <Widget>[
                Padding(
                  //Padding widget Column
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                ),
                FutureBuilder(
                    //Widget FutureBuilder untuk mengambil data
                    future: callTampilan(),
                    //Pengambilan data dengan fungsi callTampilan
                    builder: (context, AsyncSnapshot snapshot) {
                      //komponen builder yang mengambil snapshot/hasil
                      //dari fungsi callTampilan
                      try {
                        if (snapshot.data[0][0]['banned'] == 1) {
                          //Jika ternyata pengguna di banned saat penggunaan aplikasi
                          LogOut(context);
                        }

                        for (var i = 0; i < snapshot.data[3].length; i++) {
                          //Mengambil data yang terdapat pada snapshot
                          //untuk dimasukan ke variabel yang digunakan
                          //untuk menampilkan halaman
                          cardList.add(snapshot.data[3][i]['gambar']);
                          caption.add(snapshot.data[3][i]['title']);
                          idImage.add(snapshot.data[3][i]['_id']);
                        }
                        return Column(children: [
                          //Jika widget FutureBuilder berhasil, FutureBuilder
                          //akan memanggil widget Column beserta
                          //children widgetnya

/////////////////////////////////////////////////////////Pembuatan Kartu Profile Akun///////////////////////////////////////////////////////////
                          Card(
                              //Widget card untuk membangun tampilan kartu
                              //info profile
                              elevation: 20,
                              color: Colors.lightBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              //Komponen kartu seperti bayangan, warna, dan bentuk
                              child: SizedBox(
                                  //widget yang membentuk box yang dapat diatur
                                  //tinggi dan lebarnya
                                  width: 300,
                                  height: 190,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    //Penempatan posisi widget children
                                    // pada widget Column
                                    mainAxisSize: MainAxisSize.max,
                                    //Batas axis size widget children Column
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    //Batas axis aligment widget children Column
                                    children: <Widget>[
                                      GestureDetector(
                                        //Widget yang digunakan untuk mendeteksi
                                        //jika widget box ditekan
                                        onTap: () {
                                          Navigator.push(
                                            //Widget yang
                                            //memanggil kelas profile
                                            context,
                                            MaterialPageRoute(builder: (context) => profile(iduser)),
                                          );
                                        },
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          //Penempatan posisi widget children
                                          children: <Widget>[
                                            Padding(
                                              //Widget padding untuk menggeser
                                              //widget lain
                                              padding: EdgeInsets.symmetric(horizontal: 4),
                                            ),
                                            if (snapshot.data[0][0]['picture'] == null)
                                              CircleAvatar(
                                                backgroundImage: AssetImage(''),
                                                backgroundColor: Colors.greenAccent,
                                                radius: 35,
                                              ),
                                            //Jika snapshot tidak mempunyai data
                                            //picture maka akan ditampilkan default picture
                                            if (snapshot.data[0][0]['picture'] != null)
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(snapshot.data[0][0]['picture']),
                                                backgroundColor: Colors.greenAccent,
                                                radius: 35,
                                              ),
                                            //Jika snapshot mempunyai data
                                            //picture maka akan ditampilkan picture
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 5),
                                            ),
                                            Column(
                                              children: <Widget>[
                                                //Pada widget column ini akan
                                                //ditampilkan data-data akun pengguna yang dibutuhkan
                                                //oleh pembuatan kartu pada view
                                                //dalam widget Text
                                                Text(
                                                  snapshot.data[0][0]['nama'],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.w700),
                                                ),
                                                Text(
                                                  snapshot.data[0][0]['email'],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w500),
                                                ),
                                                Text(
                                                  snapshot.data[0][0]['paroki'],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w500),
                                                ),
                                                Text(
                                                  snapshot.data[0][0]['lingkungan'],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w500),
                                                ),
                                                ////Batas akhir penambilan data pada kartu/////
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 7),
                                      ),
                                      GestureDetector(
                                          //Widget yang digunakan untuk mendeteksi
                                          //jika widget box ditekan
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => tiketSaya(iduser, "current")),
                                            );
                                          },
                                          child: Container(
                                            //widget Container digunakan untuk membangun
                                            //box jadwal terdekat yang didaftar pengguna
                                            //Pada widget ini data akan dibentuk dengan
                                            //widget Text
                                            height: 80,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.indigo[100],
                                              borderRadius: BorderRadius.vertical(
                                                bottom: Radius.circular(20),
                                                top: Radius.circular(0),
                                              ),
                                            ),
                                            //Komponen widget Container
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                //Widget Column ini akan menampilkan
                                                //data tentang jadwal terdekat
                                                Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 4),
                                                ),
                                                Text(
                                                  'Jadwal Terdekat:',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w300),
                                                ),
                                                if (snapshot.data[2] == null)
                                                  //Jika data tidak mempunyai isi
                                                  Text(
                                                    'Belum ada Pendaftaran',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w300),
                                                  ),

                                                if (snapshot.data[2] != null)
                                                  //Jika data mempunyai isi
                                                  Column(children: <Widget>[
                                                    if (snapshot.data[2][0]['idKrisma'] != null)
                                                      //Jika data berisi idKrisma
                                                      Text(
                                                        'Krisma',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w300),
                                                      ),
                                                    if (snapshot.data[2][0]['idKomuni'] != null)
                                                      //Jika data berisi idKomuni
                                                      Text(
                                                        'Komuni',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w300),
                                                      ),
                                                    if (snapshot.data[2][0]['idBaptis'] != null)
                                                      //Jika data berisi idBaptis
                                                      Text(
                                                        'Baptis',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w300),
                                                      ),
                                                    if (snapshot.data[2][0]['idKegiatan'] != null)
                                                      //Jika data berisi idKegiatan
                                                      Text(
                                                        'Kegiatan Umum',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w300),
                                                      ),
                                                    if (snapshot.data[2][0]['namaLengkap'] != null)
                                                      //Jika data berisi namaLengkap
                                                      Text(
                                                        'Pemberkatan',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w300),
                                                      ),
                                                    if (snapshot.data[2][0]['namaPria'] != null)
                                                      //Jika data berisi namaPria
                                                      Text(
                                                        'Perkawinan',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w300),
                                                      ),
                                                    if (snapshot.data[2][0]['tanggalDaftar'] != null)
                                                      //Jika data berisi tanggalDaftar
                                                      Text(
                                                        snapshot.data[2][0]['tanggalDaftar'].toString().substring(0, 19),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                      ),
                                                    if (snapshot.data[2][0]['tanggal'] != null && snapshot.data[2][0]['idImam'] != null)
                                                      //Jika data berisi tanggal dan idImam
                                                      Text(
                                                        snapshot.data[2][0]['tanggal'].toString().substring(0, 19),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w300),
                                                      ),
                                                  ])
                                              ],
                                            ),
                                          )),
                                      ////////Batas Akhir Penampilan Jadwal Terdekat////////
                                    ],
                                  ))),
///////////////////////////////////////////////////////// Batas Akhir Pembuatan Kartu Profile Akun///////////////////////////////////////////////////////////

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          ),
                          //widget Padding untuk membuat ruang kosong antar widget pada halaman

/////////////////////////////////////////////////////////Pembuatan Tombol Menu///////////////////////////////////////////////////////////
                          Text(
                            'Pilihan Layanan Menu',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            //Membuat ruang kosong antar widget
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          ),
                          Row(
                            //Menu akan ditampilkan berdampingan satu sama lain
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox.fromSize(
                                //Pembuatan Tombol Menu Sakramen
                                size: Size(75, 75),
                                child: ClipOval(
                                  child: Material(
                                    color: Colors.lightBlueAccent,
                                    child: InkWell(
                                      splashColor: Colors.green,
                                      onTap: () {
                                        Navigator.push(
                                          //Jika ditekan akan memanggil kelas Sakramen
                                          context,
                                          MaterialPageRoute(builder: (context) => pelayanan(iduser, "Sakramen")),
                                        );
                                      },
                                      child: Column(
                                        //Mempunyai widget Column agar memiliki icon
                                        //yang dibawahnya tedapat Text
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.settings_accessibility, size: 30), // icon
                                          Text(
                                            "Sakramen",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
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
                                //Pembuatan Tombol Menu Sakramentali
                                size: Size(75, 75),
                                child: ClipOval(
                                  child: Material(
                                    color: Colors.greenAccent,
                                    child: InkWell(
                                      splashColor: Colors.green,
                                      onTap: () {
                                        Navigator.push(
                                          //Jika ditekan akan memanggil kelas sakramentali
                                          context,
                                          MaterialPageRoute(builder: (context) => pelayanan(iduser, "Sakramentali")),
                                        );
                                      },
                                      child: Column(
                                        //Mempunyai widget Column agar memiliki icon
                                        //yang dibawahnya tedapat Text
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.sign_language, size: 30),
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
                            ],
                          ),
                          Padding(
                            //Membuat ruang kosong antar widget
                            padding: EdgeInsets.symmetric(vertical: 10),
                          ),
                          Row(
                            //Menu akan ditampilkan berdampingan satu sama lain
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox.fromSize(
                                //Pembuatan Tombol Menu Kegiatan Umum
                                size: Size(75, 75),
                                child: ClipOval(
                                  child: Material(
                                    color: Colors.orange,
                                    child: InkWell(
                                      splashColor: Colors.green,
                                      onTap: () {
                                        Navigator.push(
                                          //Jika ditekan akan memanggil kelas Umum
                                          context,
                                          MaterialPageRoute(builder: (context) => pelayanan(iduser, "Umum")),
                                        );
                                      },
                                      child: Column(
                                        //Mempunyai widget Column agar memiliki icon
                                        //yang dibawahnya tedapat Text
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.church,
                                            size: 30,
                                          ),
                                          Text(
                                            "Umum",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
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
                                //Pembuatan Tombol Menu Kegiatan Umum
                                size: Size(75, 75),
                                child: ClipOval(
                                  child: Material(
                                    color: Colors.yellowAccent,
                                    child: InkWell(
                                      splashColor: Colors.green,
                                      onTap: () {
                                        Navigator.push(
                                          //Jika ditekan akan memanggil kelas Umum
                                          context,
                                          MaterialPageRoute(builder: (context) => Alkitab(iduser)),
                                        );
                                      },
                                      child: Column(
                                        //Mempunyai widget Column agar memiliki icon
                                        //yang dibawahnya tedapat Text
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.book,
                                            size: 30,
                                          ),
                                          Text(
                                            "Alkitab",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
/////////////////////////////////////////////////////////Batas Akhir Pembuatan Tombol Menu///////////////////////////////////////////////////////////

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                          ),
                        ]);
                      } catch (e) {
                        print(e);
                        return Center(child: CircularProgressIndicator());
                      }
                    }),
              ],
            ))
          ])),
//////////////////////////////////////Batas Akhir Pembuatan Body Halaman/////////////////////////////////////////////////////////////
      ///
      ///
      ///

/////////////////////////////////////////////////////////Pembuatan Bottom Navigation Bar////////////////////////////////////////
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          //Dekorasi Kontainer pada Bottom Navigation Bar : posisi, bentuk, dan bayangan.
          child: ClipRRect(
            //Membentuk posisi Bottom Navigation Bar agar bisa dipasangkan menu
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              //Widget untuk membuat tampilan Bottom Navigation Bar
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              unselectedItemColor: Colors.blue,
              //Konfigurasi Bottom Navigation Bar
              items: <BottomNavigationBarItem>[
                //Item yang terdapat pada Bottom Navigation Bar
                //Berisikan icon dan label
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
                  //Jika item kedua ditekan maka akan memanggil kelas tiketSaya
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => tiketSaya(iduser, "current")),
                  );
                } else if (index == 0) {}
                //Jika item pertama ditekan maka tidak akan memanggil kelas, karena sudah
                //berada pada halaman home
              },
            ),
          )),
/////////////////////////////////////////////////////////Batas Akhir Pembuatan Bottom Navigation Bar////////////////////////////////////////
    );
  }
}
