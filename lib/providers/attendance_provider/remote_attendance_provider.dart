import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';

class AttendanceProvider extends ChangeNotifier {
  bool _isRemoteAttendanceSwitched = false;
  bool _isBiometricAuthenticated = false;
  NepaliDateTime _loginTime = NepaliDateTime.now();
  NepaliDateTime _logoutTime = NepaliDateTime.now();
  String _logTime = '';

  bool get isRemoteAttendanceSwitched => _isRemoteAttendanceSwitched;
  bool get isAuthenticated => _isBiometricAuthenticated;
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

  void setLogoutTime() {
    _logoutTime = NepaliDateTime.now();
    _logTime = _logoutTime.toString().split('.')[0];
    notifyListeners();
  }
}
