import 'package:evo_restaurant/ui/views/home_view.dart';
import 'package:evo_restaurant/ui/views/login_view.dart';
import 'package:evo_restaurant/ui/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'app_providers.dart';
import 'global/api_source.dart';
import 'ui/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft]); //set the orientation of the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppProviders.getProviders(MaterialApp(
      title: 'Evo Restaurant',
      localizationsDelegates: const [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('es'), // Spanish
      ],
      theme: _themeDataForMain(),

      routes: {
        /// 'initialRoute' is  not enogh
        /// the rout '/' will always be pushed. So '/' should handle displaying LoginView Internally
        /// see 'https://stckoverflow.com/questions/56145378/why-is-initstate-called-twice/56145478#56145478
        '/': (context) {
          Provider.of<ApiSource>(context, listen: false).context = context;
          var tokenSource = Provider.of<HasToken>(context);
          var userIdSource = Provider.of<HasUserId>(context);

          // if (!(tokenSource?.hasToken??false)) {
          //
          //   SchedulerBinding.instance!.addPostFrameCallback((_) {
          //     Navigator.of(context).pushNamedAndRemoveUntil(
          //         '/login-view', (Route<dynamic> route) => false);
          //   });
          // }

          return AnimatedCrossFade(
            firstCurve: Curves.easeIn,
            secondCurve: Curves.easeOut,
            duration: const Duration(milliseconds: 1000),
            firstChild: const SplashView(),
            secondChild: (tokenSource.hasToken ?? false)
                ?  const HomeView()
                : const LoginView(),
            crossFadeState: (userIdSource.userId != null)
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          );
        }
      },
      onGenerateRoute: AppRouter.generateRouter,
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      ),
    ));
  }

  ThemeData _themeDataForMain() {
    return ThemeData(
      primaryColor: const Color(0xFF250FF3),
      hintColor: const Color(0xFF1C0BD6),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        color: Color(0xFF250FF3),
      ),
      cardColor: const Color(0xFF00007F),
      useMaterial3: true,
      colorScheme: ColorScheme(
          brightness: Brightness.dark,
          error: Colors.red[900] ?? Colors.red,
          background: Colors.white,
          primary: const Color(0xFF250FF3),
          onPrimary: Color(0xFF250FF3),
          secondary: Color(0xFF1C0BD6),
          onSecondary: Color(0xFF1C0BD6),
          onError: Colors.red[900] ?? Colors.red,
          onBackground: Colors.white,
          surface: Color(0xFF00007F),
          onSurface: Color(0xFF00007F)),
    );
  }
}
