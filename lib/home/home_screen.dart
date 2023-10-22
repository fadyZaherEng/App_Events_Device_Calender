// ignore_for_file: depend_on_referenced_packages, unnecessary_null_comparison, avoid_print
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

  bool _updateStatus = false;

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
                  _addEventToCalender();
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
                  _removeEventFromCalender();
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
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  _updateEventFromCalender(_eventID);
                },
                child: const Text(
                  "Update Event From Calender",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                _updateStatus == true
                    ? "Event Update Status is: $_removeStatus"
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

  void _addEventToCalender() async {
    _deviceCalendarPlugin.requestPermissions().then((value) async {
      if (value.data!) {
        final calendars = await _deviceCalendarPlugin.retrieveCalendars();
        if (calendars.isSuccess && calendars.data!.isNotEmpty) {
          Calendar calender = calendars.data!.first;
          if (calender != null) {
            _deviceCalendarPlugin
                .createOrUpdateEvent(
              Event(
                calender.id,
                title: "Appointment",
                description: "Meeting Tomorrow",
                start: TZDateTime.from(
                  DateTime(2023, 10, 23, 4),
                  getLocation(await FlutterNativeTimezone
                      .getLocalTimezone()), //"Africa/Cairo",
                ),
                end: TZDateTime.from(
                  DateTime(2023, 10, 23, 5),
                  getLocation(await FlutterNativeTimezone
                      .getLocalTimezone()), //"Africa/Cairo",
                ),
                allDay: true,
              ),
            )
                .then((result) {
              setState(() {
                _calenderID = calender.id.toString();
                _eventID = result!.data.toString();
              });
            }).catchError((onError) {
              print(onError.toString());
            });
          }
        }
      } else {
        await _deviceCalendarPlugin.requestPermissions();
      }
    });
  }

  void _removeEventFromCalender() async {
    _deviceCalendarPlugin
        .deleteEvent(
      _calenderID,
      _eventID,
    )
        .then((value) {
      setState(() {
        _removeStatus = value.data!;
      });
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  void _updateEventFromCalender(String eventId) async {
    if (eventId != "") {
      final calendars = await _deviceCalendarPlugin.retrieveCalendars();
      if (calendars.isSuccess && calendars.data!.isNotEmpty) {
        Calendar calender = calendars.data!.first;
        if (calender != null) {
          _deviceCalendarPlugin
              .createOrUpdateEvent(
            Event(
              calender.id,
              eventId: eventId,
              title: "Appointment",
              description: "Meeting Tomorrow",
              start: TZDateTime.from(
                DateTime(2023, 10, 23, 4),
                getLocation(await FlutterNativeTimezone
                    .getLocalTimezone()), //"Africa/Cairo",
              ),
              end: TZDateTime.from(
                DateTime(2023, 10, 23, 5),
                getLocation(await FlutterNativeTimezone
                    .getLocalTimezone()), //"Africa/Cairo",
              ),
              allDay: true,
            ),
          )
              .then((result) {
            setState(() {
              _calenderID = calender.id.toString();
              _eventID = result!.data.toString();
              _updateStatus = true;
            });
          }).catchError((onError) {
            print(onError.toString());
          });
        }
      }
    } else {
      _updateStatus = false;
      print(_updateStatus);
    }
  }
}
