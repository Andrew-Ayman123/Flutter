import "package:flutter/material.dart";

class DialogHelper {
  static Future<void> displayImage({
    required Widget image,
    required BuildContext context,
  }) async {
    showDialog(
      context: context,
      builder: (ctx) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: image,
        ),
      ),
    );
  }

  static Future<DateTime?> displayDateDay(
      BuildContext context, DateTime initialDate) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 2)),
      lastDate: DateTime.now().add(const Duration(days: 31)),
    );
  }

  static Future<TimeOfDay?> displayDateTime(
      BuildContext context, DateTime initialTime) async {
    return await showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(initialTime));
  }
}
