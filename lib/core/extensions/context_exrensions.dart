import 'package:another_flushbar/flushbar.dart';
import 'package:auto_route/auto_route.dart';
import '../theme/app_theme.dart';
import '../theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import '../../extensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

extension ContextExtension on BuildContext {
  bool isArabic() => this.locale.toString() == 'ar';

  TextStyle get headLine6 => AppTheme.headline6;

  TextStyle get headLine5 => AppTheme.headline5;

  TextStyle get headLine4 => AppTheme.headline4;

  TextStyle get headLine3 => AppTheme.headline3;

  TextStyle get headLine2 => AppTheme.headline2;

  TextStyle get headLine1 => AppTheme.headline1;

  TextStyle get body1 => AppTheme.bodyText1;

  TextStyle get body2 => AppTheme.bodyText2;

  TextStyle get subTitle1 => AppTheme.subTitle1;

  TextStyle get subTitle2 => AppTheme.subTitle2;

  TextStyle get button => AppTheme.button;

  TextStyle get caption => AppTheme.caption;

  showSnackBar({
    String message,
    bool isError = false,
  }) =>
      snackBar(this, message, isError);

  removeFocus() => FocusScope.of(this).requestFocus(FocusNode());

  Future<bool> willPopScopeDialog() async {
    return (await showAnimatedDialog(
          context: this,
          barrierDismissible: true,
          animationType: DialogTransitionType.size,
          curve: Curves.fastOutSlowIn,
          duration: const Duration(seconds: 1),
          builder: (_) => AlertDialog(
            title: Text('Are you  sure?'),
            content: new Text('Do you want to exit Colibri'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(this).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(this).pop(true),
                child: Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Size get getScreenSize =>
      Size(MediaQuery.of(this).size.width, MediaQuery.of(this).size.height);

  num get getScreenHeight => MediaQuery.of(this).size.height;
  num get getScreenWidth => MediaQuery.of(this).size.width;

  num get getScreenAspect => MediaQuery.of(this).size.aspectRatio;

  num get getHeightBloc =>
      ScreenUtil().setHeight(MediaQuery.of(this).size.height) / 100;
  num get getWidthBloc =>
      ScreenUtil().setWidth(MediaQuery.of(this).size.width) / 100;

  num get getHeightAndWidthBloc => getHeightBloc + getWidthBloc;

  showModelBottomSheet(Widget child) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      barrierColor: Colors.white.withOpacity(0),
      elevation: 0.0,
      context: this,
      builder: (builder) => child,
    );
  }

  showAlertDialog(
      {@required List<Widget> widgets, @required String title}) async {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // title: Text("AlertDialog"),
      content: title.toSubTitle1(),
      actions: widgets,
    );
    showAnimatedDialog(
      context: this,
      barrierDismissible: true,
      builder: (BuildContext context) => alert,
      animationType: DialogTransitionType.size,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(seconds: 1),
    );
  }

  showOkAlertDialog(
      {@required String desc,
      @required String title,
      VoidCallback onTapOk}) async {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // title: Text("AlertDialog"),
      content: desc.toSubTitle2(fontWeight: FontWeight.w600),
      title: title.toSubTitle1(fontWeight: FontWeight.bold),
      actions: [
        "OK".toButton().toFlatButton(() {
          // Fix the issue
          if (onTapOk == null)
            ExtendedNavigator.root.pop();
          else
            onTapOk.call();
        }),
      ],
    );
    showAnimatedDialog(
      context: this,
      barrierDismissible: true,
      builder: (BuildContext context) => alert,
      animationType: DialogTransitionType.size,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(seconds: 1),
    );
  }

  showOkCancelAlertDialog<T>(
      {@required String desc,
      @required String title,
      VoidCallback onTapOk,
      String okButtonTitle = "OK"}) async {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // title: Text("AlertDialog"),
      content: desc.toSubTitle2(),
      title: title.toSubTitle1(fontWeight: FontWeight.bold),
      actions: [
        okButtonTitle.toButton().toFlatButton(() {
          // Fix the issue
          if (!isRedundentClick(DateTime.now())) {
            // ExtendedNavigator.root.pop();
            if (onTapOk != null) {
              onTapOk.call();
            }
          }
        }),
        "Cancel".toButton().toFlatButton(() {
          ExtendedNavigator.root.pop();
        })
      ],
    );
    return showAnimatedDialog<T>(
      context: this,
      barrierDismissible: false,
      builder: (BuildContext context) => alert,
      animationType: DialogTransitionType.size,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(seconds: 1),
    ).then((value) {
      loginClickTime = null;
      return value;
    });
  }

  showDeleteDialog({@required onOkTap}) {
    showOkCancelAlertDialog(
        desc:
            "Please note that if you delete this post, then with the removal of this post all posts related to this thread will also be permanently deleted!",
        title: "Please confirm your actions!",
        okButtonTitle: "Delete",
        onTapOk: onOkTap);
  }

  initScreenUtil() => ScreenUtil.init(
      BoxConstraints(
        maxWidth: MediaQuery.of(this).size.width,
        maxHeight: MediaQuery.of(this).size.height,
      ),
      designSize: getScreenSize);
}

snackBar(BuildContext context, String text, bool isError) {
  Flushbar(
    backgroundColor: isError ? Colors.red : AppColors.colorPrimary,
    flushbarStyle: FlushbarStyle.GROUNDED,
    icon: Icon(
      isError ? Icons.error : Icons.done,
      color: Colors.white,
    ),
    message: text ?? "Null value passed",
    duration: const Duration(seconds: 3),
  )..show(context);
}

DateTime loginClickTime;

bool isRedundentClick(DateTime currentTime) {
  if (loginClickTime == null) {
    loginClickTime = currentTime;
    print("first click");
    return false;
  }
  print('diff is ${currentTime.difference(loginClickTime).inSeconds}');
  if (currentTime.difference(loginClickTime).inSeconds < 4) {
    //set this difference time in seconds
    return true;
  }

  loginClickTime = currentTime;
  return false;
}
