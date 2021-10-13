import 'package:colibri/core/constants/appconstants.dart';
import 'package:colibri/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:colibri/extensions.dart';

class DrawerProperties extends StatelessWidget {
  const DrawerProperties(
      {Key key,
      @required this.number,
      @required this.text,
      @required this.function})
      : super(key: key);
  final String number;
  final String text;
  final VoidCallback function;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        number.toSubTitle1(
            color: AppColors.colorPrimary,
            fontWeight: FontWeight.w400,
            fontFamily1: "CeraPro",
            fontSize: AC.getDeviceHeight(context) * 0.02),
        SizedBox(height: AC.getDeviceHeight(context) * 0.002),
        FittedBox(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: "CeraPro",
              fontSize: AC.getDeviceHeight(context) * 0.02,
              color: const Color(0xFF8A8E95),
            ),
          ).onTapWidget(function),
        ),
      ],
    );
  }
}
