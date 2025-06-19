import 'dart:convert';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../themes/custom_colors.dart';
import '../../../utils/toast_message.dart';

class CreateUserProvider extends ChangeNotifier {
  final _userNameTextController = TextEditingController();
  final _userPasswordTextController = TextEditingController();
  final _userEmailTextController = TextEditingController();
  final _userAddressTextController = TextEditingController();
  final _userDobController = TextEditingController();
  final _phoneNoController = TextEditingController();
  final _userDojTextController = TextEditingController();

  Map<String, dynamic> _data = {};
  Map<String, dynamic> _userData = {};
  List<dynamic> _userList = [];
  List<dynamic> _rolesList = [];
  List<String> _selectedRole = [];
  List<String> _country = ['Nepali', 'Indian'];
  String _selectedCountry = 'Nepali';
  String _role = '';
  String _selectedGender = '';
  String _selectedDepartment = '';
  String _selectedDesignation = '';
  String _selectedMaritalStatus = '';
  String _selectedNationality = '';
  String _selectedUserVisitType = '';
  String _radioGroupValue = '';
  int _tabIndex = 0;

  List<String> _department = [
    "Marketing",
    "Administrator",
  ];
  List<String> _designation = ["Marketing Manager", "Hospital Representative"];
  List<String> _gender = ["Male", "Female", "Other"];
  List<String> _maritalStatus = ["Unmarried", "Married"];
  List<String> _nationality = ["Nepali", "Indian"];
  List<String> _userTypeList = ['Create User', 'View User'];
  List<String> _selectedUserVisitTypeList = ['none', 'More Detail'];
  List<String> _countryCode = ['+977', '+91'];
  List<String> get country => _country;
  String get selectedCountry => _selectedCountry;
  Map<String, dynamic> _selectedRoleMap = {};

  String _designationDefaultValue = "Hospital Representative";
  String _departmentDefaultValue = "Marketing";
  String _genderDefaultValue = "Male";
  String _maritalStatusDefaultValue = "Unmarried";
  String _nationalityDefaultValue = "Nepali";
  String _roleDefaultValue = "";
  String _selectedCountryCode = '+977';

  TextEditingController get userNameTextController => _userNameTextController;
  TextEditingController get userPasswordTextController =>
      _userPasswordTextController;
  TextEditingController get userEmailTextController => _userEmailTextController;
  TextEditingController get userAddressTextController =>
      _userAddressTextController;
  TextEditingController get userDobController => _userDobController;
  TextEditingController get phoneNoController => _phoneNoController;
  TextEditingController get userDojTextController => _userDojTextController;

  Map<String, dynamic> get data => _data;
  Map<String, dynamic> get userData => _userData;
  List<dynamic> get rolesList => _rolesList;
  List<String> get department => _department;
  List<String> get designation => _designation;
  List<String> get countryCode => _countryCode;
  String get selectedCountryCode => _selectedCountryCode;
  List<String> get gender => _gender;
  List<String> get maritalStatus => _maritalStatus;
  List<String> get nationality => _nationality;
  List<String> get selectedRole => _selectedRole;
  List<String> get userTypeList => _userTypeList;
  List<String> get selectedUserVisitTypeList => _selectedUserVisitTypeList;
  List<dynamic> get userList => _userList;
  String get selectedGender => _selectedGender;
  String get selectedMaritalStatus => _selectedMaritalStatus;
  String get selectedNationality => _selectedNationality;

  String get selectedUserVisitType => _selectedUserVisitType;
  String get radioGroupValue => _radioGroupValue;
  int get tabIndex => _tabIndex;

  String get designationDefaultValue => _designationDefaultValue;
  String get departmentDefaultValue => _departmentDefaultValue;
  String get genderDefaultValue => _genderDefaultValue;
  String get maritalStatusDefaultValue => _maritalStatusDefaultValue;
  String get nationalityDefaultValue => _nationalityDefaultValue;
  String get roleDefaultValue => _roleDefaultValue;
  String get role => _role;
  String get selectedDepartment => _selectedDepartment;
  String get selectedDesignation => _selectedDesignation;

  void selectUserVisitType(value) {
    _radioGroupValue = value;
    notifyListeners();
  }

  void unSelectUserVisitType() {
    _radioGroupValue = '';
    _selectedUserVisitType = '';
    notifyListeners();
  }

  bool setSelectedUserVisitType() {
    _selectedUserVisitType = _radioGroupValue;
    if (_selectedUserVisitType.isEmpty) {
      ToastMessageUtils().showToastMessage('Please select User visit type');
      notifyListeners();
      return false;
    } else {
      _selectedUserVisitTypeList[0] = _selectedUserVisitType;
      notifyListeners();
      return true;
    }
  }

  void setRole(newValue) {
    _role = newValue;
    for (int i = 0; i < _rolesList.length; i++) {
      if (_rolesList[i]['role'] == _role) {
        _selectedRoleMap = _rolesList[i];
        print(_selectedRoleMap);
      }
    }
    notifyListeners();
  }

  void setDesignation(newValue) {
    _selectedDesignation = newValue;
    notifyListeners();
  }

  void setDepartment(newValue) {
    _selectedDepartment = newValue;
    notifyListeners();
  }

  void setGender(newValue) {
    _selectedGender = newValue;
    notifyListeners();
  }

  void setMaritalStatus(newValue) {
    _selectedMaritalStatus = newValue;
    notifyListeners();
  }

  void setNationality(value) {
    _selectedNationality = value;
    notifyListeners();
  }

  void resetForm() {
    resetRoles();
    _userNameTextController.text = '';
    _userEmailTextController.text = '';
    _userPasswordTextController.text = '';
    _selectedRoleMap = {};
    _phoneNoController.text = '';
    _userAddressTextController.text = '';
    _userDobController.text = '';
    _userDojTextController.text = '';
    notifyListeners();
  }

  void resetRoles() {
    _selectedRole = [];
    _roleDefaultValue = '';
    _rolesList = [];
    _role = '';
    notifyListeners();
  }

  void getRoleList(context) async {
    ERPResponse response = await ERPServices.getRequest('/users/roles', context);
    _data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _rolesList = _data['roles'];
      print(_rolesList);
      for (var role in _rolesList) {
        _selectedRole.add(role['role'].toString());
      }
      _roleDefaultValue = _selectedRole[_selectedRole.length - 1];
    }
    notifyListeners();
  }

  void setCountryCode(value) {
    _selectedCountryCode = value;
    notifyListeners();
  }

  void PostUserDetails(context) async {
    Map<String, dynamic> body = {
      "username": _userNameTextController.value.text,
      "email": _userEmailTextController.value.text,
      "password": _userPasswordTextController.value.text,
      "role": _selectedRoleMap,
      "department": _selectedDepartment,
      "designation": _selectedDesignation,
      "number": '$_selectedCountryCode${_phoneNoController.value.text}',
      "address": _userAddressTextController.value.text,
      "nationality": _selectedNationality,
      "dob": _userDobController.value.text,
      "doj": _userDojTextController.value.text,
      "maritalStatus": _selectedMaritalStatus,
      "gender": _selectedGender,
    };
    print(body);
    ERPResponse response = await ERPServices.postRequest('/users', body, context);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      ToastMessageUtils().showToastMessage('User created successfully',
          ToastGravity.TOP, CustomColors.jadeGreen);
      Navigator.of(context)
          .pushReplacementNamed(MarketingManagerConstants.homePage);
      resetForm();
      print('success');
    } else {
      ToastMessageUtils().showToastMessage(
          'Something went wrong', ToastGravity.TOP, CustomColors.lightRed);
    }
  }

  void getUserDetails(context) async {
    ERPResponse response = await ERPServices.getRequest('/users', context);
    _userData = jsonDecode(response.body);
    print(response.statusCode);
    // print(response.body);
    print(_userList.length);
    if (response.statusCode == 200) {
      _userList = _userData['users'];
      // _userName = _userData['users'][0]['username'];
      // print(_userName);
    }else{
      _userList = [];
    }
    notifyListeners();
  }

  void setUserDetails(name, role, department, email, designation, address, dob,
      number, gender, maritalStatus, doj, nationality) {
    _userNameTextController.text = name;
    _role = role;
    _selectedDepartment = department;
    _userEmailTextController.text = email;
    _selectedDesignation = designation;
    _userAddressTextController.text = address;
    _userDobController.text = dob;
    _phoneNoController.text = number;
    _selectedGender = gender;
    _selectedMaritalStatus = maritalStatus;
    _userDojTextController.text = doj;
    _selectedNationality = nationality;
    notifyListeners();
  }
}
