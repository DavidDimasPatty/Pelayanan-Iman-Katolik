import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/singup.dart';

class Login extends StatelessWidget {
  const Login({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            ),
            Text(
              'Selamat Datang Iman Katolik',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Masukan email anda',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Masukan password anda',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                buttonPadding:
                    EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                children: [
                  RaisedButton(
                      child: Text("Log In"),
                      textColor: Colors.white,
                      color: Colors.blueAccent,
                      onPressed: () {}),
                  RaisedButton(
                    child: Text("Sign Up"),
                    textColor: Colors.white,
                    color: Colors.blueAccent,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
