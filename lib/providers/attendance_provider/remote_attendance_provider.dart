import 'dart:convert';

import 'package:deskgoo/consts.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/utils/hourToHMS.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

class AttendanceProvider extends ChangeNotifier {
  TextEditingController _checkInTimeController = TextEditingController();
  TextEditingController _checkOutTimeController = TextEditingController();
  String _status = 'Unknown';
  String _totalHours = 'Unknown';
  bool _isAttendance = false;
  bool _isRemoteAttendanceSwitched = false;
  bool _isBiometricAuthenticated = false;
  bool _isCheckedOut = false;
  bool _checkOutConfirmation = false;
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _time = 'Unknown';
  double _distance = 0.0;
  DateTime _checkInTime = DateTime.now();
  DateTime _checkOutTime = DateTime.now();
  // NepaliDateTime _checkInTime = NepaliDateTime.now();
  // NepaliDateTime _checkOutTime = NepaliDateTime.now();
  String _checkInTimeStr = 'Unknown';
  String _checkOutTimeStr = 'Unknown';
  String _hours = '00';
  String _minutes = '00';

  TextEditingController get checkInTimeController => _checkInTimeController;
  TextEditingController get checkOutTimeController => _checkOutTimeController;
  String get status => _status;
  String get totalHours => _totalHours;
  bool get isAttendance => _isAttendance;
  bool get isRemoteAttendanceSwitched => _isRemoteAttendanceSwitched;
  bool get isAuthenticated => _isBiometricAuthenticated;
  bool get isCheckedOut => _isCheckedOut;
  bool get checkOutConfirmation => _checkOutConfirmation;
  double get latitude => _latitude;
  double get longitude => _longitude;
  String get time => _time;
  double get distance => _distance;
  DateTime get checkInTime => _checkInTime;
  DateTime get checkOutTime => _checkOutTime;
  // NepaliDateTime get checkInTime => _checkInTime;
  // NepaliDateTime get checkOutTime => _checkOutTime;
  String get checkInTimeStr => _checkInTimeStr;
  String get checkOutTimeStr => _checkOutTimeStr;
  String get hours => _hours;
  String get minutes => _minutes;

  void resetCheckOutConfirmation() {
    _checkOutConfirmation = false;
  }

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    _latitude = position.latitude;
    _longitude = position.longitude;
    List timeList = _checkInTime.toString().split('.')[0].toString().split(' ');
    _time = '${timeList[1]} ${timeList[0]}';
    notifyListeners();
  }

  void calculateTimeDifference(String checkInTime) {
    // Parse check-in time as UTC and convert to local time
    DateTime inTimeUtc = DateTime.parse(checkInTime).toUtc();
    DateTime inTimeLocal = inTimeUtc.toLocal();

    // Get current local time
    DateTime currentTime = DateTime.now();

    // Remove microseconds and milliseconds for consistency
    inTimeLocal = DateTime(inTimeLocal.year, inTimeLocal.month, inTimeLocal.day,
        inTimeLocal.hour, inTimeLocal.minute, inTimeLocal.second);
    currentTime = DateTime(currentTime.year, currentTime.month, currentTime.day,
        currentTime.hour, currentTime.minute, currentTime.second);

    // Calculate the difference
    Duration difference = currentTime.difference(inTimeLocal);

    print('checkInTime (local) = $inTimeLocal');
    print('currentTime = $currentTime');
    print('difference = $difference');

    // Convert the difference to hours and minutes
    int hours = difference.inHours;
    int minutes = difference.inMinutes.remainder(60);

    // Format hours and minutes with zero-padding
    _hours = hours.toString().padLeft(2, '0');
    _minutes = minutes.toString().padLeft(2, '0');

    notifyListeners();
  }

  void getAttendanceStatus(context) async {
    print(
        '********************************************************************************************');
    try {
      ERPResponse response =
          await ERPServices.getRequest('/attendance/userId?userId=$userId',context);
      print(response.body);
      if (response.statusCode == 200) {
        print('StatusCode=${response.statusCode}');
        final data = jsonDecode(response.body);
        print(data['status']);
        if (data.isEmpty) {
          _isAttendance = false;
          _isRemoteAttendanceSwitched = false;
          _isBiometricAuthenticated = false;
          _status = 'Unknown';
          _checkInTimeStr = 'Unknown';
          _checkOutTimeStr = 'Unknown';
          _totalHours = 'Unknown';
        } else {
          print(data);
          print('Data not empty');
          _isAttendance = true;
          _isRemoteAttendanceSwitched = true;
          _isBiometricAuthenticated = true;
          _status = data['status'];
          if (_status == 'check-in') {
            print('check-in data = ${data['checkIn']}');
            _checkInTimeStr = data['checkIn']['deviceInTime'];
            _checkOutTimeStr = 'Not Check-out yet';
            _totalHours = 'In progress';
            _isCheckedOut = false;
            calculateTimeDifference(data['checkIn']['inTime']);
          } else {
            // if (_checkOutConfirmation) {}
            _isCheckedOut = true;
            _isRemoteAttendanceSwitched = false;
            _isBiometricAuthenticated = true;
            print('check-out data = ${data['checkOut']}');
            _checkInTimeStr = data['checkIn']['deviceInTime'];
            _checkOutTimeStr = data['checkOut']['deviceOutTime'];
            // calculateTotalTime(data[0]['createdAt']);
            _totalHours = hoursToHMS(data['totalHours']);
            _hours = _totalHours.split(':')[0];
            _minutes = _totalHours.split(':')[1];
          }
          print(data.runtimeType);
        }
      } else {
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (err) {
      print('Err = $err');
    }
    print(
        '********************************************************************************************');
    notifyListeners();
  }

  void switchRemoteAttendanceSwitch(context) async {
    getCurrentLocation();
    try {
      _time = '${DateFormat('HH:mm:ss dd/MM/yyyy').format(DateTime.now())}';
      Map<String, dynamic> body = {
        "deviceTime": _time,
        "attendanceTime": DateTime.now().toString(),
        "latitude": _latitude,
        "longitude": _longitude
      };
      print(body);
      ERPResponse response = await ERPServices.postRequest(
          '/attendance/userId?userId=$userId', body, context);
      if (response.statusCode == 200) {
        _isRemoteAttendanceSwitched = !_isRemoteAttendanceSwitched;
        final data = jsonDecode(response.body);
        print('data = $data');
        getAttendanceStatus(context);
      } else {
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (err) {
      print('Err = $err');
    }
    notifyListeners();
  }

  void toggleIsAuthenticated() {
    _isBiometricAuthenticated = !_isBiometricAuthenticated;
    notifyListeners();
  }

  void setCheckInTime() {
    _checkInTime = NepaliDateTime.now();
    _checkInTimeController.text =
        _checkInTime.toString().split('.')[0].split(' ')[1];
    notifyListeners();
  }

  void setCheckOutTime() {
    _checkOutTime = NepaliDateTime.now();
    _checkOutTimeController.text =
        _checkOutTime.toString().split('.')[0].split(' ')[1];
    notifyListeners();
  }

  void getDistance() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
      ),
    );
    _distance = Geolocator.distanceBetween(
      26.45773716586737,
      87.27957052288616,
      position.latitude,
      position.longitude,
    );
    notifyListeners();
  }

  void resetValue() {
    _checkInTimeController.text = '';
    _checkOutTimeController.text = '';
    _status = 'Unknown';
    _totalHours = 'Unknown';
    _isAttendance = false;
    _isRemoteAttendanceSwitched = false;
    _isBiometricAuthenticated = false;
    _isCheckedOut = false;
    _checkOutConfirmation = false;
    _latitude = 0.0;
    _longitude = 0.0;
    _time = 'Unknown';
    _distance = 0.0;
    _checkInTime = DateTime.now();
    _checkOutTime = DateTime.now();
    _checkInTimeStr = 'Unknown';
    _checkOutTimeStr = 'Unknown';
    _hours = '00';
    _minutes = '00';
    notifyListeners();
  }

  Future<void> confirmCheckout(context) => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: CustomColors.primaryWhite,
          elevation: 10,
          title: Center(
            child: CustomText(
              maxLines: 2,
              text: 'Are you sure you want to checkout?',
              isSubHeading: true,
            ),
          ),
          contentPadding: const EdgeInsets.all(16.0),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomElevatedButton(
                backgroundColor: CustomColors.lightRed,
                onPressed: () {
                  Navigator.pop(context);
                },
                widget: CustomText(
                  text: 'Cancel',
                  isContent: true,
                ),
              ),
              CustomElevatedButton(
                backgroundColor: CustomColors.primaryColor,
                onPressed: () {
                  _checkOutConfirmation = true;
                  Navigator.pop(context);
                },
                widget: CustomText(
                  text: 'Yes',
                  isContent: true,
                ),
              ),
            ],
          ),
        ),
      );
}
