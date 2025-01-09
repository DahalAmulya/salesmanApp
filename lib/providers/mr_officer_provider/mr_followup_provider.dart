import 'dart:convert';

import 'package:deskgoo/consts.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MrOfficerFollowUpProvider extends ChangeNotifier {
  final _fullNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _specializationController = TextEditingController();
  final _ageController = TextEditingController();
  final _numberController = TextEditingController();
  final _addressController = TextEditingController();
  final _organizationController = TextEditingController();
  final _remarksController = TextEditingController();
  final _searchByNameController = TextEditingController();
  List<dynamic> _pocList = [];
  String _pocId = '';
  double _latitude = 0;
  double _longitude = 0;
  String _dateTime = '';

  TextEditingController get fullNameController => _fullNameController;
  TextEditingController get categoryController => _categoryController;
  TextEditingController get specializationController =>
      _specializationController;
  TextEditingController get ageController => _ageController;
  TextEditingController get numberController => _numberController;
  TextEditingController get addressController => _addressController;
  TextEditingController get organizationController => _organizationController;
  TextEditingController get remarksController => _remarksController;
  TextEditingController get searchByNameController => _searchByNameController;
  List<dynamic> get pocList => _pocList;
  String get pocId => _pocId;

  void GetPOCList() async {
    ERPResponse response = await ERPServices.getRequest('/poc');
    print(response.statusCode);
    print(response.body);
    _pocList = jsonDecode(response.body);
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

  void getPOCDetailByID(id) async {
    _pocId = id;
    ERPResponse response = await ERPServices.getRequest('/poc/$id');
    print(response.statusCode);
    Map<String, dynamic> data = jsonDecode(response.body);
    print(data);
    String name = data['fullName'];
    String category = data['category'];
    String specialization = data['specialization'];
    String age = data['age'];
    String number = data['number'];
    String address = data['fullAddress'];
    String organization = data['organization'];
    setPOCDetails(
        name, category, specialization, age, number, address, organization);
    notifyListeners();
  }

  void setPOCDetails(
      name, category, specialization, age, number, address, organization) {
    _fullNameController.text = name;
    _categoryController.text = category;
    _specializationController.text = specialization;
    _ageController.text = age;
    _numberController.text = number;
    _addressController.text = address;
    _organizationController.text = organization;
    notifyListeners();
  }

  void postFollowUp() async {
    Map<String, dynamic> body = {
      'createdById': userId,
      'createdByName': userName,
      'pocId': _pocId,
      'mobileTime': _dateTime,
      'latitude': _latitude,
      'longitude': _longitude,
      'remarks': _remarksController.value.text,
    };
    ERPResponse response = await ERPServices.postRequest('/visitlog', body);
    print(response.statusCode);
    print(response.body);
  }
}
