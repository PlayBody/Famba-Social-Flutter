import 'package:auto_size_text/auto_size_text.dart';
import 'package:colibri/core/constants/appconstants.dart';
import 'package:flutter/material.dart';
import 'package:colibri/extensions.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key key,
    @required this.icon,
    @required this.text,
    @required this.onTap,
  }) : super(key: key);
  final Widget icon;
  final String text;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(
              height: AC.getDeviceHeight(context) * 0.030,
              width: AC.getDeviceHeight(context) * 0.025,
              child: icon),
          15.toSizedBoxHorizontal,
          AutoSizeText(
            text,
            style: TextStyle(
              fontFamily: "CeraPro",
              fontSize: AC.getDeviceHeight(context) * 0.022,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}
