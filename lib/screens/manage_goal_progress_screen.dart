import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/manage_goal_progress_controller.dart';
import '../utility/common_widgets/common_scaffold.dart';
import '../utility/common_widgets/custom_button.dart';
import '../utility/common_widgets/custom_text_field.dart';
import '../utility/constants/dimens_constants.dart';
import '../utility/helper/common_helper.dart';

class ManageGoalProgressScreen extends StatelessWidget {
  ManageGoalProgressScreen({super.key});

  final ManageGoalProgressController _controller =
      Get.put(ManageGoalProgressController());

  @override
  Widget build(BuildContext context) {
    context.theme;
    return Obx(
      () {
        return CommonScaffold(
          appBar: AppBar(
            title: Text(_controller.appBarTitle.value),
            centerTitle: true,
            actions: [_actionWidget()],
          ),
          body: _body(),
        );
      },
    );
  }

  Widget _actionWidget() {
    try {
      if (_controller.goalProgressId.isNotEmpty) {
        return IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _controller.onTapDelete(),
        );
      } else {
        return Container();
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "ManageGoalProgressScreen line 46");
      return Container();
    }
  }

  Widget _body() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(DimenConstants.contentPadding),
                child: Center(
                  child: Form(
                    key: _controller.formKey,
                    child: _textFields(),
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _buttons(),
        ),
      ],
    );
  }

  Widget _textFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: DimenConstants.contentPadding),
          child: Text(
            'Current Progress: ${_controller.currentProgressValue.value}%',
          ),
        ),
        Slider(
          min: 0,
          max: 100,
          divisions: 1000,
          label: "${_controller.currentProgressValue.value}%",
          value: _controller.currentProgressValue.value,
          onChanged: (value) => _controller.onProgressValueChange(value),
        ),
        CustomTextField(
          hintText: "Previously Completed Progress",
          readOnly: true,
          textEditingController: _controller.etPreviouslyCompletedPercent,
          prefixIcon: Icons.history_outlined,
        ),
        CustomTextField(
          hintText: "Description",
          textEditingController: _controller.etDescription,
          keyboardType: TextInputType.multiline,
          minLines: 3,
          prefixIcon: Icons.description_outlined,
        ),
      ],
    );
  }

  Widget _buttons() {
    return CustomButton(
      buttonText: "Submit",
      onButtonPressed: () => _controller.onClickSubmit(),
    );
  }
}
