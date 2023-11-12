import 'package:evo_restaurant/repositories/service/auth/user_service.dart';
import 'package:evo_restaurant/repositories/service/command_table/command_table_service.dart';
import 'package:evo_restaurant/repositories/service/family/family_service.dart';
import 'package:evo_restaurant/repositories/service/hall/hall_service.dart';
import 'package:evo_restaurant/repositories/service/sub_family/sub_family_service.dart';
import 'package:evo_restaurant/repositories/service/table/table_service.dart';
import 'package:evo_restaurant/utils/db/sql_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'global/api_source.dart';
import 'repositories/models/user.dart';
import 'repositories/service/auth/authentication_service.dart';
import 'ui/views/widgets/loading/loading_provider.dart';

class AppProviders {
  static MultiProvider getProviders(Widget child) {
    return MultiProvider(
      providers: [
        Provider<User>(create: (_) => User()),
        Provider<SQLHelper>(
          create: (_) => SQLHelper(),
        ),
        Provider<ApiSource>(
          create: (_) => ApiSource()..init(),
        ),
        ProxyProvider<ApiSource, AuthenticationService>(
          create: (_) => AuthenticationService(),
          update: (_, api, authenticationService) =>
              (authenticationService ?? AuthenticationService())..api = api,
        ),
        ProxyProvider<ApiSource, UserService>(
          create: (_) => UserService(),
          update: (_, api, authenticationService) =>
              (authenticationService ?? UserService())..api = api,
        ),
        ProxyProvider<ApiSource, HallService>(
          create: (_) => HallService(),
          update: (_, api, hallService) =>
              (hallService ?? HallService())..api = api,
        ),
        ProxyProvider2<ApiSource, SQLHelper, FamilyService>(
          create: (_) => FamilyService(),
          update: (_, api, sqlHelper, hallService) =>
              (hallService ?? FamilyService())
                ..api = api
                ..sqlHelper = sqlHelper,
        ),
        ProxyProvider<ApiSource, SubFamilyService>(
          create: (_) => SubFamilyService(),
          update: (_, api, subFamilyService) =>
              (subFamilyService ?? SubFamilyService())..apiSource = api,
        ),
        ProxyProvider<ApiSource, CommandTableService>(
          create: (_) => CommandTableService(),
          update: (_, api, tableDetailService) =>
              (tableDetailService ?? CommandTableService())..apiSource = api,
        ),
        ProxyProvider<ApiSource, TableService>(
          create: (_) => TableService(),
          update: (_, api, tableDetailService) =>
              (tableDetailService ?? TableService())..apiSource = api,
        ),
        StreamProvider<HasToken>(
            initialData: HasToken(),
            create: (context) {
              return Provider.of<ApiSource>(context, listen: false).hasToken;
            }),
        StreamProvider<HasUserId>(
            initialData: HasUserId(),
            create: (context) {
              return Provider.of<ApiSource>(context, listen: false).hasUserId;
            }),
        StreamProvider<User>(
          initialData: User(),
          create: (context) {
            return Provider.of<AuthenticationService>(context, listen: false)
                .user;
          },
        ),
        ChangeNotifierProvider<LoadingProvider>(
          create: (_) => LoadingProvider(),
        )
      ],
      child: child,
    );
  }
}
