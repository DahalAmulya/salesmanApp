import 'package:deskgoo/utils/toast_message.dart';
import 'package:flutter/material.dart';

class MrOfficerVisitProvider extends ChangeNotifier {
  List<String> _vistTypeList = [
    'Create Visit',
    'New Visit',
    'FollowUp Visit',
  ];
  List<String> _selectedVisitTypeList = ['none', 'More Detail'];
  String _selectedVisitType = '';
  String _radioGroupValue = '';
  int _tabIndex = 0;
  Widget _selectedVisit = Container();

  List<String> get vistTypeList => _vistTypeList;
  List<String> get selectedVisitTypeList => _selectedVisitTypeList;
  String get selectedVisitType => _selectedVisitType;
  String get radioGroupValue => _radioGroupValue;
  int get tabIndex => _tabIndex;
  Widget get selectedVisit => _selectedVisit;

  void selectVisitType(value) {
    _radioGroupValue = value;
    notifyListeners();
  }

  void setTabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  bool setSelectedVisitType() {
    _selectedVisitType = _radioGroupValue;
    if (_selectedVisitType.isEmpty) {
      ToastMessageUtils().showToastMessage('Please select visit type');
      notifyListeners();
      return false;
    } else {
      _selectedVisitTypeList[0] = _selectedVisitType;
      notifyListeners();
      return true;
    }
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
