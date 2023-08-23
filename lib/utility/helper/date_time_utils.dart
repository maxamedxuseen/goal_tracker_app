import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'common_helper.dart';

class DateTimeUtils {
  static String? currentDate() {
    try {
      final now = DateTime.now();
      DateFormat dateFormat = DateFormat("yyyy/MM/dd");
      return dateFormat.format(now);
    } catch (e) {
      CommonHelper.printDebugError(e,"DateTimeUtils line 14");
      return null;
    }
  }

  static String? currentDateTimeYMDHMS() {
    try {
      final now = DateTime.now();
      DateFormat dateFormat = DateFormat("yyyy/MM/dd HH:mm:ss");
      return dateFormat.format(now);
    } catch (e) {
      CommonHelper.printDebugError(e,"DateTimeUtils line 25");
      return null;
    }
  }

  static Future<String?> showDatePickerDialog({
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    DateFormat dateFormat = DateFormat(DateFormat.YEAR);
    int currentYear = int.parse(dateFormat.format(DateTime.now()));
    final DateTime? d = await showDatePicker(
      context: Get.context as BuildContext,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(currentYear - 100),
      lastDate: lastDate ?? DateTime(currentYear + 1),
    );
    if (d != null) {
      DateFormat dateFormat = DateFormat("yyyy/MM/dd");
      return dateFormat.format(d);
    }
    return null;
  }

  static Future<String?> showDateTimePickerDialog({
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    DateFormat dateFormat = DateFormat(DateFormat.YEAR);
    int currentYear = int.parse(dateFormat.format(DateTime.now()));
    final DateTime? d = await showDatePicker(
      context: Get.context as BuildContext,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(currentYear - 100),
      lastDate: lastDate ?? DateTime(currentYear + 1),
    );
    if (d != null) {
      DateFormat dateFormat = DateFormat("yyyy/MM/dd");
      return showTimePickerDialog(selectedDate: dateFormat.format(d));
    }
    return null;
  }

  static Future<String?> showTimePickerDialog({
    required String selectedDate,
  }) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: Get.context as BuildContext,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? Container(),
        );
      },
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (timeOfDay != null) {
      final localization =
          MaterialLocalizations.of(Get.context as BuildContext);
      String formattedTime = localization.formatTimeOfDay(
        timeOfDay,
        alwaysUse24HourFormat: true,
      );
      return "$selectedDate $formattedTime";
    }
    return null;
  }

  static String? stringDateTimeValidation({
    required String inputStartDateTime,
    required String inputEndDateTime,
  }) {
    try {
      DateFormat dateFormat = DateFormat("yyyy/MM/dd hh:mm");
      DateTime startDateTime = dateFormat.parse(inputStartDateTime);
      DateTime endDateTime = dateFormat.parse(inputEndDateTime);

      if (startDateTime.isAfter(endDateTime) ||
          startDateTime.isAtSameMomentAs(endDateTime)) {
        return "Arrival Time is after delivery time";
      } else {
        return null;
      }
    } catch (e) {
      CommonHelper.printDebugError(e,"DateTimeUtils line 113");
    }
    return null;
  }
}
