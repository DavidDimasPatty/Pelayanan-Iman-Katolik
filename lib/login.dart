import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/FadeAnimation.dart';
import 'package:pelayanan_iman_katolik/singup.dart';
import 'DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/homePage.dart';

class Login extends StatelessWidget {
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
                          image: AssetImage('assets/images/background.png'),
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
                                      image: AssetImage(
                                          'assets/images/light-1.png'))),
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
                                      image: AssetImage(
                                          'assets/images/light-2.png'))),
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
                                      image: AssetImage(
                                          'assets/images/clock.png'))),
                            )),
                      ),
                      Positioned(
                        child: FadeAnimation(
                            1.6,
                            Container(
                              margin: EdgeInsets.only(top: 50),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
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
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Email or Phone number",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextField(
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
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(colors: [
                                  Color.fromRGBO(143, 148, 251, 1),
                                  Color.fromRGBO(143, 148, 251, .6),
                                ])),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 70,
                      ),
                      FadeAnimation(
                          1.5,
                          Text(
                            "Forgot Password?",
                            style: TextStyle(
                                color: Color.fromRGBO(143, 148, 251, 1)),
                          )),
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
