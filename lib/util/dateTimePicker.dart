import 'package:flutter/material.dart';

Future<DateTime> showDateTimePicker({
  @required BuildContext context,
  DateTime initialDate,
}) async {
  final defaultDate = DateTime.now();
  DateTime date;
  TimeOfDay time;
  date = await showDatePicker(
    context: context,
    initialDate: initialDate ?? defaultDate,
    firstDate: initialDate.subtract(const Duration(days: 365)),
    lastDate: initialDate.add(const Duration(days: 365)),
  );
  if (date == null) {
    return initialDate;
  }
  time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDate ?? defaultDate),
  );
  if (time == null) {
    return initialDate;
  }
  return date.add(Duration(hours: time.hour, minutes: time.minute));
}
