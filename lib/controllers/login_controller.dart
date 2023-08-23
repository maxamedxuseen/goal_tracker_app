import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user_master.dart';
import '../utility/common_widgets/common_progress.dart';
import '../utility/constants/api_constants.dart';
import '../utility/helper/common_helper.dart';
import '../utility/helper/snack_bar_utils.dart';
import '../utility/routes/route_constants.dart';
import '../utility/services/api_provider.dart';
import '../utility/services/user_pref.dart';

class LoginController extends GetxController {
  late TextEditingController etEmailId;
  late TextEditingController etPassword;

  late FocusNode etEmailIdFocusNode;
  late FocusNode etPasswordFocusNode;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    initUI();
  }

  void initUI() {
    etEmailId = TextEditingController();
    etPassword = TextEditingController();
    etEmailIdFocusNode = FocusNode();
    etPasswordFocusNode = FocusNode();
  }

  void onTapSignUp() {
    Get.toNamed(RouteConstants.registrationScreen);
  }

  void onPressButtonLogin() {
    formKey.currentState!.validate() ? login() : null;
  }

  UserMaster createUserObject() {
    UserMaster userMaster = UserMaster();
    userMaster.emailId = etEmailId.text.toString().trim();
    userMaster.password = etPassword.text.toString().trim();
    return userMaster;
  }

  Future<void> login() async {
    try {
      CommonProgressBar.show();
      List<dynamic> jsonResponse = await ApiProvider.postMethod(
        url: ApiConstants.userLogin,
        obj: createUserObject().toJson(),
      );
      CommonHelper.printDebug(jsonResponse);
      if (jsonResponse.isNotEmpty) {
        List<UserMaster> userMasterList = jsonResponse.map((e) {
          return UserMaster.fromJson(e);
        }).toList();
        if (userMasterList.isNotEmpty) {
          if (userMasterList.first.status == "ok" ||
              userMasterList.first.status == "true") {
            onLoginSuccess(userMasterList.first);
          } else {
            onLoginFailed("false");
          }
        }
      } else {
        onLoginFailed(null);
      }
    } catch (e) {
      CommonHelper.printDebugError(e,"LoginGoalController line 66");
      onLoginFailed(e.toString());
    } finally {
      CommonProgressBar.hide();
    }
  }

  void onLoginSuccess(UserMaster userMaster) async {
    UserPref.setUserId(userId: userMaster.userId ?? "-1");
    Get.offAllNamed(RouteConstants.bottomNavigationScreen);
  }

  void onLoginFailed(String? error) {
    if (error != null && error.toLowerCase().contains("false")) {
      SnackBarUtils.errorSnackBar(
        title: "Failed!!!",
        message: "Invalid Email Id or Password",
      );
    } else {
      SnackBarUtils.errorSnackBar(
        title: "Failed!!!",
        message: "Something went wrong",
      );
    }
  }
}
