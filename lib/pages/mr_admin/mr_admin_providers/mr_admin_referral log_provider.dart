import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../services/erp_services.dart';
import '../../../utils/toast_message.dart';

class MrAdminReferralLogProvider extends ChangeNotifier{
  List<String> _referralLogsUsersList = ["Select User"];
  List<String> _referralDateTypeList = ['Today', 'Yesterday', 'Custom'];
  List<dynamic> _usersReferralList = [];
  List<dynamic> _referralList = [];

  String _selectedUser = 'Select User';
  String _selectedReferralType = 'Today';
  String _selectedUserId = '';
  String _from = '';
  String _to = '';

  List<dynamic> _foundReferral = [];

  TextEditingController _fromTextEditingController = TextEditingController();
  TextEditingController _toTextEditingController = TextEditingController();

  List<dynamic> get usersReferralList => _usersReferralList;
  List<dynamic> get referralList => _referralList;
  List<String> get referralLogsUsersList => _referralLogsUsersList;
  List<String> get referralDateTypeList => _referralDateTypeList;

  String get selectedUser => _selectedUser;
  String get selectedUserId => _selectedUserId;
  String get selectedReferralType => _selectedReferralType;
  String get from => _from;
  String get to => _to;

  List<dynamic> get foundReferral => _foundReferral;

  TextEditingController get fromTextEditingController => _fromTextEditingController;
  TextEditingController get toTextEditingController => _toTextEditingController;


  void setSelectedUser(user) {
    _selectedUser = user;
    print(_selectedUser);

    for (int i = 0; i < _usersReferralList.length; i++) {
      if (_usersReferralList[i]['username'] == _selectedUser) {
        _selectedUserId = _usersReferralList[i]['_id'];
        break;
      }
    }

    notifyListeners();
  }

  void setSelectedVisitType(visitType) {
    DateTime currentDate = DateTime.now();
    DateTime yesterday = currentDate.subtract(Duration(days: 1));
    _selectedReferralType = visitType;
    if (_selectedReferralType == _referralDateTypeList[0]) {
      _from = '${currentDate.toString().split(' ')[0]}';
      _to = '${currentDate.toString().split(' ')[0]}';
    } else if (_selectedReferralType == _referralDateTypeList[1]) {
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

  void getVisitLogsList() async {
    _referralLogsUsersList = ["Select User"];
    _selectedUser = 'Select User';
    _selectedReferralType = 'Today';
    _selectedUserId = '';
    ERPResponse response = await ERPServices.getRequest('/visitLogs/users');
    // print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      _usersReferralList = body['logs'];
      for (int i = 0; i < _usersReferralList.length; i++) {
        _referralLogsUsersList.add(_usersReferralList[i]['username']);
      }
    }
    notifyListeners();
  }

  void getReferralLogsById() async {
    if (_selectedUserId.isEmpty) {
      ToastMessageUtils().showToastMessage('Please select a user');
    } else {
      ERPResponse response = await ERPServices.getRequest(
          '/referral/area?_id=$_selectedUserId&from=$_from&to=$_to&country=Nepal&region=Morang');
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        _foundReferral = body['referralLogs'];
        // _referralList = _foundReferral['visitLogs'];
        print(_foundReferral[0]['referral']['patientName']);
        // print(_foundReferral.runtimeType);
        // print(response.body);

      }
      else{
        _referralList = [];
      }
    }
    notifyListeners();
  }


}