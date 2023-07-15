import 'dart:io' show Platform;
import 'package:evo_restaurant/repositories/models/hall.dart';
import 'package:evo_restaurant/repositories/service/auth/user_service.dart';
import 'package:evo_restaurant/repositories/view_models/base_widget_model.dart';

import 'package:evo_restaurant/ui/views/widgets/base_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:provider/provider.dart';

import '../../repositories/models/user.dart';
import '../../repositories/service/hall/hall_service.dart';
import '../../repositories/view_models/hall_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utils/share/app_colors.dart';

part 'hall_view.g.dart';

class HallView extends BaseWidget {
  const HallView({super.key});

  @override
  Widget getChild(BuildContext context, BaseWidgetModel baseWidgetModel) {
    Hall hall = Provider.of<Hall>(context);

    return ChangeNotifierProxyProvider3<User, UserService, HallService,
        HallViewModel>(
      create: (_) => HallViewModel(),
      update: (_, user, userService, hallService, model) =>
          (model ?? HallViewModel())
            ..hall = hall
            ..user = user
            ..userService = userService
            ..hallService = hallService
            ..init(),
      child: Consumer2<HallViewModel, BaseWidgetModel>(
        builder: (context, model, baseWidgetModel, _) {
          Size mediaQuery = MediaQuery.of(context).size;
          return SizedBox(
            width: mediaQuery.width,
            height: mediaQuery.height,
            child: Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context).evoRestaurantText),
                elevation: 0.5,
                backgroundColor: colorPrimary,
                leading: IconButton(
                  icon: Icon(
                    Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                centerTitle: true,
                titleTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 30),
              ),
              // PreferredSize(
              //   preferredSize: const Size.fromHeight(70.0),
              //   child: OwnAppBar(
              //     isFromHome: false,
              //   ),
              // ),
              body: const _Body(),
            ),
          );
        },
      ),
    );
  }
}

@swidget
Widget __body(BuildContext context) {
  return Consumer2<HallViewModel, BaseWidgetModel>(
    builder: (context, model, baseWidgetModel, _) {
      return Container(
        child: Center(
          child: Text(model.hall.name ?? ""),
        ),
      );
    },
  );
}
