import 'package:flutter/material.dart';

class MrOfficerVisitProvider extends ChangeNotifier {
  String _selectedVisitType = '';
  String _radioGroupValue = '';

  String get selectedVisitType => _selectedVisitType;
  String get radioGroupValue => _radioGroupValue;

  void selectVisitType(value) {
    _radioGroupValue = value;
    print(_radioGroupValue);
    notifyListeners();
  }

  void unSelectVisitType() {
    _radioGroupValue = '';
    notifyListeners();
  }
}
