import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/authentication/data/models/login_response.dart';

abstract class LocalDataSource {
  // final storage;
  // LocalDataSource(this.storage);

  saveUserData(LoginResponse model);

  setSocialLogin(bool isLoginBySocial);

  Future<bool> didSocialLoggedIn();

  bool isUserLoggedIn();

  clearData();

  LoginResponse getUserData();

  savePushToken(String token);

  Future<String> getPushToken();

  saveUserAuthentication(UserAuth auth);

  Future<UserAuth> getUserAuth();
}

@Injectable(as: LocalDataSource)
class LocalDataSourceImpl extends LocalDataSource {
  final Dio dio;
  final SharedPreferences storage;

  LocalDataSourceImpl(this.dio, this.storage) : super();
  @override
  bool isUserLoggedIn() => storage.containsKey("user");

  @override
  saveUserData(LoginResponse model) async {
    await storage.setString("user", jsonEncode(model));
    await saveUserAuthentication(model.auth);
  }

  @override
  clearData() async {
    storage.clear();
  }

  @override
  LoginResponse getUserData() {
    if (!isUserLoggedIn()) return null;
    return LoginResponse.fromJson(jsonDecode(storage.getString('user')));
  }

  @override
  savePushToken(String token) async {
    await storage.setString("push_token", token);
  }

  @override
  Future<String> getPushToken() async => await storage.getString("push_token");

  @override
  Future<UserAuth> getUserAuth() async {
    if (storage.containsKey('auth'))
      return await UserAuth.fromJson(jsonDecode(storage.getString("auth")));
    else if (storage.containsKey('user'))
      return LoginResponse.fromJson(jsonDecode(storage.getString('user'))).auth;
    return null;
  }

  @override
  saveUserAuthentication(UserAuth auth) async {
    await storage.setString("auth", jsonEncode(auth));
  }

  @override
  setSocialLogin(bool isLoginBySocial) async {
    await storage.setBool("social", isLoginBySocial);
  }

  @override
  Future<bool> didSocialLoggedIn() async => await storage.getBool("social");
}
