import 'package:deskgoo/utils/toast_message.dart';
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
    if (_selectedVisitType.isEmpty) {
      ToastMessageUtils().showToastMessage('Please select visit type');
    }
    notifyListeners();
  }

  void unSelectVisitType() {
    _radioGroupValue = '';
    _selectedVisitType = '';
    notifyListeners();
  }

  void resetSelectedVisitType() {
    _selectedVisitType = '';
    notifyListeners();
  }
}
