import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/view_goals_controller.dart';
import '../models/goal_master.dart';
import '../utility/constants/dimens_constants.dart';
import '../utility/common_widgets/common_data_holder.dart';
import '../utility/common_widgets/common_scaffold.dart';

class ViewGoalsScreen extends StatelessWidget {
  ViewGoalsScreen({super.key});

  final ViewGoalsController _controller = Get.put(ViewGoalsController());

  @override
  Widget build(BuildContext context) {
    context.theme;
    return CommonScaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "add_goals",
        label: const Text('Goal'),
        icon: const Icon(Icons.add_outlined),
        onPressed: () => _controller.onPressFbAddGoal(),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return CommonDataHolder(
      controller: _controller,
      dataList: _controller.goalList,
      widget: Obx(() => _dataHolderWidget()),
      onRefresh: () => _controller.fetchGoals(),
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
    return InkWell(
      onTap: () {
        Get.defaultDialog(
          title: 'CHOOSE',
          content: _optionDialog(goal: goal),
        );
      },
      borderRadius: BorderRadius.circular(DimenConstants.cardRadius),
      child: Card(
        margin: const EdgeInsets.all(DimenConstants.contentPadding),
        elevation: DimenConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DimenConstants.cardRadius),
        ),
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints(minWidth: Get.width),
              margin: const EdgeInsets.all(DimenConstants.contentPadding),
              padding: const EdgeInsets.all(DimenConstants.contentPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: DimenConstants.contentPadding),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          goal.goalTitle ?? "Unknown",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Get.textTheme.headlineSmall?.fontSize,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => _controller.onTapShareIcon(goal: goal),
                        child: const Icon(Icons.share_outlined),
                      ),
                    ],
                  ),
                  const SizedBox(height: DimenConstants.contentPadding),
                  Text(
                    goal.goalType ?? " -- ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: DimenConstants.contentPadding),
                  Text(
                    "Start date : ${(goal.startDate ?? "Unknown")}",
                  ),
                  const SizedBox(height: DimenConstants.contentPadding),
                  Text(
                    "End date : ${(goal.endDate ?? "Unknown")}",
                  ),
                  const SizedBox(height: DimenConstants.contentPadding),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(minWidth: Get.width),
              decoration: BoxDecoration(
                color: Get.theme.focusColor.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(DimenConstants.cardRadius),
                  bottomRight: Radius.circular(DimenConstants.cardRadius),
                ),
              ),
              padding: const EdgeInsets.all(DimenConstants.contentPadding),
              child: InkWell(
                onTap: () => _controller.onTapGoalCard(goal: goal),
                child: const Text("Tap to view goal progress or manage goal"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionDialog({required GoalMaster goal}) {
    return Column(
      children: [
        SimpleDialogOption(
          onPressed: () {
            _controller.onTapGoalCard(goal: goal, isEditGoal: true);
          },
          padding: const EdgeInsets.all(DimenConstants.mixPadding),
          child: SizedBox(
            width: Get.width,
            child: const Center(child: Text('Edit/Delete Goal')),
          ),
        ),
        const Divider(thickness: 2),
        SimpleDialogOption(
          onPressed: () => _controller.onTapGoalCard(goal: goal),
          padding: const EdgeInsets.all(DimenConstants.mixPadding),
          child: SizedBox(
            width: Get.width,
            child: const Center(child: Text('View/Add Goal Progress')),
          ),
        ),
        const Divider(thickness: 2),
        SimpleDialogOption(
          onPressed: () {
            _controller.onTapGoalCard(goal: goal, isShareGoal: true);
          },
          padding: const EdgeInsets.all(DimenConstants.mixPadding),
          child: SizedBox(
            width: Get.width,
            child: const Center(child: Text('Share Goal')),
          ),
        ),
      ],
    );
  }
}
