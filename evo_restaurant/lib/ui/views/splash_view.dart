import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';


part 'splash_view.g.dart';

@swidget
Widget splashView(BuildContext context) {
  Size mediaQuery = MediaQuery
      .of(context)
      .size;
  Image image = Image.asset(
         "assets/splash_view.png" , //add image route here,
          gaplessPlayback: true,
  );

  return SizedBox(
    width: mediaQuery.width,
    height: mediaQuery.height,
    child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(image: image.image, fit: BoxFit.contain)),
          child: null,
        )),
  );
}