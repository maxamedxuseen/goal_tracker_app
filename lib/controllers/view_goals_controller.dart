import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../models/goal_master.dart';
import '../utility/constants/api_constants.dart';
import '../utility/helper/common_helper.dart';
import '../utility/routes/route_constants.dart';
import '../utility/services/api_provider.dart';
import '../utility/services/user_pref.dart';

class ViewGoalsController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<GoalMaster> goalList = <GoalMaster>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchGoals();
  }

  void onPressFbAddGoal() {
    Get.toNamed(RouteConstants.manageGoalScreen)?.then((value) => fetchGoals());
  }

  void onTapShareIcon({required GoalMaster goal}) {
    String message = "Title: ${goal.goalTitle ?? "Goal"}\n"
        "Type: ${goal.goalType ?? "Other"}\n"
        "Progress: ${goal.progress ?? "0"}%\n"
        "Description : ${goal.description ?? ""}";
    Share.share(message, subject: "Goal Share");
  }

  void onTapGoalCard({
    required GoalMaster goal,
    bool? isEditGoal,
    bool? isShareGoal,
  }) {
    Get.back();
    if (isEditGoal == true) {
      Get.toNamed(
        RouteConstants.manageGoalScreen,
        arguments: goal,
      )?.then((value) => fetchGoals());
    } else if (isShareGoal == true) {
      onTapShareIcon(goal: goal);
    } else {
      Get.toNamed(
        RouteConstants.viewGoalProgressScreen,
        arguments: goal,
      )?.then((value) => fetchGoals());
    }
  }

  Future<void> fetchGoals() async {
    try {
      isLoading(true);
      goalList.clear();
      String? userId = await UserPref.getUserId();
      List<dynamic> jsonResponse = await ApiProvider.getMethod(
        url: ApiConstants.getUserGoals + userId.toString(),
      );
      if (jsonResponse.first["api_status"] != null &&
          jsonResponse.first["api_status"] == "ok") {
        goalList.value = jsonResponse.map((e) {
          return GoalMaster.fromJson(e);
        }).toList();
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "ViewGoalsController line 58");
    } finally {
      isLoading(false);
    }
  }
}
