import 'dart:convert';
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
  final _userNumberTextController = TextEditingController();
  final _userDojTextController = TextEditingController();

  Map<String, dynamic> _data = {};
  Map<String, dynamic> _userData = {};
  List<dynamic> _userList = [];
  List<dynamic> _rolesList = [];
  List<String> _selectedRole = [];
  String _role = '';
  String _selectedGender = '';
  String _selectedDepartment = '';
  String _selectedDesignation = '';
  String _selectedMaritalStatus = '';
  String _selectedNationality = '';
  String _selectedUserVisitType = '';
  String _radioGroupValue = '';
  int _tabIndex = 0;

  // String _userName = '';
  // String _userPassword = '';
  // String _userRole = '';
  // String _userDepartment = '';
  // String _userEmail = '';
  // String _userDesignation = '';
  // String _userAddress = '';
  // String _userDOB = '';
  // String _userNumber = '';
  // String _userGender = '';
  // String _userMaritalStatus = '';
  // String _userDOJ = '';
  // String _userNationality = '';

  List<String> _department = [
    "Marketing",
    "Administrator",
  ];
  List<String> _designation = ["Mr Manager", "Mr Staff"];
  List<String> _gender = ["Male", "Female", "Other"];
  List<String> _maritalStatus = ["Unmarried", "Married", "Divorced"];
  List<String> _nationality = ["Nepali", "Indian"];
  List<String> _userTypeList = ['Create User', 'View User'];
  List<String> _selectedUserVisitTypeList = ['none', 'More Detail'];

  String _designationDefaultValue = "Mr Manager";
  String _departmentDefaultValue = "Marketing";
  String _genderDefaultValue = "Male";
  String _maritalStatusDefaultValue = "Unmarried";
  String _nationalityDefaultValue = "Nepali";
  String _roleDefaultValue = "Admin";

  TextEditingController get userNameTextController => _userNameTextController;
  TextEditingController get userPasswordTextController =>
      _userPasswordTextController;
  TextEditingController get userEmailTextController => _userEmailTextController;
  TextEditingController get userAddressTextController =>
      _userAddressTextController;
  TextEditingController get userDobController => _userDobController;
  TextEditingController get userNumberTextController =>
      _userNumberTextController;
  TextEditingController get userDojTextController => _userDojTextController;

  Map<String, dynamic> get data => _data;
  Map<String, dynamic> get userData => _userData;
  List<dynamic> get rolesList => _rolesList;
  List<String> get department => _department;
  List<String> get designation => _designation;
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

  // String get userName => _userName;
  // String get userPassword => _userPassword;
  // String get userRole => _userRole;
  // String get userDepartment => _userDepartment;
  // String get userEmail => _userEmail;
  // String get userDesignation => _userDesignation;
  // String get userAddress => _userAddress;
  // String get userDOB => _userDOB;
  // String get userNumber => _userNumber;
  // String get userGender => _userGender;
  // String get userMaritalStatus => _userMaritalStatus;
  // String get userDOJ => _userDOJ;
  // String get userNationality => _userNationality;

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

  void setNationality(newValue) {
    _selectedNationality = newValue;
    notifyListeners();
  }

  void getRoleList(context) async {
    ERPResponse response = await ERPServices.getRequest('/users/roles');
    _data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _rolesList = _data['roles'];
      // print(_data);
      for (var role in _rolesList) {
        _selectedRole.add(role['role'].toString());
      }
      // print(_selectedRole);
    }
  }

  void PostUserDetails(context) async {
    Map<String, dynamic> body = {
      "username": _userNameTextController.value.text,
      "email": _userEmailTextController.value.text,
      "password": _userPasswordTextController.value.text,
      "role": {"role": "Marketing Staff", "roleValue": 3031},
      "department": _selectedDepartment,
      "designation": _selectedDesignation,
      "number": _userNumberTextController.value.text,
      "address": _userAddressTextController.value.text,
      "nationality": _selectedNationality,
      "dob": _userDobController.value.text,
      "doj": _userDojTextController.value.text,
      "maritalStatus": _selectedMaritalStatus,
      "gender": _selectedGender,

      // "username": _userNameTextController.value.text,
      // "password": _userPasswordTextController.value.text,
      // "role": _role,
      // "department": _selectedDepartment,
      // "email": _userEmailTextController.value.text,
      // "designation": _selectedDesignation
    };
    // print(body);
    ERPResponse response = await ERPServices.postRequest('/users', body);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      ToastMessageUtils().showToastMessage('User created successfully',
          ToastGravity.TOP, CustomColors.jadeGreen);
      print('success');
    } else {
      ToastMessageUtils().showToastMessage(
          'Something went wrong', ToastGravity.TOP, CustomColors.lightRed);
      print('something is missing');
    }
  }

  void getUserDetails() async {
    ERPResponse response = await ERPServices.getRequest('/users');
    _userData = jsonDecode(response.body);
    print(response.statusCode);
    // print(response.body);
    _userList = _userData['users'];
    print(_userList.length);
    if (response.statusCode == 200) {
      // _userName = _userData['users'][0]['username'];
      // print(_userName);
    }
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
    _userNumberTextController.text = number;
    _selectedGender = gender;
    _selectedMaritalStatus = maritalStatus;
    _userDojTextController.text = doj;
    _selectedNationality = nationality;
    notifyListeners();
  }
}
