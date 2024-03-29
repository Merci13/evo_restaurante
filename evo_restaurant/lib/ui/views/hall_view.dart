// ignore_for_file: use_build_context_synchronously

import 'dart:io' show Platform;
import 'package:evo_restaurant/repositories/enums/type_information_modal.dart';
import 'package:evo_restaurant/repositories/models/hall.dart';
import 'package:evo_restaurant/repositories/models/response_object.dart';

import 'package:evo_restaurant/repositories/service/auth/user_service.dart';
import 'package:evo_restaurant/repositories/view_models/base_widget_model.dart';

import 'package:evo_restaurant/ui/views/widgets/base_widget.dart';
import 'package:evo_restaurant/ui/views/widgets/information_modal/information_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      Size mediaQuery = MediaQuery.of(context).size;

      BorderRadius borderRadius = BorderRadius.circular(8.0);
      double appbarHeight = const Size.fromHeight(70.0).height;
      return Container(
        height: mediaQuery.height - appbarHeight,
        width: mediaQuery.width,
        padding: const EdgeInsets.only(top: 20, bottom: 50),
        child: model.listOfTables.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: model.listOfTables.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          AppLocalizations.of(context)?.tablesText ?? "",
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: controlColorGray),
                        )));
                  }
                  index = index - 1;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Material(
                        elevation: 10,
                        borderRadius: borderRadius,
                        child: Container(
                          padding: const EdgeInsets.all(0.0),
                          height: mediaQuery.height * 0.20,
                          width: mediaQuery.width * 0.5,
                          decoration: BoxDecoration(
                            borderRadius: borderRadius,
                          ),
                          child: index % 2 == 0
                              ? Row(
                                  children: <Widget>[
                                    LayoutBuilder(
                                        builder: (context, constraints) {
                                      return InkWell(
                                        enableFeedback: false,
                                        onTap: () async {
                                          baseWidgetModel.showOverLayWidget(
                                              true,
                                              const InformationModal.loading(
                                                  typeInformationModal:
                                                      TypeInformationModal
                                                          .LOADING));
                                          ResponseObject res =
                                              await model.getTable(
                                                  model.listOfTables[index]);
                                          if (res.status ?? false) {
                                            baseWidgetModel.showOverLayWidget(
                                                false, Container());
                                            //move the user to table view
                                            Navigator.pushNamed(
                                                context, "/tableView",
                                                arguments: {
                                                  "table":
                                                      model.listOfTables[index],
                                                  "tableDetail":
                                                      res.responseObject
                                                });
                                          } else {
                                            baseWidgetModel.showOverLayWidget(
                                                false, Container());
                                            baseWidgetModel.showOverLayWidget(
                                              true,
                                              InformationModal(
                                                typeInformationModal:
                                                    TypeInformationModal
                                                        .WARNING,
                                                title:
                                                    AppLocalizations.of(context)
                                                            ?.warningText ??
                                                        "",
                                                contentText: AppLocalizations
                                                            .of(context)
                                                        ?.somethingWentWrongText ??
                                                    "",
                                                acceptButton: () {
                                                  baseWidgetModel
                                                      .showOverLayWidget(
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
                                        child: Container(
                                          height: constraints.maxHeight,
                                          width: constraints.maxHeight,
                                          decoration: BoxDecoration(
                                            color: Colors.blue[900],
                                            borderRadius: borderRadius,
                                          ),
                                          child: const Icon(
                                            Icons.table_bar_outlined,
                                            color: Colors.white,
                                            size: 50,
                                          ),
                                        ),
                                      );
                                    }),
                                    Expanded(
                                      child: Text(
                                        "${AppLocalizations.of(context)?.tableText ?? ""}: #"
                                        "${model.listOfTables[index].num ?? 0}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: (model.listOfTables[index]
                                                        .est ??
                                                    false)
                                                ? Colors.red[700]
                                                : Colors.green[700]),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        "${AppLocalizations.of(context)?.tableText ?? ""}: #"
                                        "${model.listOfTables[index].num ?? 0}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: (model.listOfTables[index]
                                                .est ??
                                                false)
                                                ? Colors.red[700]
                                                : Colors.green[700]),
                                      ),
                                    ),
                                    LayoutBuilder(
                                        builder: (context, constraints) {
                                      return InkWell(
                                        enableFeedback: false,
                                        onTap: () async {
                                          baseWidgetModel.showOverLayWidget(
                                              true,
                                              const InformationModal.loading(
                                                  typeInformationModal:
                                                      TypeInformationModal
                                                          .LOADING));
                                          ResponseObject res =
                                              await model.getTable(
                                                  model.listOfTables[index]);
                                          if (res.status ?? false) {
                                            baseWidgetModel.showOverLayWidget(
                                                false, Container());
                                            //move the user to table view
                                            Navigator.pushNamed(
                                                context, "/tableView",
                                                arguments: {
                                                  "table":
                                                      model.listOfTables[index],
                                                  "tableDetail":
                                                      res.responseObject
                                                });
                                          } else {
                                            baseWidgetModel.showOverLayWidget(
                                                false, Container());
                                            baseWidgetModel.showOverLayWidget(
                                              true,
                                              InformationModal(
                                                typeInformationModal:
                                                    TypeInformationModal
                                                        .WARNING,
                                                title:
                                                    AppLocalizations.of(context)
                                                            ?.warningText ??
                                                        "",
                                                contentText: AppLocalizations
                                                            .of(context)
                                                        ?.somethingWentWrongText ??
                                                    "",
                                                acceptButton: () {
                                                  baseWidgetModel
                                                      .showOverLayWidget(
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
                                        child: Container(
                                          height: constraints.maxHeight,
                                          width: constraints.maxHeight,
                                          decoration: BoxDecoration(
                                            color: Colors.blue[700],
                                            borderRadius: borderRadius,
                                          ),
                                          child: const Icon(
                                            Icons.table_bar_outlined,
                                            color: Colors.white,
                                            size: 50,
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  );
                }),
      );
    },
  );
}
