// ignore_for_file: depend_on_referenced_packages, unnecessary_null_comparison, avoid_print
import 'package:calender/home/utils/add_event_to_calender.dart';
import 'package:calender/home/utils/event_model.dart';
import 'package:calender/home/utils/remove_event_from_calender.dart';
import 'package:calender/home/utils/update_event_calender.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
  String _eventID = "";

  String _calenderID = "";

  bool _removeStatus = false;

  bool _updateStatus = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Device Calender",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 10,
      ),
      body: Padding(
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
                    deviceCalendarPlugin: _deviceCalendarPlugin,
                  );
                  if (eventModel != null) {
                    _calenderID = eventModel.calenderId;
                    _eventID = eventModel.eventId;
                  }
                  setState(() {});
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
                _eventID,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  _removeStatus = await removeEventFromCalender(
                        deviceCalendarPlugin: _deviceCalendarPlugin,
                        eventId: _eventID,
                        calenderId: _calenderID,
                      ) ??
                      false;
                  _eventID = "";
                  _calenderID = "";
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
              const SizedBox(height: 10),
              Text(
                _removeStatus == true
                    ? "Event Remove Status is: $_removeStatus"
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
                    deviceCalendarPlugin: _deviceCalendarPlugin,
                    eventId: _eventID,
                    calenderId: _calenderID,
                  );
                  if (eventModel != null) {
                    _eventID = eventModel.eventId;
                    _calenderID = eventModel.calenderId;
                    _removeStatus = false;
                    _updateStatus = eventModel.status;
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
                _updateStatus == true
                    ? "Event Update Status is: $_updateStatus"
                    : "Updated: $_updateStatus",
                style: TextStyle(
                  fontWeight: _updateStatus == false
                      ? FontWeight.normal
                      : FontWeight.bold,
                  fontSize: _updateStatus == false ? 13 : 16,
                  color: _updateStatus == false ? Colors.grey : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
