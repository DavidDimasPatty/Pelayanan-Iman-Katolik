import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/detailDaftarMisa.dart';
import 'package:pelayanan_iman_katolik/profile.dart';
import 'package:pelayanan_iman_katolik/tiketSayaDetail.dart';

class tiketSaya extends StatelessWidget {
  var names;
  var idUser;
  var emails;
  var tiketGereja;
  var tiket;
  var namaGereja;
  var hasil;
  tiketSaya(this.names, this.emails, this.idUser);

  Future<List> callDb() async {
    tiketGereja = await MongoDatabase.jadwalku(idUser);
    return tiketGereja;
  }

  Future<List> callInfoMisa(idMisa) async {
    tiket = await MongoDatabase.jadwalMisaku(idMisa);
    return tiket;
  }

  Future<List> callInfoGereja(idGereja) async {
    namaGereja = await MongoDatabase.cariGereja(idGereja);
    return namaGereja;
  }

  Future<List> addChild(idMisa) async {
    var temp;
    tiket = await callInfoMisa(idMisa).then((value) => temp = value);
    tiketGereja = await callInfoGereja(temp[0]['idGereja']);
    hasil = [temp[0]['jadwal'], tiketGereja[0]['nama']];
    return hasil;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jadwal Saya'),
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
        ],
      ),
      body: FutureBuilder<List>(
          future: callDb(),
          builder: (context, AsyncSnapshot snapshot) {
            try {
              return ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(20.0),
                children: <Widget>[
                  for (var i in snapshot.data)
                    InkWell(
                      borderRadius: new BorderRadius.circular(24),
                      onTap: () {
                        tiketSayaDetail(names, emails, idUser, i['idMisa'])
                            .showDialogBox(context);
                      },
                      child: Container(
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.lightBlue,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Column(children: <Widget>[
                            FutureBuilder<List>(
                                future: addChild(i['idMisa']),
                                builder: (context, AsyncSnapshot snapshot) {
                                  try {
                                    return Column(
                                      children: <Widget>[
                                        Text(snapshot.data[0]),
                                        Text(snapshot.data[1])
                                      ],
                                    );
                                  } catch (e) {
                                    print(e);
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                })
                          ])),
                    ),

                  ///map////////
                ],
              );
            } catch (e) {
              print(e);
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
