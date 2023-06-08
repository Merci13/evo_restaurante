import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';


part 'login_loading.g.dart';

@swidget
Widget loading(BuildContext context, String title, String message, Icon icon) {
  Size mediaQuery = MediaQuery.of(context).size;
  AnimationController animationController;
  return Center(
    child: Container(
      width: mediaQuery.width * 0.5,
      height: mediaQuery.height * 0.3,
      color: Colors.white,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue,
            width: 1.5,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            children: [
              icon,
              Text(
                message,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              )

            ],
          )
        ],
      ),
    ),
  );
}

class Box extends StatelessWidget {
  final double height;
  final double width;
  final Color color;

  const Box(
      {this.height = 0, this.width = 0, this.color = Colors.black, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: color,
    );
  }
}