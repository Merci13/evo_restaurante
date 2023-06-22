
import 'package:evo_restaurant/repositories/service/auth/user_service.dart';
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