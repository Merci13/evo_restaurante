import 'package:evo_restaurant/repositories/service/auth/user_service.dart';
import 'package:evo_restaurant/repositories/view_models/base_widget_model.dart';
import 'package:evo_restaurant/ui/views/widgets/base_widget.dart';
import 'package:evo_restaurant/utils/share/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:provider/provider.dart';

import '../../../../repositories/models/user.dart';
import 'app_bar_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'own_app_bar.g.dart';

class OwnAppBar extends BaseWidget {
  bool isFromHome = false;

   OwnAppBar({super.key, required this.isFromHome});


  @override
  Widget getChild(BuildContext context, BaseWidgetModel baseWidgetModel) {
    return ChangeNotifierProxyProvider2<User, UserService, AppBarViewModel>(
      create: (_) => AppBarViewModel(),
      update: (_, user, userService, model) => (model ?? AppBarViewModel())
        ..user = user
        ..userService = userService
        ..init(),
      child: Consumer2<AppBarViewModel, BaseWidgetModel>(
        builder: (context, model, baseWidgetModel, _) {
          return  _AppBarBody(isFromHome);
        },
      ),
    );
  }
}

@swidget
Widget __appBarBody(BuildContext context, bool isFromHome) {
  return Consumer2<AppBarViewModel, BaseWidgetModel>(
      builder: (context, model, baseWidgetModel, _) {
    return AppBar(
      title: Text(AppLocalizations.of(context).evoRestaurantText ),
      elevation: 0.5,
      backgroundColor: colorPrimary,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 30
      ),
      automaticallyImplyLeading: isFromHome,
      leading: isFromHome ? IconButton(
        icon:const Icon(FontAwesomeIcons.bars, size: 30,),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ):  IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 30, color: Colors.white,),
        onPressed: (){
          Navigator.pop(context);
        },

      ),


    );
  });
}
