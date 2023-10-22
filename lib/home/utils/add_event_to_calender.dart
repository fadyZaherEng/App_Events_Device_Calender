// ignore_for_file: depend_on_referenced_packages, unnecessary_null_comparison, avoid_print
import 'package:calender/home/utils/event_model.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

Future<EventModel?> addEventToCalender({
  required DeviceCalendarPlugin deviceCalendarPlugin,
}) async {
  EventModel? addEventModel;
  await deviceCalendarPlugin.requestPermissions().then((value) async {
    if (value.data!) {
      final calendars = await deviceCalendarPlugin.retrieveCalendars();
      if (calendars.isSuccess && calendars.data!.isNotEmpty) {
        Calendar calender = calendars.data!.first;
        if (calender != null) {
          await deviceCalendarPlugin
              .createOrUpdateEvent(
            Event(
              calender.id,
              title: "Appointment",
              description: "Meeting Today",
              start: TZDateTime.from(
                DateTime(2023, 10, 22, 3),
                getLocation(await FlutterNativeTimezone
                    .getLocalTimezone()), //"Africa/Cairo",
              ),
              end: TZDateTime.from(
                DateTime(2023, 10, 22, 4),
                getLocation(await FlutterNativeTimezone
                    .getLocalTimezone()), //"Africa/Cairo",
              ),
            ),
          )
              .then((result) {
            addEventModel = EventModel(
              eventId: result!.data.toString(),
              status: true,
              calenderId: calender.id.toString(),
            );
          }).catchError((onError) {
            print(onError.toString());
          });
        }
      }
    } else {
      await deviceCalendarPlugin.requestPermissions();
    }
  });
  return addEventModel;
}
