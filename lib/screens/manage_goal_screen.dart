import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/manage_goal_controller.dart';
import '../utility/common_widgets/common_scaffold.dart';
import '../utility/common_widgets/custom_button.dart';
import '../utility/common_widgets/custom_drop_down.dart';
import '../utility/common_widgets/custom_text_field.dart';
import '../utility/constants/dimens_constants.dart';
import '../utility/helper/common_helper.dart';

class ManageGoalScreen extends StatelessWidget {
  ManageGoalScreen({super.key});

  final ManageGoalController _controller = Get.put(ManageGoalController());

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
      if (_controller.goalId.isNotEmpty &&
          _controller.isGoalEditingEnabled.value) {
        return IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _controller.onTapDelete(),
        );
      } else {
        return Container();
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "ManageGoalScreen line 45");
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
      children: [
        CustomTextField(
          hintText: "Title",
          readOnly: !_controller.isGoalEditingEnabled.value,
          textEditingController: _controller.etGoalTitle,
          prefixIcon: Icons.title_outlined,
          currentFocusNode: _controller.etGoalTitleFocusNode,
          nextFocusNode: _controller.etDescriptionFocusNode,
          validatorFunction: (value) {
            if (value!.isEmpty) {
              return 'Title Cannot Be Empty';
            }
            return null;
          },
        ),
        CustomDropDown(
          labelText: 'Goal Type',
          isReadOnly: !_controller.isGoalEditingEnabled.value,
          prefixIcon: Icons.type_specimen_outlined,
          displayList: _controller.goalTypeList,
          selected: _controller.selectedGoalType,
          validatorFunction: (value) {
            try {
              if (value == null) {
                return 'Cannot Be Empty';
              }
              if (value == "Goal Type" || value == "Select Goal Type") {
                return 'Cannot Be Empty';
              }
            } catch (e) {
              return 'Cannot Be Empty';
            }
            return null;
          },
        ),
        CustomTextField(
          hintText: "Start Date",
          textEditingController: _controller.etStartDate,
          keyboardType: TextInputType.datetime,
          prefixIcon: Icons.date_range_outlined,
          currentFocusNode: _controller.etStartDateFocusNode,
          nextFocusNode: _controller.etEndDateFocusNode,
          readOnly: true,
          onTapField: () => _controller.onClickStartDate(),
          validatorFunction: (value) {
            if (value!.isEmpty) {
              return 'Start Date Cannot Be Empty';
            }
            return null;
          },
        ),
        CustomTextField(
          hintText: "End Date",
          textEditingController: _controller.etEndDate,
          keyboardType: TextInputType.datetime,
          prefixIcon: Icons.date_range_outlined,
          currentFocusNode: _controller.etEndDateFocusNode,
          nextFocusNode: _controller.etDescriptionFocusNode,
          readOnly: true,
          onTapField: () => _controller.onClickEndDate(),
          validatorFunction: (value) {
            if (value!.isEmpty) {
              return 'End Date Cannot Be Empty';
            }
            return null;
          },
        ),
        CustomTextField(
          hintText: "Description",
          readOnly: !_controller.isGoalEditingEnabled.value,
          textEditingController: _controller.etDescription,
          keyboardType: TextInputType.multiline,
          minLines: 3,
          prefixIcon: Icons.description_outlined,
          currentFocusNode: _controller.etDescriptionFocusNode,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Goal Publicly Available ? '),
            Checkbox(
              activeColor: Get.theme.colorScheme.primary,
              value: _controller.isGoalPublic.value,
              onChanged: (value) => _controller.onGoalPublicValueChange(value),
            ),
          ],
        )
      ],
    );
  }

  Widget _buttons() {
    return Padding(
      padding: const EdgeInsets.only(
        top: DimenConstants.layoutPadding,
        bottom: DimenConstants.contentPadding,
        left: DimenConstants.contentPadding,
        right: DimenConstants.contentPadding,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Visibility(
            visible: _controller.isGoalEditingEnabled.value,
            child: Expanded(
              child: CustomButton(
                buttonText: "Submit",
                isWrapContent: true,
                radius: _controller.goalId.isNotEmpty
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(DimenConstants.cardRadius),
                        bottomLeft: Radius.circular(DimenConstants.cardRadius),
                      )
                    : null,
                onButtonPressed: () => _controller.onClickSubmit(),
              ),
            ),
          ),
          Visibility(
            visible: _controller.goalId.isNotEmpty,
            child: Expanded(
              child: CustomButton(
                buttonText: "View Progress",
                isWrapContent: true,
                radius: _controller.goalId.isNotEmpty
                    ? _controller.isGoalEditingEnabled.value
                        ? const BorderRadius.only(
                            topRight:
                                Radius.circular(DimenConstants.cardRadius),
                            bottomRight:
                                Radius.circular(DimenConstants.cardRadius),
                          )
                        : null
                    : null,
                onButtonPressed: () => _controller.onClickViewProgress(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
