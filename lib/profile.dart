import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final name;
  final email;

  Profile(this.name, this.email);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: <Widget>[],
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          ),
          CircleAvatar(
            backgroundImage: AssetImage(''),
            backgroundColor: Colors.greenAccent,
            radius: 120,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          ),
          Text(
            'User Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          ),
          Row(
            children: <Widget>[
              Text("Nama: "),
              Text(name),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          ),
          Row(
            children: <Widget>[
              Text("Email: "),
              Text(email),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          ),
          Row(
            children: <Widget>[
              Text("Address: "),
              Text(" "),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          ),
          Row(
            children: <Widget>[
              Text("Phone Number: "),
              Text(" "),
            ],
          ),
        ],
      )),
    );
  }
}
