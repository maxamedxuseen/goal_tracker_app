import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/goal_master.dart';
import '../models/goal_progress.dart';
import '../utility/common_widgets/common_progress.dart';
import '../utility/constants/api_constants.dart';
import '../utility/helper/common_helper.dart';
import '../utility/helper/date_time_utils.dart';
import '../utility/helper/snack_bar_utils.dart';
import '../utility/services/api_provider.dart';

class ManageGoalProgressController extends GetxController {
  Rxn<GoalProgress> goalProgressArg = Rxn<GoalProgress>();
  Rxn<GoalMaster> goalMasterArg = Rxn<GoalMaster>();

  RxString goalProgressId = ''.obs;
  RxDouble currentProgressValue = 0.0.obs;
  RxString appBarTitle = 'Add Goal Progress'.obs;

  late TextEditingController etPreviouslyCompletedPercent;
  late TextEditingController etDescription;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    initUI();
    initObj();
  }

  void initUI() {
    etPreviouslyCompletedPercent = TextEditingController();
    etDescription = TextEditingController();
    etPreviouslyCompletedPercent.text = "0";
  }

  Future<void> initObj() async {
    goalMasterArg.value = Get.arguments[0];
    goalProgressArg.value = Get.arguments[1];
    goalProgressId.value = goalProgressArg.value?.goalProgressId?.trim() ?? "";
    setDataToField();
  }

  void onProgressValueChange(double value) {
    value = value.toPrecision(2);
    currentProgressValue.value = value;
  }

  void onTapDelete() {
    CommonHelper.confirmationDialog(
      confirmationText: "Delete goal Progress? ",
      onConfirm: () {
        goalProgressId.isNotEmpty ? _delete() : onFailedResponse();
      },
    );
  }

  void onClickSubmit() {
    formKey.currentState!.validate() ? createOrUpdate() : null;
  }

  Future<void> setDataToField() async {
    if (goalMasterArg.value != null) {
      etPreviouslyCompletedPercent.text = goalMasterArg.value?.progress ?? "0";
    }
    if (goalProgressArg.value != null) {
      GoalProgress? goalProgress = goalProgressArg.value;
      String currentProgress = goalProgress?.currentCompletedPercent ?? "";
      appBarTitle.value = 'Update Goal Progress';
      currentProgressValue.value = double.tryParse(currentProgress) ?? 0.0;
      etPreviouslyCompletedPercent.text =
          goalProgress?.previouslyCompletedPercent ?? "";
      etDescription.text = goalProgress?.description ?? "";
    }
  }

  Future<GoalProgress> createGoalProgressObject() async {
    GoalProgress goalMaster = GoalProgress();
    goalMaster.goalProgressId = goalProgressId.value;
    goalMaster.goalId = goalMasterArg.value!.goalId;
    goalMaster.previouslyCompletedPercent = etPreviouslyCompletedPercent.text;
    goalMaster.currentCompletedPercent = currentProgressValue.value.toString();
    goalMaster.description = etDescription.text;
    goalMaster.dateTime = DateTimeUtils.currentDateTimeYMDHMS();
    return goalMaster;
  }

  void createOrUpdate() async {
    try {
      if (goalMasterArg.value != null) {
        CommonProgressBar.show();
        await ApiProvider.postMethod(
          url: goalProgressId.isNotEmpty
              ? ApiConstants.updateGoalProgress
              : ApiConstants.addGoalProgress,
          obj: (await createGoalProgressObject()).toJson(),
        ).then(
          (response) {
            List progressList = response.map((e) {
              return GoalProgress.fromJson(e);
            }).toList();
            if (progressList.isNotEmpty && progressList.first.status == 'ok' ||
                progressList.first.status == 'true') {
              onSuccessResponse();
            } else if (progressList.first.status == "already") {
              SnackBarUtils.errorSnackBar(
                title: "Failed!!!",
                message: "Goal Progress already exist",
              );
            } else {
              onFailedResponse();
            }
          },
        );
      } else {
        onFailedResponse();
        CommonHelper.printDebugError(
          "GoalMaster Object Null",
          "ManageGoalProgressController line 108",
        );
      }
    } catch (e) {
      onFailedResponse();
      CommonHelper.printDebugError(e, "ManageGoalProgressController line 108");
    } finally {
      CommonProgressBar.hide();
    }
  }

  void _delete() async {
    try {
      CommonProgressBar.show();
      await ApiProvider.postMethod(
        url: ApiConstants.deleteGoalProgress,
        obj: (await createGoalProgressObject()).toJson(),
      ).then(
        (response) {
          List progressList = response.map((e) {
            return GoalProgress.fromJson(e);
          }).toList();
          if (progressList.isNotEmpty) {
            if ((progressList.first.status != null) &&
                    progressList.first.status == 'true' ||
                progressList.first.status == 'ok') {
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
      message: goalProgressId.isEmpty
          ? "Added successfully..."
          : "Updated successfully...",
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
