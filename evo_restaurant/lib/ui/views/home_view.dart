// ignore_for_file: use_build_context_synchronously

import 'package:evo_restaurant/repositories/enums/type_information_modal.dart';
import 'package:evo_restaurant/repositories/models/response_object.dart';
import 'package:evo_restaurant/repositories/service/auth/user_service.dart';
import 'package:evo_restaurant/repositories/service/family/family_service.dart';
import 'package:evo_restaurant/repositories/service/hall/hall_service.dart';
import 'package:evo_restaurant/repositories/service/sub_family/sub_family_service.dart';
import 'package:evo_restaurant/repositories/service/table/table_service.dart';
import 'package:evo_restaurant/repositories/view_models/base_widget_model.dart';
import 'package:evo_restaurant/ui/views/widgets/appbar/own_app_bar.dart';
import 'package:evo_restaurant/ui/views/widgets/base_widget.dart';
import 'package:evo_restaurant/ui/views/widgets/information_modal/information_modal.dart';
import 'package:evo_restaurant/utils/share/app_colors.dart';
import 'package:evo_restaurant/utils/share/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:provider/provider.dart';

import '../../repositories/models/user.dart';
import '../../repositories/service/article/article_service.dart';
import '../../repositories/view_models/home_view_model.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'home_view.g.dart';

class HomeView extends BaseWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget getChild(BuildContext context, BaseWidgetModel baseWidgetModel) {
    return ChangeNotifierProxyProvider6<User, UserService, HallService,
        FamilyService, SubFamilyService, ArticleService, HomeViewModel>(
      create: (_) => HomeViewModel(),
      update: (_, user, userService, hallService, familyService,
              subfamilyService, articleService, model) =>
          (model ?? HomeViewModel())
            ..hallService = hallService
            ..user = user
            ..userService = userService
            ..familyService = familyService
            ..subFamilyService = subfamilyService
            ..articleService = articleService
            ..context = context
            ..init(AppLocalizations.of(context)),
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
    double height = mediaQuery.height * 0.40;
    double width = mediaQuery.width * 0.5;
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
              Navigator.pop(context);
              //request password of manager
              // baseWidgetModel.showOverLayWidget(true,
              //     _ContainerOfRequestAdminPassword(model, baseWidgetModel));

              Map<String, bool> res = await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return Material(
                      color: Colors.black26,
                      child: Center(
                        child: Container(
                          width: width,
                          height: height,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(7)),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(7)),
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                //content title
                                Container(
                                  width: double.infinity,
                                  height: mediaQuery.height * 0.05,
                                  padding: const EdgeInsets.all(5),
                                  color: colorPrimary,
                                  child: Text(
                                    AppLocalizations.of(context)
                                            ?.synchronizeText ??
                                        "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                        color: Colors.white),
                                  ),
                                ),
                                UIHelper.verticalSpace(20),
                                //content text
                                Text(
                                  AppLocalizations.of(context)
                                          ?.passwordIsRequiredText ??
                                      "",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),

                                //text input of password
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 30),
                                  child: TextFormField(
                                    focusNode: model.passwordFocusNode,
                                    controller: model.passwordEditingController,
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                    onTap: () {
                                      if (!model.passwordFocusNode.hasFocus) {
                                        model.passwordFocusNode.requestFocus();
                                      }
                                    },
                                    decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context)
                                                ?.passwordText ??
                                            "",
                                        labelStyle: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey),
                                        prefixIcon: Container(
                                          padding: const EdgeInsets.all(10),
                                          child: const Icon(
                                            FontAwesomeIcons.lock,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        hintText: AppLocalizations.of(context)
                                                ?.enterPasswordHintText ??
                                            "",
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: Colors.blue[900] ??
                                                  Colors.blue),
                                        ),
                                        hintStyle: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                width: 2,
                                                color: Colors.blue[900] ??
                                                    Colors.blue)),
                                        filled: true,
                                        contentPadding:
                                            const EdgeInsets.all(16),
                                        fillColor: Colors.white),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return AppLocalizations.of(context)
                                                ?.enterACorrectUserNameText ??
                                            "";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                UIHelper.verticalSpace(30),
                                //Buttons Accept and Cancel
                                SizedBox(
                                  width: double.infinity,
                                  height: mediaQuery.height * 0.05,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        flex: 40,
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          decoration: BoxDecoration(
                                              color: colorPrimary,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(7)),
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 1,
                                              )),
                                          child: TextButton(
                                            style: const ButtonStyle(
                                                enableFeedback: false),
                                            onPressed: () async {
                                              Navigator.pop(context,
                                                  {'acceptButtonRes': true});
                                            },
                                            child: Text(
                                              AppLocalizations.of(context)
                                                      ?.acceptText ??
                                                  "",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(flex: 05, child: Container()),
                                      Expanded(
                                        flex: 40,
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                              color: colorPrimary,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(7)),
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 1,
                                              )),
                                          child: TextButton(
                                            style: const ButtonStyle(
                                                enableFeedback: false),
                                            onPressed: () {
                                              model.passwordEditingController
                                                  .text = "";
                                              Navigator.pop(context,
                                                  {'acceptButtonRes': false});
                                            },
                                            child: Text(
                                              AppLocalizations.of(context)
                                                      ?.cancelText ??
                                                  "",
                                              style: styleForButtons(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });

              ///check password or not
              if (res['acceptButtonRes'] ?? false) {

                showDialog(
                  barrierDismissible: false,
                    context: model.context,
                    builder: (BuildContext context) {
                      ///variable container
                      ///first show loading message

                      ///ToDo: investigate how to call this method outside the building process
                      ///

                      model.process(context);
                      return Dialog(
                        backgroundColor: Colors.white,
                        child: StreamBuilder(
                            stream: model.chargingProcessWidgets.stream,
                            builder: (BuildContext context,
                                AsyncSnapshot<Widget> snapshot) {


                              if (snapshot.hasError) {
                                return Column(
                                  children: [
                                    Text(AppLocalizations.of(context)
                                            ?.somethingWentWrongText ??
                                        ""),
                                    UIHelper.verticalSpace(20),
                                    Text(model.errorMessage),
                                    UIHelper.verticalSpace(20),
                                    TextButton(
                                        onPressed: () {
                                          model.passwordEditingController.text =
                                              "";
                                          Navigator.pop(context);
                                        },
                                        child: Text(AppLocalizations.of(context)
                                                ?.acceptText ??
                                            ""))
                                  ],
                                );
                              }
                              ConnectionState connection = snapshot.connectionState;
                              if(connection == ConnectionState.none){
                                return    Container(
                                  width: mediaQuery.width * 0.3,
                                  height: mediaQuery.width * 0.2,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(7)),
                                      color: Colors.white
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      //Title container
                                      Expanded(
                                        flex: 25,
                                        child: Container(
                                          width: double.infinity,
                                          height: mediaQuery.height * 0.05,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(7),
                                              topLeft: Radius.circular(7),

                                            ),
                                            color: colorPrimary,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  flex: 75,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      AppLocalizations.of(context)?.evoRestaurantText ?? "",
                                                      style: const TextStyle(
                                                          fontSize: 17,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.white
                                                      ),
                                                    ),
                                                  )
                                              ),
                                              Expanded(
                                                  flex: 25,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      AppLocalizations.of(context)?.chargingDataText ?? "",
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 15,
                                                          color: Colors.white
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //content container
                                      Expanded(
                                        flex: 75,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text( AppLocalizations.of(context)?.chargingDataText ?? "",
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black
                                              ),),
                                            const Center(
                                              child: CircularProgressIndicator(),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }else
                              if(connection == ConnectionState.waiting){
                                return    Container(
                                  width: mediaQuery.width * 0.3,
                                  height: mediaQuery.width * 0.2,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(7)),
                                      color: Colors.white
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      //Title container
                                      Expanded(
                                        flex: 25,
                                        child: Container(
                                          width: double.infinity,
                                          height: mediaQuery.height * 0.05,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(7),
                                              topLeft: Radius.circular(7),

                                            ),
                                            color: colorPrimary,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  flex: 75,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      AppLocalizations.of(context)?.evoRestaurantText ?? "",
                                                      style: const TextStyle(
                                                          fontSize: 17,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.white
                                                      ),
                                                    ),
                                                  )
                                              ),
                                              Expanded(
                                                  flex: 25,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      AppLocalizations.of(context)?.chargingDataText ?? "",
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 15,
                                                          color: Colors.white
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //content container
                                      Expanded(
                                        flex: 75,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text( AppLocalizations.of(context)?.chargingDataText ?? "",
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black
                                              ),),
                                            const Center(
                                              child: CircularProgressIndicator(),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }
                              return snapshot.data ?? Container();
                            }),
                      );
                    });

              }

            },
            child: Text(
              AppLocalizations.of(context)?.synchronizeText ?? "",
              style: _styleForButtons(),
            ),
          ),
        ),
      ],
    );
  });
}

@swidget
Widget __containerOfRequestAdminPassword(BuildContext context,
    HomeViewModel model, BaseWidgetModel baseWidgetModel) {
  Size mediaQuery = MediaQuery.of(context).size;
  double height = mediaQuery.height * 0.40;
  double width = mediaQuery.width * 0.5;
  return Material(
    color: Colors.black26,
    child: Center(
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(7)),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(7)),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: mediaQuery.height * 0.05,
                padding: const EdgeInsets.all(5),
                color: colorPrimary,
                child: Text(
                  AppLocalizations.of(context)?.synchronizeText ?? "",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.white),
                ),
              ),
              UIHelper.verticalSpace(20),
              Text(
                AppLocalizations.of(context)?.passwordIsRequiredText ?? "",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),

              //text input of password
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: TextFormField(
                  focusNode: model.passwordFocusNode,
                  controller: model.passwordEditingController,
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  onTap: () {
                    if (!model.passwordFocusNode.hasFocus) {
                      model.passwordFocusNode.requestFocus();
                    }
                  },
                  decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context)?.passwordText ?? "",
                      labelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          FontAwesomeIcons.lock,
                          color: Colors.grey,
                        ),
                      ),
                      hintText:
                          AppLocalizations.of(context)?.enterPasswordHintText ??
                              "",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2, color: Colors.blue[900] ?? Colors.blue),
                      ),
                      hintStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              width: 2,
                              color: Colors.blue[900] ?? Colors.blue)),
                      filled: true,
                      contentPadding: const EdgeInsets.all(16),
                      fillColor: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)
                              ?.enterACorrectUserNameText ??
                          "";
                    }
                    return null;
                  },
                ),
              ),
              UIHelper.verticalSpace(30),

              SizedBox(
                width: double.infinity,
                height: mediaQuery.height * 0.05,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 40,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(7)),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            )),
                        child: TextButton(
                          style: const ButtonStyle(enableFeedback: false),
                          onPressed: () async {
                            BuildContext contextForDialog = context;
                            baseWidgetModel.showOverLayWidget(
                                false, Container());
                            baseWidgetModel.showOverLayWidget(
                                true,
                                const InformationModal.loading(
                                    typeInformationModal:
                                        TypeInformationModal.LOADING));
                            bool resPassword = await model.checkPassword();
                            if (resPassword) {
                              model.passwordEditingController.text = "";

                              baseWidgetModel.showOverLayWidget(
                                  false, Container());

                              baseWidgetModel.showOverLayWidget(
                                  true,
                                  _ContainerOfChargingTextAndSpinner(
                                      //  model,
                                      //    baseWidgetModel
                                      ));

                              bool resL = await model.resLoadingData();

                              if (resL) {
                                String title = AppLocalizations.of(context)
                                        ?.informationText ??
                                    "";

                                baseWidgetModel.showOverLayWidget(
                                    false, Container());

                                baseWidgetModel.showOverLayWidget(
                                  true,
                                  InformationModal(
                                    typeInformationModal:
                                        TypeInformationModal.INFORMATION,
                                    title: title,
                                    contentText:
                                        AppLocalizations.of(contextForDialog)
                                            ?.loadingDataSuccessfullyText,
                                    acceptButton: () {
                                      baseWidgetModel.showOverLayWidget(
                                          false, Container());
                                    },
                                    icon: const Icon(
                                      Icons.info,
                                      color: Colors.white,
                                      size: 23,
                                    ),
                                  ),
                                );
                              } else {
                                baseWidgetModel.showOverLayWidget(
                                    false, Container());
                                baseWidgetModel.showOverLayWidget(
                                  true,
                                  InformationModal(
                                    typeInformationModal:
                                        TypeInformationModal.ERROR,
                                    title: AppLocalizations.of(context)
                                            ?.somethingWentWrongText ??
                                        "",
                                    contentText: AppLocalizations.of(context)
                                            ?.chargingDataFailedText ??
                                        "",
                                    acceptButton: () {
                                      baseWidgetModel.showOverLayWidget(
                                          false, Container());
                                    },
                                    icon: const Icon(
                                      Icons.error,
                                      color: Colors.white,
                                      size: 23,
                                    ),
                                  ),
                                );
                              }
                            } else {
                              model.passwordEditingController.text = "";
                              baseWidgetModel.showOverLayWidget(
                                  false, Container());
                              baseWidgetModel.showOverLayWidget(
                                true,
                                InformationModal(
                                  typeInformationModal:
                                      TypeInformationModal.INFORMATION,
                                  title:
                                      AppLocalizations.of(context)?.warningText,
                                  contentText: AppLocalizations.of(context)
                                      ?.passwordIsNotCorrectText,
                                  acceptButton: () {
                                    baseWidgetModel.showOverLayWidget(
                                        false, Container());
                                  },
                                  icon: Icon(
                                    Icons.warning,
                                    color: Colors.yellow[700],
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context)?.acceptText ?? "",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    Expanded(flex: 05, child: Container()),
                    Expanded(
                      flex: 40,
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(7)),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            )),
                        child: TextButton(
                          style: const ButtonStyle(enableFeedback: false),
                          onPressed: () {
                            model.passwordEditingController.text = "";
                            baseWidgetModel.showOverLayWidget(
                                false, Container());
                          },
                          child: Text(
                            AppLocalizations.of(context)?.cancelText ?? "",
                            style: styleForButtons(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

@swidget
Widget __containerOfChargingTextAndSpinner(
  BuildContext context,
  // HomeViewModel model,
  // BaseWidgetModel baseWidgetModel
) {
  Size mediaQuery = MediaQuery.of(context).size;
  double heightCharge = mediaQuery.height * 0.20;
  double widthCharge = mediaQuery.width * 0.25;
  return Consumer2<HomeViewModel, BaseWidgetModel>(
    builder: (context, model, baseWidgetModel, _) {
      return Material(
        color: Colors.black26,
        child: Center(
          child: Container(
            width: widthCharge,
            height: heightCharge,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(7)),
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)?.chargingDataText ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: 22,
                        ),
                      ),
                      UIHelper.verticalSpace(30),
                      const CircularProgressIndicator()
                    ],
                  ),
                )),
          ),
        ),
      );
    },
  );
}

@swidget
Widget __authorizationModal(BuildContext context) {
  return Consumer2<HomeViewModel, BaseWidgetModel>(
    builder: (context, model, baseWidgetModel, _) {
      Size mediaQuery = MediaQuery.of(context).size;
      double height = mediaQuery.height * 0.40;
      double width = mediaQuery.width * 0.5;
      return Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(7)),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(7)),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
        ),
      );
    },
  );
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
            AppLocalizations.of(context)?.evoRestaurantText ?? "",
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
            model.errorMessage.isEmpty
                ? Expanded(
                    flex: 10,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          AppLocalizations.of(context)?.hallsText ?? "",
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: controlColorGray),
                        ))),
                  )
                : Container(),
            model.errorMessage.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(
                        horizontal: mediaQuery.width * 0.1,
                        vertical: mediaQuery.height * 0.1),
                    width: mediaQuery.width * 0.5,
                    height: mediaQuery.height * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(7)),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      width: mediaQuery.width * 0.5,
                      height: mediaQuery.height * 0.4,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(7)),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              model.errorMessage,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                  color: colorPrimary),
                            ),
                            TextButton(
                              onPressed: () {
                                model.flag = true;
                                model.errorMessage = "";
                                model.init(AppLocalizations.of(context));
                              },
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.replay,
                                    color: controlColorGray,
                                    size: 25,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)
                                            ?.tryAgainText ??
                                        "",
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: colorPrimary),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                : model.listOfHalls.isEmpty
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
                                        Navigator.pushNamed(
                                            context, "/hallView",
                                            arguments:
                                                model.listOfHalls[index]);
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
                                            LayoutBuilder(builder:
                                                (context, constraints) {
                                              return Container(
                                                height: constraints.maxHeight,
                                                width: constraints.maxHeight,
                                                decoration: BoxDecoration(
                                                  color: Colors.deepPurple,
                                                  borderRadius: borderRadius,
                                                ),
                                                child: const Icon(
                                                  Icons
                                                      .arrow_circle_right_outlined,
                                                  color: Colors.white,
                                                  size: 50,
                                                ),
                                              );
                                            }),
                                            Expanded(
                                              child: Text(
                                                model.listOfHalls[index].name ??
                                                    "",
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
