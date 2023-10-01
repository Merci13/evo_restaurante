// ignore_for_file: use_build_context_synchronously

import 'dart:io' show Platform;

import 'package:evo_restaurant/repositories/enums/type_information_modal.dart';
import 'package:evo_restaurant/repositories/models/family.dart';
import 'package:evo_restaurant/repositories/models/sub_family.dart';
import 'package:evo_restaurant/repositories/service/auth/user_service.dart';
import 'package:evo_restaurant/repositories/service/command_table/command_table_service.dart';
import 'package:evo_restaurant/repositories/service/family/family_service.dart';
import 'package:evo_restaurant/repositories/service/sub_family/sub_family_service.dart';
import 'package:evo_restaurant/repositories/view_models/base_widget_model.dart';
import 'package:evo_restaurant/ui/views/widgets/base_widget.dart';
import 'package:evo_restaurant/ui/views/widgets/information_modal/information_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:provider/provider.dart';
import '../../repositories/models/article.dart';
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
                enableFeedback: false,
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
    Size mediaQuery = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AnimatedSwitcher(
          duration: const Duration(seconds: 2),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: SizedBox(
              width: mediaQuery.width * 0.55,
              child: model.isFamilySelected != -1
                  ? const _ContainerOfSubFamilyAndArticlesOfFamily(
                      key: ValueKey(2),
                    )
                  : const _ContainerOfFamilies(
                      key: ValueKey(1),
                    )),
        ),
        SizedBox(
            width: mediaQuery.width * 0.10,
            child: Container(
              color: Colors.green,
            ))
      ],
    );
  });
}

@swidget
Widget __containerOfSubFamilyAndArticlesOfFamily(BuildContext context) {
  return Consumer2<TableViewModel, BaseWidgetModel>(
      builder: (context, model, baseWidgetModel, _) {
    Size mediaQuery = MediaQuery.of(context).size;
    bool hasArticlesOfFamily = model.listOfArticlesByFamily.isNotEmpty;
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      width: mediaQuery.width * 0.55,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(7)),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(7)),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: ListView(
          children: [
            _ContainerOfNameOfFamily(
                model.listOfFamilies[model.isFamilySelected].name ?? ""),
            //Articles that are directly ancestors of the family
            hasArticlesOfFamily
                ? const _ContainerOfArticlesOfFamily()
                : Container(),

            AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: SizedBox(
                width: mediaQuery.width * 0.55,
                child: model.subfamilySelected != -1
                    ?  _ContainerOfArticlesOfSubFamily(
                    hasArticlesOfFamily,
                        key: const ValueKey(4),
                      )
                    : _ContainerOfSubFamilies(
                        key: const ValueKey(3), hasArticlesOfFamily),
              ),
            ),
          ],
        ),
      ),
    );
  });
}

@swidget
Widget __containerOfArticlesOfSubFamily(BuildContext context, bool hasArticlesOfFamily) {
  return Consumer2<TableViewModel, BaseWidgetModel>(
      builder: (context, model, baseWidgetModel, _) {
    Size mediaQuery = MediaQuery.of(context).size;

    return Column(
      children: [
        _ContainerOfSubFamilyName(model.listOfSubFamilies[model.subfamilySelected].name ?? ""),
        SizedBox(
           width: mediaQuery.width * 0.55,
          height: hasArticlesOfFamily
              ? mediaQuery.height * 0.50
              : mediaQuery.height * 0.80,
          child: model.listOfArticlesBySubFamily.isNotEmpty ?

          GridView.builder(
          scrollDirection: Axis.vertical,
            itemCount: model.listOfArticlesBySubFamily.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemBuilder: (BuildContext context, int index) {

              return Container(
                margin: const EdgeInsets.all(5),
                color: index % 2 == 0 ? Colors.green : Colors.red,
                child: Text(model.listOfArticlesBySubFamily[index].name ?? ""),
              );
            })
          : Center(
            child: Text(
              AppLocalizations.of(context).noArticlesText
            ),
          )

          ,
        ),
      ],
    );
  });
}
@swidget
Widget __containerOfSubFamilyName(BuildContext context, String name) {
  return Consumer2<TableViewModel, BaseWidgetModel>(
      builder: (context, model, baseWidgetModel, _) {
        Size mediaQuery = MediaQuery.of(context).size;
        return Container(
          width: double.infinity,
          height: mediaQuery.height * 0.05,
          color: colorPrimary,
          child: Row(
            children: [
              Expanded(
                  flex: 10,
                  child: IconButton(
                    enableFeedback: false,
                    icon: const Icon(
                      Icons.arrow_drop_up,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () {
                      model.subfamilySelected = -1;

                    },
                  )),
              Expanded(
                flex: 90,
                child: Center(
                  child: Text(
                    name,
                    style: styleForTitleFamily(),
                  ),
                ),
              )
            ],
          ),
        );
      });
}

@swidget
Widget __containerOfSubFamilies(
    BuildContext context, bool hasArticlesOfFamily) {
  return Consumer2<TableViewModel, BaseWidgetModel>(
      builder: (context, model, baseWidgetModel, _) {
    Size mediaQuery = MediaQuery.of(context).size;
    return SizedBox(
      height: hasArticlesOfFamily
          ? mediaQuery.height * 0.50
          : mediaQuery.height * 0.80,
      child: Column(
        children: [
          Expanded(
            flex: 10,
            child: Container(
              color: colorAccent,
              child: Center(
                child: Text(model.subfamilySelected == -1
                    ? AppLocalizations.of(context).subFamiliesText
                    : model.listOfSubFamilies[model.subfamilySelected].name ??
                        ""),
              ),
            ),
          ),
          Expanded(
            flex: 90,
            child: model.listOfSubFamilies.isEmpty ?
                Center(child: Text(AppLocalizations.of(context).noSubFamiliesText),)
                : GridView.builder(
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: model.listOfSubFamilies.length,
              itemBuilder: (BuildContext context, int index) {
                SubFamily subFamily = model.listOfSubFamilies[index];

                return TextButton(
                  onPressed: () async {
                    //load the articles of the sub-family
                    bool res = await model.loadArticlesOfSubfamily(index);
                    if (res) {
                      model.subfamilySelected = index;
                    } else {
                      baseWidgetModel.showOverLayWidget(
                          true,
                          InformationModal(
                              typeInformationModal: TypeInformationModal.ERROR,
                              title: AppLocalizations.of(context)
                                  .unavailableToLoadData,
                              contentText: AppLocalizations.of(context)
                                  .somethingWentWrongText,
                              acceptButton: () {
                                baseWidgetModel.showOverLayWidget(
                                    false, Container());
                              },
                              icon: Icon(
                                Icons.error,
                                color: Colors.red[800],
                                size: 40,
                              )));
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: index % 2 == 0 ? Colors.purple : Colors.blue,
                    child: Text(subFamily.name??""),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  });
}

@swidget
Widget __containerOfArticlesOfFamily(BuildContext context) {
  return Consumer2<TableViewModel, BaseWidgetModel>(
      builder: (context, model, baseWidgetModel, _) {
    Size mediaQuery = MediaQuery.of(context).size;
    return SizedBox(
      height: mediaQuery.height * 0.50,
      child: Column(
        children: [
          Expanded(
            flex: 10,
            child: Container(
              color: colorAccent,
              child: Center(
                child: Text(AppLocalizations.of(context).articleText),
              ),
            ),
          ),
          Expanded(
            flex: 90,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(6),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: model.listOfArticlesByFamily.length,
              itemBuilder: (BuildContext context, int index) {
                Article article = model.listOfArticlesByFamily[index];
                return Container(
                  margin: const EdgeInsets.all(5),
                  width: double.infinity,
                  height: double.infinity,
                  color: index % 2 == 0 ? Colors.green : Colors.purple,
                  child: Text(article.name ?? "N/A"),
                );
              },
            ),
          ),
        ],
      ),
    );
  });
}

@swidget
Widget __containerOfNameOfFamily(BuildContext context, String name) {
  return Consumer2<TableViewModel, BaseWidgetModel>(
    builder: (context, model, baseWidgetModel, _) {
      Size mediaQuery = MediaQuery.of(context).size;
      return Container(
        width: double.infinity,
        height: mediaQuery.height * 0.05,
        color: colorPrimary,
        child: Row(
          children: [
            Expanded(
                flex: 10,
                child: IconButton(
                  enableFeedback: false,
                  icon: const Icon(
                    Icons.arrow_drop_up,
                    color: Colors.white,
                    size: 40,
                  ),
                  onPressed: () {
                    model.subfamilySelected = -1;
                    model.isFamilySelected = -1;
                  },
                )),
            Expanded(
              flex: 90,
              child: Center(
                child: Text(
                  name,
                  style: styleForTitleFamily(),
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}

@swidget
Widget __containerOfFamilies(BuildContext context) {
  return Consumer2<TableViewModel, BaseWidgetModel>(
      builder: (context, model, baseWidgetModel, _) {
    Size mediaQuery = MediaQuery.of(context).size;
    return model.listOfFamilies.isEmpty
        ? const Center(
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
                  Family family = model.listOfFamilies[index];
                  return InkWell(
                    enableFeedback: false,
                    onTap: () async {
                      //deploy the family articles and sub-family
                      baseWidgetModel.showOverLayWidget(
                          true,
                          const InformationModal.loading(
                              typeInformationModal:
                                  TypeInformationModal.LOADING));
                      bool res =
                          await model.loadArticlesOfFamilyAndSubfamilies(index);
                      if (res) {
                        baseWidgetModel.showOverLayWidget(false, Container());
                        model.isFamilySelected = index;
                      } else {
                        baseWidgetModel.showOverLayWidget(false, Container());

                        baseWidgetModel.showOverLayWidget(
                          true,
                          InformationModal(
                            typeInformationModal: TypeInformationModal.ERROR,
                            title: AppLocalizations.of(context)
                                .somethingWentWrongText,
                            contentText: AppLocalizations.of(context)
                                .unavailableToLoadData,
                            acceptButton: () {
                              baseWidgetModel.showOverLayWidget(
                                  false, Container());
                            },
                            icon: Icon(
                              Icons.error,
                              color: Colors.red[800],
                              size: 40,
                            ),
                          ),
                        );
                      }
                    },
                    child: Card(
                        color: Colors.grey[400],
                        child: Column(
                          children: [
                            Expanded(
                              flex: 80,
                              child: family.img != ""
                                  ? Image(
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
                                  family.name ?? "",
                                  style: styleForDetails(),
                                ))
                          ],
                        )),
                  );
                }),
          );
  });
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
      enableFeedback: false,
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

TextStyle styleForTitleFamily() {
  return const TextStyle(
      fontWeight: FontWeight.w700, color: Colors.white, fontSize: 20);
}
