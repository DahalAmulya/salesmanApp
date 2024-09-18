import 'package:flutter/foundation.dart';

class AttendanceProvider extends ChangeNotifier {
  bool _isRemoteAttendanceSwitched = false;
  bool _isBiometricAuthenticated = false;

  bool get isRemoteAttendanceSwitched => _isRemoteAttendanceSwitched;
  bool get isAuthenticated => _isBiometricAuthenticated;

  void switchRemoteAttendanceSwitch() {
    _isRemoteAttendanceSwitched = !_isRemoteAttendanceSwitched;
    notifyListeners();
  }

  void toggleIsAuthenticated() {
    _isBiometricAuthenticated = !_isBiometricAuthenticated;
    notifyListeners();
  }
}
