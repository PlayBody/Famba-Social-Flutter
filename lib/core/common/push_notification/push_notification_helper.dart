import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../api/response_models/chat_notification_response.dart';
import '../../constants/appconstants.dart';
import '../../datasource/local_data_source.dart';
import '../../di/injection.dart';
import '../../routes/routes.gr.dart';
import '../../../features/feed/domain/usecase/save_notification_token_use_case.dart';
import '../../../features/feed/presentation/pages/feed_screen.dart';
import '../../../features/messages/domain/entity/chat_entity.dart';
import '../../../features/notifications/domain/entity/notification_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationHelper {
  static bool isNotificationShow = false;
  static bool isMessageShow = false;

  static LocalDataSource localDataSource = getIt<LocalDataSource>();
  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static ValueChanged<ChatEntity> listenNotificationOnChatScreen;

  static String currentUserId;
  Random random = new Random();
  static configurePush(BuildContext context) {
    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onBackgroundMessage(
      Platform.isIOS ? null : _onMyBackground,
    );
    FirebaseMessaging.instance.getInitialMessage().then(_onLaunch);
    FirebaseMessaging.onMessageOpenedApp.listen(_onResume);

    FirebaseMessaging.instance
      ..requestPermission()
      ..getToken().then(
        (value) {
          print("firebase token $value");
          localDataSource.savePushToken(value);
          _savePushNotificationTokenToServer();
        },
      )
      ..onTokenRefresh.listen(
        (event) {
          localDataSource.savePushToken(event);
          _savePushNotificationTokenToServer();
        },
      );

    _initLocalNotification();
  }

  static _savePushNotificationTokenToServer() async {
    final savePush = getIt<SaveNotificationPushUseCase>();
    savePush.call(unit);
  }

  static Future<void> _onLaunch(RemoteMessage message) async {
    print("on Launch");

    if (message.data['type'] == "chat_message") {
      isMessageShow = true;
    } else {
      isNotificationShow = true;
    }
    _showLocationNotification(message);
    _navigateToScreen(message.data);
    controller.add(1);
  }

  static Future<void> _onResume(RemoteMessage message) async {
    if (message.data['type'] == "chat_message") {
      isMessageShow = true;
    } else {
      isNotificationShow = true;
    }

    controller.add(1);

    print("on Resume ${message}");
    if (Platform.isIOS) {
      var chatObject = message.data["gcm.notification.chat_message"];
      if (listenNotificationOnChatScreen != null && chatObject != null) {
        if (listenNotificationOnChatScreen != null)
          listenNotificationOnChatScreen.call(
            ChatEntity.fromNotification(
              ChatMessage.fromJson(
                json.decode(chatObject),
              ),
            ),
          );
        return;
      }

      _navigateToScreen(message.data);
    } else {
      _showLocationNotification(message);
    }
  }

  static Future<void> _onMessage(RemoteMessage message) async {
    print("on Message ${message}");

    if (message.data['type'] == "chat_message") {
      AC.prefs.setBool("message", true);
    } else {
      AC.prefs.setBool("notification", true);
    }

    _showLocationNotification(message);

    controller.add(1);
  }

  static Future<void> _onMyBackground(RemoteMessage message) async {
    print("on Bg ${message}");
    if (message.data['type'] == "chat_message") {
      isMessageShow = true;
    } else {
      isNotificationShow = true;
    }
    _showLocationNotification(message);
    controller.add(1);
  }

  static void _initLocalNotification() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        const IOSInitializationSettings(
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) =>
            _navigateToScreen(jsonDecode(payload)));
  }

  static Future _onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    _showLocationNotification(jsonDecode(payload));
  }

  static Future _navigateToScreen(Map<String, dynamic> message) async {
    final postId = Platform.isAndroid
        ? message['post_id']
        : message['gcm.notification.post_id'];
    final userId = Platform.isAndroid
        ? message['user_id']
        : message['gcm.notification.user_id'];
    final chatMessage = Platform.isAndroid
        ? message['chat_message']
        : message["gcm.notification.chat_message"];

    if (chatMessage != null) {
      var chatEntity = ChatEntity.fromNotification(
        ChatMessage.fromJson(
          json.decode(chatMessage),
        ),
      );

      ExtendedNavigator.root.push(
        Routes.chatScreen,
        arguments: ChatScreenArguments(
          otherPersonProfileUrl: chatEntity.profileUrl,
          otherPersonUserId: chatEntity.senderUserId,
        ),
      );
    } else if (postId != null) {
      ExtendedNavigator.root.popUntil((route) {
        if (route.settings.name != Routes.viewPostScreen) {
          ExtendedNavigator.root.push(
            Routes.viewPostScreen,
            arguments: ViewPostScreenArguments(
              threadID: int.tryParse(postId),
              postEntity: null,
            ),
          );
        }
        return true;
      });
    } else if (userId != null) {
      ExtendedNavigator.root.push(
        Routes.profileScreen,
        arguments: ProfileScreenArguments(otherUserId: userId),
      );
    }
  }

  static void _showLocationNotification(RemoteMessage map) async {
    var chatObject = Platform.isAndroid
        ? map.data['chat_message']
        : map.data["gcm.notification.chat_message"];
    if (listenNotificationOnChatScreen != null && chatObject != null) {
      if (listenNotificationOnChatScreen != null)
        listenNotificationOnChatScreen.call(
          ChatEntity.fromNotification(
            ChatMessage.fromJson(
              json.decode(chatObject),
            ),
          ),
        );
      return;
    }
    ;
    var title =
        Platform.isAndroid ? map.data['title'] : map.data["alert"]["title"];

    final body = Platform.isAndroid
        ? map.data['type']
        : map.data["gcm.notification.type"];

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      '0',
      'colibri',
      'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const IOSNotificationDetails(),
    );
    await _flutterLocalNotificationsPlugin.show(
      Random().nextInt(100),
      title,
      NotificationEntity.getTitleFromNotificationType(body),
      platformChannelSpecifics,
      payload: jsonEncode(map.data),
    );
  }
}
