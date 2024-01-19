// ignore_for_file: use_build_context_synchronously

import 'dart:io' show Platform;

import 'package:evo_restaurant/repositories/enums/type_information_modal.dart';
import 'package:evo_restaurant/repositories/models/command_table.dart';
import 'package:evo_restaurant/repositories/models/family.dart';
import 'package:evo_restaurant/repositories/models/sub_family.dart';
import 'package:evo_restaurant/repositories/service/auth/user_service.dart';
import 'package:evo_restaurant/repositories/service/command_table/command_table_service.dart';
import 'package:evo_restaurant/repositories/service/family/family_service.dart';
import 'package:evo_restaurant/repositories/service/sub_family/sub_family_service.dart';
import 'package:evo_restaurant/repositories/view_models/base_widget_model.dart';
import 'package:evo_restaurant/ui/views/widgets/base_widget.dart';
import 'package:evo_restaurant/ui/views/widgets/information_modal/information_modal.dart';
import 'package:evo_restaurant/utils/share/ui_helpers.dart';
import 'package:flutter/material.dart';
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
              title:
                  Text(AppLocalizations.of(context)?.evoRestaurantText ?? ""),
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
            body: model.errorMessageInit != ""
                ? _ErrorInitMessage(model.errorMessageInit)
                : const _Body(),
          ),
        );
      }),
    );
  }
}

@swidget
Widget __errorInitMessage(BuildContext context, String errorMessage) {
  Size mediaQuery = MediaQuery.of(context).size;
  return Center(
    child: Container(
      width: mediaQuery.width * 0.4,
      height: mediaQuery.width * 0.3,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(7)),
          color: Colors.white),
      padding: EdgeInsets.all(5),
      child: Container(
        width: mediaQuery.width * 0.7,
        height: mediaQuery.width * 0.4,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(7)),
            color: Colors.white),
        child: Column(
          children: [
            Expanded(
              flex: 25,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                    color: colorPrimary,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(7),
                        topLeft: Radius.circular(7))),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)?.evoRestaurantText ?? "",
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    errorMessage,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.black),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 25,
              child: Container(
                width: mediaQuery.width * 0.1,
                height: mediaQuery.height * 0.1,
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppLocalizations.of(context)?.acceptText ?? "",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

@swidget
Widget __body(BuildContext context) {
  return Consumer2<TableViewModel, BaseWidgetModel>(
    builder: (context, model, baseWidgetModel, _) {
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
    return Padding(
      padding: const EdgeInsets.only(top: 5, right: 5),
      child: Column(
        children: [
          SizedBox(
            height: mediaQuery.height * 0.095,
            child: Container(
              decoration: const BoxDecoration(
                  color: colorPrimary,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(7),
                      topRight: Radius.circular(7))),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)?.familiesText ?? "",
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        const VerticalDivider(),
                        const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 35,
                        ),
                        Text(
                          AppLocalizations.of(context)?.searchArticleText ?? "",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(seconds: 2),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: SizedBox(
                height: mediaQuery.width * 0.53,
                child: model.isFamilySelected != -1
                    ? const _ContainerOfSubFamilyAndArticlesOfFamily(
                        key: ValueKey(2),
                      )
                    : const _ContainerOfFamilies(
                        key: ValueKey(1),
                      )),
          ),
        ],
      ),
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
                    ? _ContainerOfArticlesOfSubFamily(
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
Widget __containerOfArticlesOfSubFamily(
    BuildContext context, bool hasArticlesOfFamily) {
  return Consumer2<TableViewModel, BaseWidgetModel>(
      builder: (context, model, baseWidgetModel, _) {
    Size mediaQuery = MediaQuery.of(context).size;

    return Column(
      children: [
        _ContainerOfSubFamilyName(
            model.listOfSubFamilies[model.subfamilySelected].name ?? ""),
        SizedBox(
          width: mediaQuery.width * 0.55,
          height: hasArticlesOfFamily
              ? mediaQuery.height * 0.50
              : mediaQuery.height * 0.80,
          child: model.listOfArticlesBySubFamily.isNotEmpty
              ? GridView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: model.listOfArticlesBySubFamily.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return _ContainerOfArticleComponent(
                        model.listOfArticlesBySubFamily[index]);
                  })
              : Center(
                  child:
                      Text(AppLocalizations.of(context)?.noArticlesText ?? ""),
                ),
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
                child: Text(
                  model.subfamilySelected == -1
                      ? AppLocalizations.of(context)?.subFamiliesText ?? ""
                      : model.listOfSubFamilies[model.subfamilySelected].name ??
                          "",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 15),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 90,
            child: model.listOfSubFamilies.isEmpty
                ? Center(
                    child: Text(
                        AppLocalizations.of(context)?.noSubFamiliesText ?? ""),
                  )
                : GridView.builder(
                    scrollDirection: Axis.vertical,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    itemCount: model.listOfSubFamilies.length,
                    itemBuilder: (BuildContext context, int index) {
                      SubFamily subFamily = model.listOfSubFamilies[index];

                      return _ContainerOfSubFamilyComponent(subFamily, index);
                    },
                  ),
          ),
        ],
      ),
    );
  });
}

@swidget
Widget __containerOfSubFamilyComponent(
    BuildContext context, SubFamily subFamily, int index) {
  return Consumer2<TableViewModel, BaseWidgetModel>(
      builder: (context, model, baseWidgetModel, _) {
    bool hasImage = subFamily.img != "";

    return TextButton(
      onPressed: () async {
        //load the articles of the sub-family
        bool res = await model.loadArticlesOfSubfamily(subFamily.id ?? "");
        if (res) {
          model.subfamilySelected = index;
        } else {
          baseWidgetModel.showOverLayWidget(
              true,
              InformationModal(
                  typeInformationModal: TypeInformationModal.ERROR,
                  title:
                      AppLocalizations.of(context)?.unavailableToLoadData ?? "",
                  contentText:
                      AppLocalizations.of(context)?.somethingWentWrongText ??
                          "",
                  acceptButton: () {
                    baseWidgetModel.showOverLayWidget(false, Container());
                  },
                  icon: Icon(
                    Icons.error,
                    color: Colors.red[800],
                    size: 40,
                  )));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(7)),
          border: Border.all(width: 1, color: Colors.black),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 25,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7),
                    topRight: Radius.circular(7),
                  ),
                  color: colorPrimary,
                ),
                child: Center(
                  child: Text(
                    subFamily.name ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 75,
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                ),
                child: hasImage
                    ? Image(
                        image: subFamily.image!.image,
                        fit: BoxFit.fill,
                      )
                    : const Center(
                        child: Text(
                          "N/A",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
              ),
            )
          ],
        ),
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
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                AppLocalizations.of(context)?.articleText ?? "",
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 15),
              ),
            ),
          ),
          Expanded(
            flex: 90,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: model.listOfArticlesByFamily.length,
              itemBuilder: (BuildContext context, int index) {
                Article article = model.listOfArticlesByFamily[index];

                return _ContainerOfArticleComponent(article);
              },
            ),
          ),
        ],
      ),
    );
  });
}

@swidget
Widget __containerOfArticleComponent(BuildContext context, Article article) {
  return Consumer2<TableViewModel, BaseWidgetModel>(
      builder: (context, model, baseWidgetModel, _) {
    bool hasImage = article.img != "";
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        enableFeedback: false,
        onTap: () {
          model.addArticleToCommand(article);
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(7)),
              border: Border.all(width: 1, color: Colors.black)),
          child: Column(
            children: [
              Expanded(
                flex: 25,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(6),
                          topLeft: Radius.circular(6)),
                      color: colorPrimary),
                  child: Center(
                    child: Text(
                      article.name ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 15,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 75,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7.0),
                    child: hasImage
                        ? Image(
                            image: article.image!.image,
                            fit: BoxFit.fill,
                          )
                        : const Center(
                            child: Text(
                              "N/A",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: colorPrimary),
                            ),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
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
                                    ?.somethingWentWrongText ??
                                "",
                            contentText: AppLocalizations.of(context)
                                    ?.unavailableToLoadData ??
                                "",
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
                                flex: 20,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: colorPrimary,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(7),
                                        topLeft: Radius.circular(7)),
                                  ),
                                  child: Text(
                                    family.name ?? "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 15,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                )),
                            Expanded(
                              flex: 80,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8)),
                                child: family.img != ""
                                    ? Image(
                                        image: model
                                            .listOfFamilies[index].image!.image,
                                        fit: BoxFit.fill,
                                      )
                                    : const Center(
                                        child: Text("N/A"),
                                      ),
                              ),
                            ),
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
        padding: const EdgeInsets.all(5),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(7)),
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
        onPressed: () async {
          baseWidgetModel.showOverLayWidget(
              true,
              const InformationModal.loading(
                  typeInformationModal: TypeInformationModal.LOADING));
          bool res = await model.sendCommand();
          if (res) {
            baseWidgetModel.showOverLayWidget(false, Container());
            baseWidgetModel.showOverLayWidget(true, _ApproveCommandMessage());
          } else {
            baseWidgetModel.showOverLayWidget(false, Container());
            baseWidgetModel.showOverLayWidget(
                true,
                InformationModal(
                    typeInformationModal: TypeInformationModal.ERROR,
                    title: AppLocalizations.of(context)?.errorText ?? "",
                    contentText:
                        AppLocalizations.of(context)?.somethingWentWrongText ??
                            "",
                    acceptButton: () {
                      baseWidgetModel.showOverLayWidget(false, Container());
                    },
                    icon: Icon(
                      Icons.warning,
                      color: Colors.yellow[700],
                      size: 40,
                    )));
          }
        },
        child: Text(
          AppLocalizations.of(context)?.applyText ?? "",
          style: styleForButton(),
        ),
      ),
    );
  });
}

@swidget
Widget __approveCommandMessage(BuildContext context) {
  Size mediaQuery = MediaQuery.of(context).size;
  return Material(
    color: Colors.transparent,
    child: Container(
      width: mediaQuery.width,
      height: mediaQuery.height,
      color: const Color(0xbd000000),
      child: Center(
        child: Container(
          width: mediaQuery.width * 0.5,
          height: mediaQuery.height * 0.5,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(7)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                flex: 20,
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(7),
                          topLeft: Radius.circular(7),
                        ),
                        color: colorPrimary),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)?.evoRestaurantText ?? "",
                        style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                    )),
              ),
              Expanded(
                flex: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 100,
                      color: Color(0xff1ce210),
                    ),
                    UIHelper.verticalSpace(20),
                    Text(
                      AppLocalizations.of(context)?.approveCommandText ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: colorPrimary),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 20,
                child: Container(
                  width: mediaQuery.width * 0.2,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimary,
                      enableFeedback: false,
                      elevation: 5,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)?.acceptText ?? "",
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
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
Widget __containerOfTotal(BuildContext context) {
  return Consumer2<TableViewModel, BaseWidgetModel>(
      builder: (context, model, baseWidgetModel, _) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)?.totalText ?? "",
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
              "${AppLocalizations.of(context)?.attendedByText ?? ""}:",
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
      "${AppLocalizations.of(context)?.dateText ?? ""}: "
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
      Size mediaQuery = MediaQuery.of(context).size;

      return Column(
        children: [
          const _ContainerOfTitleOfCommand(),
          UIHelper.verticalSpace(10),
          model.listOfCommand.isNotEmpty
              ? Flexible(
                  fit: FlexFit.loose,
                  child: ListView.builder(
                    itemCount: model.listOfCommand.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      CommandTable command = model.listOfCommand[index];
                      const double sizeButton = 30.0;
                      return Container(
                        decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            color: Colors.white70),
                        child: SizedBox(
                          width: double.infinity,
                          height: mediaQuery.height * 0.09,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 50,
                                child: Text(
                                  command.name ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: controlColorGray,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 50,
                                child: Row(
                                  children: [
                                    _ContainerOfPriceCommandLine(
                                        "${command.pre ?? 0}"),
                                    Expanded(
                                      flex: 50,
                                      child: Row(
                                        children: [
                                          _ContainerMinusCommandLine(index),
                                          Expanded(
                                            flex: 40,
                                            child: Container(
                                              alignment: Alignment.center,
                                              child:
                                                  Text("${command.can ?? "0"}"),
                                            ),
                                          ),
                                          _ContainerOfPlusCommandLine(index),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Container(
                  width: double.infinity,
                  height: mediaQuery.height * 0.1,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset:
                            const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)?.noArticlesText ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: Colors.black),
                    ),
                  ),
                ),
        ],
      );
    },
  );
}

@swidget
Widget __containerOfPlusCommandLine(BuildContext context, int index) {
  return Consumer2<TableViewModel, BaseWidgetModel>(
      builder: (context, model, baseWidgetModel, _) {
    const double sizeButton = 30.0;
    return Expanded(
      flex: 30,
      child: Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          icon: const Icon(
            Icons.add_circle,
            color: colorPrimary,
            size: sizeButton,
          ),
          onPressed: () {
            model.add(index);
          },
        ),
      ),
    );
  });
}

@swidget
Widget __containerMinusCommandLine(BuildContext context, int index) {
  return Consumer2<TableViewModel, BaseWidgetModel>(
    builder: (context, model, baseWidgetModel, _) {
      const double sizeButton = 30.0;
      bool wasCheckedByAdmin = false;
      return Expanded(
        flex: 30,
        child: Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(
              Icons.do_not_disturb_on_outlined,
              color: colorPrimary,
              size: sizeButton,
            ),
            onPressed: () async {
              bool res = model.restArticle(index);
              /*
               * if res is false
                  means that is resting amount
                  articles that the original command that are provide from the API
                  ask for administrator password.
                  * also
                  * Check if the admin provides the password for this line before,
                  * if it was, don't request the password
               * */
              if(wasCheckedByAdmin){
                model.restArticleByAdmin(index);
              }else{
                if (!res) {
                  baseWidgetModel.showOverLayWidget(
                    true,
                    _ContainerOfRequestPasswordOfAdmin(
                      accept: (textEditingController) {
                        model.administratorPasswordTextController.text =
                            textEditingController.text;
                        bool res = model.checkAdminPassword();

                        if(res){
                          model.restArticleByAdmin(index);
                        }
                      },
                      cancel: () {
                        baseWidgetModel.showOverLayWidget(false, Container());
                      },
                    ),
                  );
                }
              }

            },
          ),
        ),
      );
    },
  );
}

@swidget
Widget __containerOfPriceCommandLine(BuildContext context, String price) {
  return Expanded(
    flex: 50,
    child: Text(
      "${AppLocalizations.of(context)?.priceText ?? ""}:"
      " $price}",
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.w600, color: controlColorGray),
    ),
  );
}

@swidget
Widget __containerOfRequestPasswordOfAdmin(BuildContext context,
    {required Function accept, required Function cancel}) {
  Size mediaQuery = MediaQuery.of(context).size;
  FocusNode focusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();
  return Material(
    color: Colors.black87,
    child: Container(
      width: mediaQuery.width * 0.50,
      height: mediaQuery.height * 0.40,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(7)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 25,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  color: colorPrimary,
                ),
                child: Text(
                  AppLocalizations.of(context)?.passwordIsRequiredText ?? "",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: Colors.white),
                ),
              )),
          Expanded(
              flex: 50,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)
                              ?.enterAAdministratorPasswordText ??
                          "",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  TextFormField(
                    focusNode: focusNode,
                    controller: textEditingController,
                    decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                                ?.enterPasswordHintText ??
                            "",
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                            color: controlColorGray)),
                  ),
                ],
              )),
          Expanded(
              flex: 25,
              child: Row(
                children: [
                  Container(
                    width: mediaQuery.width * 0.3,
                    color: colorPrimary,
                    child: ElevatedButton(
                      onPressed: () {
                        accept(textEditingController);
                      },
                      child: Text(
                        AppLocalizations.of(context)?.acceptText ?? "",
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    width: mediaQuery.width * 0.3,
                    color: Colors.red[800],
                    child: ElevatedButton(
                      onPressed: () {
                        cancel();
                      },
                      child: Text(
                        AppLocalizations.of(context)?.cancelText ?? "",
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    ),
  );
}

@swidget
Widget __containerOfTitleOfCommand(BuildContext context) {
  return Container(
      height: MediaQuery.of(context).size.height * 0.05,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 10),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(7), topLeft: Radius.circular(7)),
          color: colorPrimary),
      child: Text(
        AppLocalizations.of(context)?.articlesText ?? "",
        style: const TextStyle(
            fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
      ));
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
