import 'dart:convert';

import 'package:deskgoo/services/erp_services.dart';
import 'package:deskgoo/utils/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';

class MrAdminVisitLogProvider extends ChangeNotifier {
  List<String> _visitLogsUsersList = ["Select User"];
  List<dynamic> _visitLogsById = [];
  List<dynamic> _usersList = [];
  List<String> _visitDateTypeList = ['Today', 'Yesterday', 'Custom'];
  Map<String, dynamic> _foundVisit = {};
  List<dynamic> _visitList = [];
  String _selectedUserId = '';
  String _selectedUser = 'Select User';
  String _selectedVisitType = 'Today';
  String _from = '';
  String _to = '';
  NepaliDateTime nepaliDateTime = NepaliDateTime.now();
  NepaliDateFormat yearMonthDateBSFormat = NepaliDateFormat('yyyy-MM-dd G');
  NepaliDateTime selectedDate = NepaliDateTime.now();

  TextEditingController _fromTextEditingController = TextEditingController();
  TextEditingController _toTextEditingController = TextEditingController();

  List<String> get visitLogsUserList => _visitLogsUsersList;
  List<dynamic> get visitLogsById => _visitLogsById;
  List<String> get visitDateTypeList => _visitDateTypeList;
  Map<String, dynamic> get foundVisit => _foundVisit;
  List<dynamic> get visitList => _visitList;
  String get selectedUserId => _selectedUserId;
  List<dynamic> get usersList => _usersList;
  String get selectedUser => _selectedUser;
  String get selectedVisitType => _selectedVisitType;
  String get from => _from;
  String get to => _to;
  TextEditingController get fromTextEditingController =>
      _fromTextEditingController;
  TextEditingController get toTextEditingController => _toTextEditingController;

  void setSelectedVisitType(visitType) {
    DateTime currentDate = DateTime.now();
    DateTime yesterday = currentDate.subtract(Duration(days: 1));
    _selectedVisitType = visitType;
    if (_selectedVisitType == _visitDateTypeList[0]) {
      _from = '${currentDate.toString().split(' ')[0]}';
      _to = '${currentDate.toString().split(' ')[0]}';
    } else if (_selectedVisitType == _visitDateTypeList[1]) {
      _from = '${yesterday.toString().split(' ')[0]}';
      _to = '${yesterday.toString().split(' ')[0]}';
    } else {}

    notifyListeners();
  }

  Future<void> selectDateFrom(context) async {
    print('Select date from');
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
    );
    if (picked == null) {
      return;
    } else {
      _from = '${picked.year}-${picked.month}-${picked.day}';
    }
    _fromTextEditingController.text = _from;
    notifyListeners();
  }

  Future<void> selectDateTo(context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
    );
    if (picked == null) {
      return;
    } else {
      _to = '${picked.year}-${picked.month}-${picked.day}';
    }
    _toTextEditingController.text = _to;
    notifyListeners();
  }

  void setSelectedUser(user) {
    _selectedUser = user;
    print(_selectedUser);

    for (int i = 0; i < _usersList.length; i++) {
      if (_usersList[i]['username'] == _selectedUser) {
        _selectedUserId = _usersList[i]['_id'];
        break;
      }
    }

    notifyListeners();
  }

  void getVisitLogsList() async {
    _visitLogsUsersList = ["Select User"];
    _selectedUser = 'Select User';
    _selectedVisitType = 'Today';
    _selectedUserId = '';
    ERPResponse response = await ERPServices.getRequest('/visitLogs/users');
    // print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      _usersList = body['logs'];
      for (int i = 0; i < _usersList.length; i++) {
        _visitLogsUsersList.add(_usersList[i]['username']);
      }
    }
    notifyListeners();
  }

  void getVisitLogsById() async {
    if (_selectedUserId.isEmpty) {
      ToastMessageUtils().showToastMessage('Please select a user');
    } else {
      ERPResponse response = await ERPServices.getRequest(
          '/visitLogs?visitLogId=$_selectedUserId&from=$_from&to=$_to');
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        _foundVisit = body['visitLogs'];
        _visitList = _foundVisit['visitLogs'];
        print(_visitList);
      }
    }
    notifyListeners();
  }
}
