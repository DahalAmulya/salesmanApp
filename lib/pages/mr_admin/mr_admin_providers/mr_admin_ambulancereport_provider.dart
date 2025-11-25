import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../services/erp_services.dart';
import '../../../utils/toast_message.dart';

class MrAdminAmbulanceReportProvider extends ChangeNotifier{
  List<String> _ambulanceLogsUsersList = ["Select User",];
  List<String> _ambulanceReportDateTypeList = ['Today', 'Yesterday', 'Custom'];
  List<String> _ambulanceReferralType = ["Country","Region","City"];
  List<String> _countryList = ['Nepal','India',];
  List<String> _approvalType = ['approved', 'pending', 'rejected'];
  List<String> _foundDistrictList = [];
  List<String> _foundStateList = [];
  List<String> _foundCities = [];


  List<dynamic> _usersList = [];
  List<dynamic> _ambulanceReportLogs = [];
  Map<String, dynamic> _foundReport = {};
  List<dynamic> _allUsersAmbulanceReport = [];
  List<dynamic> _foundAmbulanceReferral = [];
  List<dynamic> _foundAmbulanceReferralByCountry = [];
  List<dynamic> _foundAmbulanceReferralByCity = [];
  List<dynamic> _districts = [];
  List<dynamic> _stateList = [];
  List<dynamic> _cities = [];
  List<dynamic> _searchResult = [];
  List<dynamic> _foundAmbulanceList = [];

  List<dynamic> _usersAmbulanceList = [];
  List<dynamic> _referralList = [];



  String _selectedUser = 'Select User';
  String _selectedAmbulanceReportDateType = 'Today';
  String _selectedAmbulanceReferralType = 'Country';
  String _selectedCountry = 'Nepal';
  String _selectedDistrict = 'Morang';
  String _selectedStates = 'Andhra Pradesh';
  String _selectedCity = 'Biratnagar';
  String _selectedUserId = '';
  String _selectedRegion = '';
  String _selectedCities = '';
  String _selectedState = '';
  String _profileImage = '';
  String _baseUrl = 'http://202.51.3.49:8002/api/poc/category?createdById=67bb038a43570a2502dd1ee6&category=Ambulance';
  String _foundAmbulanceDetail = '';

  String _from = DateTime.now().toString().split(' ')[0];
  String _to = DateTime.now().toString().split(' ')[0];

  TextEditingController _fromTextEditingController = TextEditingController();
  TextEditingController _toTextEditingController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _districtController = TextEditingController();
  TextEditingController _stateController = TextEditingController();


  List<String> get ambulanceLogsUsersList => _ambulanceLogsUsersList;
  List<String> get ambulanceReferralType => _ambulanceReferralType;
  List<String> get countryList => _countryList;
  List<String> get ambulanceReportDateTypeList => _ambulanceReportDateTypeList;
  List<String> get foundDistrictList => _foundDistrictList;
  List<String> get foundStateList => _foundStateList;
  List<String> get foundCities => _foundCities;
  List<String> get approvalType => _approvalType;

  List<dynamic> get usersList => _usersList;
  List<dynamic> get ambulanceReportLogs => _ambulanceReportLogs;
  List<dynamic> get foundAmbulanceReferral => _foundAmbulanceReferral;
  List<dynamic> get foundAmbulanceReferralByCountry => _foundAmbulanceReferralByCountry;
  List<dynamic> get foundAmbulanceReferralByCity => _foundAmbulanceReferralByCity;
  Map<String, dynamic> get foundReport => _foundReport;
  List<dynamic> get allUsersAmbulanceReport => _allUsersAmbulanceReport;
  List<dynamic> get districts => _districts;
  List<dynamic> get stateList => _stateList;
  List<dynamic> get cities => _cities;
  List<dynamic> get searchResult => _searchResult;
  List<dynamic> get usersAmbulanceList => _usersAmbulanceList;
  List<dynamic> get referralList => _referralList;
  List<dynamic> get foundAmbulanceList => _foundAmbulanceList;



  String get selectedUser => _selectedUser;
  String get selectedAmbulanceReportDateType => _selectedAmbulanceReportDateType;
  String get selectedUserId => _selectedUserId;
  String get from => _from;
  String get to => _to;
  String get selectedAmbulanceReferralType => _selectedAmbulanceReferralType;
  String get selectedCountry => _selectedCountry;
  String get selectedDistrict => _selectedDistrict;
  String get selectedStates => _selectedStates;
  String get selectedCity => _selectedCity;
  String get selectedRegion => _selectedRegion;
  String get selectedCities => _selectedCities;
  String get selectedState => _selectedState;
  String get profileImage => _profileImage;
  String get baseUrl => _baseUrl;
  String get foundAmbulanceDetail => _foundAmbulanceDetail;

  TextEditingController get fromTextEditingController => _fromTextEditingController;
  TextEditingController get toTextEditingController => _toTextEditingController;
  TextEditingController get searchController => _searchController;
  TextEditingController get cityController => _cityController;
  TextEditingController get districtController => _districtController;
  TextEditingController get stateController => _stateController;


  void setSelectedUser(user) {
    _selectedUser = user;
    print(_selectedUser);

    for (int i = 0; i < _usersAmbulanceList.length; i++) {
      if (_usersAmbulanceList[i]['username'] == _selectedUser) {
        _selectedUserId = _usersAmbulanceList[i]['_id'];
        break;
      }
    }

    notifyListeners();
  }

  void approvalStatus(int index, String value) {
    notifyListeners();
  }

  void setSelectedAmbulanceVisitType(visitType) {
    DateTime currentDate = DateTime.now();
    DateTime yesterday = currentDate.subtract(Duration(days: 1));
    _selectedAmbulanceReportDateType = visitType;
    if (_selectedAmbulanceReportDateType == _ambulanceReportDateTypeList[0]) {
      _from = '${currentDate.toString().split(' ')[0]}';
      _to = '${currentDate.toString().split(' ')[0]}';
    } else if (_selectedAmbulanceReportDateType == _ambulanceReportDateTypeList[1]) {
      _from = '${yesterday.toString().split(' ')[0]}';
      _to = '${yesterday.toString().split(' ')[0]}';
    } else {}

    notifyListeners();
  }

  void setSelectedAmbulanceReferralType(newValue){
    _selectedAmbulanceReferralType = newValue;
    notifyListeners();
  }

  void setSelectedCountry(newValue){
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
    final response = await rootBundle.loadString('assets/states.json');
    List<dynamic> stateData = json.decode(response);
    _stateList = stateData;
    _foundStateList =
        stateData.map((item) => item['states'] as String).toList();
    // print(stateList);
    notifyListeners();
  }

  void getCitiesForSelection(
      String selectedItem,
      ) {
    // Clear the previous list of cities
    _foundCities.clear();

    // Search for the state in the stateList
    for (var stateData in _stateList) {
      if (stateData["states"] == selectedItem) {
        // Extract the cities list
        _foundCities = List<String>.from(stateData["cities"] ?? []);
        print("Found Cities for State: $_foundCities");
        break; // Exit the loop once the state is found
      }
    }

    // Search for the district in the districtList
    for (var districtData in _districts) {
      if (districtData["district"] == selectedItem) {
        // Extract the cities list
        _foundCities = List<String>.from(districtData["cities"] ?? []);
        break; // Exit the loop once the district is found
      }
    }
    notifyListeners();

    // Print the result for debugging
    // print("Cities for $selectedItem: $foundCities");
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

  void getAmbulanceLogList(context) async {
    _ambulanceLogsUsersList = ["Select User"];
    _selectedUser = 'Select User';
    _selectedAmbulanceReportDateType = 'Today';
    _selectedUserId = '';
    ERPResponse response = await ERPServices.getRequest('/visitLogs/users', context);
    // print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      _usersAmbulanceList = body['logs'];
      for (int i = 0; i < _usersAmbulanceList.length; i++) {
        _ambulanceLogsUsersList.add(_usersAmbulanceList[i]['username']);
      }
    }
    notifyListeners();
  }

  void getAmbulanceReport(context)async{
    if(_selectedUserId.isEmpty){
      ToastMessageUtils().showToastMessage('Please select a user');
    }
    try{
      ERPResponse response = await ERPServices.getRequest('/poc/category?createdById=$_selectedUserId&category=Ambulance', context);
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // _foundAmbulanceDetail = body['poc'][0]['pocName'];
        _foundAmbulanceList = body['poc'];

      if(_foundAmbulanceList.isEmpty){
       print( _foundAmbulanceDetail = '');
      }else{
       print( _foundAmbulanceDetail = body['poc'][0]['pocName']);
      }

      }else{
        ToastMessageUtils().showToastMessage('Failed to fetch data');
      }
    }catch(err){
      ToastMessageUtils().showToastMessage('An error occurred');
    }
   notifyListeners();
  }
}