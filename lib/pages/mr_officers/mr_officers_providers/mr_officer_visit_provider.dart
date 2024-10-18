import 'package:flutter/material.dart';

class MrOfficerVisitProvider extends ChangeNotifier {
  List<String> vistTypeList = [
    'Create Visit',
    'New Visit',
    'FollowUp Visit',
  ];
  String _selectedVisitType = '';
  String _radioGroupValue = '';

  String get selectedVisitType => _selectedVisitType;
  String get radioGroupValue => _radioGroupValue;

  void selectVisitType(value) {
    _radioGroupValue = value;
    print(_radioGroupValue);
    notifyListeners();
  }

  void setSelectedVisitType() {
    _selectedVisitType = _radioGroupValue;
    notifyListeners();
  }

  void unSelectVisitType() {
    _radioGroupValue = '';
    _selectedVisitType = '';
    notifyListeners();
  }
}
