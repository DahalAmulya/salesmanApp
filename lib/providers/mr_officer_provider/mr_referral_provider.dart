import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../consts.dart';
import '../../routes/marketing_officer_consts.dart';
import '../../services/erp_services.dart';

class ReferralsDetailProvider extends ChangeNotifier {
 final _districtTextEditingController = TextEditingController();
 final _stateTextEditingController = TextEditingController();
 final _searchForStatesTextEditingController = TextEditingController();

 final _patientNameTextController = TextEditingController();
 final _patientAgeTextController = TextEditingController();
 final _patientGenderTextController = TextEditingController();
 final _patientProvisionalDiagnosisTextController = TextEditingController();
 final _patientCountryTextController = TextEditingController();
 final _patientDistrictTextController = TextEditingController();
 final _patientCityTextController = TextEditingController();
 final _patientAddressTextController = TextEditingController();

 final _driverNameTextController = TextEditingController();
 final _ambulanceTextController = TextEditingController();
 final _phoneNumberTextController = TextEditingController();
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

 final _driverNameText = TextEditingController();
 final _ambulanceNumText = TextEditingController();
 final _phoneNumberText = TextEditingController();

 List<dynamic> _pocList = [];
 String _pocId = '';
 String _ambId = '';

 TextEditingController get districtTextEditingController => _districtTextEditingController;
 TextEditingController get stateTextEditingController => _stateTextEditingController;
 TextEditingController get searchForStatesTextEditingController => _searchForStatesTextEditingController;

 TextEditingController get patientNameTextController => _patientNameTextController;
 TextEditingController get patientAgeTextController => _patientAgeTextController;
 TextEditingController get patientGenderTextController => _patientGenderTextController;
 TextEditingController get patientProvisionalDiagnosisTextController => _patientProvisionalDiagnosisTextController;
 TextEditingController get patientCountryTextController => _patientCountryTextController;
 TextEditingController get patientDistrictTextController => _patientDistrictTextController;
 TextEditingController get patientCityTextController => _patientCityTextController;
 TextEditingController get patientAddressTextController => _patientAddressTextController;

 TextEditingController get driverNameTextController => _driverNameTextController;
 TextEditingController get ambulanceTextController => _ambulanceTextController;
 TextEditingController get phoneNumberTextController => _phoneNumberTextController;

 TextEditingController get textController => _textController;
 TextEditingController get referralNameTextController => _referralNameTextController;
 TextEditingController get referralAgeTextController => _referralAgeTextController;
 TextEditingController get referredNumberTextController => _referredNumberTextController;
 TextEditingController get referredCityTextController => _referredCityTextController;
 TextEditingController get referredAddressTextController => _referredAddressTextController;
 TextEditingController get referredCategoryTextController => _referredCategoryTextController;
 TextEditingController get referredSpecializationTextController => _referredSpecializationTextController;
 TextEditingController get referralRemarkTextController => _referralRemarkTextController;
 TextEditingController get searchByNameController => _searchByNameController;

 TextEditingController get driverNameText => _driverNameText;
 TextEditingController get ambulanceNumText => _ambulanceNumText;
 TextEditingController get phoneNumberText => _phoneNumberText;

 List<dynamic> get pocList => _pocList;
String get pocId => _pocId;
 String get ambId => _ambId;

 void setPOCDetails(id,name, category, specialization, age, number, address){
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
  ERPResponse response =
  await ERPServices.getRequest('/poc/category?createdById=$userId&category=');
  if (response.statusCode == 200) {
   _pocList = jsonDecode(response.body)['poc'];
   // print(_pocList);
   // Navigator.of(context).pushNamed(MarketingOfficerConstants.followUpVisit);
  } else {
   print('Error: ${response.statusCode} - ${response.body}');
  }
  notifyListeners();
 }

 void setAmbulancePOCDetails(id,name, ambNumber, number ){
  _ambId = id;
  _driverNameTextController.text = name;
  _ambulanceTextController.text = ambNumber;
  _phoneNumberTextController.text = number;
  notifyListeners();

 }

 void GetAmbulancePOCList(context) async {
  ERPResponse response =
  await ERPServices.getRequest('/poc/category?createdById=$userId&category=Ambulance');
  if (response.statusCode == 200) {
   _pocList = jsonDecode(response.body)['poc'];
   print(_pocList);
   // Navigator.of(context).pushNamed(MarketingOfficerConstants.followUpVisit);
  } else {
   print('Error: ${response.statusCode} - ${response.body}');
  }
  notifyListeners();
 }

 void PostReferralPOCList(context) async{
  DateTime now = DateTime.now();
  String mobileTime = DateFormat('HH:mm:ss dd-MM-yyyy').format(now);
  String dateTime = DateFormat('yyyy-MM-d HH:mm:ss').format(now);

  Map<String,dynamic> _body = {
   "fullName": _patientNameTextController.value.text,
   "age": _patientAgeTextController.value.text,
   "gender": _patientGenderTextController.value.text,
   "country": _patientCountryTextController.value.text,
   "region": _patientDistrictTextController.value.text,
   "city": _patientCityTextController.value.text,
   "address": _patientAddressTextController.value.text,
   "createdById": userId,
   "createdByName": userName,
   "pocId": _pocId,
   "pocName": _referralNameTextController.value.text,
   "pocNumber": _referredNumberTextController.value.text,
   "ambId": _ambId,
   "ambDriverName": _driverNameText.value.text,
   "ambDriverNumber": _phoneNumberText.value.text,
   "ambNumber": _ambulanceNumText.value.text,
   "latitude": 26.4577518899581,
   "longitude": 87.27941914017262,
   "mobileTime": mobileTime,
   "dateTime": dateTime
  };

  print(_body);
    // ERPResponse response = await ERPServices.postRequest('/referral?createdById=$userId', _body);
    // print(response.statusCode);
    // print(response.body);
    // if(response.statusCode == 200){
    //
    // }
 }
}