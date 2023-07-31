import 'dart:io' show Platform;

import 'package:evo_restaurant/repositories/enums/type_information_modal.dart';
import 'package:evo_restaurant/repositories/service/auth/user_service.dart';
import 'package:evo_restaurant/repositories/service/command_table/command_table_service.dart';
import 'package:evo_restaurant/repositories/service/family/family_service.dart';
import 'package:evo_restaurant/repositories/service/sub_family/sub_family_service.dart';
import 'package:evo_restaurant/repositories/view_models/base_widget_model.dart';
import 'package:evo_restaurant/ui/views/widgets/base_widget.dart';
import 'package:evo_restaurant/ui/views/widgets/information_modal/information_modal.dart';
import 'package:evo_restaurant/ui/views/widgets/loading/login_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:provider/provider.dart';

import '../../repositories/enums/view_state.dart';
import '../../repositories/models/family.dart';
import '../../repositories/models/user.dart';
import '../../repositories/service/table/table_service.dart';
import '../../repositories/view_models/table_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../utils/share/app_colors.dart';

part 'table_view.g.dart';

class TableView extends BaseWidget {
  const TableView({super.key});

  @override
  Widget getChild(BuildContext context, BaseWidgetModel baseWidgetModel) {
    Map<String, dynamic> data = Provider.of<Map<String, dynamic>>(context);

    return ChangeNotifierProxyProvider6<User, UserService, TableService,
        CommandTableService, FamilyService, SubFamilyService, TableViewModel>(
      create: (_) => TableViewModel(),
      update: (_, user, userService, tableService, commandTableService,
              familyService, subFamilyService, model) =>
          (model ?? TableViewModel())
            ..user = user
            ..userService = userService
            ..tableService = tableService
            ..commandTableService = commandTableService
            ..familyService = familyService
            ..context = context
            ..subFamilyService = subFamilyService
            ..table = data["table"]
            ..tableDetail = data["tableDetail"]
            ..init(),
      child: Consumer2<TableViewModel, BaseWidgetModel>(
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
            body: const _Body(),
          ),
        );
      }),
    );
  }
}

@swidget
Widget __body(BuildContext context) {
  return Consumer2<TableViewModel, BaseWidgetModel>(
    builder: (context, model, baseWidgetModel, _) {
      Size mediaQuery = MediaQuery.of(context).size;
      return const Row(
        children: [
          Expanded(flex: 30, child: _ContainerOfCommandAndDetails()),
          Expanded(flex: 70, child: _ContainerOfFamiliesAndSearch())
        ],
      );
    },
  );
}

@swidget
Widget __containerOfFamiliesAndSearch(BuildContext context) {
  return Consumer2<TableViewModel, BaseWidgetModel>(
      builder: (context, model, baseWidgetModel, _) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 90, child: _ContainerOfFamilies()),
        Expanded(
            flex: 10,
            child: Container(
              color: Colors.green,
            ))
      ],
    );
  });
}

@swidget
Widget __containerOfFamilies(BuildContext context) {
  return Consumer2<TableViewModel, BaseWidgetModel>(
      builder: (context, model, baseWidgetModel, _) {
    Size mediaQuery = MediaQuery.of(context).size;
    return model.listOfFamilies.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemCount: model.listOfFamilies.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () async {
                      HapticFeedback.mediumImpact();
                      baseWidgetModel.showOverLayWidget(
                          true,
                          InformationModal.loading(
                              typeInformationModal:
                                  TypeInformationModal.LOADING));
                      bool res = await model
                          .chargeSubfamily(model.listOfFamilies[index]);
                      if (res) {
                        double width = mediaQuery.width;
                        double height = mediaQuery.height;
                        Family family = model.listOfFamilies[index];
                        baseWidgetModel.showOverLayWidget(false, Container());
                        baseWidgetModel.showOverLayWidget(
                            true,
                            _SelectSubFamilyAndArticles(
                                model.listOfFamilies[index],
                                model,
                                baseWidgetModel)
                        );
                      } else {
                        baseWidgetModel.showOverLayWidget(false, Container());
                        baseWidgetModel.showOverLayWidget(
                            true,
                            InformationModal(
                                typeInformationModal:
                                    TypeInformationModal.WARNING,
                                title: AppLocalizations.of(context).warningText,
                                contentText: AppLocalizations.of(context)
                                    .loadChargeFailText,
                                acceptButton: () {
                                  baseWidgetModel.showOverLayWidget(
                                      false, Container());
                                },
                                icon: Icon(
                                  Icons.warning,
                                  color: Colors.yellow[700],
                                )));
                      }
                    },
                    child: Card(
                        color: Colors.grey[400],
                        child: Column(
                          children: [
                            Expanded(
                              flex: 80,
                              child: model.listOfFamilies[index].img != ""
                                  ? //model.listOfFamilies[index].image
                                  Image(
                                      image: model
                                          .listOfFamilies[index].image!.image,
                                      fit: BoxFit.contain,
                                    )
                                  : const Center(
                                      child: Text("N/A"),
                                    ),
                            ),
                            Expanded(
                                flex: 20,
                                child: Text(
                                  model.listOfFamilies[index].name ?? "",
                                  style: styleForDetails(),
                                ))
                          ],
                        )),
                  );
                }),
          );

    // ListView.builder(
    //   itemCount: model.listOfFamilies.length,
    //     itemBuilder: (BuildContext context, int index){
    //     return Container(
    //       decoration: const BoxDecoration(
    //         color: Colors.red
    //       ),
    //       width: mediaQuery.width * 0.1,
    //       height: mediaQuery.width * 0.1,
    //       child:model.listOfFamilies[index].img != ""
    //           ? model.listOfFamilies[index].image
    //           : const Center(child: Text("N/A"),),
    //     );
    //
    // })
    ;
  });
}

@swidget
Widget __selectSubFamilyAndArticles(BuildContext context, Family family,
    TableViewModel model, BaseWidgetModel baseWidgetModel) {
  Size mediaQuery = MediaQuery.of(context).size;
  double height = mediaQuery.height * 0.8;
  double width = mediaQuery.width * 0.8;
  return Material(
    color: Colors.black87,
    child: Center(
      child: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: height * 0.10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: colorPrimary,
              ),
              child: Row(children: [
                Expanded(
                  flex: 90,
                  child: Center(
                    child: Text(
                      family.name ?? "",
                      style: styleForButton(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Center(
                    child: IconButton(
                        onPressed: () {
                          model.clearListOfSubFamily();
                          model.listOfArticlesBySubFamily.clear();
                          baseWidgetModel.showOverLayWidget(false, Container());
                        },
                        icon: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.white,
                          size: 27,
                        )),
                  ),
                )
              ]),
            ),
            Expanded(
              flex: 80,
              child: Row(
                children: [
                  Expanded(
                    flex: 20,
                    child: SizedBox(
                      width: width * 0.20,
                      height: height - (height * 0.25),
                      child: ListView.builder(
                          itemCount: model.listOfSubFamilies.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () async {
                                model.listOfArticlesBySubFamily.clear();
                                print("tap SubFamily");
                                bool res =
                                    await model.chargeArticlesOfSubFamily(
                                        model.listOfSubFamilies[index].id ??
                                            "0",
                                        family.id ?? "0");
                                if (!res) {
                                  baseWidgetModel.showOverLayWidget(
                                      true,
                                      InformationModal(
                                          typeInformationModal:
                                              TypeInformationModal.ERROR,
                                          title: AppLocalizations.of(context)
                                              .errorText,
                                          contentText:
                                              AppLocalizations.of(context)
                                                  .somethingWentWrongText,
                                          acceptButton: () {
                                            baseWidgetModel.showOverLayWidget(
                                                false, Container());
                                          },
                                          icon: Icon(
                                            Icons.error,
                                            color: Colors.red[700],
                                            size: 33,
                                          )));
                                }
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(7)),
                                    color: Colors.grey[600],
                                  ),
                                  child: Column(
                                    children: [
                                      model.listOfSubFamilies[index].img != ""
                                          ? Image(
                                              image: model
                                                  .listOfSubFamilies[index]
                                                  .image!
                                                  .image)
                                          : const Text("N/A"),
                                      Center(
                                        child: Text(model
                                                .listOfSubFamilies[index]
                                                .name ??
                                            ""),
                                      )
                                    ],
                                  )),
                            );
                          }),
                    ),
                  ),
                  Expanded(
                    flex: 80,
                    child: model.listOfArticlesBySubFamily.isEmpty
                        ? Container()
                        : SizedBox(
                            width: width * 0.80,
                            height: height - (height * 0.17),
                            child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                ),
                                itemCount:
                                    model.listOfArticlesBySubFamily.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () async {
                                      HapticFeedback.mediumImpact();
                                    },
                                    child: Card(
                                        color: Colors.grey[400],
                                        child: Column(
                                          children: [
                                            Expanded(
                                              flex: 80,
                                              child: model
                                                          .listOfArticlesBySubFamily[
                                                              index]
                                                          .img !=
                                                      ""
                                                  ? //model.listOfFamilies[index].image
                                                  Image(
                                                      image: model
                                                          .listOfArticlesBySubFamily[
                                                              index]
                                                          .image!
                                                          .image,
                                                      fit: BoxFit.contain,
                                                    )
                                                  : const Center(
                                                      child: Text("N/A"),
                                                    ),
                                            ),
                                            Expanded(
                                                flex: 20,
                                                child: Text(
                                                  model
                                                          .listOfArticlesBySubFamily[
                                                              index]
                                                          .name ??
                                                      "",
                                                  style: styleForDetails(),
                                                ))
                                          ],
                                        )),
                                  );
                                }),
                          ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 10,
              child: TextButton(
                  onPressed: () {
                    baseWidgetModel.showOverLayWidget(false, Container());
                  },
                  child: Text("OK")),
            )
          ],
        ),
      ),
    ),
  );
}

@swidget
Widget __containerOfCommandAndDetails(BuildContext context) {
  return Consumer2<TableViewModel, BaseWidgetModel>(
    builder: (context, model, baseWidgetModel, _) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(5),
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              border: Border.all(
                color: Colors.black,
                width: 1,
              )),
          child: const Column(
            children: [
              Expanded(flex: 70, child: _ContainerOfCommands()),
              Expanded(
                flex: 30,
                child: _ContainerOfInformationAndTotal(),
              )
            ],
          ),
        ),
      );
    },
  );
}

@swidget
Widget __containerOfInformationAndTotal(BuildContext context) {
  return Consumer2<TableViewModel, BaseWidgetModel>(
      builder: (context, model, baseWidgetModel, _) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(7)),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ContainerOfDate(),
            _ContainerOfUser(),
            _ContainerOfTotal(),
            _ContainerOfApplyButton(),
          ],
        ),
      ),
    );
  });
}

@swidget
Widget __containerOfApplyButton(BuildContext context) {
  return Consumer2<TableViewModel, BaseWidgetModel>(
      builder: (context, model, baseWidgetModel, _) {
    Size mediaQuery = MediaQuery.of(context).size;
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.black87,
      backgroundColor: colorPrimaryLight,
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(7)),
      ),
    );
    return SizedBox(
      width: mediaQuery.width * 0.2,
      child: ElevatedButton(
        style: raisedButtonStyle,
        onPressed: () {},
        child: Text(
          AppLocalizations.of(context).applyText,
          style: styleForButton(),
        ),
      ),
    );
  });
}

@swidget
Widget __containerOfTotal(BuildContext context) {
  return Consumer2<TableViewModel, BaseWidgetModel>(
      builder: (context, model, baseWidgetModel, _) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context).totalText,
          style: styleForDetails(),
        ),
        Text(
          model.getTotalOfCommand(),
          style: styleForDetails(),
        ),
      ],
    );
  });
}

@swidget
Widget __containerOfUser(BuildContext context) {
  return Consumer2<TableViewModel, BaseWidgetModel>(
    builder: (context, model, baseWidgetModel, _) {
      return Container(
        color: colorSurface,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${AppLocalizations.of(context).attendedByText}:",
              style: styleForDetails(),
            ),
            Text(
              model.user.name?.toUpperCase() ?? "",
              style: styleForDetails(),
            )
          ],
        ),
      );
    },
  );
}

@swidget
Widget __containerOfDate(BuildContext context) {
  return Container(
    alignment: Alignment.centerLeft,
    child: Text(
      "${AppLocalizations.of(context).dateText}:"
      " ${DateTime.now().day}-"
      "${DateTime.now().month}-"
      "${DateTime.now().year}"
      "  ${DateTime.now().hour}:"
      "${DateTime.now().minute}",
      style: styleForDetails(),
    ),
  );
}

@swidget
Widget __containerOfCommands(BuildContext context) {
  return Consumer2<TableViewModel, BaseWidgetModel>(
    builder: (context, model, baseWidgetModel, _) {
      return ListView.builder(
        itemCount: model.tableDetail.commandTable?.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Column(
              children: [
                Row(children: [
                  Expanded(
                    flex: 40,
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context).articleText,
                          textAlign: TextAlign.center,
                          style: styleForTitle(),
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(width: 1, color: Colors.black),
                            ),
                          ),
                          child: Text(
                            model.tableDetail.commandTable?[index].name ?? "",
                            style: styleForArticle(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 25,
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context).quantityText,
                          textAlign: TextAlign.center,
                          style: styleForTitle(),
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(width: 1, color: Colors.black),
                            ),
                          ),
                          child: Text(
                            "x ${model.tableDetail.commandTable?[index].can ?? 0}",
                            style: styleForArticle(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 35,
                      child: Column(
                        children: [
                          Text(
                            AppLocalizations.of(context).priceText,
                            textAlign: TextAlign.center,
                            style: styleForTitle(),
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(width: 1, color: Colors.black),
                              ),
                            ),
                            child: Text(
                              "${(model.tableDetail.commandTable?[index].pre ?? 0) * (model.tableDetail.commandTable?[index].can ?? 0)}",
                              style: styleForArticle(),
                            ),
                          ),
                        ],
                      ))
                ]),
              ],
            );
          }
          return Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.black),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 40,
                  child: Text(
                    model.tableDetail.commandTable?[index].name ?? "",
                    textAlign: TextAlign.center,
                    style: styleForArticle(),
                  ),
                ),
                Expanded(
                  flex: 25,
                  child: Text(
                    "x ${model.tableDetail.commandTable?[index].can ?? 0}",
                    textAlign: TextAlign.center,
                    style: styleForArticle(),
                  ),
                ),
                Expanded(
                  flex: 35,
                  child: Text(
                    "${(model.tableDetail.commandTable?[index].pre ?? 0) * (model.tableDetail.commandTable?[index].can ?? 0)}",
                    textAlign: TextAlign.center,
                    style: styleForArticle(),
                  ),
                )
              ],
            ),
          );
        },
      );
    },
  );
}

TextStyle styleForArticle() {
  return const TextStyle(
      fontWeight: FontWeight.w600, color: Colors.black, fontSize: 20);
}

TextStyle styleForTitle() {
  return const TextStyle(
      fontWeight: FontWeight.w700, color: colorPrimary, fontSize: 23);
}

TextStyle styleForDetails() {
  return const TextStyle(
      fontWeight: FontWeight.w500, color: Colors.black, fontSize: 15);
}

TextStyle styleForButton() {
  return const TextStyle(
      fontWeight: FontWeight.w700, color: Colors.white, fontSize: 23);
}
