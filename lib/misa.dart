import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/profile.dart';

class Misa extends StatelessWidget {
  var names;
  var emails;
  Misa(this.names, this.emails);
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(),
            SizedBox(),
            Container(),
          ],
        ),
      ),
    );
  }
}
