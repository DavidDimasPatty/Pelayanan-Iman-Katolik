import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/login.dart';

class SignUp extends StatelessWidget {
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController repasswordController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  checkSignUp(context) async {
    var email = emailController.text;
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    var nama = nameController.text;
    bool namaValid = RegExp(r'^[a-z A-Z,.\-]+$').hasMatch(nama);
    if (namaValid == false) {
      nameController.text = "";

      return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Nama lengkap tidak valid'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    if (passwordController.text != repasswordController.text) {
      passwordController.text = "";
      repasswordController.text = "";
      return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Password tidak sama'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    if (emailValid == false) {
      print("masuk");
      emailController.text = "";
      return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Email tidak valid'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    if (emailValid == true &&
        namaValid == true &&
        passwordController.text == repasswordController.text) {
      var add = await MongoDatabase.addUser(
          nameController.text, emailController.text, passwordController.text);
      print(add);
      if (add == "nama") {
        return showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Nama sudah digunakan'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else if (add == "email") {
        return showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Email sudah digunakan'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else if (add == 'oke') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  'https://firebasestorage.googleapis.com/v0/b/pelayananimankatolik.appspot.com/o/register.png?alt=media&token=c875ef67-9a3e-46ba-a96d-e3b5d83e0bb8'),
              fit: BoxFit.cover),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 35, top: 30),
                  child: Text(
                    'Create\nAccount',
                    style: TextStyle(color: Colors.white, fontSize: 33),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 35, right: 35),
                          child: Column(
                            children: [
                              TextField(
                                controller: nameController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Name",
                                    hintStyle: TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextField(
                                controller: emailController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextField(
                                controller: passwordController,
                                style: TextStyle(color: Colors.white),
                                obscureText: true,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextField(
                                controller: repasswordController,
                                style: TextStyle(color: Colors.white),
                                obscureText: true,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Retype Password",
                                    hintStyle: TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 27,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Color(0xff4c505b),
                                    child: IconButton(
                                        color: Colors.white,
                                        onPressed: () async {
                                          checkSignUp(context);
                                        },
                                        icon: Icon(
                                          Icons.arrow_forward,
                                        )),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Login()),
                                      );
                                    },
                                    child: Text(
                                      'Sign In',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.white,
                                          fontSize: 18),
                                    ),
                                    style: ButtonStyle(),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
            //   return Material(
            //     child: Column(
            //       children: <Widget>[
            //         Padding(
            //           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            //         ),
            //         Text(
            //           'Sign Up',
            //           style: TextStyle(
            //             fontSize: 15,
            //             fontWeight: FontWeight.bold,
            //           ),
            //           textAlign: TextAlign.center,
            //         ),
            //         Padding(
            //           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            //           child: TextField(
            //             controller: nameController,
            //             decoration: InputDecoration(
            //               border: OutlineInputBorder(),
            //               hintText: 'Nama lengkap',
            //             ),
            //           ),
            //         ),
            //         Padding(
            //           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            //           child: TextField(
            //             controller: emailController,
            //             decoration: InputDecoration(
            //               border: OutlineInputBorder(),
            //               hintText: 'Masukan email anda',
            //             ),
            //           ),
            //         ),
            //         Padding(
            //           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            //           child: TextField(
            //             obscureText: true,
            //             enableSuggestions: false,
            //             autocorrect: false,
            //             controller: passwordController,
            //             decoration: InputDecoration(
            //               border: OutlineInputBorder(),
            //               hintText: 'Masukan password anda',
            //             ),
            //           ),
            //         ),
            //         Padding(
            //           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            //           child: TextField(
            //             controller: repasswordController,
            //             obscureText: true,
            //             enableSuggestions: false,
            //             autocorrect: false,
            //             decoration: InputDecoration(
            //               border: OutlineInputBorder(),
            //               hintText: 'ketik ulang password anda',
            //             ),
            //           ),
            //         ),
            //         Padding(
            //           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            //           child: ButtonBar(
            //             alignment: MainAxisAlignment.center,
            //             buttonPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            //             children: [
            //               RaisedButton(
            //                   child: Text("Create Account"),
            //                   textColor: Colors.white,
            //                   color: Colors.blueAccent,
            //                   onPressed: () async {
            //                     checkSignUp(context);
            //                   }),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   );
            // }
            ));
  }
}
