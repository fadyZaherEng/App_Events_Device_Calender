// ignore_for_file: depend_on_referenced_packages, unnecessary_null_comparison, avoid_print
import 'package:calender/home/utils/event_model.dart';
import 'package:calender/home/utils/remove_event_from_calender.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

Future<EventModel?> updateEventFromCalender({
  required DeviceCalendarPlugin deviceCalendarPlugin,
  required String eventId,
  required String calenderId,
}) async {
  String tempEventId = eventId;
  EventModel? eventModel;
  if (eventId != "" && calenderId != "") {
    await deviceCalendarPlugin
        .createOrUpdateEvent(
      Event(
        calenderId,
        title: "Appointment Updated ",
        description: "Meeting  Updated",
        start: TZDateTime.from(
          DateTime(2023, 10, 23, 4),
          getLocation(
              await FlutterNativeTimezone.getLocalTimezone()), //"Africa/Cairo",
        ),
        end: TZDateTime.from(
          DateTime(2023, 10, 23, 5),
          getLocation(
              await FlutterNativeTimezone.getLocalTimezone()), //"Africa/Cairo",
        ),
      ),
    )
        .then((result) async {
      await removeEventFromCalender(
        deviceCalendarPlugin: deviceCalendarPlugin,
        eventId: tempEventId,
        calenderId: calenderId,
      ).then((value) {
        eventModel = EventModel(
          eventId: result!.data.toString(),
          status: true,
          calenderId: calenderId,
        );
      });
    }).catchError((onError) {
      print(onError.toString());
    });
  } else {
    eventModel = EventModel(
      eventId: eventId,
      status: false,
      calenderId: calenderId,
    );
  }
  return eventModel;
}
