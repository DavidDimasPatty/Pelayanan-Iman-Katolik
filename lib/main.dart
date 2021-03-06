import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';
import 'package:pelayanan_iman_katolik/login.dart';

// void main() {
//   runApp(MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MongoDatabase.connect();
  //await MongoDatabase.showUser();
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: Login(),
  ));
}

//     return MyAppState(Login());
//   }
// }

/////////////////////////////////////////////
//////////////////////////////////////////////
// class MyAppState extends State<MyApp> {
//   final Function page;

//   MyAppState(this.page);

// class MyApp extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Aplikasi Gereja'),
//         ),
//         body: page(),
//       ),
//     );
//   }
// }
