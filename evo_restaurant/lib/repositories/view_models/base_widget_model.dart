import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class BaseWidgetModel {
  bool _showTheWidget = false;

  StreamController<Widget> _widgetToShow = BehaviorSubject();

  bool get showTheWidget => _showTheWidget;

  Stream<Widget> get widgetToShow => _widgetToShow.stream;

  ///Show the widget
  void showOverLayWidget(bool showWidget, Widget widgetToShow) {
    _showTheWidget = showWidget;
    if(showTheWidget){
      _widgetToShow.add(widgetToShow);
    }///ToDO I think here lack a else mark
    else{
      _widgetToShow.add(Container());
    }
  }
}