import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goal_tracker_app/main.dart';
import 'package:goal_tracker_app/screens/bottom_navigation_screen.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/lifecycle_controller.dart';
import '../../models/goal_master.dart';
import '../constants/api_constants.dart';
import '../helper/common_helper.dart';
import '../helper/date_time_utils.dart';
import '../routes/route_constants.dart';
import 'api_provider.dart';
import 'user_pref.dart';

class NotificationService {
  static String channelId = '123';
  static String channelName = 'goal_motivation_notification';
  static String channelDescription = 'Show Motivation And Other Notifications';

  static FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  static AndroidNotificationDetails? androidPlatformChannelSpecifics;
  static DarwinNotificationDetails? iOSPlatformChannelSpecifics;
  static NotificationDetails? platformChannelSpecifics;

  static Future<void> initialize() async {
    try {
      await GetStorage.init();
      Get.put(LifeCycleController(), permanent: true);
      await createNotificationChannel();
    } catch (e) {
      CommonHelper.printDebug(e);
    }
  }

  static process() async {
    try {
      DartPluginRegistrant.ensureInitialized();
      await checkForNotification();
    } catch (e) {
      CommonHelper.printDebugError(e, "NotificationService line:44");
    }
  }

  static Future<GoalMaster> _createGoalMasterObject() async {
    GoalMaster goalMaster = GoalMaster();
    goalMaster.userId = await UserPref.getUserId();
    goalMaster.currentDate = DateTimeUtils.currentDate();
    return goalMaster;
  }

  static Future<void> checkForNotification() async {
    try {
      List goalList = [];
      List<dynamic>? jsonResponse = await ApiProvider.postMethod(
        url: ApiConstants.getNotification,
        obj: (await _createGoalMasterObject()).toJson(),
      );
      if (jsonResponse != null &&
          jsonResponse.first["api_status"] != null &&
          jsonResponse.first["api_status"] == "ok") {
        goalList = jsonResponse.map((e) {
          return GoalMaster.fromJson(e);
        }).toList();
      }
      List<ActiveNotification?>? activeNotifications =
          await flutterLocalNotificationsPlugin
              ?.resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.getActiveNotifications();
      if (goalList.isNotEmpty) {
        for (GoalMaster goalMaster in goalList) {
          bool isNotificationAvailable = false;
          int? goalId = int.tryParse(goalMaster.goalId ?? "0");
          CommonHelper.printDebug(goalId);
          try {
            if (activeNotifications != null) {
              activeNotifications.firstWhere((element) {
                return isNotificationAvailable = element?.id == (goalId ?? 0);
              });
            } else {
              isNotificationAvailable = false;
            }
          } catch (e) {
            isNotificationAvailable = false;
          }
          if (!isNotificationAvailable) {
            String? recommended = goalMaster.percentage ?? "0";
            String? progress = goalMaster.progress ?? "0";
            String? url = goalMaster.motivationLink ?? "";
            String body =
                "You have progressed your goal $progress/$recommended%";
            if (CommonHelper.checkIfUrl(string: url.toString())) {
              if (GetPlatform.isAndroid) {
                body = "$body\nOpen notification page "
                    "home screen to view motivational video";
              } else {
                body = "$body\nTap to view motivational video";
              }
            }
            await showNotification(
              id: goalId ?? 0,
              title: goalMaster.goalTitle ?? "",
              body: body,
              url: goalMaster.motivationLink,
            );
          } else {
            CommonHelper.printDebug('Notification Displayed : $goalId');
          }
        }
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "NotificationController line 113");
    }
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? url,
  }) async {
    try {
      BigPictureStyleInformation? bigPictureStyleInformation =
          await processUrlAndGetPicture(url: url.toString());

      androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        channelAction: AndroidNotificationChannelAction.createIfNotExists,
        fullScreenIntent: true,
        styleInformation: bigPictureStyleInformation,
        // actions: CommonHelper.checkIfUrl(string: url.toString()) == true
        //     ? GetPlatform.isAndroid
        //         ? [AndroidNotificationAction(id.toString(), "Open Link")]
        //         : null
        //     : null,
      );
      iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
        sound: 'slow_spring_board.aiff',
        threadIdentifier: 'notification_goal',
      );
      platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin
          ?.getNotificationAppLaunchDetails()
          .then(
        (value) {
          if (value?.didNotificationLaunchApp ?? false) {
            final String? payload = value?.notificationResponse?.payload;
            if (payload == null) {
              CommonHelper.printDebugError(
                'notification payload: $payload',
                "NotificationService line no 151",
              );
            }
            openUrlOrApp(payload: payload);
          }
        },
      );

      await flutterLocalNotificationsPlugin?.show(
        id,
        title,
        body,
        platformChannelSpecifics,
        payload: CommonHelper.checkIfUrl(string: url.toString()) == true
            ? url
            : 'Default_Sound',
      );
    } catch (e) {
      CommonHelper.printDebugError(e, "Notification Service line no :168");
    }
  }

  @pragma('vm:entry-point')
  static Future<void> createNotificationChannel() async {
    DarwinInitializationSettings iosInit = const DarwinInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    InitializationSettings initSetting = InitializationSettings(
      android: const AndroidInitializationSettings('app_icon'),
      iOS: iosInit,
    );

    if (flutterLocalNotificationsPlugin == null) {
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin?.initialize(
        initSetting,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );
    }
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(
    NotificationResponse notificationResponse,
  ) {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload == null) {
      CommonHelper.printDebugError(
        'notification payload: $payload',
        "NotificationService line no 208",
      );
    }
    openUrlOrApp(payload: notificationResponse.payload);
  }

  static Future<void> onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    if (payload == null) {
      CommonHelper.printDebugError(
        'notification payload: $payload',
        "NotificationService line no 223",
      );
    }
    openUrlOrApp(payload: payload);
  }

  @pragma('vm:entry-point')
  static Future<void> openUrlOrApp({String? payload}) async {
    try {
      if (payload == null || payload == 'Default_Sound') {
        String userId = (await UserPref.getUserId());
        runApp(MyApp(userId: userId));
      } else {
        if (!await launchUrl(
          Uri.parse(payload),
          mode: LaunchMode.platformDefault,
        )) {
          openUrlOrApp(payload: null);
        }
      }
    } catch (e) {
      Get.offAllNamed(RouteConstants.bottomNavigationScreen);
      CommonHelper.printDebugError(e, "NotificationService line:245");
    }
  }

  static Future<BigPictureStyleInformation?>? processUrlAndGetPicture({
    required String url,
  }) async {
    try {
      if (CommonHelper.checkIfUrl(string: url.toString())) {
        url = url.toString().replaceAll("https://www.youtube.com/watch?v=", "");
        http.Response response = await http
            .get(Uri.parse("https://img.youtube.com/vi/$url/hqdefault.jpg"))
            .timeout(const Duration(seconds: 10));
        String base64String = base64.encode(response.bodyBytes);
        return BigPictureStyleInformation(
          ByteArrayAndroidBitmap.fromBase64String(base64String),
        );
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "NotificationService line:264");
    }
    return null;
  }

  static void onDidReceiveNotificationResponse(NotificationResponse details) {
    final String? payload = details.payload;
    if (details.payload == null) {
      CommonHelper.printDebugError(
        'notification payload: $payload',
        "NotificationService line no 191",
      );
    }
    openUrlOrApp(payload: details.payload);
  }
}
