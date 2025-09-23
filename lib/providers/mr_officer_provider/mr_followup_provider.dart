import 'dart:convert';

import 'package:deskgoo/consts.dart';
import 'package:deskgoo/routes/marketing_officer_consts.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/utils/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class MrOfficerFollowUpProvider extends ChangeNotifier {
  final _fullNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _specializationController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _numberController = TextEditingController();
  final _ambulanceNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _organizationController = TextEditingController();
  final _remarksController = TextEditingController();
  final _searchByNameController = TextEditingController();
  List<dynamic> _pocList = [];
  List<dynamic> _pocSearchResult = [];
  String _pocId = '';
  double _latitude = 0;
  double _longitude = 0;
  String _dateTime = '';
  DateTime _updatedDate = DateTime.now();

  TextEditingController get fullNameController => _fullNameController;
  TextEditingController get categoryController => _categoryController;
  TextEditingController get specializationController =>
      _specializationController;
  TextEditingController get ageController => _ageController;
  TextEditingController get genderController => _genderController;
  TextEditingController get numberController => _numberController;
  TextEditingController get ambulanceNumberController => _ambulanceNumberController;
  TextEditingController get addressController => _addressController;
  TextEditingController get organizationController => _organizationController;
  TextEditingController get remarksController => _remarksController;
  TextEditingController get searchByNameController => _searchByNameController;
  List<dynamic> get pocList => _pocList;
  List<dynamic> get pocSearchResult => _pocSearchResult;
  String get pocId => _pocId;
  DateTime get updatedDate => _updatedDate;

  void GetPOCList(context) async {
    try{
      showDialog(context: context, builder: (_) => const Center(child: CircularProgressIndicator(),));
      ERPResponse response = await ERPServices.getRequest('/poc/createdUserId/$userId', context).timeout(const Duration(seconds: 7));
      if (response.statusCode == 200) {
        _pocList = jsonDecode(response.body)['poc'];
        _pocSearchResult = _pocList;
        print(_pocList);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.of(context)
            .pushNamed(MarketingOfficerConstants.followUpVisit);
      }
    }catch (err){
      Navigator.pop(context);
      ToastMessageUtils().showToastMessage('Something went wrong!\nPlease try again later.');
      debugPrint(err.toString());
    }
    notifyListeners();
  }

  void getCurrentTimeAndLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
      ),
    );
    _latitude = position.latitude;
    _longitude = position.longitude;
    List timeList =
        DateTime.now().toString().split('.')[0].toString().split(' ');
    _dateTime = '${timeList[1]} ${timeList[0]}';
    notifyListeners();
  }

  void filterPOCList(name) {}

  void updateDate(DateTime newDate) {
    _updatedDate = newDate;
    notifyListeners();
  }

  void getPOCDetailByID(id, context) async {
    _pocId = id;
    ERPResponse response = await ERPServices.getRequest('/poc/followup',context);
    print(response.statusCode);
    Map<String, dynamic> data = jsonDecode(response.body);
    notifyListeners();
  }

  void setPOCDetails(id, name, category, specialization, gender, number, ambNumber,
      address, organization) {
    _pocId = id;
    _fullNameController.text = name;
    _categoryController.text = category;
    _specializationController.text = specialization;
    _genderController.text = gender;
    _numberController.text = number;
    _addressController.text = address;
    _ambulanceNumberController.text = ambNumber;
    _organizationController.text = organization;
    notifyListeners();
  }

  void clearValue() {
    _pocId = '';
    _fullNameController.text = '';
    _categoryController.text = '';
    _specializationController.text = '';
    _ageController.text = '';
    _genderController.text = '';
    _numberController.text = '';
    _addressController.text = '';
    _ambulanceNumberController.text = '';
    _organizationController.text = '';
    _remarksController.text = '';
    notifyListeners();
  }

  void searchPocName(String enteredKeyword, BuildContext context) async {
    try {
      ERPResponse response = await ERPServices.getRequest(
        '/poc/createdUserId/$userId?keyword=${enteredKeyword.trim()}',
        context,
      );

      if (response.statusCode == 200) {
        List<dynamic> pocList = jsonDecode(response.body)['poc'];
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

  // void searchPocName(String enteredKeyWord, context) async {
  //   try{
  //     print('************************* _pocSearchResult **********************************');
  //     print(enteredKeyWord);
  //     ERPResponse response = await ERPServices.getRequest('/poc/createdUserId/$userId?keyword=${enteredKeyWord.trim()}', context);
  //     print(response.body);
  //     if(response.statusCode == 200){
  //       List<dynamic> pocNames = jsonDecode(response.body)['poc'];
  //       _pocSearchResult = pocNames;
  //       if (enteredKeyWord.trim().isEmpty) {
  //         _pocSearchResult = pocNames;
  //       } else {
  //         _pocSearchResult = pocNames
  //             .where((poc) => poc['pocName']
  //             .toString()
  //             .toLowerCase()
  //             .contains(enteredKeyWord.toLowerCase()))
  //             .toList();
  //       }
  //       print('Search Result = $_pocSearchResult');
  //       print('***********************************************************');
  //     }else{
  //       _pocSearchResult = [];
  //     }
  //     notifyListeners();
  //   }catch (e){
  //     _pocSearchResult = [];
  //     print(e.toString());
  //   }
  // }

  // void searchPocName(String enteredKeyWord, List<dynamic> pocNames) {
  //   _pocSearchResult = pocNames;
  //   if (enteredKeyWord.isEmpty) {
  //     _pocSearchResult = pocNames;
  //   } else {
  //     _pocSearchResult = pocNames
  //         .where((poc) => poc['pocName']
  //         .toString()
  //         .toLowerCase()
  //         .contains(enteredKeyWord.toLowerCase()))
  //         .toList();
  //   }
  //   print('Search Result = $_pocSearchResult');
  //   notifyListeners();
  // }

  void postFollowUp(context) async {
    try {
      showDialog(context: context,
          builder: (_) => const Center(child: CircularProgressIndicator(),));
      DateTime now = DateTime.now();
      String mobileTime = DateFormat('HH:mm:ss yyyy-MM-dd').format(now);
      DateTime currentTime = DateTime.now();

      Map<String, dynamic> body = {
        "pocId": _pocId,
        "pocName": _fullNameController.value.text,
        "createdById": userId,
        "remarks": _remarksController.value.text,
        "mobileTime": mobileTime,
        "visitDate": currentTime.toString(),
        "latitude": _latitude,
        "longitude": _longitude,
      };

      ERPResponse response = await ERPServices.postRequest(
          '/poc/followup', body, context).timeout(const Duration(seconds: 7));
      print(response.statusCode);
      print(response.body);
      print("response : ${body}");
      if (response.statusCode == 200) {
        Navigator.pop(context);
        clearValue();
        ToastMessageUtils().showToastMessage(
            'Follow Up successful', ToastGravity.TOP, CustomColors.jadeGreen);
        Navigator.of(context)
            .popAndPushNamed(MarketingOfficerConstants.mrStaffDashboardConst);
      } else {
        Navigator.pop(context);
        ToastMessageUtils().showToastMessage('Something went wrong');
      }
    } catch (e) {
      Navigator.pop(context);
      ToastMessageUtils().showToastMessage(
          'Something went wrong!\nPlease try again later.');
      debugPrint(e.toString());
    }
    notifyListeners();
  }
}
