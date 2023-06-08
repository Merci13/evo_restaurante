import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loading_provider.dart';
import 'login_loading.dart';

class LoadingScreen {
  String title = "";
  String message = "";
  Icon icon = const Icon(Icons.info_outline, color: Colors.blue, size: 40,);


  TransitionBuilder init({
    TransitionBuilder? builder,
  }) {
    return (BuildContext context, Widget? child) {
      if (builder != null) {
        return builder(context, LoadingCustom(
          title: title, icon: icon, message: message,
          child: child!,));
      } else {
        return LoadingCustom(
            title: title, message: message, icon: icon,
            child: child!);
      }
    };
  }
}

class LoadingCustom extends StatelessWidget {
  final Widget child;
  final String title;
  final String message;
  final Icon icon;

  const LoadingCustom({
    Key? key,
    required this.title,
    required this.message,
    required this.icon,
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChangeNotifierProvider<LoadingProvider>(
            create: (context) => LoadingProvider(),
            builder: (context, _) {
              return Stack(
                  children: [
                    child,
                    Consumer<LoadingProvider>(
                        builder: (context, provider, child) {
                          return provider.loading
                              ? Loading(title, message, icon)
                              : Container();
                        }
                    )
                  ]
              );
            }
        )
    );
  }
}