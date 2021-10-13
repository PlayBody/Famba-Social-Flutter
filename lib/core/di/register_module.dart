import 'package:dio/dio.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => Dio();

  @preResolve
  Future<SharedPreferences> get storage async =>
      await SharedPreferences.getInstance();

  @lazySingleton
  GoogleSignIn get googleLogin => GoogleSignIn(
        scopes: <String>[
          'email',
        ],
      );

  // @lazySingletoncr
  // TwitterLogin get twitterLogin=>TwitterLogin(
  //   consumerKey: 'E261JBzxTeuj5PLM5bgN2VLUY',
  //   consumerSecret: 'lc38SoHLDU8XZ7BhrljvcrsfiIWxGknzPSnPPSfmPCzalXqKdp',);
  // bearer token
  // AAAAAAAAAAAAAAAAAAAAAGOqJgEAAAAA1yu5V2v%2FlEkQ%2B54Q86v0Hcfsdgk%3DbNqqGPgAqsB3OuniOuIr1sqpcwRtZxbYaJPaNL12nsQv7t3AGp
}
