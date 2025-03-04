import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../services/erp_services.dart';
import '../../../utils/toast_message.dart';

class MrAdminReferralLogProvider extends ChangeNotifier{
  List<String> _referralLogsUsersList = ["Select User"];
  List<String> _referralDateTypeList = ['Today', 'Yesterday', 'Custom'];
  List<String> _referralType = ["Country","Region","City"];
  List<String> _countryList = ['Nepal','India',];
  List<String> _regionList = ['Morang','Sunsari','Inrwa'];
  List<String> _cityList = ['Biratnagar','Duhabi','Hatkhola'];
  List<dynamic> _districts = [];
  List<dynamic> _stateList = [];
  List<String> _foundDistrictList = [];
  List<String> _foundStateList = [];
  bool _isExpanded = true;
  bool get isExpanded => _isExpanded;

  List<dynamic> _usersReferralList = [];
  List<dynamic> _referralList = [];

  String _selectedUser = 'Select User';
  String _selectedDateReferralType = 'Today';
  String _selectedReferralType = 'Country';
  String _selectedCountry = 'Nepal';
  String _selectedDistrict = 'Morang';
  String _selectedStates = 'Andhra Pradesh';
  String _selectedCity = 'Biratnagar';
  String _selectedUserId = '';
  String _selectedRegion = '';
  String _from = '';
  String _to = '';

  List<dynamic> _foundReferral = [];
  List<dynamic> _foundReferralByCountry = [];
  List<dynamic> _foundReferralByCity = [];

  TextEditingController _fromTextEditingController = TextEditingController();
  TextEditingController _toTextEditingController = TextEditingController();

  List<dynamic> get usersReferralList => _usersReferralList;
  List<dynamic> get referralList => _referralList;
  List<dynamic> get districts => _districts;
  List<dynamic> get stateList => _stateList;
  List<String> get foundDistrictList => _foundDistrictList;
  List<String> get foundStateList => _foundStateList;
  List<String> get referralLogsUsersList => _referralLogsUsersList;
  List<String> get referralDateTypeList => _referralDateTypeList;
  List<String> get referralType => _referralType;
  List<String> get countryList => _countryList;
  List<String> get regionList => _regionList;
  List<String> get cityList => _cityList;

  String get selectedUser => _selectedUser;
  String get selectedUserId => _selectedUserId;
  String get selectedRegion => _selectedRegion;
  String get selectedDateReferralType => _selectedDateReferralType;
  String get selectedReferralType => _selectedReferralType;
  String get selectedCountry => _selectedCountry;
  String get selectedDistrict => _selectedDistrict;
  String get selectedStates => _selectedStates;
  String get selectedCity => _selectedCity;
  String get from => _from;
  String get to => _to;

  List<dynamic> get foundReferral => _foundReferral;
  List<dynamic> get foundReferralByCountry => _foundReferralByCountry;
  List<dynamic> get foundReferralByCity => _foundReferralByCity;

  TextEditingController get fromTextEditingController => _fromTextEditingController;
  TextEditingController get toTextEditingController => _toTextEditingController;

  void getDataForDistrict() async {
    final respose = await rootBundle.loadString('assets/district.json');
    // print(respose.runtimeType);
    List<dynamic> districtData = json.decode(respose);
    // print(districtData);
    _districts = districtData;
    _foundDistrictList =
        districtData.map((item) => item['district'] as String).toList();
    // print(foundDistrictList);
    notifyListeners();
  }

  void getDataForState() async {
    final respose = await rootBundle.loadString('assets/states.json');
    List<dynamic> stateData = json.decode(respose);
    _stateList = stateData;
    _foundStateList =
        stateData.map((item) => item['states'] as String).toList();
    // print(stateList);
    notifyListeners();
  }


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

  void setSelectedReferralType(newValue){
    _selectedReferralType = newValue;
    notifyListeners();
  }

  void setSelectedCountry(newValue){
    _selectedCountry = newValue;
    notifyListeners();
  }

  void setSelectedRegion(String newValue){
     _selectedRegion = newValue;
    notifyListeners();
  }

  void setSelectedCity(newValue){
    _selectedCity = newValue;
    notifyListeners();
  }



  void setSelectedVisitType(visitType) {
    DateTime currentDate = DateTime.now();
    DateTime yesterday = currentDate.subtract(Duration(days: 1));
    _selectedDateReferralType = visitType;
    if (_selectedDateReferralType == _referralDateTypeList[0]) {
      _from = '${currentDate.toString().split(' ')[0]}';
      _to = '${currentDate.toString().split(' ')[0]}';
    } else if (_selectedDateReferralType == _referralDateTypeList[1]) {
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
    _selectedDateReferralType = 'Today';
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

  void getReferralLogsByRegion() async {
    if (_selectedUserId.isEmpty) {
      ToastMessageUtils().showToastMessage('Please select a user');
    } else {

      if (_selectedUserId.isEmpty || _from.isEmpty || _to.isEmpty) {
        ToastMessageUtils().showToastMessage('Please select a user and provide valid dates');
        return;
      }
      ERPResponse response = await ERPServices.getRequest(
        '/referral/area/region?_id=$_selectedUserId&from=$_from&to=$_to&country=$_selectedCountry&region=$_selectedRegion',
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        _foundReferral = body['referralLogs'];
        // print(_foundReferral.runtimeType);
        // print(response.body);
      }
      else{
        _referralList = [];
      }
    }
    notifyListeners();
  }

  void getReferralByCountry()async{
    if (_selectedUserId.isEmpty) {
      ToastMessageUtils().showToastMessage('Please select a user');
      }else{
      if (_selectedUserId.isEmpty || _from.isEmpty || _to.isEmpty) {
        ToastMessageUtils().showToastMessage('Please select a user and provide valid dates');
        return;
      }
      ERPResponse response = await ERPServices.getRequest('/referral/area/country?_id=$_selectedUserId&from=$_from&to=$_to&country=$_selectedCountry');
      final body = jsonDecode(response.body);
      _foundReferral = body['referralLogs'];
      // print(_foundReferralByCountry[0]['createdBy']);
    }
    notifyListeners();
  }

  void getReferralLogByCity()async{
    if (_selectedUserId.isEmpty) {
      ToastMessageUtils().showToastMessage('Please select a user');
    }else{
      if (_selectedUserId.isEmpty || _from.isEmpty || _to.isEmpty) {
        ToastMessageUtils().showToastMessage('Please select a user and provide valid dates');
        return;
      }
      ERPResponse response = await ERPServices.getRequest('http://202.51.3.49:8002/api/referral/area/city?_id=$_selectedUserId&from=$_from&to=$_to&country=$_selectedCountry&region=$_selectedRegion&city=$_selectedCity');
      final body = jsonDecode(response.body);
      _foundReferral = body['referralLogs'];

    }
  }


}