


import 'package:flutter/material.dart';

///Contains useful functions to reduce boilerplate code
class UIHelper {
  // Vertical spacing constants. Adjust to your liking.
  static const double _VerticalSpaceSmall = 10.0;
  static const double _VerticalSpaceMedium = 20.0;
  static const double _VerticalSpaceLarge = 60.0;

  // Vertical spacing constants. Adjust to your liking.
  static const double _HorizontalSpaceSmall = 10.0;
  static const double _HorizontalSpaceMedium = 20.0;
  static const double HorizontalSpaceLarge = 60.0;

  /// Returns a vertical space with height set to [_VerticalSpaceSmall]
  static Widget verticalSpaceSmall = SizedBox(width: _VerticalSpaceSmall);

  /// Returns a vertical space with height set to [_VerticalSpaceMedium]
  static Widget verticalSpaceMedium() {
    return verticalSpace(_VerticalSpaceMedium);
  }

  /// Returns a vertical space with height set to [_VerticalSpaceLarge]
  static const Widget verticalSpaceLarge = SizedBox(width: _VerticalSpaceLarge);

  /// Returns a vertical space equal to the [height] supplied
  static Widget verticalSpace(double height) {
    return Container(height: height);
  }

  /// Returns a vertical space with height set to [_HorizontalSpaceSmall]
  static Widget horizontalSpaceSmall() {
    return horizontalSpace(_HorizontalSpaceSmall);
  }

  /// Returns a vertical space with height set to [_HorizontalSpaceMedium]
  static Widget horizontalSpaceMedium() {
    return horizontalSpace(_HorizontalSpaceMedium);
  }

  /// Returns a vertical space with height set to [HorizontalSpaceLarge]
  static Widget horizontalSpaceLarge() {
    return horizontalSpace(HorizontalSpaceLarge);
  }

  /// Returns a vertical space equal to the [width] supplied
  static Widget horizontalSpace(double width) {
    return Container(width: width);
  }

  static Widget defaultViewMargin(Widget content) {
    return Row(children: <Widget>[
      Expanded(flex: 1, child: Container()),
      Expanded(flex: 8, child: content),
      Expanded(flex: 1, child: Container()),
    ],);
  }

  static double defaultHorizontalPadding(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.10;
  }

  static List<BoxShadow>? boxShadowHelper = const <BoxShadow>[
    //apply shadow on Dropdown button
    BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
        blurRadius: 3) //blur radius of shadow
  ];
}