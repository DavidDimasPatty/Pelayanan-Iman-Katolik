import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/singup.dart';
import 'DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/homePage.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = new TextEditingController();
    TextEditingController passwordController = new TextEditingController();
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Masukan email anda',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: passwordController,
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
                      onPressed: () async {
                        var ret = await MongoDatabase.findUser(
                            emailController.text, passwordController.text);
                        //print("hasil: " + ret);
                        if (ret != "failed") {
                          //Navigator.popUntil(context, ModalRoute.withName('/'));
                          // Navigator.pop(context,
                          //     true); // It worked for me instead of above line
                          print(ret);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(ret[0]['name'],
                                    ret[0]['email'], ret[0]['_id'])),
                          );

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => HomePage()),
                          // );
                        } else {}
                      }),
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
