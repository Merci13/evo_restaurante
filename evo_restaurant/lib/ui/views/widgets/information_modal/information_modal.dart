import 'package:evo_restaurant/repositories/enums/type_information_modal.dart';
import 'package:evo_restaurant/repositories/view_models/base_widget_model.dart';
import 'package:evo_restaurant/ui/views/widgets/base_widget.dart';
import 'package:evo_restaurant/utils/share/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'information_modal.g.dart';

class InformationModal extends BaseWidget {
  final TypeInformationModal? typeInformationModal;
  final String? title;
  final String? contentText;
  final Function? acceptButton;
  final Function? cancelButton;
  final Icon? icon;

  const InformationModal(
      {super.key,
      required this.typeInformationModal,
      required this.title,
      required this.contentText,
      required this.acceptButton,
      this.cancelButton,
      required this.icon});

  const InformationModal.loading({
    super.key,
    required this.typeInformationModal,
    this.title,
    this.contentText,
    this.acceptButton,
    this.cancelButton,
    this.icon,
  });

  @override
  Widget getChild(BuildContext context, BaseWidgetModel baseWidgetModel) {
    Size mediaQuery = MediaQuery.of(context).size;
    bool loadingVal =
        typeInformationModal == TypeInformationModal.LOADING ? true : false;

    return _ScaffoldOfInformation(
      loading: loadingVal,
      title: title,
      contentText: contentText,
      acceptButton: acceptButton,
      cancelButton: cancelButton,
      icon: icon,
    );
  }
}

@swidget
Widget __scaffoldOfInformation(BuildContext context,
    {required bool loading,
    String? title,
    String? contentText,
    Function? acceptButton,
    Function? cancelButton,
    Icon? icon}) {
  Size mediaQuery = MediaQuery.of(context).size;
  double height = mediaQuery.height * 0.40;
  double width = mediaQuery.width * 0.5;
  if (loading) {
    height = (mediaQuery.height * 0.30);
    width = (mediaQuery.width * 0.20);
  }
  return Material(
    color: Colors.black54,
    child: Center(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          color: loading ? Colors.white30 : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: loading
            ? Center(
                child: CircularProgressIndicator(
                color: Colors.blue[900],
              ))
            : Container(
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(7))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 25,
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 75,
                                  child: Text(
                                    title ?? "",
                                    textAlign: TextAlign.center,
                                    style: styleTitle(),
                                  )),
                              Expanded(
                                flex: 25,
                                child: icon ??
                                    Icon(
                                      Icons.warning,
                                      size: 25,
                                      color: Colors.yellow[700],
                                    ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        thickness: 2,
                        color: controlColorGray,
                      ),
                      Expanded(
                        flex: 50,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          width: double.infinity,
                            child: Text(
                          contentText ?? "",
                          style: contentStyle(),
                        )),
                      ),
                      Expanded(
                        flex: 25,
                        child: Row(
                          children: [
                            Expanded(
                              flex:60,
                              child: Container(
                                color: Colors.red,
                                child: TextButton(
                                  onPressed: () {
                                    acceptButton!() ?? () {};
                                  },
                                  child:
                                      Text(AppLocalizations.of(context).acceptText),
                                ),
                              ),
                            ),
                            cancelButton == null
                                ? Container()
                                : Expanded(
                              flex:60,
                              child: Container(
                                color: Colors.green,
                                child: TextButton(
                                  onPressed: () {
                                    acceptButton!() ?? () {};
                                  },
                                  child:
                                  Text(AppLocalizations.of(context).cancelText),
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
    ),
  );
}

TextStyle contentStyle() {
  return  TextStyle(
    fontSize: 22,
    color: Colors.grey[800],
    fontWeight: FontWeight.w600,
  );
}

TextStyle styleTitle() {
  return const TextStyle(
    fontSize: 25,
    color: colorPrimaryDark,
    fontWeight: FontWeight.bold,
  );
}
