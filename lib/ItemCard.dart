import 'dart:math';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

//Kelas yang digunakan untuk membuat carrousel
class ItemCard extends StatelessWidget {
  final String images; //gambar pada carraousel
  final String captions; //caption yang ada pada gambar di carrousel

  const ItemCard(
      {Key? key, required this.images, required this.captions}) //konstuktor
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //membangun carrousel
    return Container(
      //kontainer untuk tempat gambar
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color:
            Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 2),
        ],
      ),
      child: SingleChildScrollView(
        //widget untuk container agar bisa di slide
        child: Column(
            //widget untuk menyatukan gambar dan caption
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ClipRRect(
                //menyatukan gambar pada kontainer agar fit
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                child: Image.network(images,
                    height: 170, fit: BoxFit.fill), //gambar pada container
              ),
              ListTile(
                  // Widget untuk tempat caption
                  title: Text(
                captions,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              )),
            ]),
      ),
    );
  }
}
