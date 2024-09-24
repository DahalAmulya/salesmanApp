import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nepali_utils/nepali_utils.dart';

class AttendanceProvider extends ChangeNotifier {
  bool _isRemoteAttendanceSwitched = false;
  bool _isBiometricAuthenticated = false;
  double _distance = 0.0;
  NepaliDateTime _loginTime = NepaliDateTime.now();
  NepaliDateTime _logoutTime = NepaliDateTime.now();
  String _logTime = '';

  bool get isRemoteAttendanceSwitched => _isRemoteAttendanceSwitched;
  bool get isAuthenticated => _isBiometricAuthenticated;
  double get distance => _distance;
  NepaliDateTime get loginTime => _loginTime;
  NepaliDateTime get logoutTime => _logoutTime;
  String get logTime => _logTime;

  void switchRemoteAttendanceSwitch() {
    _isRemoteAttendanceSwitched = !_isRemoteAttendanceSwitched;
    notifyListeners();
  }

  void toggleIsAuthenticated() {
    _isBiometricAuthenticated = !_isBiometricAuthenticated;
    notifyListeners();
  }

  void setLoginTime() {
    _loginTime = NepaliDateTime.now();
    _logTime = _logoutTime.toString().split('.')[0];
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

  void setLogoutTime() {
    _logoutTime = NepaliDateTime.now();
    _logTime = _logoutTime.toString().split('.')[0];
    notifyListeners();
  }
}
