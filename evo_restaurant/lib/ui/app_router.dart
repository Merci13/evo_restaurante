import 'package:evo_restaurant/ui/views/hall_view.dart';
import 'package:evo_restaurant/ui/views/login_view.dart';
import 'package:evo_restaurant/ui/views/table_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../repositories/models/hall.dart';

class AppRouter {
  static Route<dynamic>? generateRouter(RouteSettings settings) {
    switch (settings.name) {
      case '/login-view':
        return CupertinoPageRoute(
            builder: (_) => Provider.value(
                  value: settings.arguments,
                  child: const LoginView(),
                ));
      case '/hallView':
        return CupertinoPageRoute(
            builder: (_) => Provider.value(
                  value: settings.arguments as Hall,
                  child: const HallView(),
                ));

      case '/tableView':
        return CupertinoPageRoute(
            builder: (_) => Provider.value(
              value: settings.arguments as Map<String, dynamic>,
              child: const TableView(),
            ));

      default:
        return null;
    }
  }
}
