import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../services/erp_services.dart';

class MrAdminAttendanceProvider extends ChangeNotifier {
  List<String> _attendanceLogsUsersList = ["Select User"];
  List<String> _visitDateTypeList = ['Today', 'Yesterday', 'Custom'];

  List<dynamic> _usersList = [];
  List<dynamic> _attendanceLogs = [];
  Map<String, dynamic> _foundAttendance = {};


  String _selectedUser = 'Select User';
  String _selectedVisitType = 'Today';
  String _selectedUserId = '';
  String _from = '';
  String _to = '';
  double _totalHours = 0;
  bool _isExpanded = true;

  List<String> get attendanceLogsUsersList => _attendanceLogsUsersList;
  List<String> get visitDateTypeList => _visitDateTypeList;
  List<dynamic> get usersList => _usersList;
  List<dynamic> get attendanceLogs => _attendanceLogs;
  Map<String, dynamic> get foundAttendance => _foundAttendance;

  TextEditingController _fromTextEditingController = TextEditingController();
  TextEditingController _toTextEditingController = TextEditingController();

  TextEditingController get fromTextEditingController => _fromTextEditingController;
  TextEditingController get toTextEditingController => _toTextEditingController;

  String get selectedUser => _selectedUser;
  String get selectedUserId => _selectedUserId;
  String get from => _from;
  String get to => _to;
  double get totalHours => _totalHours;
  String get selectedVisitType => _selectedVisitType;
  bool get isExpanded => _isExpanded;


  void setExpanded() {
    _isExpanded = false;
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

  void getVisitLogsList(context) async {
    _attendanceLogsUsersList = ["Select User"];
    _selectedUser = 'Select User';
    _selectedVisitType = 'Today';
    _selectedUserId = '';
    ERPResponse response = await ERPServices.getRequest('/visitLogs/users', context);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      _usersList = body['logs'];
      for (int i = 0; i < _usersList.length; i++) {
        _attendanceLogsUsersList.add(_usersList[i]['username']);
      }
    }
    notifyListeners();
  }

  void getAttendanceReport(context)async{
    if (_selectedUserId.isEmpty) {
      print("User ID is required");
      return;
    }
    ERPResponse response = await ERPServices.getRequest('/attendance/date?userId=$_selectedUserId&from=$_from&to=$_to',context);
    _foundAttendance = jsonDecode(response.body);
    _attendanceLogs = _foundAttendance['attendance']['attendanceLogs'];

    if (response.statusCode == 200) {
      print(_attendanceLogs[0]);
      _totalHours = _foundAttendance['totalHours'];
      print(_totalHours);
      print(_foundAttendance);
    }
    notifyListeners();
  }
}