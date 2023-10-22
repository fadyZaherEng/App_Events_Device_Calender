// ignore_for_file: depend_on_referenced_packages, unnecessary_null_comparison

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _eventID = "";

  String _calenderID = "";

  bool _removeStatus = false;

  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

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
                onPressed: () {
                  _addEventToCalender(context);
                },
                child: const Text(
                  "Add Event To Calender",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
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
                onPressed: () {
                  _removeEventFromCalender(context);
                },
                child: const Text(
                  "Remove Event From Calender",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                _removeStatus == true
                    ? "Event Remove Status is: $_removeStatus"
                    : "",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addEventToCalender(BuildContext context) async {
    _deviceCalendarPlugin.requestPermissions().then((value) async {
      if (value.data!) {
        final calendars = await _deviceCalendarPlugin.retrieveCalendars();
        if (calendars.isSuccess && calendars.data!.isNotEmpty) {
          Calendar calender = calendars.data!.first;
          _calenderID = calender.id.toString();
          if (calender != null) {
            Result? result = await _deviceCalendarPlugin.createOrUpdateEvent(
              Event(
                calender.id,
                title: "Appointment",
                description: "Meeting Tomorrow",
                start: TZDateTime.from(
                  DateTime(2023, 10, 23, 4),
                  getLocation(
                    await FlutterNativeTimezone.getLocalTimezone(),
                  ),
                ),
                end: TZDateTime.from(
                  DateTime(2023, 10, 23, 5),
                  getLocation(
                    await FlutterNativeTimezone.getLocalTimezone(),
                  ),
                ),
                allDay: true,
              ),
            );
            _eventID = result!.data.toString();
            setState(() {});
          }
        }
      } else {
        await _deviceCalendarPlugin.requestPermissions();
      }
    });
  }

  void _removeEventFromCalender(BuildContext context) async {
    _deviceCalendarPlugin
        .deleteEvent(
      _calenderID,
      _eventID,
    )
        .then((value) {
      _removeStatus = value.data!;
      setState(() {});
    });
  }
}
