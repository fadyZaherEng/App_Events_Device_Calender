import 'package:calender/constants.dart';
import 'package:calender/home/utils/add_event_to_calender.dart';
import 'package:calender/home/utils/event_model.dart';
import 'package:calender/home/utils/remove_event_from_calender.dart';
import 'package:calender/home/utils/update_event_calender.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';

class HomeBodyContentWidget extends StatefulWidget {
  final DeviceCalendarPlugin deviceCalendarPlugin;
  //comment
  const HomeBodyContentWidget({
    super.key,
    required this.deviceCalendarPlugin,
  });

  ///test
  @override
  State<HomeBodyContentWidget> createState() => _HomeBodyContentWidgetState();
}

class _HomeBodyContentWidgetState extends State<HomeBodyContentWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                EventModel? eventModel = await addEventToCalender(
                  deviceCalendarPlugin: widget.deviceCalendarPlugin,
                );
                if (eventModel != null) {
                  calenderID = eventModel.calenderId;
                  eventID = eventModel.eventId;
                }
                setState(
                  () {},
                );
              },
              child: const Text(
                "Add Event To Calender",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              eventID,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                removeStatus = await removeEventFromCalender(
                      deviceCalendarPlugin: widget.deviceCalendarPlugin,
                      eventId: eventID,
                      calenderId: calenderID,
                    ) ??
                    false;
                eventID = "";
                calenderID = "";
                setState(() {});
              },
              child: const Text(
                "Remove Event From Calender",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              removeStatus == true
                  ? "Event Remove Status is: $removeStatus"
                  : "",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                EventModel? eventModel = await updateEventFromCalender(
                  deviceCalendarPlugin: widget.deviceCalendarPlugin,
                  eventId: eventID,
                  calenderId: calenderID,
                );
                if (eventModel != null) {
                  eventID = eventModel.eventId;
                  calenderID = eventModel.calenderId;
                  removeStatus = false;
                  updateStatus = eventModel.status;
                }
                setState(() {});
              },
              child: const Text(
                "Update Event From Calender",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              updateStatus == true
                  ? "Event Update Status is: $updateStatus"
                  : "Updated: $updateStatus",
              style: TextStyle(
                fontWeight:
                    updateStatus == false ? FontWeight.normal : FontWeight.bold,
                fontSize: updateStatus == false ? 14 : 16,
                color: updateStatus == false ? Colors.grey : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
