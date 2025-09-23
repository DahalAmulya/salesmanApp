import 'dart:convert';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../../consts.dart';
import '../../routes/marketing_officer_consts.dart';
import '../../services/erp_services.dart';
import '../../themes/custom_colors.dart';
import '../../utils/toast_message.dart';

class ReferralsDetailProvider extends ChangeNotifier {
  // final _createVisitFormKey = GlobalKey<FormState>();
  List<String> _referralTypeList = ['Create Referral', 'Referral Log'];
  String _selectedReferralType = '';
  String _radioGroupValue = '';
  String _selectedDate = '';
  double _referralLatitude = 0;
  double _referralLongitude = 0;
  List<dynamic> _referralLogs = [];
  List<dynamic> _pocSearchResult = [];
  List<dynamic> _ambSearchResult = [];
  List<dynamic> _foundDistrictList = [];

  List<dynamic> _stateList = [];
  List<dynamic> _foundStateList = [];

  List<dynamic> _foundCities = [];
  Map<String, dynamic> _body = {};

  final _districtTextEditingController = TextEditingController();

  final _searchForStatesTextEditingController = TextEditingController();
  final _searchForCityTextEditingController = TextEditingController();
  final _searchForDistrictTextEditingController = TextEditingController();

  final _searchController = TextEditingController();

  final _patientNameTextController = TextEditingController();
  final _patientAgeTextController = TextEditingController();
  final _patientGenderTextController = TextEditingController();
  final _patientProvisionalDiagnosisTextController = TextEditingController();
  final _patientCountryTextController = TextEditingController();
  final _patientDistrictTextController = TextEditingController();
  final _patientStateTextController = TextEditingController();
  final _patientCityTextController = TextEditingController();
  final _patientAddressTextController = TextEditingController();
  final _remarksTextController = TextEditingController();

  final _textController = TextEditingController();
  final _referralNameTextController = TextEditingController();
  final _referralAgeTextController = TextEditingController();
  final _referredNumberTextController = TextEditingController();
  final _referredCityTextController = TextEditingController();
  final _referredAddressTextController = TextEditingController();
  final _referredCategoryTextController = TextEditingController();
  final _referredSpecializationTextController = TextEditingController();
  final _referralRemarkTextController = TextEditingController();
  final _searchByNameController = TextEditingController();

  final _ambDriverNameTextController = TextEditingController();
  final _ambNumberTextController = TextEditingController();
  final _ambPhoneNumberTextController = TextEditingController();

  List<String> get referralTypeList => _referralTypeList;
  String get selectedReferralType => _selectedReferralType;
  String get radioGroupValue => _radioGroupValue;
  String get selectedDate => _selectedDate;
  double get referralLatitude => _referralLatitude;
  double get referralLongitude => _referralLongitude;
  List<dynamic> _pocList = [];
  List<String> _citiesList = [];
  List<String> _gender = ["Male", "Female", "Others"];

  String _selectedGender = 'Male';
  String _pocId = '';
  String _ambId = '';

  TextEditingController get patientDistrictTextEditingController =>
      _districtTextEditingController;

  TextEditingController get searchForStatesTextEditingController =>
      _searchForStatesTextEditingController;

  TextEditingController get searchForCityTextEditingController =>
      _searchForCityTextEditingController;
  TextEditingController get searchForDistrictTextEditingController =>
      _searchForDistrictTextEditingController;
  TextEditingController get searchController => _searchController;

  TextEditingController get patientNameTextController =>
      _patientNameTextController;
  TextEditingController get patientAgeTextController =>
      _patientAgeTextController;
  TextEditingController get patientGenderTextController =>
      _patientGenderTextController;
  TextEditingController get patientProvisionalDiagnosisTextController =>
      _patientProvisionalDiagnosisTextController;
  TextEditingController get patientCountryTextController =>
      _patientCountryTextController;
  TextEditingController get patientDistrictTextController =>
      _patientDistrictTextController;
  TextEditingController get patientStateTextController =>
      _patientStateTextController;
  TextEditingController get patientCityTextController =>
      _patientCityTextController;
  TextEditingController get patientAddressTextController =>
      _patientAddressTextController;
  TextEditingController get remarksTextController =>
      _remarksTextController;

  TextEditingController get textController => _textController;
  TextEditingController get referralNameTextController =>
      _referralNameTextController;
  TextEditingController get referralAgeTextController =>
      _referralAgeTextController;
  TextEditingController get referredNumberTextController =>
      _referredNumberTextController;
  TextEditingController get referredCityTextController =>
      _referredCityTextController;
  TextEditingController get referredAddressTextController =>
      _referredAddressTextController;
  TextEditingController get referredCategoryTextController =>
      _referredCategoryTextController;
  TextEditingController get referredSpecializationTextController =>
      _referredSpecializationTextController;
  TextEditingController get referralRemarkTextController =>
      _referralRemarkTextController;
  TextEditingController get searchByNameController => _searchByNameController;

  TextEditingController get ambDriverNameTextController =>
      _ambDriverNameTextController;
  TextEditingController get ambNumberTextController => _ambNumberTextController;
  TextEditingController get ambPhoneNumberTextController =>
      _ambPhoneNumberTextController;

  List<dynamic> get pocList => _pocList;
  List<dynamic> get referralLogs => _referralLogs;
  List<dynamic> get pocSearchResult => _pocSearchResult;
  List<dynamic> get ambSearchResult => _ambSearchResult;

  List<dynamic> get foundDistrictList => _foundDistrictList;

  List<dynamic> get stateList => _stateList;
  List<dynamic> get foundStateList => _foundStateList;

  List<dynamic> get foundCities => _foundCities;

  Map<String, dynamic> get body => _body;
  List<String> get citiesList => _citiesList;

  List<String> get gender => _gender;
  String get selectedGender => _selectedGender;

  String get pocId => _pocId;
  String get ambId => _ambId;

  List<dynamic> _ambDriverList = [];
  List<dynamic> get ambDriverList => _ambDriverList;
  final _ambDriverSearchController = TextEditingController();
  TextEditingController get ambDriverSearchController =>
      _ambDriverSearchController;

  List<String> _country = ['Nepal', 'India'];
  String _selectedCountry = 'Nepal';
  List<String> get country => _country;
  String get selectedCountry => _selectedCountry;

  final _districtController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  TextEditingController get districtController => _districtController;
  TextEditingController get stateController => _stateController;
  TextEditingController get cityController => _cityController;

  List<dynamic> _districts = [];
  String _selectedDistrict = '';
  List<dynamic> _states = [];
  String _selectedState = '';
  List<dynamic> _cities = [];
  String _selectedCity = '';
  List<dynamic> get districts => _districts;
  String get selectedDistrict => _selectedDistrict;
  List<dynamic> get states => _states;
  String get selectedState => _selectedState;
  List<dynamic> get cities => _cities;
  String get selectedCity => _selectedCity;
  List<dynamic> _searchResult = [];
  List<dynamic> get searchResult => _searchResult;

  void setCountry(value) {
    _selectedCountry = value;
    notifyListeners();
  }

  void getCities(List<dynamic> citiesList) {
    _cities = citiesList;
    notifyListeners();
  }

  void setSelectedDistrict(value) {
    _selectedDistrict = value;
    _districtController.text = _selectedDistrict;
    notifyListeners();
  }

  void setSelectedState(value) {
    _selectedState = value;
    _stateController.text = _selectedState;
    notifyListeners();
  }

  void setSelectedCity(value) {
    _selectedCity = value;
    _cityController.text = _selectedCity;
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

  void selectVisitType(value) {
    _radioGroupValue = value;
    notifyListeners();
  }

  void setSelectedDate(String date) {
    _selectedDate = date;
    notifyListeners();
  }

  void unSelectVisitType() {
    _radioGroupValue = '';
    _selectedReferralType = '';
    notifyListeners();
  }

  bool setSelectedVisitType() {
    _selectedReferralType = _radioGroupValue;
    if (_selectedReferralType.isEmpty) {
      ToastMessageUtils().showToastMessage('Please select visit type');
      notifyListeners();
      return false;
    } else {
      // _selectedVisitTypeList[0] = _selectedVisitType;
      notifyListeners();
      return true;
    }
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
    final respose = await rootBundle.loadString('assets/states.json');
    List<dynamic> stateData = json.decode(respose);
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

  void updateCountry(String country) {
    _patientCountryTextController.text = country;
    notifyListeners();
  }

  void updateDistrict(String district) {
    _patientDistrictTextController.text = district;
    notifyListeners();
  }

  void updateState(String state) {
    _patientStateTextController.text = state;
    notifyListeners();
  }

  void updateCitiesList(List<String> newCities) {
    _citiesList = newCities;
    notifyListeners(); // Ensures UI rebuilds when citiesList changes
  }

  void updateCity(String city) {
    _patientCityTextController.text = city;
    notifyListeners();
  }

  void setGender(gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  void setPOCDetails(id, name, category, specialization, number, address, context) {
    _pocId = id;
    _referralNameTextController.text = name;
    _referredCategoryTextController.text = category;
    _referredSpecializationTextController.text = specialization;
    // _referralAgeTextController.text = age;
    _referredNumberTextController.text = number;
    _referredAddressTextController.text = address;
    Navigator.pop(context);
    notifyListeners();
  }

  void getPOCList(context) async {
    showDialog(context: context, builder: (context) => Center(child: CircularProgressIndicator(color: CustomColors.primaryColor,),));
    ERPResponse response = await ERPServices.getRequest(
        '/poc/createdUserId/$userId?category=POC&keyword=', context);
    if (response.statusCode == 200) {
      _pocList = jsonDecode(response.body)['poc'];
      _pocSearchResult = _pocList;
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      ToastMessageUtils().showToastMessage(
          'Failed to load POC list', ToastGravity.TOP, CustomColors.lightRed);
      print('Error: ${response.statusCode} - ${response.body}');
    }
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
      ),
    );
    _referralLatitude = position.latitude;
    _referralLongitude = position.longitude;
    notifyListeners();
  }

  void setAmbulancePOCDetails(id, name,ambNumber, number) {
    _ambId = id;
    _ambDriverNameTextController.text = name;
    _ambNumberTextController.text = ambNumber;
    _ambPhoneNumberTextController.text = number;
    print(_ambId);
    print(_ambDriverNameTextController.value.text);
    print(_ambNumberTextController.value.text);
    print(_ambPhoneNumberTextController.value.text);
    notifyListeners();
  }

  void getAmbulancePOCList(context) async {
    showDialog(context: context, builder: (context) => Center(child: CircularProgressIndicator(color: CustomColors.primaryColor,),));
    ERPResponse response = await ERPServices.getRequest(
        '/poc/createdUserId/$userId?category=Ambulance&keyword=',context);
    if (response.statusCode == 200) {
      Navigator.pop(context);
      _ambDriverList = jsonDecode(response.body)['poc'];
      _ambSearchResult = _ambDriverList;
      print('ambDriverList = $_ambDriverList');
      // Navigator.of(context).pushNamed(MarketingOfficerConstants.followUpVisit);
    } else {
      Navigator.pop(context);
      ToastMessageUtils().showToastMessage(
          'Failed to load Ambulance POC list', ToastGravity.TOP, CustomColors.lightRed);
      print('Error: ${response.statusCode} - ${response.body}');
    }
    notifyListeners();
  }

  void clearValues() {
    _patientNameTextController.text = '';
    _patientAgeTextController.text = '';
    _patientGenderTextController.text = '';
    _patientProvisionalDiagnosisTextController.text = '';
    _patientDistrictTextController.text = '';
    _patientCityTextController.text = '';
    _patientAddressTextController.text = '';
    _remarksTextController.text = '';
    _referralNameTextController.text = '';
    _referredCategoryTextController.text = '';
    _referredSpecializationTextController.text = '';
    _referralAgeTextController.text = '';
    _referredNumberTextController.text = '';
    _referredAddressTextController.text = '';

    _ambDriverSearchController.text = '';
    _ambDriverNameTextController.text = '';
    _ambPhoneNumberTextController.text = '';
    _ambNumberTextController.text = '';
    _pocId = '';
    notifyListeners();
  }

  void postReferralPOCList(context) async {
    showDialog(context: context, builder: (context) => Center(child: CircularProgressIndicator(color: CustomColors.primaryColor,),));
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
      ),
    );
    _referralLatitude = position.latitude;
    _referralLongitude = position.longitude;

    DateTime now = DateTime.now();
    String mobileTime = DateFormat('MMMM-dd, yyyy').format(now);
    String dateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String region = '';

    if (_selectedCountry == _country[0]) {
      region = _districtController.value.text;
    } else {
      region = _stateController.value.text;
    }
    print(region);
    print(_selectedCountry);

    Map<String, dynamic> _body = {
      "fullName": _patientNameTextController.value.text,
      "age": _patientAgeTextController.value.text,
      "gender": _selectedGender,
      "provisionalDiagnosis":
          _patientProvisionalDiagnosisTextController.value.text,
      "country": _patientCountryTextController.value.text.isEmpty
          ? "Nepal"
          : _patientCountryTextController.value.text,
      "region": region,
      "city": _cityController.value.text,
      "address": _patientAddressTextController.value.text,
      "remarks": _remarksTextController.value.text,
      "userId": userId,
      "pocId": _pocId.isEmpty ? null : _pocId,
      "ambId": _ambId.isEmpty ? null : _ambId,
      "latitude": _referralLatitude,
      "longitude": _referralLongitude,
      "mobileTime": mobileTime,
      "dateTime": dateTime,
    };

    print(_body);
    ERPResponse response =
        await ERPServices.postRequest('/patient-referral', _body, context);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 201) {
      ToastMessageUtils().showToastMessage('Referral created successfully',
          ToastGravity.TOP, CustomColors.jadeGreen);
      Navigator.pop(context);
      Navigator.of(context)
          .popAndPushNamed(MarketingOfficerConstants.mrStaffDashboardConst);
      print('success');
    } else {
      Navigator.pop(context);
      ToastMessageUtils().showToastMessage(
          'Something went wrong', ToastGravity.TOP, CustomColors.lightRed);
      print('something is missing');
    }
  }

  void getReferralLogs(context) async {
    DateTime now = DateTime.now();
    String date = now.toString().split(' ')[0];
    _selectedDate = selectedDate.isEmpty ? date : _selectedDate;
    print('selectedDate = ${_selectedDate}');
    ERPResponse response = await ERPServices.getRequest(
        '/referral?_id=$userId&from=$_selectedDate&to=$_selectedDate', context);
    // print(response.statusCode);
    // print(response.body);
    _body = jsonDecode(response.body);
    _referralLogs = body['referralLogs'];
    // print(_referralLogs);
    notifyListeners();
  }

  void getReferralLogsByDate(context) async {
    ERPResponse response = await ERPServices.getRequest(
        '/patient-referral/by-user/$userId?from=$_selectedDate&to=2$_selectedDate', context);
    final decodedBody = jsonDecode(response.body);
    // print(decodedBody['data'].runtimeType);
    if(decodedBody['data'].isNotEmpty){
      _referralLogs = decodedBody['data'];
      print(_referralLogs[0]['_id']);
    }else{
      _referralLogs.clear();
    }
    // print(response.body);
    notifyListeners();
  }

  // void searchAmbPocName(String enteredKeyWord, List<dynamic> pocNames) {
  //   _ambSearchResult = pocNames;
  //   if (enteredKeyWord.isEmpty) {
  //     _ambSearchResult = pocNames;
  //   } else {
  //     _ambSearchResult = pocNames
  //         .where((poc) => poc['pocName']
  //             .toString()
  //             .toLowerCase()
  //             .contains(enteredKeyWord.toLowerCase()))
  //         .toList();
  //   }
  //   print('Search Result = $_ambSearchResult');
  //   notifyListeners();
  // }

  // void searchPocName(String enteredKeyWord, List<dynamic> pocNames) {
  //   _pocSearchResult = pocNames;
  //   if (enteredKeyWord.isEmpty) {
  //     _pocSearchResult = pocNames;
  //   } else {
  //     _pocSearchResult = pocNames
  //         .where((poc) => poc['pocName']
  //             .toString()
  //             .toLowerCase()
  //             .contains(enteredKeyWord.toLowerCase()))
  //         .toList();
  //   }
  //   print('Search Result = $_pocSearchResult');
  //   notifyListeners();
  // }

  void searchAmbPocName(String enteredKeyword, BuildContext context) async {
    try {
      ERPResponse response = await ERPServices.getRequest(
        '/poc/createdUserId/$userId?category=Ambulance&keyword=${enteredKeyword.trim()}',
        context,
      );

      if (response.statusCode == 200) {
        List<dynamic> pocList = jsonDecode(response.body)['poc'];
        debugPrint('pocList = ${pocList}');
        _ambSearchResult = pocList;
      } else {
        _ambSearchResult = [];
      }

      notifyListeners();
    } catch (e) {
      print('Error while searching: $e');
      _ambSearchResult = [];
      notifyListeners();
    }
  }

  void searchPocName(String enteredKeyword, BuildContext context) async {
    try {
      ERPResponse response = await ERPServices.getRequest(
        '/poc/createdUserId/$userId?category=POC&keyword=${enteredKeyword.trim()}',
        context,
      );

      if (response.statusCode == 200) {
        List<dynamic> pocList = jsonDecode(response.body)['poc'];
        debugPrint('pocList = ${pocList}');
        _pocSearchResult = pocList;
      } else {
        _pocSearchResult = [];
      }

      notifyListeners();
    } catch (e) {
      print('Error while searching: $e');
      _pocSearchResult = [];
      notifyListeners();
    }
  }
}
