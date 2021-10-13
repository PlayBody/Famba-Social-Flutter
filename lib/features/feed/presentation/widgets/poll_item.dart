import 'package:colibri/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:colibri/extensions.dart';

class PollItem extends StatelessWidget {
  const PollItem({Key key, @required this.text, @required this.percentage})
      : super(key: key);
  final String text;
  final String percentage;
  @override
  Widget build(BuildContext context) {
    String _s = percentage == null ? null : (percentage + '%');
    final background = Color(0xFFE7F6FF);
    final fill = Color(0xFFCBEAFB);
    final List<Color> gradient = [background, background, fill, fill];
    final double fillPercent =
        percentage == null ? 0.0 : double.tryParse(percentage.toString());
    final double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          stops: stops,
          end: Alignment.centerLeft,
          begin: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        color: Colors.cyan.shade100,
      ),
      child: Row(
        children: [
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.colorPrimary, width: 1.3),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Icon(
              Icons.check_outlined,
              color: AppColors.colorPrimary,
              size: 12,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          text.toSubTitle1(fontFamily1: 'CeraPro', fontWeight: FontWeight.w400),
          Spacer(),
          if (percentage != null)
            _s.toSubTitle1(
              fontFamily1: 'CeraPro',
              fontWeight: FontWeight.w500,
              color: AppColors.colorPrimary,
            )
        ],
      ),
    );
  }
}
// TODO Error when two polls come after the other