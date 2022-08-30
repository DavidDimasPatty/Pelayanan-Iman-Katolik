import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/FadeAnimation.dart';
import 'package:pelayanan_iman_katolik/login.dart';
import 'package:pelayanan_iman_katolik/singup.dart';
import 'DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/homePage.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = new TextEditingController();
    TextEditingController passwordController = new TextEditingController();
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/pelayananimankatolik.appspot.com/o/imageedit_2_4702386825.png?alt=media&token=53776f41-1d60-4057-adeb-899f82d0ae67'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeAnimation(
                            1,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://firebasestorage.googleapis.com/v0/b/pelayananimankatolik.appspot.com/o/light-1.png?alt=media&token=0d0ab37a-ebca-4259-881c-dd4e1ba844bd'))),
                            )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(
                            1.3,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://firebasestorage.googleapis.com/v0/b/pelayananimankatolik.appspot.com/o/light-2.png?alt=media&token=fe4a055f-63fe-4d76-afb8-8fae5d353cdb'))),
                            )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(
                            1.5,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://firebasestorage.googleapis.com/v0/b/pelayananimankatolik.appspot.com/o/clock.png?alt=media&token=d1a161d5-ca29-4d5c-9a4d-e8a02f26cb09'))),
                            )),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(
                          1.8,
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(143, 148, 251, .2),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Email",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      FadeAnimation(
                          2,
                          SizedBox(
                            width: double.infinity,
                            child: RaisedButton(
                                textColor: Colors.white,
                                color: Colors.lightBlue,
                                child: Text("Send Email"),
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                onPressed: () async {
                                  var ret = await MongoDatabase.findUser(
                                      emailController.text,
                                      passwordController.text);
                                  //print("hasil: " + ret);
                                  if (ret != "failed") {
                                    //Navigator.popUntil(context, ModalRoute.withName('/'));
                                    // Navigator.pop(context,
                                    //     true); // It worked for me instead of above line
                                    print(ret);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage(
                                              ret[0]['name'],
                                              ret[0]['email'],
                                              ret[0]['_id'])),
                                    );

                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) => HomePage()),
                                    // );
                                  } else {}
                                }),
                          )),
                      SizedBox(
                        height: 50,
                      ),
                      FadeAnimation(
                        1.5,
                        new GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()),
                              );
                            },
                            child: Text(
                              "Back to Sign In",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.lightBlue,
                                decoration: TextDecoration.underline,
                              ),
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
