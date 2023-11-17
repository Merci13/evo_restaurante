
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../repositories/view_models/base_widget_model.dart';

// ignore: prefer_const_constructors_in_immutables
abstract class BaseWidget extends StatelessWidget {
  Widget  getChild( BuildContext context, BaseWidgetModel baseWidgetModel);

  const BaseWidget({Key? key}): super (key: key);

  @override
  Widget build(BuildContext context){
    return Provider<BaseWidgetModel>(
        create:(_) => BaseWidgetModel(),
        child: Consumer<BaseWidgetModel>(builder: (context, model, _){
          return Stack(
            children: [
              getChild(context, model),
              StreamBuilder<Widget>(
                stream: model.widgetToShow,
                builder: (context, snapshot){
                  if(snapshot.hasData) {
                    return snapshot.data ?? Container();
                  }
                  return Container();
                },
              )
            ],
          );
        })
    );
  }


}