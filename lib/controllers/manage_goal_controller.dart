import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/goal_master.dart';
import '../utility/common_widgets/common_progress.dart';
import '../utility/constants/api_constants.dart';
import '../utility/constants/string_constants.dart';
import '../utility/helper/common_helper.dart';
import '../utility/helper/date_time_utils.dart';
import '../utility/helper/snack_bar_utils.dart';
import '../utility/routes/route_constants.dart';
import '../utility/services/api_provider.dart';
import '../utility/services/user_pref.dart';

class ManageGoalController extends GetxController {
  Rxn<GoalMaster> goalArg = Rxn<GoalMaster>();

  RxString goalId = ''.obs;
  RxString appBarTitle = 'Add Goal'.obs;
  RxString selectedGoalType = ''.obs;
  RxBool isGoalPublic = false.obs;
  RxBool isGoalEditingEnabled = false.obs;
  RxList<String> goalTypeList = StringConstants.goalTypeList.obs;

  late TextEditingController etGoalTitle;
  late TextEditingController etDescription;
  late TextEditingController etStartDate;
  late TextEditingController etEndDate;

  late FocusNode etGoalTitleFocusNode;
  late FocusNode etDescriptionFocusNode;
  late FocusNode etStartDateFocusNode;
  late FocusNode etEndDateFocusNode;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    initUI();
    initObj();
  }

  void initUI() {
    etGoalTitle = TextEditingController();
    etDescription = TextEditingController();
    etStartDate = TextEditingController();
    etEndDate = TextEditingController();

    etGoalTitleFocusNode = FocusNode();
    etDescriptionFocusNode = FocusNode();
    etStartDateFocusNode = FocusNode();
    etEndDateFocusNode = FocusNode();
  }

  Future<void> initObj() async {
    goalArg.value = Get.arguments;
    goalId.value = goalArg.value?.goalId?.trim() ?? "";
    setDataToField();
  }

  void onClickStartDate() {
    try {
      if (isGoalEditingEnabled.value == true) {
        DateTimeUtils.showDatePickerDialog().then(
          (value) => etStartDate.text = value ?? "",
        );
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "ManageGoalController line 66");
    }
  }

  void onClickEndDate() {
    try {
      if (isGoalEditingEnabled.value == true) {
        DateTimeUtils.showDatePickerDialog().then(
          (value) => etEndDate.text = value ?? "",
        );
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "ManageGoalController line 76");
    }
  }

  void onGoalPublicValueChange(bool? value) {
    if (isGoalEditingEnabled.value == true) {
      isGoalPublic.value = value ?? false;
    }
  }

  void onTapDelete() {
    CommonHelper.confirmationDialog(
      confirmationText: "delete goal ? ",
      onConfirm: () {
        goalId.isNotEmpty ? _delete() : onFailedResponse();
      },
    );
  }

  void onClickSubmit() {
    formKey.currentState!.validate() ? createOrUpdate() : null;
  }

  void onClickViewProgress() {
    try {
      if (goalId.isNotEmpty) {
        Get.toNamed(
          RouteConstants.viewGoalProgressScreen,
          arguments: goalArg.value,
        );
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "ManageGoalController line 106");
    }
  }

  Future<void> setDataToField() async {
    if (goalArg.value != null) {
      String? loginUserId = await UserPref.getUserId();
      GoalMaster? goalMaster = goalArg.value;
      appBarTitle.value = 'Update Goal';
      etGoalTitle.text = goalMaster?.goalTitle ?? "";
      etDescription.text = goalMaster?.description ?? "";
      etStartDate.text = goalMaster?.startDate ?? "";
      etEndDate.text = goalMaster?.endDate ?? "";
      selectedGoalType.value = goalMaster?.goalType ?? "";
      isGoalPublic.value = goalMaster?.isPublic == "1";
      isGoalEditingEnabled.value = goalMaster?.userId == loginUserId;
      appBarTitle.value =
          isGoalEditingEnabled.value ? 'Update Goal' : 'Goal Details';
    } else {
      isGoalEditingEnabled.value = true;
      appBarTitle.value = 'Update Goal';
    }
  }

  Future<GoalMaster> createGoalObject() async {
    GoalMaster goalMaster = GoalMaster();
    goalMaster.goalId = goalId.value;
    goalMaster.userId = await UserPref.getUserId();
    goalMaster.goalTitle = etGoalTitle.text;
    goalMaster.description = etDescription.text;
    goalMaster.startDate = etStartDate.text;
    goalMaster.endDate = etEndDate.text;
    goalMaster.goalType = selectedGoalType.value;
    goalMaster.isPublic = isGoalPublic.value == true ? "1" : "0";
    return goalMaster;
  }

  void createOrUpdate() async {
    try {
      CommonProgressBar.show();
      await ApiProvider.postMethod(
        url: goalId.isNotEmpty ? ApiConstants.updateGoal : ApiConstants.addGoal,
        obj: (await createGoalObject()).toJson(),
      ).then(
        (response) {
          List goalList = response.map((e) {
            return GoalMaster.fromJson(e);
          }).toList();
          if (goalList.isNotEmpty && goalList.first.status == 'ok' ||
              goalList.first.status == 'true') {
            onSuccessResponse();
          } else if (goalList.first.status == "already") {
            SnackBarUtils.errorSnackBar(
              title: "Failed!!!",
              message: "Goal already exist",
            );
          } else {
            onFailedResponse();
          }
        },
      );
    } catch (e) {
      onFailedResponse();
      CommonHelper.printDebugError(e, "ManageGoalController line 162");
    } finally {
      CommonProgressBar.hide();
    }
  }

  void _delete() async {
    try {
      CommonProgressBar.show();
      await ApiProvider.postMethod(
        url: ApiConstants.deleteGoal,
        obj: (await createGoalObject()).toJson(),
      ).then(
        (response) {
          List goalList = response.map((e) {
            return GoalMaster.fromJson(e);
          }).toList();
          if (goalList.isNotEmpty) {
            if ((goalList.first.status != null) &&
                    goalList.first.status == 'true' ||
                goalList.first.status == 'ok') {
              onSuccessDeleteResponse();
            } else {
              onFailedResponse();
            }
          } else {
            onFailedResponse();
          }
        },
      );
    } catch (e) {
      onFailedResponse();
    } finally {
      CommonProgressBar.hide();
    }
  }

  void onSuccessResponse() {
    Get.back();
    SnackBarUtils.normalSnackBar(
      title: "Success",
      message:
          goalId.isEmpty ? "Added successfully..." : "Updated successfully...",
    );
  }

  void onSuccessDeleteResponse() {
    Get.back();
    SnackBarUtils.normalSnackBar(
      title: "Success",
      message: "Deleted successfully...",
    );
  }

  void onFailedResponse() {
    SnackBarUtils.errorSnackBar(
      title: "Failed",
      message: "Something went wrong",
    );
  }
}
