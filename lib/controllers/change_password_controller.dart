import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user_master.dart';
import '../utility/constants/api_constants.dart';
import '../utility/common_widgets/common_dialog.dart';
import '../utility/common_widgets/common_progress.dart';
import '../utility/helper/common_helper.dart';
import '../utility/helper/snack_bar_utils.dart';
import '../utility/routes/route_constants.dart';
import '../utility/services/api_provider.dart';
import '../utility/services/user_pref.dart';

class ChangePasswordController extends GetxController {
  late TextEditingController etOldPassword;
  late TextEditingController etNewPassword;
  late TextEditingController etConfirmNewPassword;
  late FocusNode etOldPasswordFocusNode;
  late FocusNode etNewPasswordFocusNode;
  late FocusNode etConfirmNewPasswordFocusNode;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    initUI();
  }

  void initUI() {
    etOldPassword = TextEditingController();
    etNewPassword = TextEditingController();
    etConfirmNewPassword = TextEditingController();

    etOldPasswordFocusNode = FocusNode();
    etNewPasswordFocusNode = FocusNode();
    etConfirmNewPasswordFocusNode = FocusNode();
  }

  Future<void> onConfirmChangePassword() async {
    try {
      changePassword();
    } catch (e) {
      onChangePasswordFailed(e);
    } finally {
      CommonProgressBar.hide();
    }
  }

  Future<UserMaster> createUserMasterObject() async {
    UserMaster user = UserMaster();
    user.userId = await UserPref.getUserId();
    user.password = etOldPassword.text.trim();
    user.newPassword = etNewPassword.text.trim();
    return user;
  }

  Future<void> changePassword() async {
    try {
      CommonProgressBar.show();
      List<dynamic> jsonResponse = await ApiProvider.postMethod(
        url: ApiConstants.changePassword,
        obj: (await createUserMasterObject()).toJson(),
      );
      CommonHelper.printDebug(jsonResponse);
      if (jsonResponse.isNotEmpty) {
        List<UserMaster> userList = jsonResponse.map((e) {
          return UserMaster.fromJson(e);
        }).toList();
        if (userList.isNotEmpty) {
          if (userList.first.status == "ok" ||
              userList.first.status == "true") {
            onChangePasswordSuccess();
          } else if (userList.first.status == "false" ||
              userList.first.status == "no") {
            onChangePasswordFailed("false");
          } else {
            onChangePasswordFailed(null);
          }
        }
      } else {
        onChangePasswordFailed(null);
      }
    } catch (e) {
      CommonHelper.printDebugError(e,"ChangePasswordController line 85");
      onChangePasswordFailed(e.toString());
    } finally {
      CommonProgressBar.hide();
    }
  }

  void onChangePasswordSuccess() {
    Get.back();
    Get.dialog(
      CommonDialog(
        title: "Success",
        contentWidget: const Text(
          "Password Changed Successfully,"
          "\n Need to login again!!!",
        ),
        positiveDialogBtnText: "Ok",
        onPositiveButtonClicked: () async {
          Get.offAllNamed(RouteConstants.loginScreen);
        },
      ),
      barrierDismissible: false,
    );
  }

  void onChangePasswordFailed(error) {
    CommonHelper.printDebugError(error,"ChangePasswordController line 111");
    Get.back();
    String onError = error ?? "";
    if (onError == "false") {
      Get.dialog(
        const CommonDialog(
          title: "Password Incorrect!!!",
          contentWidget: Text(
            "Enter Correct Password And"
            "\nTry Again Later",
          ),
          positiveDialogBtnText: "Ok",
        ),
      );
    } else {
      SnackBarUtils.errorSnackBar(
        title: "Failed!!!",
        message: "Something went wrong. Please try again later'",
      );
    }
  }
}
