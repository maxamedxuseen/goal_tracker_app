import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../helper/common_helper.dart';
import '../constants/string_constants.dart';

class CommonProgressBar {
  static OverlayEntry? _progressOverlayEntry;
  static BuildContext context = Get.overlayContext as BuildContext;

  static void show() {
    try {
      _progressOverlayEntry = _createdProgressEntry(context);
      Overlay.of(context).insert(_progressOverlayEntry!);
    } catch (e) {
      CommonHelper.printDebugError(e,"CommonProgressWidget line 17");
    }
  }

  static void hide() {
    try {
      if (_progressOverlayEntry != null) {
        _progressOverlayEntry?.remove();
        _progressOverlayEntry = null;
      }
    } catch (e) {
      CommonHelper.printDebugError(e,"CommonProgressWidget line 28");
    }
  }

  static OverlayEntry _createdProgressEntry(BuildContext context) {
    return OverlayEntry(
      builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            Container(color: Colors.black54),
            Align(
              alignment: Alignment.center,
              child: Container(
                child: Lottie.asset(
                  StringConstants.loadingLottie,
                  height: Get.width / 3,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
