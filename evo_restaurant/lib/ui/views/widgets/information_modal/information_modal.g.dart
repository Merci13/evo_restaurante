// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'information_modal.dart';

// **************************************************************************
// FunctionalWidgetGenerator
// **************************************************************************

class _ScaffoldOfInformation extends StatelessWidget {
  const _ScaffoldOfInformation({
    Key? key,
    required this.loading,
    this.title,
    this.contentText,
    this.acceptButton,
    this.cancelButton,
    this.icon,
  }) : super(key: key);

  final bool loading;

  final String? title;

  final String? contentText;

  final Function? acceptButton;

  final Function? cancelButton;

  final Icon? icon;

  @override
  Widget build(BuildContext _context) => __scaffoldOfInformation(
        _context,
        loading: loading,
        title: title,
        contentText: contentText,
        acceptButton: acceptButton,
        cancelButton: cancelButton,
        icon: icon,
      );
}

class _AcceptButton extends StatelessWidget {
  const _AcceptButton(
    this.acceptButton, {
    Key? key,
  }) : super(key: key);

  final Function acceptButton;

  @override
  Widget build(BuildContext _context) => __acceptButton(
        _context,
        acceptButton,
      );
}

class _CancelButton extends StatelessWidget {
  const _CancelButton(
    this.cancelButton, {
    Key? key,
  }) : super(key: key);

  final Function cancelButton;

  @override
  Widget build(BuildContext _context) => __cancelButton(
        _context,
        cancelButton,
      );
}
