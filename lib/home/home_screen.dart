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
                onPressed: () {
                  _removeEventFromCalender(_eventID);
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
                onPressed: () {
                  _updateEventFromCalender();
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

  void _removeEventFromCalender(String eventId) async {
    _deviceCalendarPlugin
        .deleteEvent(
      _calenderID,
      eventId,
    )
        .then((value) {
      setState(() {
        _removeStatus = value.data!;
      });
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  void _updateEventFromCalender() async {
    String tempEventId = _eventID;
    if (_eventID != "" && _calenderID != "") {
      _deviceCalendarPlugin
          .createOrUpdateEvent(
        Event(
          _calenderID,
          title: "Appointment Updated ",
          description: "Meeting Tomorrow Updated",
          start: TZDateTime.from(
            DateTime(2023, 10, 24, 4),
            getLocation(await FlutterNativeTimezone
                .getLocalTimezone()), //"Africa/Cairo",
          ),
          end: TZDateTime.from(
            DateTime(2023, 10, 24, 5),
            getLocation(await FlutterNativeTimezone
                .getLocalTimezone()), //"Africa/Cairo",
          ),
          allDay: true,
        ),
      )
          .then((result) {
        setState(() {
          _eventID = result!.data.toString();
          _updateStatus = true;
          _removeEventFromCalender(tempEventId);
        });
      }).catchError((onError) {
        print(onError.toString());
      });
    } else {
      setState(() {
        _updateStatus = false;
      });
    }
  }
}
