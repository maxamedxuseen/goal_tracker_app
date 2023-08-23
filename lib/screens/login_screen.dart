import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/login_controller.dart';
import '../../utility/constants/dimens_constants.dart';
import '../../utility/constants/string_constants.dart';
import '../utility/common_widgets/common_scaffold.dart';
import '../utility/common_widgets/custom_button.dart';
import '../utility/common_widgets/custom_text_field.dart';
import '../utility/common_widgets/hidden_text_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController _controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    context.theme;
    return CommonScaffold(body: Center(child: _body()));
  }

  Widget _body() {
    return Container(
      margin: const EdgeInsets.all(DimenConstants.layoutPadding),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  _iconWidget(),
                  _textFields(),
                  _loginButton(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(DimenConstants.contentPadding),
                child: InkWell(
                  onTap: () => _controller.onTapSignUp(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Sign Up ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconWidget() {
    return Padding(
      padding: const EdgeInsets.all(DimenConstants.mixPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Welcome Back!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Get.textTheme.headlineSmall?.fontSize,
            ),
          ),
          const SizedBox(height: DimenConstants.layoutPadding),
          SizedBox(
            height: Get.height * 0.13,
            child: Image.asset(
              StringConstants.signIn,
              fit: BoxFit.contain,
            ),
          )
        ],
      ),
    );
  }

  Widget _textFields() {
    return Padding(
      padding: const EdgeInsets.all(DimenConstants.contentPadding),
      child: Form(
        key: _controller.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(
              textEditingController: _controller.etEmailId,
              hintText: "Email Id",
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              currentFocusNode: _controller.etEmailIdFocusNode,
              nextFocusNode: _controller.etPasswordFocusNode,
              validatorFunction: (value) {
                if (value!.isEmpty) {
                  return 'Email Id Cannot Be Empty';
                }
                if (!value.isEmail) {
                  return 'Invalid Email Id';
                }
                return null;
              },
            ),
            const SizedBox(height: DimenConstants.contentPadding),
            CustomHiddenTextField(
              textEditingController: _controller.etPassword,
              hintText: "Password",
              prefixIcon: Icons.lock_outline,
              currentFocusNode: _controller.etPasswordFocusNode,
              validatorFunction: (value) {
                if (value!.isEmpty) {
                  return 'Password Cannot Be Empty';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return CustomButton(
      buttonText: "Sign In",
      onButtonPressed: () => _controller.onPressButtonLogin(),
    );
  }
}
