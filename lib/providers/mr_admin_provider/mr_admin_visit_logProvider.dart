import 'dart:convert';

import 'package:deskgoo/services/erp_services.dart';
import 'package:flutter/material.dart';

class MrAdminVisitLogProvider extends ChangeNotifier {
  List<String> _visitLogsUsersList = ["Select User"];
  List<dynamic> _visitLogsByUserId = [];
  List<dynamic> _usersList = [];
  List<String> _visitDateTypeList = ['Today', 'Yesterday', 'Custom'];
  String _selectedUserId = '';
  String _selectedUser = 'Select User';
  String _selectedVisitType = 'Today';
  TextEditingController _fromTextEditingController = TextEditingController();
  TextEditingController _toTextEditingController = TextEditingController();

  List<String> get visitLogsUserList => _visitLogsUsersList;
  List<dynamic> get visitLogsByUserId => _visitLogsByUserId;
  List<String> get visitDateTypeList => _visitDateTypeList;
  String get selectedUserId => _selectedUserId;
  List<dynamic> get usersList => _usersList;
  String get selectedUser => _selectedUser;
  String get selectedVisitType => _selectedVisitType;
  TextEditingController get fromTextEditingController =>
      _fromTextEditingController;
  TextEditingController get toTextEditingController => _toTextEditingController;

  void setSelectedVisitType(visitType) {
    _selectedVisitType = visitType;

    notifyListeners();
  }

  void setSelectedUser(user) {
    _selectedUser = user;
    int index = user.indexWhere((u) => u["username"] == _selectedUser);

    if (index != -1) {
      print("User found at index: $index");
      print("ID: ${_usersList[index]["_id"]}");
      print("Username: ${_usersList[index]["username"]}");
    } else {
      print("User not found");
    }

    notifyListeners();
  }

  void getVisitLogs() async {
    ERPResponse response = await ERPServices.getRequest('/visitLogs/users');
    print(response.statusCode);
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
}
