import '../common/buttons/custom_button.dart';
import '../theme/app_theme.dart';
import '../theme/colors.dart';
import 'package:flutter/material.dart';

extension TextExtension on Text {
  CustomButton toCustomButton(VoidCallback callBack, {bool fullWidth = true}) =>
      CustomButton(
        text: this.data,
        fullWidth: fullWidth,
        onTap: () {
          FocusManager.instance.primaryFocus.unfocus();
          callBack.call();
        },
      );

  StreamBuilder toStreamBuilderButton(
    Stream<bool> stream,
    VoidCallback callBack, {
    bool fullWidth = true,
  }) =>
      StreamBuilder<bool>(
        stream: stream,
        initialData: false,
        builder: (c, snapshot) => CustomButton(
          color: snapshot.data != null && snapshot.data
              ? AppColors.colorPrimary
              : AppColors.colorPrimary.withOpacity(.5),
          text: this.data,
          fullWidth: fullWidth,
          onTap: () {
            /// If the stream is not null and returns true
            if (snapshot.data != null && snapshot.data) callBack.call();
            FocusManager.instance.primaryFocus.unfocus();
          },
        ),
      );

  TextButton toFlatButton(VoidCallback callback,
          {Color color, RoundedRectangleBorder border}) =>
      TextButton(
        child: this,
        style: TextButton.styleFrom(
          shape: border,
          backgroundColor: color,
        ),
        onPressed: () {
          FocusManager.instance.primaryFocus.unfocus();
          callback.call();
        },
      );

  Text toAlign(TextAlign align) => Text(
        this.data,
        textAlign: align,
        style: this.style,
      );

  Text toUnderLine() => Text(
        this.data,
        style: this.style.copyWith(decoration: TextDecoration.underline),
        textAlign: textAlign,
      );

  StreamBuilder toTextStreamBuilder(Stream<String> stream) => StreamBuilder(
        initialData: this.data,
        builder: (_, snapshot) => Text(
          snapshot.data,
          // style: this.style.copyWith(decoration: TextDecoration.underline),
          style: this.style,
          textAlign: textAlign,
        ),
        stream: stream,
      );

  StreamBuilder toVisibilityStreamBuilder(Stream<bool> stream) => StreamBuilder(
        initialData: false,
        builder: (_, sndapshot) => Visibility(
          visible: sndapshot.data,
          child: Text(
            this.data,
            style: this.style,
            textAlign: textAlign,
          ),
        ),
        stream: stream,
      );

  Widget toNoBorderTextField() => TextField(
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: this.data,
            labelStyle: AppTheme.caption.copyWith(fontWeight: FontWeight.bold)),
      );

  Widget get toEllipsis => RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(text: this.data, style: this.style));

  Widget toOutlinedBorder(VoidCallback callback, {double borderRadius = 20}) =>
      OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: const BorderSide(color: AppColors.colorPrimary, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: this,
        onPressed: callback,
      );
}
