import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nepali_utils/nepali_utils.dart';

class AttendanceProvider extends ChangeNotifier {
  TextEditingController _checkInTimeController = TextEditingController();
  TextEditingController _checkOutTimeController = TextEditingController();
  bool _isRemoteAttendanceSwitched = false;
  bool _isBiometricAuthenticated = false;
  double _distance = 0.0;
  NepaliDateTime _checkInTime = NepaliDateTime.now();
  NepaliDateTime _checkOutTime = NepaliDateTime.now();

  TextEditingController get checkInTimeController => _checkInTimeController;
  TextEditingController get checkOutTimeController => _checkOutTimeController;
  bool get isRemoteAttendanceSwitched => _isRemoteAttendanceSwitched;
  bool get isAuthenticated => _isBiometricAuthenticated;
  double get distance => _distance;
  NepaliDateTime get checkInTime => _checkInTime;
  NepaliDateTime get checkOutTime => _checkOutTime;

  void switchRemoteAttendanceSwitch() {
    _isRemoteAttendanceSwitched = !_isRemoteAttendanceSwitched;
    if (_isRemoteAttendanceSwitched) {
      setCheckInTime();
    } else {
      setCheckOutTime();
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
}
