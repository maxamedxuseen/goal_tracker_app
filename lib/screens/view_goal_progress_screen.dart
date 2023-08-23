import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../controllers/view_goal_progress_controller.dart';
import '../models/goal_progress.dart';
import '../utility/constants/dimens_constants.dart';
import '../utility/common_widgets/common_data_holder.dart';
import '../utility/common_widgets/common_scaffold.dart';

class ViewGoalProgressScreen extends StatelessWidget {
  ViewGoalProgressScreen({super.key});

  final ViewGoalProgressController _controller =
      Get.put(ViewGoalProgressController());

  @override
  Widget build(BuildContext context) {
    context.theme;
    return Obx(
      () {
        return CommonScaffold(
          appBar: AppBar(
            title: const Text('Goal Progress'),
            centerTitle: false,
          ),
          floatingActionButton:
              _controller.isAddGoalProgressEnabled.value == true &&
                      _controller.isGoalProgressCompleted.value != true
                  ? FloatingActionButton.extended(
                      heroTag: "add_goal_progress",
                      label: const Text('Goal Progress'),
                      icon: const Icon(Icons.add_outlined),
                      onPressed: () => _controller.onPressFbAddGoalProgress(),
                    )
                  : null,
          body: _body(),
        );
      },
    );
  }

  Widget _body() {
    return Obx(
      () {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _controller.goalProgressList.isNotEmpty
                ? _progressBar()
                : Container(),
            Expanded(
              child: CommonDataHolder(
                controller: _controller,
                dataList: _controller.goalProgressList,
                widget: Obx(() => _dataHolderWidget()),
                onRefresh: () => _controller.fetchGoalProgress(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _progressBar() {
    double? value = double.tryParse(
      _controller.currentGoalProgressPercent.value,
    );
    return Padding(
      padding: const EdgeInsets.only(top: DimenConstants.layoutPadding),
      child: CircularPercentIndicator(
        radius: DimenConstants.mediumAvatarRadius,
        percent: value == null ? 0.0 : value / 100,
        center: Center(
          child: Text(
            "${value == null ? "Unknown" : value.toString()}/100%",
            textAlign: TextAlign.center,
          ),
        ),
        footer: const Padding(
          padding: EdgeInsets.all(DimenConstants.contentPadding),
          child: Text('Current Goal Progress'),
        ),
      ),
    );
  }

  Widget _dataHolderWidget() {
    return Container(
      constraints: BoxConstraints(minHeight: Get.height / 1.2),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: _controller.goalProgressList.length,
        itemBuilder: (context, index) {
          return _goalProgressCard(
            goalProgress: _controller.goalProgressList[index],
          );
        },
      ),
    );
  }

  Widget _goalProgressCard({required GoalProgress goalProgress}) {
    double? prev = double.tryParse(
      goalProgress.previouslyCompletedPercent ?? "0",
    );
    double? curr = double.tryParse(
      goalProgress.currentCompletedPercent ?? "0",
    );
    return InkWell(
      onTap: () {
        _controller.onTapGoalProgressCard(goalProgress: goalProgress);
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
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _textFields(progress: goalProgress),
                  Icon(
                    curr != null && prev != null && curr != prev
                        ? curr > prev
                            ? Icons.arrow_upward_outlined
                            : Icons.arrow_downward_outlined
                        : Icons.not_interested_outlined,
                    color: curr != null && prev != null && curr != prev
                        ? curr > prev
                            ? Colors.green
                            : Colors.red
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textFields({required GoalProgress progress}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: DimenConstants.contentPadding),
          Text(
            "Currently Completed : ${(progress.currentCompletedPercent ?? " -- ")}%",
          ),
          const SizedBox(height: DimenConstants.contentPadding),
          Text(
            "Previously Completed : ${(progress.previouslyCompletedPercent ?? " -- ")}%",
          ),
          const SizedBox(height: DimenConstants.contentPadding),
          Text(progress.dateTime ?? " -- "),
          const SizedBox(height: DimenConstants.contentPadding),
          Text(progress.description ?? " -- "),
          const SizedBox(height: DimenConstants.contentPadding),
        ],
      ),
    );
  }
}
