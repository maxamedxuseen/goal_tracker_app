// import 'package:get/get.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
//
// import '../models/goal_master.dart';
// import '../utility/constants/api_constants.dart';
// import '../utility/helper/common_helper.dart';
// import '../utility/helper/date_time_utils.dart';
// import '../utility/routes/route_constants.dart';
// import '../utility/services/api_provider.dart';
// import '../utility/services/user_pref.dart';
//
// class NotificationController extends GetxController {
//   ReceivedAction? receivedAction;
//
//   @override
//   Future<void> onInit() async {
//     await requestPermission();
//     await _initializeNotification();
//     await startListeningNotificationEvents();
//     await checkForNotification();
//     super.onInit();
//   }
//
//   Future<void> _initializeNotification() async {
//     await AwesomeNotifications().initialize(
//       null,
//       [
//         NotificationChannel(
//           channelKey: 'alerts',
//           channelName: 'alerts',
//           channelDescription: 'Notification for motivation as alerts',
//           playSound: true,
//           onlyAlertOnce: true,
//           groupAlertBehavior: GroupAlertBehavior.Children,
//           importance: NotificationImportance.High,
//           defaultPrivacy: NotificationPrivacy.Private,
//         )
//       ],
//       debug: true,
//     );
//     receivedAction = await AwesomeNotifications().getInitialNotificationAction(
//       removeFromActionEvents: false,
//     );
//   }
//
//   Future<void> requestPermission() async {
//     await AwesomeNotifications()
//         .isNotificationAllowed()
//         .then((isAllowed) async {
//       if (!isAllowed) {
//         await AwesomeNotifications().requestPermissionToSendNotifications();
//       }
//     });
//   }
//
//   static Future<void> startListeningNotificationEvents() async {
//     AwesomeNotifications().setListeners(
//       onActionReceivedMethod: onActionReceivedMethod,
//     );
//   }
//
//   @pragma('vm:entry-point')
//   static Future<void> onActionReceivedMethod(
//     ReceivedAction receivedAction,
//   ) async {
//     try {
//       String userId = (await UserPref.getUserId());
//       Get.toNamed(
//         userId == "-1" || userId == "0" || userId.isEmpty
//             ? RouteConstants.loginScreen
//             : RouteConstants.bottomNavigationScreen,
//       );
//     } catch (e) {
//       CommonHelper.printDebugError(e, "NotificationController line:70");
//     }
//   }
//
//   static Future<void> scheduleNewNotification({
//     String? title,
//     String? body,
//     String? url,
//     bool? isMotivationNotification,
//   }) async {
//     bool isAllowed =
//         await AwesomeNotifications().requestPermissionToSendNotifications();
//     if (!isAllowed) return;
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: -1,
//         channelKey: 'alerts',
//         title: title ?? "Goal Tracker",
//         body: body ?? "Running in background",
//         bigPicture: url,
//         notificationLayout: url != null
//             ? NotificationLayout.BigPicture
//             : NotificationLayout.Default,
//         payload: {'notificationId': '1234567890'},
//         displayOnForeground: true,
//         wakeUpScreen: true,
//       ),
//       actionButtons: isMotivationNotification == true
//           ? [
//               NotificationActionButton(
//                 key: 'REDIRECT',
//                 label: 'Open Link',
//                 actionType: ActionType.SilentBackgroundAction,
//               ),
//             ]
//           : null,
//       schedule: NotificationCalendar.fromDate(
//         date: DateTime.now().add(
//           isMotivationNotification == true
//               ? const Duration(seconds: 60)
//               : const Duration(seconds: 10),
//         ),
//       ),
//     );
//   }
//
//   static Future<GoalMaster> _createGoalMasterObject() async {
//     GoalMaster goalMaster = GoalMaster();
//     goalMaster.userId = await UserPref.getUserId();
//     goalMaster.currentDate = DateTimeUtils.currentDate();
//     return goalMaster;
//   }
//
//   static Future<void> checkForNotification() async {
//     try {
//       List goalList = [];
//       List<dynamic>? jsonResponse = await ApiProvider.postMethod(
//         url: ApiConstants.getNotification,
//         obj: (await _createGoalMasterObject()).toJson(),
//       );
//       if (jsonResponse != null &&
//           jsonResponse.first["api_status"] != null &&
//           jsonResponse.first["api_status"] == "ok") {
//         goalList = jsonResponse.map((e) {
//           return GoalMaster.fromJson(e);
//         }).toList();
//       }
//       if (goalList.isNotEmpty) {
//         for (GoalMaster goalMaster in goalList) {
//           scheduleNewNotification(
//             title: goalMaster.goalTitle ?? "",
//             body: "You have progressed your goal ${goalMaster.progress ?? 0}%",
//             url: goalMaster.motivationLink,
//           );
//         }
//       } else {
//         scheduleNewNotification();
//       }
//     } catch (e) {
//       CommonHelper.printDebugError(e, "NotificationController line 141");
//       scheduleNewNotification();
//     }
//   }
//
//   static Future<void> cancelNotifications() async {
//     await AwesomeNotifications().cancelAllSchedules();
//   }
// }
