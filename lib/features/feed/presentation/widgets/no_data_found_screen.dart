import '../../../../core/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../extensions.dart';

class NoDataFoundScreen extends StatelessWidget {
  final VoidCallback onTapButton;
  final String message;
  final String title;
  final Widget icon;
  final String buttonText;
  final bool buttonVisibility;
  const NoDataFoundScreen(
      {Key key,
      this.onTapButton,
      this.buttonVisibility = true,
      this.message =
          "It looks like there are no posts on your feed yet. All your posts and publications of people you follow will be displayed here.",
      this.title = "No posts yet",
      this.icon = const Icon(
        Icons.description,
        color: AppColors.colorPrimary,
        size: 40,
      ),
      this.buttonText = "Create my first post"})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          10.toSizedBox,
          title.toSubTitle1(fontWeight: FontWeight.bold),
          10.toSizedBox,
          message
              .toCaption(
                  textAlign: TextAlign.center, fontWeight: FontWeight.w600)
              .toHorizontalPadding(18),
          30.toSizedBox,
          OutlinedButton(
            child: buttonText.toButton(color: AppColors.colorPrimary),
            onPressed: onTapButton,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.colorPrimary),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
                side: const BorderSide(
                  color: Colors.red,
                  width: 10,
                ),
              ),
            ),
          ).toVisibility(buttonVisibility)
        ],
      ),
    );
  }
}
