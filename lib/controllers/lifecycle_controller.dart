import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';

import '../utility/helper/common_helper.dart';
import '../utility/services/user_pref.dart';

class LifeCycleController extends SuperController {
  static bool isRunningInForeground = true;

  @override
  Future<void> onDetached() async {
    sendServiceToForeground();
  }

  @override
  Future<void> onResumed() async {
    sendServiceToBackground();
  }

  @override
  void onInactive() {
    sendServiceToForeground();
  }

  @override
  void onPaused() {
    sendServiceToForeground();
  }

  static Future<void> sendServiceToBackground() async {
    try {
      isRunningInForeground = true;
      String userId = await UserPref.getUserId();
      if (userId != "0") {
        FlutterBackgroundService().invoke("setAsBackground");
      }
    } catch (e) {
      CommonHelper.printDebugError(e,"LifecycleController line:36");
    }
  }

  static Future<void> sendServiceToForeground() async {
    try {
      isRunningInForeground = false;
      String userId = await UserPref.getUserId();
      if (userId != "0") {
        FlutterBackgroundService().invoke("setAsForeground");
      }
    } catch (e) {
      CommonHelper.printDebugError(e,"LifecycleController line:47");
    }
  }
}
