import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';

import '../utility/common_widgets/common_dialog.dart';
import '../utility/helper/common_helper.dart';
import '../utility/routes/route_constants.dart';
import '../utility/services/background_service.dart';
import '../utility/services/user_pref.dart';

class BottomNavigationController extends GetxController {
  Rx<int> tabIndex = 1.obs;
  RxString appBarTitle = 'Home'.obs;
  Rx<double?> elevation = null.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await BackgroundService.initializeService();
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
    if (index == 1) {
      appBarTitle.value = 'Search Goals';
    } else if (index == 2) {
      appBarTitle.value = 'Home';
    } else if (index == 3) {
      appBarTitle.value = 'Recent Chats';
    } else {
      appBarTitle.value = 'Notifications';
    }
  }

  void onTapPopupMenu(String value) {
    if (value == "Logout") {
      _onTapLogout();
    } else if (value == "Exit") {
      _onTapExit();
    } else {
      Get.toNamed(RouteConstants.profileScreen);
    }
  }

  void _onTapLogout() {
    Get.dialog(CommonDialog(
      title: "Logout",
      contentWidget: const Text("Are you sure you want to logout?"),
      negativeRedDialogBtnText: "Confirm",
      positiveDialogBtnText: "Back",
      onNegativeRedBtnClicked: () {
        Get.back();
        _logout();
      },
    ));
  }

  void _onTapExit() {
    Get.dialog(CommonDialog(
      title: "Exit",
      contentWidget: const Text("Are you sure you want to exit?"),
      negativeRedDialogBtnText: "Confirm",
      positiveDialogBtnText: "Back",
      onNegativeRedBtnClicked: () {
        Get.back();
        exit(0);
      },
    ));
  }

  Future<void> _logout() async {
    try {
      await UserPref.removeAllFromUserPref();
      Get.offAllNamed(RouteConstants.loginScreen);
      FlutterBackgroundService().invoke("stopService");
    } catch (e) {
      CommonHelper.printDebugError(e, "Bottom Navigation Line 71");
    }
  }
}
