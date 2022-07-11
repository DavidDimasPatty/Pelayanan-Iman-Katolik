import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/DatabaseFolder/mongodb.dart';

// void main() {
//   runApp(MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  // await MongoDatabase.showUser();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

/////////////////////////////////////////////
//////////////////////////////////////////////
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    void printLog() {
      print('Button Pressed');
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Aplikasi Gereja'),
        ),
      ),
    );
  }
}
