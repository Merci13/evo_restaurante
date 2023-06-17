import 'package:evo_restaurant/repositories/enums/type_information_modal.dart';
import 'package:evo_restaurant/repositories/view_models/base_widget_model.dart';
import 'package:evo_restaurant/ui/views/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

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
      this.title,
      this.contentText,
      this.acceptButton,
      this.cancelButton,
      this.icon});

  @override
  Widget getChild(BuildContext context, BaseWidgetModel baseWidgetModel) {
    Size mediaQuery = MediaQuery.of(context).size;

    if (typeInformationModal == TypeInformationModal.LOADING) {
      return _ScaffoldOfInformation(
          loading: true,
          child: Center(
              child: CircularProgressIndicator(
            color: Colors.blue[900],
          )));
    } else {
      return _ScaffoldOfInformation(loading: false, child: Container());
    }
  }
}

@swidget
Widget __scaffoldOfInformation(BuildContext context,
    {required bool loading, required Widget child}) {
  Size mediaQuery = MediaQuery.of(context).size;
  double height = mediaQuery.height * 0.40;
  double width = mediaQuery.width * 0.8;
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
          color: Colors.white30,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: child,
      ),
    ),
  );
}
