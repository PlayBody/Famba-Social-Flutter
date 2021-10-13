import '../../theme/colors.dart';
import 'package:flutter/material.dart';
import '../../../extensions.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool fullWidth;
  final Color color;
  const CustomButton({
    Key key,
    this.text,
    this.fullWidth = true,
    this.onTap,
    this.color = AppColors.colorPrimary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialButton(
        color: color,
        onPressed: onTap,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          width: fullWidth ? double.infinity : null,
          child: Text(
            text,
            style: context.button.copyWith(color: Colors.white),
          ),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      );
}
