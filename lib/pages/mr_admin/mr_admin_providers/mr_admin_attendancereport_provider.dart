import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../services/erp_services.dart';
import 'package:path/path.dart' as path;

import '../../../themes/custom_colors.dart';
import '../../../utils/toast_message.dart';

class MrAdminAttendanceProvider extends ChangeNotifier {
  List<String> _attendanceLogsUsersList = ["All Users"];
  List<String> _visitDateTypeList = ['Today', 'Yesterday', 'Custom'];

  List<dynamic> _usersList = [];
  List<dynamic> _attendanceLogs = [];
  Map<String, dynamic> _foundAttendance = {};
  List<dynamic> _allUsersAttendanceReport = [];

  List<dynamic> get allUserAttendanceReport => _allUsersAttendanceReport;

  String _selectedUser = 'All Users';
  String _selectedVisitType = 'Today';
  String _selectedUserId = '';
  String _from = DateTime.now().toString().split(' ')[0];
  String _to = DateTime.now().toString().split(' ')[0];
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
      _from = currentDate.toString().split(' ')[0];
      _to = currentDate.toString().split(' ')[0];
    } else if (_selectedVisitType == _visitDateTypeList[1]) {
      _from = yesterday.toString().split(' ')[0];
      _to = yesterday.toString().split(' ')[0];
    } else {}

    notifyListeners();
  }

  void getVisitLogsList(context) async {
    _attendanceLogsUsersList = ["All Users"];
    _selectedUser = 'All Users';
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

  void getAttendanceReport(context) async {
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

  void downloadAttendanceReport(context) async {
    if (_selectedUserId.isEmpty) {
      print("User ID is required");
      return;
    }
    ERPResponse response = await ERPServices.getRequest('/attendance/download?userId=$_selectedUserId&from=$_from&to=$_to', context);
    if (response.statusCode == 200) {
      String csvContent = response.body;
      // Handle the file download logic here
      // 2. Get the download directory (Android only)
      Directory downloadDir = Directory('/storage/emulated/0/Download');

      // 3. Create VisitLogs/Rajan Kumar folder
      String folderPath = path.join(downloadDir.path, 'Attendance', _selectedUser);
      Directory nestedDir = Directory(folderPath);

      if (!nestedDir.existsSync()) {
        nestedDir.createSync(recursive: true); // Create all folders
      }

      // 4. Create file inside the folder
      String filePath = path.join(nestedDir.path, '${selectedUser}_Attendance_${_from}_to_$_to.csv');
      File file = File(filePath);

      await file.writeAsString(csvContent);
      ToastMessageUtils().showToastMessage(
          "Success! CSV file saved to: \n$filePath", ToastGravity.TOP, CustomColors.jadeGreen
      );
    } else {
      ToastMessageUtils().showToastMessage("Error! Failed to download visit log.");
    }
  }

  void getAllUserAttendanceReport(context) async {
    ERPResponse response = await ERPServices.getRequest('/attendance/date/all?from=$_from&to=$_to',context);
    _allUsersAttendanceReport = jsonDecode(response.body);
    print(_allUsersAttendanceReport.length);
    print(_allUsersAttendanceReport);
    notifyListeners();
  }
}