import '../../features/posts/presentation/bloc/post_cubit.dart';
import '../../features/search/presentation/bloc/search_cubit.dart';
import '../../main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AC {
  static SharedPreferences prefs;

  static SearchCubit searchCubitHash;
  static SearchCubit searchCubitA;
  static PostCubit postCubit;
  static TextEditingController textEditingController;

  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  static var loginResponse;

  static getInstance() async {
    prefs = await SharedPreferences.getInstance();
  }

  static loginData() {
    Future.delayed(Duration(seconds: 2), () async {
      loginResponse = await localDataSource.getUserAuth();
    });
  }

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }

  static getDeviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static getDeviceHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static device17(BuildContext context) {
    return MediaQuery.of(context).size.width / 23;
  }

  static device12(BuildContext context) {
    return MediaQuery.of(context).size.width / 36;
  }

  static device65(BuildContext context) {
    return MediaQuery.of(context).size.width / 6;
  }
}
