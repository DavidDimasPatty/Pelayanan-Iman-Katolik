import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AnimationType { opacity, translateX } //Tipe animasi

//Kelas untuk membuat animasi pada tampilan
class FadeAnimation extends StatelessWidget {
  final double delay; // waktu animasi
  final Widget child; // widget yang dianimasikan

  FadeAnimation(this.delay, this.child); //konstruktor

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AnimationType>() //Membuat gerakan animasi
      ..add(
        //opacity adalah animasi Fade in pada widget
        AnimationType.opacity,
        Tween(begin: 0.0, end: 1.0),
        Duration(milliseconds: 500),
      )
      ..add(
        //translateX adalah animasi perubahan posisi pada widget
        AnimationType.translateX,
        Tween(begin: 30.0, end: 1.0),
        Duration(milliseconds: 500),
      );

    return PlayAnimation<MultiTweenValues<AnimationType>>(
      //Mengembalikan widget yang sudah dianimasikan
      delay: Duration(milliseconds: (500 * delay).round()), //lamanya widget akan muncul
      duration: tween.duration, // lamanya animasi berjalan
      tween: tween, //animasi yang dibuat
      child: child, //widget yang dianimasikan
      builder: (context, child, value) => Opacity(
        //membangun tampilan widget setelah animasi dijalankan
        opacity: value.get(AnimationType.opacity), //opacity kembali semula
        child: Transform.translate(
            offset: Offset(value.get(AnimationType.translateX), 0), //posisi kembali semula
            child: child),
      ),
    );
  }
}
