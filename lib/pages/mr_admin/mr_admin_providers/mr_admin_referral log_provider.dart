import 'dart:convert';
import 'dart:io';
import 'package:deskgoo/pages/mr_admin/mr_admin_pages/reports/referral/model/patient_referral_by_user_model.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../services/erp_services.dart';
import '../../../utils/toast_message.dart';
import 'package:path/path.dart' as path;

class MrAdminReferralLogProvider extends ChangeNotifier {
  List<String> _approvalType = ['Approved', 'Pending', 'Rejected'];
  List<String> _referralLogsUsersList = ["Select User"];
  List<String> _referralDateTypeList = ['Today', 'Yesterday', 'Custom'];
  List<String> _referralType = ["Country", "Region", "City"];
  List<String> _countryList = [
    'Nepal',
    'India',
  ];
  List<dynamic> _districts = [];
  List<dynamic> _stateList = [];
  List<dynamic> _searchResult = [];
  List<String> _foundDistrictList = [];
  List<String> _foundStateList = [];
  List<String> _foundCities = [];
  List<dynamic> _cities = [];
  bool _isExpanded = true;
  bool get isExpanded => _isExpanded;

  List<dynamic> _usersReferralList = [];
  List<dynamic> _referralList = [];

  String _selectedUser = 'Select User';
  String _selectedDateReferralType = 'Today';
  String _selectedReferralType = 'Country';
  String _selectedCountry = 'Nepal';
  String _selectedDistrict = 'Morang';
  String _selectedStates = 'Andhra Pradesh';
  String _selectedCity = 'Biratnagar';
  String _profileImage = '';
  String _selectedUserId = '';
  String _selectedRegion = '';
  String _selectedCities = '';
  String _selectedState = '';
  String _from = '';
  String _to = '';

  List<dynamic> _foundReferral = [];
  List<dynamic> _foundReferralByCountry = [];
  List<dynamic> _foundReferralByCity = [];

  TextEditingController _fromTextEditingController = TextEditingController();
  TextEditingController _toTextEditingController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _districtController = TextEditingController();
  TextEditingController _stateController = TextEditingController();

  List<String> get approvalType => _approvalType;
  List<dynamic> get usersReferralList => _usersReferralList;
  List<dynamic> get referralList => _referralList;
  List<dynamic> get districts => _districts;
  List<dynamic> get stateList => _stateList;
  List<dynamic> get searchResult => _searchResult;

  List<String> get foundCities => _foundCities;
  List<String> get foundDistrictList => _foundDistrictList;
  List<String> get foundStateList => _foundStateList;
  List<String> get referralLogsUsersList => _referralLogsUsersList;
  List<String> get referralDateTypeList => _referralDateTypeList;
  List<String> get referralType => _referralType;
  List<String> get countryList => _countryList;
  List<dynamic> get cities => _cities;

  String get selectedUser => _selectedUser;
  String get profileImage => _profileImage;
  String get selectedUserId => _selectedUserId;
  String get selectedRegion => _selectedRegion;
  String get selectedDateReferralType => _selectedDateReferralType;
  String get selectedReferralType => _selectedReferralType;
  String get selectedCountry => _selectedCountry;
  String get selectedDistrict => _selectedDistrict;
  String get selectedStates => _selectedStates;
  String get selectedCity => _selectedCity;
  String get selectedCities => _selectedCities;
  String get selectedState => _selectedState;
  String get from => _from;
  String get to => _to;

  List<dynamic> get foundReferral => _foundReferral;
  List<dynamic> get foundReferralByCountry => _foundReferralByCountry;
  List<dynamic> get foundReferralByCity => _foundReferralByCity;

  TextEditingController get fromTextEditingController =>
      _fromTextEditingController;
  TextEditingController get toTextEditingController => _toTextEditingController;
  TextEditingController get searchController => _searchController;
  TextEditingController get cityController => _cityController;
  TextEditingController get districtController => _districtController;
  TextEditingController get stateController => _stateController;

  void getDataForDistrict() async {
    final respose = await rootBundle.loadString('assets/district.json');
    List<dynamic> districtData = json.decode(respose);
    _districts = districtData;
    _foundDistrictList =
        districtData.map((item) => item['district'] as String).toList();
    notifyListeners();
  }

  void getDataForState() async {
    final response = await rootBundle.loadString('assets/states.json');
    List<dynamic> stateData = json.decode(response);
    _stateList = stateData;
    _foundStateList =
        stateData.map((item) => item['states'] as String).toList();
    notifyListeners();
  }

  void getCitiesForSelection(
    String selectedItem,
  ) {
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

  void setSelectedUser(user) {
    _selectedUser = user;
    print(_selectedUser);

    for (int i = 0; i < _usersReferralList.length; i++) {
      if (_usersReferralList[i]['username'] == _selectedUser) {
        _selectedUserId = _usersReferralList[i]['_id'];
        break;
      }
    }

    notifyListeners();
  }

  void setSelectedReferralType(newValue) {
    _selectedReferralType = newValue;
    notifyListeners();
  }

  void setSelectedCountry(newValue) {
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

  void setSelectedVisitType(visitType) {
    DateTime currentDate = DateTime.now();
    DateTime yesterday = currentDate.subtract(Duration(days: 1));
    _selectedDateReferralType = visitType;
    if (_selectedDateReferralType == _referralDateTypeList[0]) {
      _from = '${currentDate.toString().split(' ')[0]}';
      _to = '${currentDate.toString().split(' ')[0]}';
    } else if (_selectedDateReferralType == _referralDateTypeList[1]) {
      _from = '${yesterday.toString().split(' ')[0]}';
      _to = '${yesterday.toString().split(' ')[0]}';
    } else {}

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
      _from =
          '${picked.year}-${picked.month < 10 ? '0${picked.month}' : picked.month}-${picked.day}';
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
      _to =
          '${picked.year}-${picked.month < 10 ? '0${picked.month}' : picked.month}-${picked.day}';
    }
    _toTextEditingController.text = _to;
    notifyListeners();
  }

  void getVisitLogsList(context) async {
    _referralLogsUsersList = ["Select User"];
    _selectedUser = 'Select User';
    _selectedDateReferralType = 'Today';
    _selectedUserId = '';
    ERPResponse response =
        await ERPServices.getRequest('/visitLogs/users', context);
    // print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      _usersReferralList = body['logs'];
      for (int i = 0; i < _usersReferralList.length; i++) {
        _referralLogsUsersList.add(_usersReferralList[i]['username']);
      }
    }
    notifyListeners();
  }

  void getReferralLogsByRegion(context) async {
    if (_selectedUserId.isEmpty) {
      ToastMessageUtils().showToastMessage('Please select a user');
    } else {
      if (_selectedUserId.isEmpty || _from.isEmpty || _to.isEmpty) {
        ToastMessageUtils()
            .showToastMessage('Please select a user and provide valid dates');
        return;
      }
      ERPResponse response = await ERPServices.getRequest(
          '/referral/area/region?_id=$_selectedUserId&from=$_from&to=$_to&country=$_selectedCountry&region=$_selectedRegion',
          context);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        _foundReferral = body['referralLogs'];
        print(_foundReferral);
        _profileImage = foundReferral[0]['profileImage'];
        // print(profileImage);
        // print(_foundReferral.runtimeType);
        // print(response.body);
      } else {
        _referralList = [];
      }
    }
    notifyListeners();
  }

  void getReferralByCountry(context) async {
    if (_selectedUserId.isEmpty) {
      ToastMessageUtils().showToastMessage('Please select a user');
    } else {
      if (_selectedUserId.isEmpty || _from.isEmpty || _to.isEmpty) {
        ToastMessageUtils()
            .showToastMessage('Please select a user and provide valid dates');
        return;
      }
      ERPResponse response = await ERPServices.getRequest(
          '/referral/area/country?_id=$_selectedUserId&from=$_from&to=$_to&country=$_selectedCountry',
          context);
      final body = jsonDecode(response.body);
      _foundReferral = body['referralLogs'];
      _profileImage = foundReferral[0]['profileImage'];
      print(_foundReferral[0]['profileImage']);
    }
    notifyListeners();
  }

  void getReferralLogByCity(context) async {
    if (_selectedUserId.isEmpty) {
      ToastMessageUtils().showToastMessage('Please select a user');
    } else {
      if (_selectedUserId.isEmpty || _from.isEmpty || _to.isEmpty) {
        ToastMessageUtils()
            .showToastMessage('Please select a user and provide valid dates');
        return;
      }
      ERPResponse response = await ERPServices.getRequest(
          '/referral/area/city?_id=$_selectedUserId&from=$_from&to=$_to&country=$_selectedCountry&region=$_selectedRegion&city=$_selectedCities',
          context);
      final body = jsonDecode(response.body);
      _foundReferral = body['referralLogs'];
      _profileImage = foundReferral[0]['profileImage'];
      print(selectedCities);
    }
    notifyListeners();
  }

  void exportData(context) async {
    ERPResponse response =
        await ERPServices.getRequest('/referral/area/export', context);
    print(response.statusCode);
    print(response.body);
  }

  //// New API Model

  PatientReferralByUserModel _patientReferralModel =
      PatientReferralByUserModel();
  PatientReferralByUserModel get patientReferralModel => _patientReferralModel;

  List<Map<String, dynamic>> payload = [];

  void approvalStatus(int index, String value) {
    _patientReferralModel.data![index].approvalStatus = value;

    String referralId = _patientReferralModel.data![index].id;
    String approvalStatus = _patientReferralModel.data![index].approvalStatus;

    // Check if referralId already exists in payload
    int existingIndex =
        payload.indexWhere((item) => item['referralId'] == referralId);

    if (existingIndex != -1) {
      // Exists → check if approvalStatus is different
      if (payload[existingIndex]['approvalStatus'] != approvalStatus) {
        payload[existingIndex]['approvalStatus'] = approvalStatus;
      }
    } else {
      // Doesn't exist → add new entry
      payload.add({
        "referralId": referralId,
        "approvalStatus": approvalStatus,
      });
    }

    debugPrint('Payload: $payload');
    notifyListeners();
  }

  void getPatientReferralByUser(context) async {
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(
                color: CustomColors.primaryColor,
              ),
            ));
    debugPrint('from = $_from');
    debugPrint('to = $_to');
    ERPResponse response = await ERPServices.getRequest(
        '/patient-referral/by-user/$_selectedUserId?from=$_from&to=$_to',
        context);
    // ERPResponse response = await ERPServices.getRequest('/patient-referral/by-user/$_selectedUserId?from=$_from&to=$_to', context);
    debugPrint('Status code = ${response.statusCode}');
    debugPrint('Body = ${response.body}');
    _patientReferralModel =
        PatientReferralByUserModel.fromJson(jsonDecode(response.body));
    debugPrint('Patient Referral Model Data: ${_patientReferralModel.data}');
    if(_patientReferralModel.data!.length == 0){
      ToastMessageUtils().showToastMessage('No referral data found for the selected user and date range.', ToastGravity.TOP, CustomColors.lightRed);
    }
    Navigator.pop(context);
    notifyListeners();
  }

  void downloadReferralReport(context) async {
    ERPResponse response = await ERPServices.getRequest(
        '/patient-referral/csv/by-user/$_selectedUserId?from=$_from&to=$_to',
        context);
    debugPrint('Download Referral Report Response: ${response.statusCode}');
    debugPrint('Download Referral Report Response: ${response.body}');
    if (response.statusCode == 200) {
      String csvContent = response.body;
      // Handle the file download logic here
      // 2. Get the download directory (Android only)
      Directory downloadDir = Directory('/storage/emulated/0/Download');

      // 3. Create VisitLogs/Rajan Kumar folder
      String folderPath =
          path.join(downloadDir.path, 'Referral', _selectedUser);
      Directory nestedDir = Directory(folderPath);

      if (!nestedDir.existsSync()) {
        nestedDir.createSync(recursive: true); // Create all folders
      }

      // 4. Create file inside the folder
      String filePath = path.join(
          nestedDir.path, '${selectedUser}_Referral_${_from}_to_$_to.csv');
      File file = File(filePath);

      await file.writeAsString(csvContent);
      ToastMessageUtils().showToastMessage(
          "Success! CSV file saved to: \n$filePath",
          ToastGravity.TOP,
          CustomColors.jadeGreen);
    } else {
      ToastMessageUtils()
          .showToastMessage("Error! Failed to download visit log.");
    }
  }

  void updateApprovalStatus(context) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(
              color: CustomColors.primaryColor,
              strokeWidth: 5,
            ),
          );
        });
    debugPrint('Updating approval status with payload: $payload');
    ERPResponse response = await ERPServices.patchRequest(
        '/patient-referral/by-user/$_selectedUserId', payload, context);
    if (response.statusCode == 200) {
      ToastMessageUtils().showToastMessage(
          'Referral status updated successfully',
          ToastGravity.TOP,
          CustomColors.jadeGreen);
      debugPrint('Update Response: ${response.statusCode}');
      debugPrint('Update Response: ${response.body}');
      payload.clear();
      Navigator.pop(context);
      getPatientReferralByUser(context);
    } else {
      Navigator.pop(context);
      ToastMessageUtils().showToastMessage(
        'Failed to update referral status',
      );
    }
    notifyListeners();
  }
}
