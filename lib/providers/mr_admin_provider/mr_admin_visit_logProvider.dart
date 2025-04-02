import 'dart:convert';

import 'package:deskgoo/services/erp_services.dart';
import 'package:deskgoo/utils/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';

class MrAdminVisitLogProvider extends ChangeNotifier {
  List<String> _approvalType = ['approved', 'pending', 'rejected'];
  bool _myAnimation = false;
  double _width = 0;
  List<String> _visitLogsUsersList = ["Select User"];
  List<dynamic> _visitLogsById = [];
  List<dynamic> _usersList = [];
  List<String> _visitDateTypeList = ['Today', 'Yesterday', 'Custom'];
  Map<String, dynamic> _foundVisit = {};
  List<dynamic> _visitList = [];
  String _selectedUserId = '';
  String _selectedUser = 'Select User';
  String _selectedVisitType = 'Today';
  String _selectedVisitAddress = 'Country';
  String _from = '';
  String _to = '';
  String _executiveName = '';
  NepaliDateTime nepaliDateTime = NepaliDateTime.now();
  NepaliDateFormat yearMonthDateBSFormat = NepaliDateFormat('yyyy-MM-dd G');
  NepaliDateTime selectedDate = NepaliDateTime.now();
  List<String> _visitType = ["Country", "Region", "City"];
  List<String> _countryList = [
    'Nepal',
    'India',
  ];
  List<dynamic> _districts = [];
  List<dynamic> _stateList = [];
  List<dynamic> _searchResult = [];
  List<String> _foundDistrictList = [];
  List<String> _foundStateList = [];
  List<String> _foundCities = [];
  List<dynamic> _cities = [];
  String _selectVisitTypeByAddress = 'Country';
  String _selectedCountry = 'Nepal';
  String _selectedDistrict = 'Morang';
  String _selectedStates = 'Andhra Pradesh';
  String _selectedCity = 'Biratnagar';
  String _selectedRegion = '';
  String _selectedCities = '';
  String _selectedState = '';

  TextEditingController _fromTextEditingController = TextEditingController();
  TextEditingController _toTextEditingController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _districtController = TextEditingController();
  TextEditingController _stateController = TextEditingController();

  List<String> get approvalType => _approvalType;
  bool get myAnimation => _myAnimation;
  double get width => _width;
  TextEditingController get fromTextEditingController =>
      _fromTextEditingController;
  TextEditingController get toTextEditingController => _toTextEditingController;
  TextEditingController get searchController => _searchController;
  TextEditingController get cityController => _cityController;
  TextEditingController get districtController => _districtController;
  TextEditingController get stateController => _stateController;

  String get selectVisitTypeByAddress => _selectVisitTypeByAddress;
  List<dynamic> get districts => _districts;
  List<dynamic> get stateList => _stateList;
  List<dynamic> get searchResult => _searchResult;
  List<String> get foundCities => _foundCities;
  List<String> get foundDistrictList => _foundDistrictList;
  List<String> get foundStateList => _foundStateList;
  List<String> get visitType => _visitType;
  List<String> get countryList => _countryList;
  List<dynamic> get cities => _cities;
  String get selectedVisitType => _selectedVisitType;
  String get selectedCountry => _selectedCountry;
  String get selectedDistrict => _selectedDistrict;
  String get selectedStates => _selectedStates;
  String get selectedCity => _selectedCity;
  String get selectedCities => _selectedCities;
  String get selectedState => _selectedState;
  String get selectedRegion => _selectedRegion;

  List<String> get visitLogsUserList => _visitLogsUsersList;
  List<dynamic> get visitLogsById => _visitLogsById;
  List<String> get visitDateTypeList => _visitDateTypeList;
  String get selectedVisitAddress => _selectedVisitAddress;
  Map<String, dynamic> get foundVisit => _foundVisit;
  List<dynamic> get visitList => _visitList;
  String get selectedUserId => _selectedUserId;
  List<dynamic> get usersList => _usersList;
  String get selectedUser => _selectedUser;
  String get from => _from;
  String get to => _to;
  String get executiveName => _executiveName;
  // TextEditingController get fromTextEditingController =>
  //     _fromTextEditingController;
  // TextEditingController get toTextEditingController => _toTextEditingController;

  void triggerAnimation() {
    _myAnimation = false;

    Future.delayed(const Duration(milliseconds: 200), () {
      _myAnimation = true;
    });
  }

  void setSelectedVisitDateType(visitType) {
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

  void setSelectedVisitType(newValue) {
    _selectedVisitAddress = newValue;
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

  void setSelectedCountry(newValue) {
    _selectedCountry = newValue;
    notifyListeners();
  }

  void setSelectedDistrict(value) {
    _selectedRegion = value;
    _districtController.text = _selectedRegion;
    notifyListeners();
  }

  void setSelectedState(value) {
    _selectedRegion = value;
    _stateController.text = _selectedRegion;
    notifyListeners();
  }

  void getCities(List<dynamic> citiesList) {
    _cities = citiesList;
    notifyListeners();
  }

  void setSelectedCity(value) {
    _selectedCities = value;
    _cityController.text = _selectedCities;
    notifyListeners();
  }

  void getVisitLogsList(context) async {
    _visitLogsUsersList = ["Select User"];
    _selectedUser = 'Select User';
    _selectedVisitType = 'Today';
    _selectedUserId = '';
    ERPResponse response =
        await ERPServices.getRequest('/visitLogs/users', context);
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

  void approvalStatus(int index, String value) {
    visitList[index]['approvalStatus'] = value;
    notifyListeners();
  }

  void searchAddressResult(String enteredKeyWord, List<dynamic> addressList) {
    _searchResult = addressList;
    if (enteredKeyWord.isEmpty) {
      _searchResult = addressList;
    } else {
      try {
        if (addressList[0] is String) {
          print('List of cities');
          _searchResult = addressList
              .where((city) => city
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyWord.toLowerCase()))
              .toList();
        } else if (addressList[0].containsKey('district')) {
          print('List of district');
          _searchResult = addressList
              .where((district) => district['district']
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyWord.toLowerCase()))
              .toList();
        } else if (addressList[0].containsKey('states')) {
          print('List of states');
          _searchResult = addressList
              .where((states) => states['states']
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyWord.toLowerCase()))
              .toList();
        }
      } catch (err) {
        print('Error as $err');
      }
    }
    // print(enteredKeyWord);
    print('search result = $_searchResult');
    // _searchController.text = '';
    notifyListeners();
  }

  void getVisitLogsById(context) async {
    if (_selectedUserId.isEmpty) {
      ToastMessageUtils().showToastMessage('Please select a user');
    } else {
      ERPResponse response = await ERPServices.getRequest(
          '/visitLogs?visitLogId=$_selectedUserId&from=$_from&to=$_to',
          context);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        _foundVisit = body['visitLogs'];
        _visitList = _foundVisit['visitLogs'];
        _executiveName = _foundVisit['username'];
        // print(body);
        print(_foundVisit);
        // print(_visitList);
      } else {
        _visitList = [];
      }
    }
    notifyListeners();
  }
}
