import 'package:evo_restaurant/ui/views/login_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static Route<dynamic>? generateRouter(RouteSettings settings) {
    switch (settings.name) {
      case '/login-view':
        return CupertinoPageRoute(
            builder: (_) => Provider.value(
                  value: settings.arguments,
                  child: const LoginView(),
                ));
      default:
        return null;
    }
  }
}
