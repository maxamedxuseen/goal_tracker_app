import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/profile_controller.dart';
import '../../utility/constants/dimens_constants.dart';
import '../../utility/common_widgets/common_data_holder.dart';
import '../../utility/common_widgets/common_scaffold.dart';
import '../../utility/common_widgets/custom_text_field.dart';
import '../utility/common_widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController _controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    context.theme;
    return CommonScaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SafeArea(child: Center(child: Obx(() => _body()))),
    );
  }

  Widget _body() {
    return CommonDataHolder(
      controller: _controller,
      showNoResultFound: false,
      dataList: _controller.userMasterList,
      widget: _dataHolderBody(),
      onRefresh: () => _controller.fetchUserProfileDetails(),
    );
  }

  Widget _dataHolderBody() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(DimenConstants.layoutPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _textFields(),
            _changePassword(),
          ],
        ),
      ),
    );
  }

  Widget _textFields() {
    return Card(
      elevation: DimenConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DimenConstants.mainCardRadius),
      ),
      child: Container(
        margin: const EdgeInsets.only(
          top: DimenConstants.mainLayoutPadding,
          left: DimenConstants.contentPadding,
          right: DimenConstants.contentPadding,
          bottom: DimenConstants.layoutPadding,
        ),
        constraints: BoxConstraints(minWidth: Get.width),
        child: Column(
          children: [
            CustomTextField(
              hintText: 'Name',
              readOnly: !_controller.isEditingEnabled.value,
              textEditingController: _controller.etFullName,
              currentFocusNode: _controller.etFullNameFocusNode,
              nextFocusNode: _controller.etEmailIdFocusNode,
              validatorFunction: (value) {
                if (_controller.isEditingEnabled.value && value!.isEmpty) {
                  return 'Name Cannot Be Empty';
                }
                return null;
              },
            ),
            CustomTextField(
              hintText: 'Email Id',
              keyboardType: TextInputType.emailAddress,
              readOnly: !_controller.isEditingEnabled.value,
              textEditingController: _controller.etEmailId,
              currentFocusNode: _controller.etEmailIdFocusNode,
              nextFocusNode: _controller.etContactNumberFocusNode,
              allowedRegex: "[a-zA-Z0-9@.]",
              validatorFunction: (value) {
                if (_controller.isEditingEnabled.value) {
                  if (value!.isEmpty) {
                    return 'Email Cannot Be Empty';
                  }
                  if (!GetUtils.isEmail(value)) {
                    return 'Enter Valid Email';
                  }
                }
                return null;
              },
            ),
            CustomTextField(
              hintText: 'Contact Number',
              readOnly: !_controller.isEditingEnabled.value,
              textEditingController: _controller.etContactNumber,
              currentFocusNode: _controller.etContactNumberFocusNode,
              validatorFunction: (value) {
                if (_controller.isEditingEnabled.value && value!.isEmpty) {
                  return 'Contact Number Cannot Be Empty';
                }
                return null;
              },
            ),
            _editButton(),
          ],
        ),
      ),
    );
  }

  Widget _changePassword() {
    return InkWell(
      onTap: () => _controller.onTapChangePassword(),
      child: const Padding(
        padding: EdgeInsets.all(DimenConstants.layoutPadding),
        child: Text(
          'CHANGE PASSWORD',
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _editButton() {
    return Column(
      children: [
        Visibility(
          visible: !_controller.isEditingEnabled.value,
          child: InkWell(
            onTap: () => _controller.onTapClickToEdit(),
            child: Container(
              padding: const EdgeInsets.all(DimenConstants.contentPadding),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text('CLICK TO EDIT'),
                  SizedBox(width: DimenConstants.contentPadding),
                  Icon(Icons.edit_outlined),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: _controller.isEditingEnabled.value,
          child: CustomButton(
            buttonText: 'Update',
            onButtonPressed: () => _controller.onPressUpdate(),
          ),
        ),
      ],
    );
  }
}
