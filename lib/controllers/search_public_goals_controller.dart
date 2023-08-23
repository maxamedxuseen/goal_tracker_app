import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/chat.dart';
import '../models/goal_master.dart';
import '../utility/constants/api_constants.dart';
import '../utility/helper/common_helper.dart';
import '../utility/routes/route_constants.dart';
import '../utility/services/api_provider.dart';
import '../utility/services/user_pref.dart';

class SearchPublicGoalsController extends GetxController {
  RxBool isLoading = false.obs;
  RxString selectedFilterValue = 'Title'.obs;
  RxList<GoalMaster> goalList = <GoalMaster>[].obs;
  RxList<GoalMaster> tempAllGoalListList = <GoalMaster>[].obs;
  late TextEditingController etSearch;

  @override
  void onInit() {
    super.onInit();
    initUIAndListeners();
    fetchPublicGoals();
  }

  void initUIAndListeners() {
    etSearch = TextEditingController();
    etSearch.addListener(() => onSearchValueChange());
  }

  void onSearchValueChange() {
    String text = etSearch.text;
    if (text.trim().isEmpty) {
      goalList.assignAll(tempAllGoalListList);
    } else {
      text = text.toLowerCase();
      goalList.assignAll(tempAllGoalListList.where((p0) {
        if (selectedFilterValue.value == 'Goal Type') {
          return p0.goalType?.toLowerCase().contains(text) == true;
        } else if (selectedFilterValue.value == 'User Name') {
          return p0.userName?.toLowerCase().contains(text) == true;
        } else if (selectedFilterValue.value == 'Progress') {
          return p0.progress?.toLowerCase().contains(text) == true;
        } else {
          return p0.goalTitle?.toLowerCase().contains(text) == true;
        }
      }).toList());
    }
  }

  void onPressFilter({required selectedText}) {
    if (Get.isDialogOpen == true) Get.back();
    selectedFilterValue.value = selectedText;
    etSearch.text = '';
    goalList.assignAll(tempAllGoalListList);
  }

  Future<void> onTapGoalCard({required GoalMaster goal}) async {
    Get.toNamed(RouteConstants.manageGoalScreen, arguments: goal)
        ?.then((value) => fetchPublicGoals());
  }

  Future<void> onButtonPressChat({required GoalMaster goal}) async {
    Chat chat = Chat();
    chat.otherUserId = goal.userId;
    chat.userId = await UserPref.getUserId();
    chat.sentByName = goal.userName;
    Get.toNamed(RouteConstants.chatScreen, arguments: chat)
        ?.then((value) => fetchPublicGoals());
  }

  Future<void> fetchPublicGoals() async {
    try {
      isLoading(true);
      goalList.clear();

      String? userId = await UserPref.getUserId();
      List<dynamic> jsonResponse = await ApiProvider.getMethod(
        url: ApiConstants.getPublicGoals + userId.toString(),
      );
      if (jsonResponse.first["api_status"] != null &&
          jsonResponse.first["api_status"] == "ok") {
        goalList.value = jsonResponse.map((e) {
          return GoalMaster.fromJson(e);
        }).toList();
        tempAllGoalListList.assignAll(goalList);
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "SearchPublicGoalsController line 58");
    } finally {
      isLoading(false);
    }
  }
}
