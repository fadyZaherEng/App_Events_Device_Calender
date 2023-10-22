// ignore_for_file: avoid_print, unnecessary_null_comparison, depend_on_referenced_packages

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Calender",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String eventID = "";

  String calenderID = "";

  bool removeStatus = false;

  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                _addEventToCalender(context);
              },
              child: const Text(
                "Add Event To Calender",
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              eventID,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                removeEventFromCalender(context);
              },
              child: const Text(
                "remove Event from Calender",
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              removeStatus == true
                  ? "Event Remove Status is: $removeStatus"
                  : "",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.black,
              ),
            ),
          ],
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
          calenderID = calender.id.toString();
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
            eventID = result!.data.toString();
            setState(() {});
          }
        }
      } else {
        await _deviceCalendarPlugin.requestPermissions();
      }
    });
  }

  void removeEventFromCalender(BuildContext context) async {
    _deviceCalendarPlugin
        .deleteEvent(
      calenderID,
      eventID,
    )
        .then((value) {
      removeStatus = value.data!;
      setState(() {});
    });
  }
}
