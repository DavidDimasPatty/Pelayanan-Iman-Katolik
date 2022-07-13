import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/profile.dart';

class Misa extends StatelessWidget {
  var names;
  var emails;
  var daftarGereja;
  Misa(this.names, this.emails);

  Future<List> callDb() async {
    daftarGereja = await MongoDatabase.findGereja();
    print("tesssssssssssssss");
    print(daftarGereja[0]['nama']);
    return daftarGereja;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pendaftaran Misa'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile(names, emails)),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List>(
          future: callDb().then((value) => daftarGereja = value),
          builder: (context, AsyncSnapshot snapshot) {
            try {
              return ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(20.0),
                children: <Widget>[
                  ///map////////
                  ///

                  for (var i in daftarGereja)
                    InkWell(
                      borderRadius: new BorderRadius.circular(24),
                      onTap: () => () {},
                      child: Column(children: <Widget>[
                        //Color(Colors.blue);
                        Text(
                          i['nama'],
                          style: TextStyle(color: Colors.red, fontSize: 12),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          i['paroki'],
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                        Text(
                          i['address'],
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                        Text(
                          i['kapasitas'],
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        ),
                      ]),
                    ),

                  ///map////////
                ],
              );
            } catch (e) {
              print(e);
              return Center(child: CircularProgressIndicator());
            }
          }),
      // body: ListView(
      //   shrinkWrap: true,
      //   padding: EdgeInsets.all(20.0),
      //   children: <Widget>[
      //     ///map////////
      //     ///
      //     ...daftarGereja((i) => <Widget>[
      //           InkWell(
      //             borderRadius: new BorderRadius.circular(24),
      //             onTap: () => () {},
      //             child: Column(children: <Widget>[
      //               //Color(Colors.blue);
      //               Text(
      //                 i['nama'],
      //                 style: TextStyle(color: Colors.red, fontSize: 12),
      //                 textAlign: TextAlign.left,
      //               ),
      //               Text(
      //                 i['address'],
      //                 style: TextStyle(color: Colors.red, fontSize: 12),
      //               ),
      //               Text(
      //                 i['paroki'],
      //                 style: TextStyle(color: Colors.red, fontSize: 12),
      //               ),
      //               Text(
      //                 i['kapasitas'],
      //                 style: TextStyle(color: Colors.red, fontSize: 12),
      //               ),
      //             ]),
      //           ),
      //         ])

      //     ///map////////
      //   ],
      // )
    );
  }
}
