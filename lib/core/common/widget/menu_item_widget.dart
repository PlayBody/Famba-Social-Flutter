import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../extensions.dart';

class MenuItemWidget extends StatefulWidget {
  final Widget icon;
  final String text;

  const MenuItemWidget({Key key, this.icon, this.text}) : super(key: key);
  @override
  _MenuItemWidgetState createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<MenuItemWidget> {
  @override
  Widget build(BuildContext context) =>
      [widget.icon, 10.toSizedBoxHorizontal, widget.text.toCaption()].toRow(
        crossAxisAlignment: CrossAxisAlignment.center,
      );
}
