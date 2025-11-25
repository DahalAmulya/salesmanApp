import 'dart:convert';

import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';

class TestingDecodingAndEncoding extends StatefulWidget {
  const TestingDecodingAndEncoding({super.key});

  @override
  State<TestingDecodingAndEncoding> createState() =>
      _TestingDecodingAndEncodingState();
}

class _TestingDecodingAndEncodingState
    extends State<TestingDecodingAndEncoding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(text: 'Testing encoding and decoding'),
              CustomElevatedButton(
                onPressed: () {
                  List<Map<String, dynamic>> checkInData = [
                    {
                      'docstatus': 0,
                      'doctype': "Employee Checkin",
                      'name': 'new-employee-checkin-{row.id}',
                      '__islocal': 1,
                      '__unsaved': 1,
                      'owner': "Administrator",
                      'log_type': 'logType',
                      'time': '2024-12-12 15:28:30',
                      'skip_auto_attendance': 0,
                      'employee_name': 'employeeData.employee_name',
                      'employee': 'employeeData.employee_id',
                      'device_id': 'row.employee_id',
                      'latitude': "26.4547555",
                      'longitude': "87.2727071",
                    }
                  ];
                  final encode1 = jsonEncode(checkInData);
                  final encode2 = jsonEncode(encode1);
                  final encode3 = jsonEncode(encode2);
                  print('encode1 = ${encode1}\n');
                  print('encode2 = ${encode2}\n');
                  print('encode3 = ${encode3}\n');

                  final decode1 = jsonDecode(encode2);
                  print('decode1 = ${decode1}');
                  final String encodedData = r"""
"[\"{\\\"message\\\": \\\"Attendance for HR-EMP-00002 on 2024-10-25 is already complete. Skipping update.\\\", \\\"title\\\": \\\"Message\\\", \\\"indicator\\\": \\\"blue\\\"}\", \"{\\\"message\\\": \\\"Attendance for HR-EMP-00002 on 2024-10-28 is already complete. Skipping update.\\\", \\\"title\\\": \\\"Message\\\", \\\"indicator\\\": \\\"blue\\\"}\", \"{\\\"message\\\": \\\"Attendance for HR-EMP-00002 on 2024-11-07 is already complete. Skipping update.\\\", \\\"title\\\": \\\"Message\\\", \\\"indicator\\\": \\\"blue\\\"}\", \"{\\\"message\\\": \\\"Attendance for HR-EMP-00002 on 2024-11-07 is already complete. Skipping update.\\\", \\\"title\\\": \\\"Message\\\", \\\"indicator\\\": \\\"blue\\\"}\", \"{\\\"message\\\": \\\"Attendance for HR-EMP-00002 on 2024-11-14 is already complete. Skipping update.\\\", \\\"title\\\": \\\"Message\\\", \\\"indicator\\\": \\\"blue\\\"}\", \"{\\\"message\\\": \\\"Linked Employee Checkins to Attendance for: HR-ATT-2024-05022.<br>Check-in Details:<br>OUT at 2024-12-12 17:45:00\\\", \\\"title\\\": \\\"Checkins Linked\\\", \\\"indicator\\\": \\\"green\\\"}\", \"{\\\"message\\\": \\\"Saved\\\", \\\"title\\\": \\\"Message\\\", \\\"indicator\\\": \\\"green\\\", \\\"alert\\\": 1}\"]"
""";
                  print('encodedData = ${encodedData}\n');
                  final decodeEncodedData1 = jsonDecode(encodedData);
                  final decodeEncodedData2 = jsonDecode(decodeEncodedData1);
                  print('decodeEncodedData1 = ${decodeEncodedData1}');
                  print('decodeEncodedData2 = ${decodeEncodedData2}');

                  // Map<String, dynamic> data = {
                  //   'docstatus': 0,
                  //   'doctype': 'Employee Checkin',
                  //   'name': 'new-employee-checkin-500',
                  //   '__islocal': 1,
                  //   '__unsaved': 1,
                  //   'owner': 'Administrator',
                  //   'log_type': 'OUT',
                  //   'time': '2024-12-12- 17:'
                  // };
                },
                backgroundColor: CustomColors.primaryColor,
                widget: CustomText(
                  text: 'Press',
                  isContent: true,
                ),
              ),
              // CustomElevatedButton(
              //   onPressed: () async {
              //     final response = await http.get(Uri.parse(
              //         'https://api.openweathermap.org/data/2.5/weather?q=Biratnagar,NP&APPID=6b66e765bffa2781b5c12a6d1b9b2aab'));
              //     print(response.statusCode);
              //     print(response.body);
              //   },
              //   backgroundColor: CustomColors.primaryColor,
              //   widget: CustomText(text: 'Weather report'),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
