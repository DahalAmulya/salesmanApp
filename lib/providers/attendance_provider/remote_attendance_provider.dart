// import 'package:deskgoo/providers/deviceInfo_provider/deviceInfo_provider.dart';
import 'dart:convert';

import 'package:deskgoo/consts.dart';
import 'package:deskgoo/utils/hourToHMS.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:http/http.dart' as http;

class AttendanceProvider extends ChangeNotifier {
  TextEditingController _checkInTimeController = TextEditingController();
  TextEditingController _checkOutTimeController = TextEditingController();
  String _status = 'Unknown';
  String _totalHours = 'Unknown';
  bool _isAttendance = false;
  bool _isRemoteAttendanceSwitched = false;
  bool _isBiometricAuthenticated = false;
  bool _isCheckedOut = false;
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

  TextEditingController get checkInTimeController => _checkInTimeController;
  TextEditingController get checkOutTimeController => _checkOutTimeController;
  String get status => _status;
  String get totalHours => _totalHours;
  bool get isAttendance => _isAttendance;
  bool get isRemoteAttendanceSwitched => _isRemoteAttendanceSwitched;
  bool get isAuthenticated => _isBiometricAuthenticated;
  bool get isCheckedOut => _isCheckedOut;
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

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
      ),
    );
    _latitude = position.latitude;
    _longitude = position.longitude;
    List timeList = _checkInTime.toString().split('.')[0].toString().split(' ');
    _time = '${timeList[1]} ${timeList[0]}';
    notifyListeners();
  }

  void attendanceStatus() async {
    try {
      final response = await http.get(
        Uri.parse('${apiURLFrappe}/attendance/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
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
          _status = data[0]['status'];
          if (_status == 'check-in') {
            _checkInTimeStr = data[0]['checkIn']['deviceInTime'];
            _checkOutTimeStr = 'Not Check-out yet';
            _totalHours = 'In progress';
            _isCheckedOut = false;
          } else {
            _isCheckedOut = true;
            _checkInTimeStr = data[0]['checkIn']['deviceInTime'];
            _checkOutTimeStr = data[0]['checkOut']['deviceOutTime'];
            _totalHours = hoursToHMS(data[0]['totalHours']);
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
    notifyListeners();
  }

  void switchRemoteAttendanceSwitch() async {
    try {
      // getCurrentLocation();
      Map<String, dynamic> body = {
        "deviceTime": _time,
        "latitude": _latitude,
        "longitude": _longitude
      };
      final response =
          await http.post(Uri.parse('${apiURLFrappe}attendance/$userId'),
              headers: {
                'Content-Type': 'application/json',
              },
              body: jsonEncode(body));
      if (response.statusCode == 200) {
        _isRemoteAttendanceSwitched = !_isRemoteAttendanceSwitched;
        final data = jsonDecode(response.body);
        print('data = $data');
        attendanceStatus();
      } else {
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (err) {
      print('Err = $err');
    }
    // if (_isRemoteAttendanceSwitched) {
    //   print('_isRemoteAttendanceSwitched = $_isRemoteAttendanceSwitched');
    //   setCheckInTime();
    // } else {
    //   setCheckOutTime();
    // }
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
}
