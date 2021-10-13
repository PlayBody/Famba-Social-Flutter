import 'package:colibri/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:colibri/extensions.dart';

class ProfileUserStatsBarItem extends StatelessWidget {
  const ProfileUserStatsBarItem({
    Key key,
    @required this.number,
    @required this.text,
    this.function,
  }) : super(key: key);
  final String number;
  final String text;
  final VoidCallback function;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Row(
        children: [
          number.toSubTitle1(
            color: Colors.blueAccent.shade400,
            fontWeight: FontWeight.w500,
          ),
          4.toSizedBoxHorizontal,
          FittedBox(
            child: Text(
              parseHtmlString(text),
              overflow: TextOverflow.ellipsis,
              style: AppTheme.subTitle2.copyWith(
                fontSize: AppFontSize.subTitle2.toSp,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                fontFamily: 'CeraPro',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
