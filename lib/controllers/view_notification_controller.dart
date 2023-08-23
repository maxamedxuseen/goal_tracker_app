import 'package:get/get.dart';

import '../models/notification_master.dart';
import '../utility/constants/api_constants.dart';
import '../utility/helper/common_helper.dart';
import '../utility/helper/date_time_utils.dart';
import '../utility/routes/route_constants.dart';
import '../utility/services/api_provider.dart';
import '../utility/services/user_pref.dart';

class ViewNotificationsController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<NotificationMaster> notificationList = <NotificationMaster>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void onTapNotificationCard({required NotificationMaster notification}) {
    // launchUrl(Uri.parse(url));
  }

  static Future<NotificationMaster> _createNotificationMasterObject() async {
    NotificationMaster notificationMaster = NotificationMaster();
    notificationMaster.userId = await UserPref.getUserId();
    notificationMaster.currentDate = DateTimeUtils.currentDate();
    return notificationMaster;
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading(true);
      notificationList.clear();
      List<dynamic>? jsonResponse = await ApiProvider.postMethod(
        url: ApiConstants.getNotification,
        obj: (await _createNotificationMasterObject()).toJson(),
      );
      if (jsonResponse != null &&
          jsonResponse.first["api_status"] != null &&
          jsonResponse.first["api_status"] == "ok") {
        notificationList.value = jsonResponse.map((e) {
          return NotificationMaster.fromJson(e);
        }).toList();
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "ViewNotificationsController line 65");
    } finally {
      isLoading(false);
    }
  }
}
