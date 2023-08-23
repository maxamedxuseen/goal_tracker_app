import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/search_public_goals_controller.dart';
import '../models/goal_master.dart';
import '../utility/common_widgets/custom_button.dart';
import '../utility/common_widgets/custom_text_field.dart';
import '../utility/constants/dimens_constants.dart';
import '../utility/common_widgets/common_data_holder.dart';

class SearchPublicGoalsScreen extends StatelessWidget {
  SearchPublicGoalsScreen({super.key});

  final SearchPublicGoalsController _controller =
      Get.put(SearchPublicGoalsController());

  @override
  Widget build(BuildContext context) {
    context.theme;
    return _body();
  }

  Widget _body() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _searchBox(),
        Expanded(
          child: CommonDataHolder(
            controller: _controller,
            dataList: _controller.goalList,
            widget: Obx(() => _dataHolderWidget()),
            onRefresh: () => _controller.fetchPublicGoals(),
          ),
        ),
      ],
    );
  }

  Widget _searchBox() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 5,
          child: CustomTextField(
            hintText: "Search...",
            keyboardType: _controller.selectedFilterValue.value == "Progress"
                ? TextInputType.number
                : TextInputType.text,
            textEditingController: _controller.etSearch,
            prefixIcon: Icons.search_outlined,
          ),
        ),
        Expanded(
          flex: 1,
          child: CustomButton(
            buttonText: '',
            height: 60,
            margin: const EdgeInsets.only(right: DimenConstants.contentPadding),
            iconWidget: const Icon(Icons.filter_list_alt, color: Colors.white),
            isWrapContent: true,
            buttonColor: Get.theme.colorScheme.primaryContainer,
            radius: BorderRadius.circular(DimenConstants.cardRadius),
            primaryColor: Get.textTheme.bodyMedium?.color,
            onButtonPressed: () => Get.dialog(filterOptionsDialog()),
          ),
        ),
      ],
    );
  }

  Widget _dataHolderWidget() {
    return Container(
      constraints: BoxConstraints(minHeight: Get.height / 1.2),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: _controller.goalList.length,
        itemBuilder: (context, index) {
          return _goalCard(goal: _controller.goalList[index]);
        },
      ),
    );
  }

  Widget _goalCard({required GoalMaster goal}) {
    return Container(
      margin: const EdgeInsets.all(DimenConstants.contentPadding),
      child: Card(
        elevation: DimenConstants.cardElevation,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(DimenConstants.cardRadius),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => _controller.onTapGoalCard(goal: goal),
              child: _goalTextFieldDetails(goal: goal),
            ),
            _chatButton(goal: goal),
          ],
        ),
      ),
    );
  }

  Widget _goalTextFieldDetails({required GoalMaster goal}) {
    return Padding(
      padding: const EdgeInsets.all(DimenConstants.layoutPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            goal.goalTitle ?? "Unknown",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Get.textTheme.headlineSmall?.fontSize,
            ),
          ),
          const SizedBox(height: DimenConstants.contentPadding),
          Text(
            goal.goalType ?? " -- ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: DimenConstants.contentPadding),
          Text(
            "Progress : ${(goal.progress ?? " -- ")}%",
          ),
          const SizedBox(height: DimenConstants.contentPadding),
          Text(
            "Start date : ${(goal.startDate ?? "Unknown")}",
          ),
          const SizedBox(height: DimenConstants.contentPadding),
          Text(
            "End date : ${(goal.endDate ?? "Unknown")}",
          ),
        ],
      ),
    );
  }

  Widget _chatButton({required GoalMaster goal}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(DimenConstants.cardRadius),
          bottomRight: Radius.circular(DimenConstants.cardRadius),
        ),
      ),
      child: CustomButton(
        buttonText: 'CHAT',
        isTransparentButton: true,
        textColor: Colors.black,
        iconWidget: const Icon(Icons.chat_outlined, color: Colors.black),
        onButtonPressed: () => _controller.onButtonPressChat(goal: goal),
      ),
    );
  }

  Widget filterOptionsDialog() {
    return SimpleDialog(
      children: [
        Padding(
          padding: const EdgeInsets.all(DimenConstants.contentPadding),
          child: Text(
            'Search By...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Get.textTheme.titleLarge?.fontSize,
            ),
          ),
        ),
        SimpleDialogOption(
          onPressed: () => _controller.onPressFilter(selectedText: 'Title'),
          padding: const EdgeInsets.all(DimenConstants.contentPadding),
          child: _bottomSheetTextWidget(text: 'Title'),
        ),
        SimpleDialogOption(
          onPressed: () => _controller.onPressFilter(selectedText: 'Goal Type'),
          padding: const EdgeInsets.all(DimenConstants.contentPadding),
          child: _bottomSheetTextWidget(text: 'Goal Type'),
        ),
        SimpleDialogOption(
          onPressed: () => _controller.onPressFilter(selectedText: 'User Name'),
          padding: const EdgeInsets.all(DimenConstants.contentPadding),
          child: _bottomSheetTextWidget(text: 'User Name'),
        ),
        SimpleDialogOption(
          onPressed: () => _controller.onPressFilter(selectedText: 'Progress'),
          padding: const EdgeInsets.all(DimenConstants.contentPadding),
          child: _bottomSheetTextWidget(text: 'Progress'),
        ),
      ],
    );
  }

  Widget _bottomSheetTextWidget({required String text}) {
    return Padding(
      padding: const EdgeInsets.all(DimenConstants.smallPadding),
      child: Text(
        text,
        style: TextStyle(
          fontSize: Get.textTheme.titleMedium?.fontSize,
          color: _controller.selectedFilterValue.value == text
              ? Get.theme.colorScheme.primaryContainer
              : null,
        ),
      ),
    );
  }
}
