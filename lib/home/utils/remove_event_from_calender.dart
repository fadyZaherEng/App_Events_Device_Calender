// ignore_for_file: depend_on_referenced_packages, unnecessary_null_comparison, avoid_print
import 'package:device_calendar/device_calendar.dart';

Future<bool?> removeEventFromCalender({
  required DeviceCalendarPlugin deviceCalendarPlugin,
  required String eventId,
  required String calenderId,
}) async {
  bool? status = (await deviceCalendarPlugin.deleteEvent(
    calenderId,
    eventId,
  ))
      .data;
  return status;
}
