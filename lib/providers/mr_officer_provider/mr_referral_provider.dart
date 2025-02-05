import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../consts.dart';
import '../../routes/marketing_officer_consts.dart';
import '../../services/erp_services.dart';

class ReferralsDetailProvider extends ChangeNotifier {
   final _districtTextEditingController = TextEditingController();
   final _stateTextEditingController = TextEditingController();
   final _searchForStatesTextEditingController = TextEditingController();

  final _nameTextController = TextEditingController();
  final _ageTextController = TextEditingController();
  final _genderTextController = TextEditingController();
  final _provisionalDiagnosisTextController = TextEditingController();
 final _countryTextController = TextEditingController();
  final _districtTextController = TextEditingController();
  final _cityTextController = TextEditingController();
  final _addressTextController = TextEditingController();
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
   final _ambulanceText = TextEditingController();
   final _phoneNumberText = TextEditingController();
   List<dynamic> _pocList = [];

  TextEditingController get districtTextEditingController => _districtTextEditingController;
  TextEditingController get stateTextEditingController => _stateTextEditingController;
  TextEditingController get searchForStatesTextEditingController => _searchForStatesTextEditingController;

  TextEditingController get nameTextController => _nameTextController;
  TextEditingController get ageTextController => _ageTextController;
  TextEditingController get genderTextController => _genderTextController;
  TextEditingController get provisionalDiagnosisTextController => _provisionalDiagnosisTextController;
  TextEditingController get countryTextController => _countryTextController;
  TextEditingController get districtTextController => _districtTextController;
  TextEditingController get cityTextController => _cityTextController;
  TextEditingController get addressTextController => _addressTextController;
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
   TextEditingController get ambulanceText => _ambulanceText;
   TextEditingController get phoneNumberText => _phoneNumberText;
  List<dynamic> get pocList => _pocList;


  void setPOCDetails(name, category, specialization, age, number, address){
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
     print(_pocList);
     // Navigator.of(context).pushNamed(MarketingOfficerConstants.followUpVisit);
    } else {
     print('Error: ${response.statusCode} - ${response.body}');
    }
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
}