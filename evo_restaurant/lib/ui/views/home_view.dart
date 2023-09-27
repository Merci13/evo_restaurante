import 'package:evo_restaurant/repositories/models/response_object.dart';
import 'package:evo_restaurant/repositories/service/auth/user_service.dart';
import 'package:evo_restaurant/repositories/service/hall/hall_service.dart';
import 'package:evo_restaurant/repositories/view_models/base_widget_model.dart';
import 'package:evo_restaurant/ui/views/widgets/appbar/own_app_bar.dart';
import 'package:evo_restaurant/ui/views/widgets/base_widget.dart';
import 'package:evo_restaurant/utils/share/app_colors.dart';
import 'package:evo_restaurant/utils/share/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:provider/provider.dart';

import '../../repositories/models/user.dart';
import '../../repositories/view_models/home_view_model.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'home_view.g.dart';

class HomeView extends BaseWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget getChild(BuildContext context, BaseWidgetModel baseWidgetModel) {
    return ChangeNotifierProxyProvider3<User, UserService, HallService,
        HomeViewModel>(
      create: (_) => HomeViewModel(),
      update: (_, user, userService, hallService, model) =>
          (model ?? HomeViewModel())
            ..hallService = hallService
            ..user = user
            ..userService = userService
            ..init(),
      child: Consumer2<HomeViewModel, BaseWidgetModel>(
        builder: (context, model, baseWidgetModel, _) {
          Size mediaQuery = MediaQuery.of(context).size;

          return SizedBox(
            width: mediaQuery.width,
            height: mediaQuery.height,
            child: Theme(
              data: ThemeData(
                appBarTheme: const AppBarTheme(
                  iconTheme: IconThemeData(color: Colors.white),
                  actionsIconTheme: IconThemeData(color: Colors.white),
                  elevation: 0,
                ),
              ),
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(70.0),
                  child: OwnAppBar(isFromHome: true),
                ),
                drawer: Drawer(
                  backgroundColor: colorAccent,
                  elevation: 2,
                  width: mediaQuery.width * 0.30,
                  child: const _ContainerOfDrawer(),
                ),
                body: const SingleChildScrollView(
                  child: _Body(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

@swidget
Widget __containerOfDrawer(BuildContext context) {
  return Consumer2<HomeViewModel, BaseWidgetModel>(
      builder: (context, model, baseWidgetModel, _) {
    Size mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        const _ContainerOfIconAndNameApp(),
        const Divider(
          thickness: 2,
          color: controlColorGray,
        ),
        Container(
          width: double.infinity,
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Text(
            (model.user.name ?? "").toUpperCase(),
            style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white),
          ),
        ),
        UIHelper.verticalSpace(20),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: _borderForDrawerButtons(),
          ),
          child: TextButton(
            style: _buttonStyleForDrawerButtons(),
            onPressed: () async {
              //request password of manager
            },
            child: Text(
              AppLocalizations.of(context).synchronizeText,
              style: _styleForButtons(),
            ),
          ),
        ),
      ],
    );
  });
}

@swidget
Widget __containerOfIconAndNameApp(BuildContext context) {
  Size mediaQuery = MediaQuery.of(context).size;
  return Container(
      padding: const EdgeInsets.only(top: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Image.asset(
            "assets/evo_icon.png",
            width: mediaQuery.width * 0.20,
            height: mediaQuery.height * 0.15,
          ),
          UIHelper.verticalSpace(10),
          Text(
            AppLocalizations.of(context).evoRestaurantText,
            style: const TextStyle(
                fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ],
      ));
}

@swidget
Widget __body(BuildContext context) {
  return Consumer2<HomeViewModel, BaseWidgetModel>(
    builder: (context, model, baseWidgetModel, _) {
      return const _ContainerOfHalls();
    },
  );
}

@swidget
Widget __containerOfHalls(BuildContext context) {
  return Consumer2<HomeViewModel, BaseWidgetModel>(
    builder: (context, model, baseWidgetModel, _) {
      Size mediaQuery = MediaQuery.of(context).size;

      BorderRadius borderRadius = BorderRadius.circular(8.0);
      double appbarHeight = const Size.fromHeight(70.0).height;
      return Container(
        height: mediaQuery.height - appbarHeight,
        width: mediaQuery.width,
        padding: const EdgeInsets.only(top: 20, bottom: 50),
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    AppLocalizations.of(context).hallsText,
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: controlColorGray),
                  ))),
            ),
            model.listOfHalls.isEmpty
                ? const Expanded(
                    flex: 90,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Expanded(
                    flex: 90,
                    child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemCount: model.listOfHalls.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Material(
                                elevation: 10,
                                borderRadius: borderRadius,
                                child: InkWell(
                                  enableFeedback: false,
                                  onTap: () {
                                    Navigator.pushNamed(context, "/hallView",
                                        arguments: model.listOfHalls[index]);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(0.0),
                                    height: mediaQuery.height * 0.20,
                                    width: mediaQuery.width * 0.5,
                                    decoration: BoxDecoration(
                                      borderRadius: borderRadius,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        LayoutBuilder(
                                            builder: (context, constraints) {
                                          return Container(
                                            height: constraints.maxHeight,
                                            width: constraints.maxHeight,
                                            decoration: BoxDecoration(
                                              color: Colors.deepPurple,
                                              borderRadius: borderRadius,
                                            ),
                                            child: const Icon(
                                              Icons.arrow_circle_right_outlined,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                          );
                                        }),
                                        Expanded(
                                          child: Text(
                                            model.listOfHalls[index].name ?? "",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[700]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
          ],
        ),
      );
    },
  );
}

TextStyle _styleForButtons() {
  return const TextStyle(
      fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white);
}

ButtonStyle _buttonStyleForDrawerButtons() {
  return ButtonStyle(
    backgroundColor:
        MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return colorAccentLight;
      }
      return Colors.transparent;
    }),
    shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
      return RoundedRectangleBorder(borderRadius: BorderRadius.circular(0));
    }),
  );
}

Border _borderForDrawerButtons() {
  return const Border(
    bottom: BorderSide(
      color: controlColorGray,
      width: 1,
    ),
    top: BorderSide(
      color: controlColorGray,
      width: 1,
    ),
  );
}
