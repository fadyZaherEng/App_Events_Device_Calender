// ignore_for_file: depend_on_referenced_packages, unnecessary_null_comparison, avoid_print
import 'package:calender/home/widgets/home_body_content_widget.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      body: HomeBodyContentWidget(
        deviceCalendarPlugin: _deviceCalendarPlugin,
      ),
    );
  }
}
