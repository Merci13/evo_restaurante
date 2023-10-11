import 'dart:io' show Platform;
import 'package:evo_restaurant/repositories/models/article.dart';
import 'package:evo_restaurant/repositories/models/family.dart';
import 'package:evo_restaurant/repositories/models/user.dart';
import 'package:evo_restaurant/repositories/service/family/family_service.dart';
import 'package:evo_restaurant/repositories/service/sub_family/sub_family_service.dart';
import 'package:evo_restaurant/repositories/view_models/base_widget_model.dart';
import 'package:evo_restaurant/ui/views/widgets/base_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../repositories/service/auth/user_service.dart';
import '../../repositories/view_models/family_view_model.dart';
import '../../utils/share/app_colors.dart';

part 'family_view.g.dart';

class FamilyView extends BaseWidget {
  const FamilyView({super.key});

  @override
  Widget getChild(BuildContext context, BaseWidgetModel baseWidgetModel) {
    Map data = Provider.of<Map>(context);
    Family family = data['SELECTED'];
    List<Family> families = data["FAMILIES"];

    return ChangeNotifierProxyProvider4<SubFamilyService,FamilyService, UserService, User,
        FamilyViewModel>(
      create: (_) => FamilyViewModel(),
      update: (_, subFamilyService,familyService, userService, user, model) =>
          (model ?? FamilyViewModel())
            ..familyService = familyService
            ..userService = userService
            ..user = user
            ..family = family
            ..subFamilyService = subFamilyService
            ..listOfFamilies = families
            ..init(),
      child: Consumer2<FamilyViewModel, BaseWidgetModel>(
        builder: (context, model, baseWidgetModel, _) {
          Size mediaQuery = MediaQuery.of(context).size;
          return SizedBox(
              width: mediaQuery.width,
              height: mediaQuery.height,
              child: SingleChildScrollView(
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(AppLocalizations.of(context)?.evoRestaurantText ?? ""),
                    elevation: 0.5,
                    backgroundColor: colorPrimary,
                    leading: IconButton(
                      enableFeedback: false,
                      icon: Icon(
                        Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },
                    ),
                    centerTitle: true,
                    titleTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 30),
                  ),
                  body: _Body(),
                ),
              ));
        },
      ),
    );
  }
}

@swidget
Widget __body(BuildContext context) {
  return Consumer2<FamilyViewModel, BaseWidgetModel>(
      builder: (context, model, baseWidgetModel, _) {
    Size mediaQuery = MediaQuery.of(context).size;
    return ListView.builder(
        itemCount: model.listOfArticlesOfFamily.length,
        itemBuilder: (BuildContext context, int index){
      return Container();
    });
  });
}
