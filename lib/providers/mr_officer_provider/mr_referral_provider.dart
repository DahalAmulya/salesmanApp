import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  final _districtTextEditingController = TextEditingController();
  final _searchForStatesTextEditingController = TextEditingController();

  final _patientNameTextController = TextEditingController();
  final _patientAgeTextController = TextEditingController();
  final _patientGenderTextController = TextEditingController();
  final _patientProvisionalDiagnosisTextController = TextEditingController();
  final _patientCountryTextController = TextEditingController();
  final _patientDistrictTextController = TextEditingController();
  final _patientStateTextController = TextEditingController();
  final _patientCityTextController = TextEditingController();
  final _patientAddressTextController = TextEditingController();

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

  List<dynamic> _pocList = [];
  List<String> _citiesList = [];
  List<String> _gender = ["Male", "Female"];

  String _selectedGender = '';
  String _defaultGenderValue = 'Male';

  String _pocId = '';
  String _ambId = '';

  TextEditingController get patientDistrictTextEditingController =>
      _districtTextEditingController;

  TextEditingController get searchForStatesTextEditingController =>
      _searchForStatesTextEditingController;

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
  List<String> get citiesList => _citiesList;

  List<String> get gender => _gender;
  String get selectedGender => _selectedGender;

  String get pocId => _pocId;
  String get ambId => _ambId;
  String get defaultGenderValue => _defaultGenderValue;

  void selectVisitType(value) {
    _radioGroupValue = value;
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

  void setPOCDetails(id, name, category, specialization, age, number, address) {
    _pocId = id;
    _referralNameTextController.text = name;
    _referredCategoryTextController.text = category;
    _referredSpecializationTextController.text = specialization;
    _referralAgeTextController.text = age;
    _referredNumberTextController.text = number;
    _referredAddressTextController.text = address;
    notifyListeners();
  }

  void GetPOCList(context) async {
    ERPResponse response = await ERPServices.getRequest(
        '/poc/category?createdById=$userId&category=');
    if (response.statusCode == 200) {
      _pocList = jsonDecode(response.body)['poc'];
      // print(_pocList);
      // Navigator.of(context).pushNamed(MarketingOfficerConstants.followUpVisit);
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
    }
    notifyListeners();
  }

  void setAmbulancePOCDetails(id, name, ambNumber, number) {
    _ambId = id;
    _ambDriverNameTextController.text = name;
    _ambNumberTextController.text = ambNumber;
    _ambPhoneNumberTextController.text = number;
    notifyListeners();
  }

  void GetAmbulancePOCList(context) async {
    ERPResponse response = await ERPServices.getRequest(
        '/poc/category?createdById=$userId&category=Ambulance');
    if (response.statusCode == 200) {
      _pocList = jsonDecode(response.body)['poc'];
      print(_pocList);
      // Navigator.of(context).pushNamed(MarketingOfficerConstants.followUpVisit);
    } else {
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
    _referralNameTextController.text = '';
    _referredCategoryTextController.text = '';
    _referredSpecializationTextController.text = '';
    _referralAgeTextController.text = '';
    _referredNumberTextController.text = '';
    _referredAddressTextController.text = '';

    _ambDriverNameTextController.text = '';
    _ambPhoneNumberTextController.text = '';
    _ambNumberTextController.text = '';
    _pocId = '';
    notifyListeners();
  }

  void PostReferralPOCList(context) async {
    DateTime now = DateTime.now();
    String mobileTime = DateFormat('HH:mm:ss dd-MM-yyyy').format(now);
    String dateTime = DateFormat('yyyy-MM-d HH:mm:ss').format(now);

    Map<String, dynamic> _body = {
      "fullName": _patientNameTextController.value.text,
      "age": _patientAgeTextController.value.text,
      "gender": _selectedGender,
      "provisionalDiagnosis":
          _patientProvisionalDiagnosisTextController.value.text,
      "country": _patientCountryTextController.value.text.isEmpty
          ? "Nepal"
          : _patientCountryTextController.value.text,
      "region": _patientDistrictTextController.value.text,
      "city": _patientCityTextController.value.text,
      // "country": "Nepal",
      // "region": "Morang",
      // "city": "Biratnagar",
      "address": _patientAddressTextController.value.text,
      "createdById": userId,
      "createdByName": userName,
      "pocId": _pocId,
      "pocName": _referralNameTextController.value.text,
      "pocNumber": _referredNumberTextController.value.text,
      "ambId": _ambId,
      "ambDriverName": _ambDriverNameTextController.value.text,
      "ambDriverNumber": _ambPhoneNumberTextController.value.text,
      "ambNumber": _ambNumberTextController.value.text,
      "latitude": 26.4577518899581,
      "longitude": 87.27941914017262,
      "mobileTime": mobileTime,
      "dateTime": dateTime
    };

    print(_body);
    ERPResponse response =
        await ERPServices.postRequest('/referral?createdById=$userId', _body);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      ToastMessageUtils().showToastMessage('Referral created successfully',
          ToastGravity.TOP, CustomColors.jadeGreen);
      print('success');
    } else {
      ToastMessageUtils().showToastMessage(
          'Something went wrong', ToastGravity.TOP, CustomColors.lightRed);
      print('something is missing');
    }
  }
}
