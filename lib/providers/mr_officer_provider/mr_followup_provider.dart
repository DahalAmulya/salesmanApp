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
  TextEditingController get addressController => _addressController;
  TextEditingController get organizationController => _organizationController;
  TextEditingController get remarksController => _remarksController;
  TextEditingController get searchByNameController => _searchByNameController;
  List<dynamic> get pocList => _pocList;
  List<dynamic> get pocSearchResult => _pocSearchResult;
  String get pocId => _pocId;
  DateTime get updatedDate => _updatedDate;

  void GetPOCList(context) async {
    ERPResponse response =
        await ERPServices.getRequest('/poc/createdBy?createdById=$userId', context);
    if (response.statusCode == 200) {
      _pocList = jsonDecode(response.body)['poc'];
      _pocSearchResult = _pocList;
      print(_pocList);
      if (context.mounted) {
        Navigator.of(context)
            .pushNamed(MarketingOfficerConstants.followUpVisit);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
      }
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
    print("response : ${data}");
    // print(data['pocName']);
    // print(data['_id']);
    // _fullNameController.text = data['pocName'];
    // _categoryController.text = data['category'];
    // _specializationController.text = data['specialization'];
    // _ageController.text = data['age'];
    // _numberController.text = data['number'];
    // _addressController.text = data['address'];
    // _organizationController.text = data['organization'];

    // print(_fullNameController.text);
    // print(_categoryController.text);
    // print(_specializationController.text);

    // String name = data['pocName'];
    // String category = data['category'];
    // String specialization = data['specialization'];
    // String age = data['age'];
    // String number = data['number'];
    // String address = data['address'];
    // String organization = data['organization'];
    // setPOCDetails(
    //     name, category, specialization, age, number, address, organization);
    notifyListeners();
  }

  void setPOCDetails(id, name, category, specialization, age, gender, number,
      address, organization) {
    _pocId = id;
    _fullNameController.text = name;
    _categoryController.text = category;
    _specializationController.text = specialization;
    _ageController.text = age;
    _genderController.text = gender;
    _numberController.text = number;
    _addressController.text = address;
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
    _organizationController.text = '';
    _remarksController.text = '';
    notifyListeners();
  }

  void searchPocName(String enteredKeyWord, List<dynamic> pocNames) {
    _pocSearchResult = pocNames;
    if (enteredKeyWord.isEmpty) {
      _pocSearchResult = pocNames;
    } else {
      _pocSearchResult = pocNames
          .where((poc) => poc['pocName']
              .toString()
              .toLowerCase()
              .contains(enteredKeyWord.toLowerCase()))
          .toList();
    }
    print('Search Result = $_pocSearchResult');
    notifyListeners();
  }

  void postFollowUp(context) async {
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

    ERPResponse response = await ERPServices.postRequest('/poc/followup', body, context);
    print(response.statusCode);
    print(response.body);
    print("response : ${body}");
    if (response.statusCode == 200) {
      clearValue();
      ToastMessageUtils().showToastMessage(
          'Follow Up successful', ToastGravity.TOP, CustomColors.jadeGreen);
      Navigator.of(context)
          .popAndPushNamed(MarketingOfficerConstants.mrStaffDashboardConst);
    } else {
      ToastMessageUtils().showToastMessage('Something went wrong');
    }
  }
}
