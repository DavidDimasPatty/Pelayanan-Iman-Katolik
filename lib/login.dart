import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/FadeAnimation.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/messages.dart';
import 'package:pelayanan_iman_katolik/forgetPassword.dart';
import 'package:pelayanan_iman_katolik/singup.dart';
import 'DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/homePage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatelessWidget {
  login(id, password) async {
    Messages msg = new Messages();
    msg.addReceiver("agenAkun");
    msg.setContent([
      ["cari user"],
      [id],
      [password]
    ]);
    var hasil;
    await msg.send().then((res) async {
      print("masuk");
      print(await AgenPage().receiverTampilan());
    });
    await Future.delayed(Duration(seconds: 2));
    hasil = await AgenPage().receiverTampilan();
    return hasil;
  }

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
                      Positioned(
                        child: FadeAnimation(
                          1.6,
                          Container(
                            margin: EdgeInsets.only(top: 85),
                            child: Center(
                              child: Text(
                                'Halo, Umat Katolik!',
                                style: GoogleFonts.davidLibre(
                                  textStyle: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      letterSpacing: .5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
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
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: Colors.grey))),
                                  child: TextField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Email",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextField(
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    controller: passwordController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Password",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                  ),
                                )
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
                                child: Text("Login"),
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                onPressed: () async {
                                  if (emailController.text == "" ||
                                      passwordController.text == "") {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Email atau Password Tidak Boleh Kosong",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 2,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    emailController.clear();
                                    passwordController.clear();
                                  } else {
                                    var ret = await login(emailController.text,
                                            passwordController.text)
                                        .then((ret) async {
                                      print("work");
                                      print(await ret);
                                      try {
                                        if (await ret.length > 0) {
                                          print(ret[0]["_id"]);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomePage(
                                                      ret[0]['name'],
                                                      ret[0]['email'],
                                                      ret[0]['_id'],
                                                    )),
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "Email dan Password Salah",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 2,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          emailController.clear();
                                          passwordController.clear();
                                        }
                                      } catch (e) {
                                        Fluttertoast.showToast(
                                            msg: "Connection Problem",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 2,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                        emailController.clear();
                                        passwordController.clear();
                                      }
                                    });
                                  }
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
                                    builder: (context) => SignUp()),
                              );
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.lightBlue,
                                decoration: TextDecoration.underline,
                              ),
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FadeAnimation(
                          1.5,
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgetPassword()),
                                );
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(color: Colors.lightBlue),
                              ))),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
//     return Material(
//         child: ListView(
//       children: <Widget>[
//         Column(
//           children: <Widget>[
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//             ),
//             Text(
//               'Selamat Datang Iman Katolik',
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//               child: TextField(
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Masukan email anda',
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//               child: TextField(
//                 obscureText: true,
//                 enableSuggestions: false,
//                 autocorrect: false,
//                 controller: passwordController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Masukan password anda',
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//               child: ButtonBar(
//                 alignment: MainAxisAlignment.center,
//                 buttonPadding:
//                     EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//                 children: [
//                   RaisedButton(
//                       child: Text("Log In"),
//                       textColor: Colors.white,
//                       color: Colors.blueAccent,
//                       onPressed: () async {
//                         var ret = await MongoDatabase.findUser(
//                             emailController.text, passwordController.text);
//                         //print("hasil: " + ret);
//                         if (ret != "failed") {
//                           //Navigator.popUntil(context, ModalRoute.withName('/'));
//                           // Navigator.pop(context,
//                           //     true); // It worked for me instead of above line
//                           print(ret);
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => HomePage(ret[0]['name'],
//                                     ret[0]['email'], ret[0]['_id'])),
//                           );

//                           // Navigator.push(
//                           //   context,
//                           //   MaterialPageRoute(builder: (context) => HomePage()),
//                           // );
//                         } else {}
//                       }),
//                   RaisedButton(
//                     child: Text("Sign Up"),
//                     textColor: Colors.white,
//                     color: Colors.blueAccent,
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => SignUp()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         )
//       ],
//     ));
//   }
// }
