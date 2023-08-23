import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user_master.dart';
import '../utility/constants/api_constants.dart';
import '../utility/common_widgets/common_progress.dart';
import '../utility/helper/common_helper.dart';
import '../utility/helper/snack_bar_utils.dart';
import '../utility/routes/route_constants.dart';
import '../utility/services/api_provider.dart';
import '../utility/services/user_pref.dart';

class ProfileController extends GetxController {
  late TextEditingController etFullName;
  late TextEditingController etEmailId;
  late TextEditingController etContactNumber;

  late FocusNode etFullNameFocusNode;
  late FocusNode etEmailIdFocusNode;
  late FocusNode etContactNumberFocusNode;

  RxBool isLoading = false.obs;
  RxBool isEditingEnabled = false.obs;
  RxList<UserMaster> userMasterList = <UserMaster>[].obs;

  @override
  void onInit() {
    super.onInit();
    initUI();
    fetchUserProfileDetails();
  }

  void initUI() {
    etFullName = TextEditingController();
    etEmailId = TextEditingController();
    etContactNumber = TextEditingController();

    etFullNameFocusNode = FocusNode();
    etEmailIdFocusNode = FocusNode();
    etContactNumberFocusNode = FocusNode();
  }

  void onTapClickToEdit() {
    try {
      isEditingEnabled.value = true;
      BuildContext context = Get.context as BuildContext;
      FocusScope.of(context).requestFocus(etFullNameFocusNode);
    } catch (e) {
      CommonHelper.printDebugError(e,"ProfileController line 66");
    }
  }

  Future<void> onPressUpdate() async {
    isEditingEnabled.value = false;
    await updateUserProfile().then((value) {
      fetchUserProfileDetails();
    });
  }

  void onTapChangePassword() {
    Get.toNamed(RouteConstants.changePasswordScreen);
  }

  void setDetailsToFields() {
    if (userMasterList.isNotEmpty) {
      UserMaster? userMaster = userMasterList.first;
      etFullName.text = userMaster.fullName ?? "";
      etEmailId.text = userMaster.emailId ?? "";
      etContactNumber.text = userMaster.contactNumber ?? "";
    }
  }

  Future<UserMaster> createUserObject() async {
    UserMaster userMaster = UserMaster();
    userMaster.userId = await UserPref.getUserId();
    userMaster.fullName = etFullName.text.trim();
    userMaster.emailId = etEmailId.text.trim();
    userMaster.contactNumber = etContactNumber.text.trim();
    return userMaster;
  }

  Future<void> fetchUserProfileDetails() async {
    try {
      CommonProgressBar.hide();
      isLoading(true);
      userMasterList.clear();

      List<dynamic> jsonResponse = await ApiProvider.getMethod(
        url: ApiConstants.getUserProfile + await UserPref.getUserId(),
      );
      userMasterList.value = jsonResponse.map((e) {
        return UserMaster.fromJson(e);
      }).toList();
    } catch (e) {
      userMasterList.value = <UserMaster>[];
    } finally {
      setDetailsToFields();
      isLoading(false);
    }
  }

  Future<void> updateUserProfile() async {
    try {
      CommonProgressBar.show();
      await ApiProvider.postMethod(
        url: ApiConstants.updateProfile,
        obj: (await createUserObject()).toJson(),
      ).then((response) {
        List userList = response.map((e) {
          return UserMaster.fromJson(e);
        }).toList();
        userList.isNotEmpty
            ? userList.first.status == 'ok' || userList.first.status == 'true'
                ? onSuccessResponse()
                : onFailedResponse(userList.first.status)
            : null;
      });
    } catch (e) {
      onFailedResponse();
      CommonHelper.printDebugError(e,"ProfileController line 66");
    } finally {
      CommonProgressBar.hide();
    }
  }

  void onSuccessResponse() {
    CommonProgressBar.hide();
    SnackBarUtils.normalSnackBar(
      title: "Success",
      message: "Profile updated successfully...",
    );
  }

  void onFailedResponse([String? status]) {
    if (status != null && status.contains('already')) {
      SnackBarUtils.errorSnackBar(
        title: "Failed",
        message: "Email Id already exist",
      );
    } else {
      SnackBarUtils.errorSnackBar(
        title: "Failed",
        message: "Something went wrong",
      );
    }
  }
}
