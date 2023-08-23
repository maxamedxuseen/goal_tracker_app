import 'package:get/get.dart';

import '../models/goal_master.dart';
import '../models/goal_progress.dart';
import '../utility/constants/api_constants.dart';
import '../utility/helper/common_helper.dart';
import '../utility/routes/route_constants.dart';
import '../utility/services/api_provider.dart';
import '../utility/services/user_pref.dart';

class ViewGoalProgressController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isGoalProgressCompleted = false.obs;
  RxBool isAddGoalProgressEnabled = false.obs;
  RxString currentGoalProgressPercent = 'Unknown'.obs;
  RxList<GoalProgress> goalProgressList = <GoalProgress>[].obs;
  Rxn<GoalMaster> goalArg = Rxn<GoalMaster>();

  @override
  Future<void> onInit() async {
    super.onInit();
    await initObj();
    fetchGoalProgress();
  }

  Future<void> initObj() async {
    String? loginUserId = await UserPref.getUserId();
    goalArg.value = Get.arguments;
    isAddGoalProgressEnabled.value = goalArg.value?.userId == loginUserId;
  }

  void onPressFbAddGoalProgress() {
    if (isAddGoalProgressEnabled.value == true &&
        isGoalProgressCompleted.value != true) {
      Get.toNamed(
        RouteConstants.manageGoalProgressScreen,
        arguments: [goalArg.value, null],
      )?.then((value) => fetchGoalProgress());
    }
  }

  void onTapGoalProgressCard({required GoalProgress goalProgress}) {
    if (isAddGoalProgressEnabled.value == true) {
      Get.toNamed(
        RouteConstants.manageGoalProgressScreen,
        arguments: [goalArg.value, goalProgress],
      )?.then((value) => fetchGoalProgress());
    }
  }

  Future<void> fetchGoalProgress() async {
    try {
      isLoading(true);
      goalProgressList.clear();

      String goalId = goalArg.value?.goalId ?? "";
      List<dynamic> jsonResponse = await ApiProvider.getMethod(
        url: ApiConstants.getGoalProgress + goalId,
      );
      if (jsonResponse.first["api_status"] != null &&
          jsonResponse.first["api_status"] == "ok") {
        goalProgressList.value = jsonResponse.map((e) {
          return GoalProgress.fromJson(e);
        }).toList();
        if (goalProgressList.isNotEmpty) {
          String? percent = goalProgressList.first.currentCompletedPercent;
          double? completionPercent = double.tryParse(percent ?? "0");
          if (completionPercent != null) {
            currentGoalProgressPercent.value = completionPercent.toString();
            if (currentGoalProgressPercent.value.contains("100")) {
              isGoalProgressCompleted.value = true;
            } else {
              isGoalProgressCompleted.value = false;
            }
          } else {
            isGoalProgressCompleted.value = false;
          }
        } else {
          isGoalProgressCompleted.value = false;
        }
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "ViewGoalProgressController line 80");
    } finally {
      isLoading(false);
    }
  }
}
