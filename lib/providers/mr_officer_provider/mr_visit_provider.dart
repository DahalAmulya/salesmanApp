import 'dart:async';
import 'dart:convert';

import 'package:deskgoo/consts.dart';
import 'package:deskgoo/pages/mr_officers_pages/mr_officers_visits/model/poc_create_model.dart';
import 'package:deskgoo/pages/mr_officers_pages/mr_officers_visits/model/poc_detail_model.dart';
import 'package:deskgoo/routes/marketing_officer_consts.dart';
import 'package:deskgoo/services/database_service.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/utils/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class MrOfficerVisitProvider with ChangeNotifier {
  List<String> _visitTypeList = ['New Visit', 'FollowUp Visit', 'Visit Log'];
  List<String> _selectedVisitTypeList = ['none', 'More Detail'];
  String _selectedVisitType = '';
  String _radioGroupValue = '';
  int _tabIndex = 0;
  Widget _selectedVisit = Container();
  final _nameController = TextEditingController();
  final _districtController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneNoController = TextEditingController();
  // final _ageController = TextEditingController();
  final _searchController = TextEditingController();
  final _ambulanceNumberController = TextEditingController();
  final _organizationController = TextEditingController();
  final _remarksController = TextEditingController();
  bool _isVisitFormValid = false;
  bool _isSwitched = false;
  List<String> _genderList = ['Male', 'Female', 'Others'];
  String _selectedGender = 'Male';
  List<String> _countryCode = ['+977', '+91'];
  String _selectedCountryCode = '+977';
  List<String> _country = ['Nepal', 'India'];
  String _selectedCountry = 'Nepal';
  List<String> _category = [
    'Doctor',
    'Ambulance',
    'Pharmacist',
    'Practitioner',
    'Police',
    'Politician',
    'Medical Officer (MO)',
    'Emergency in Charge',
    'Others',
  ];
  String _selectedCategory = 'Doctor';
  List<String> _specialization = [
    'Allergist/Immunologist',
    'Cardiologist',
    'Cardiothoracic Surgeon',
    'Dermatologist',
    'ENT (Ear, Nose and Throat) Specialist',
    'Gastroenterologist',
    'General',
    'General Physician',
    'Gynecologic Oncologist',
    'Obstetrician / Gynecologist (OB / GYN)',
    'Oncologist',
    'Ophthalmologist',
    'Orthopedic Surgeon',
    'Pediatric Surgeon',
    'Pediatrician',
    'Plastic Surgeon',
    'RMC / RMP',
    'Urologist',
    'Vascular Surgeon'
  ];
  String _selectedSpecialization = 'Allergist/Immunologist';
  List<dynamic> _districts = [];
  String _selectedDistrict = '';
  List<dynamic> _states = [];
  String _selectedState = '';
  List<dynamic> _cities = [];
  String _selectedCity = '';
  List<dynamic> _searchResult = [];
  double _latitude = 0;
  double _longitude = 0;
  String _dateTime = '';
  Map<String, dynamic> _body = {
    "pocName": '',
    // "age": '',
    'gender': '',
    "number": '',
    "country": '',
    "region": '',
    "city": '',
    "address": '',
    "category": '',
    "specialization": '',
    "ambNumber": '',
    "organization": '',
    "latitude": '',
    "longitude": '',
    "remarks": '',
    "createdById": '',
    "createdByName": '',
    "mobileTime": '',
    "visitDate": ''
  };
  PocModel pocModel = PocModel();
  final DatabaseService _dbService = DatabaseService.instance;
  bool _isOffline = false;

  // Getters and setters for form fields
  List<String> get visitTypeList => _visitTypeList;
  List<String> get selectedVisitTypeList => _selectedVisitTypeList;
  String get selectedVisitType => _selectedVisitType;
  String get radioGroupValue => _radioGroupValue;
  int get tabIndex => _tabIndex;
  Widget get selectedVisit => _selectedVisit;
  TextEditingController get nameController => _nameController;
  TextEditingController get districtController => _districtController;
  TextEditingController get stateController => _stateController;
  TextEditingController get cityController => _cityController;
  TextEditingController get addressController => _addressController;
  TextEditingController get phoneNoController => _phoneNoController;
  // TextEditingController get ageController => _ageController;
  TextEditingController get searchController => _searchController;
  TextEditingController get ambulanceNumberController =>
      _ambulanceNumberController;
  TextEditingController get organizationController => _organizationController;
  TextEditingController get remarksController => _remarksController;
  // GlobalKey<FormState> get createVisitFormKey => _createVisitFormKey;
  bool get isVisitFormValid => _isVisitFormValid;
  bool get isSwitched => _isSwitched;
  List<String> get genderList => _genderList;
  String get selectedGender => _selectedGender;
  List<String> get countryCode => _countryCode;
  String get selectedCountryCode => _selectedCountryCode;
  List<String> get country => _country;
  String get selectedCountry => _selectedCountry;
  List<String> get category => _category;
  String get selectedCategory => _selectedCategory;
  List<String> get specialization => _specialization;
  String get selectedSpecialization => _selectedSpecialization;
  List<dynamic> get districts => _districts;
  String get selectedDistrict => _selectedDistrict;
  List<dynamic> get states => _states;
  String get selectedState => _selectedState;
  List<dynamic> get cities => _cities;
  String get selectedCity => _selectedCity;
  List<dynamic> get searchResult => _searchResult;
  Map<String, dynamic> get body => _body;
  bool get isOffline => _isOffline;
  int _selectedLocalPocId = -1;


  // Edit POC
  bool _isEditPOC = false;
  bool _isLoading = false;
  PocDetails? pocDetails;

  bool get isEditPoc => _isEditPOC;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setIsOffline(bool value) {
    debugPrint('New Visit isOffline to: $value');
    _isOffline = value;
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

  void setSelectedGender(String gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  void getDistricts(List<dynamic> districtsList) {
    _districts = districtsList;
    notifyListeners();
  }

  void getStates(List<dynamic> statesList) {
    _states = statesList;
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

  void selectVisitType(value) {
    _radioGroupValue = value;
    notifyListeners();
  }

  void setTabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  bool setSelectedVisitType() {
    _selectedVisitType = _radioGroupValue;
    if (_selectedVisitType.isEmpty) {
      ToastMessageUtils().showToastMessage('Please select visit type');
      notifyListeners();
      return false;
    } else {
      _selectedVisitTypeList[0] = _selectedVisitType;
      notifyListeners();
      return true;
    }
  }

  void unSelectVisitType() {
    _radioGroupValue = '';
    _selectedVisitType = '';
    notifyListeners();
  }

  void resetSelectedVisitType() {
    _selectedVisitType = '';
    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      print('latLng = ${position.latitude}, ${position.longitude}');
    } catch (err) {
      print('err = $err');
    }
  }

  void setCountryCode(value) {
    _selectedCountryCode = value;
    notifyListeners();
  }

  void setCountry(value) {
    _selectedCountry = value;
    notifyListeners();
  }

  void setCategory(value) {
    _selectedCategory = value;
    _selectedSpecialization = "General";
    print(_selectedCategory);
    notifyListeners();
  }

  void setSpecialization(value) {
    _selectedSpecialization = value;
    notifyListeners();
  }

  void setWhatsAppNumber(bool isToggled) {
    _isSwitched = isToggled;
    notifyListeners();
  }

  void setWhatsAppNumberOnChange(value) {
    notifyListeners();
  }

  void checkWhatsappAndPhoneNo(value) {
    notifyListeners();
  }

  void createClientDetails(String name, String address, String phoneNo,
      [String age = '',
      String emial = '',
      String whatsApp = '',
      bool isToggled = false]) {
    _nameController.text = name;
    _addressController.text = address;
    _phoneNoController.text = phoneNo;
    // _ageController.text = age;
    _isSwitched = isToggled;
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
    print('search result = $_searchResult');
    notifyListeners();
  }

  String formatPhoneNumber(String selectedCountryCode, String rawInput) {
    // Remove all non-digit characters
    String cleanedNumber = rawInput.replaceAll(RegExp(r'\D'), '');

    // Remove the country code prefix if user typed it again
    if (cleanedNumber.startsWith(selectedCountryCode.replaceAll('+', ''))) {
      cleanedNumber = cleanedNumber.substring(selectedCountryCode.length - 1);
    }

    // Return sanitized number
    return '$selectedCountryCode$cleanedNumber';
  }

  void createPOC() async {
    _isLoading = true;
    notifyListeners();

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 0,
        ),
      );
      _latitude = position.latitude;
      _longitude = position.longitude;
    } catch (e) {
      debugPrint("⚠️ Could not get location, fallback to default: $e");
      // fallback values
      _latitude = 26.454444412001187;
      _longitude = 87.27256880944243;
    }

    List<String> timeList =
    DateTime.now().toString().split('.')[0].toString().split(' ');
    _dateTime = '${timeList[1]} ${timeList[0]}';

    String finalNumber = formatPhoneNumber(
      _selectedCountryCode,
      _phoneNoController.value.text,
    );

    _body = {
      "pocName": _nameController.value.text,
      "gender": _selectedGender,
      "number": finalNumber.toString(),
      "country": _selectedCountry,
      "region":
      _selectedCountry == 'Nepal' ? _selectedDistrict : _selectedState,
      "city": _selectedCity,
      "address": _addressController.value.text,
      "category": _selectedCategory,
      "specialization": _selectedSpecialization,
      "ambNumber": _ambulanceNumberController.value.text,
      "organization": _organizationController.value.text,
      "remarks": _remarksController.value.text,
      "createdById": userId,
      "createdByName": userName,
      "mobileTime": _dateTime,
      "visitDate": DateTime.now().toString().split(".")[0],
      "latitude": _latitude,
      "longitude": _longitude,
    };

    pocModel = PocModel.fromJson(_body);
    debugPrint('POC Model: ${pocModel.toJson()}');

    _isLoading = false;
    notifyListeners();
  }

  void setPocModel({required BuildContext context, required PocModel poc}) {
    pocModel = poc;
    debugPrint('POC Model set: ${pocModel.toJson()}');
    postPOCDetails(context);
    notifyListeners();
  }

  void deletePocModel({required PocModel poc}) async {
    pocModel = poc;
    await _dbService.deletePOCById(pocModel.pocId!);
    notifyListeners();
  }

  void clearTextControllersValue() {
    _nameController.text = "";
    _districtController.text = "";
    _stateController.text = "";
    _cityController.text = "";
    _addressController.text = "";
    _phoneNoController.text = "";
    // _ageController.text = "";
    _selectedGender = 'Male';
    _searchController.text = "";
    _organizationController.text = "";
    _remarksController.text = "";
    _ambulanceNumberController.text = "";
    _selectedDistrict = '';
    _selectedState = '';
    _selectedCity = '';
    pocDetails = null;
    pocModel = PocModel();
    _isEditPOC = false;
    _selectedLocalPocId = -1;
    notifyListeners();
  }

  // void postPOCDetails(context) async {
  //   ERPResponse response = await ERPServices.postRequest('/poc/create', pocModel.toJson(), context);
  //   print(response.statusCode);
  //   print(response.body);
  //   _databaseService.createPOC(pocModel);
  //   if (response.statusCode == 200) {
  //     ToastMessageUtils().showToastMessage('New POC created successfully',
  //         ToastGravity.TOP, CustomColors.jadeGreen);
  //     clearTextControllersValue();
  //     Navigator.pop(context);
  //     Navigator.of(context)
  //         .popAndPushNamed(MarketingOfficerConstants.mrStaffDashboardConst);
  //   } else {
  //     ToastMessageUtils()
  //         .showToastMessage(jsonDecode(response.body)['message']);
  //     Navigator.pop(context);
  //   }
  // }

  void postPOCDetails(BuildContext context) async {
    try {
      // Show loading dialog
      Navigator.pop(context);
      showDialog(
        context: context,
        barrierDismissible: false, // prevent closing by tapping outside
        builder: (context) => Center(
          child: CircularProgressIndicator(color: CustomColors.primaryColor),
        ),
      );

      Map<String,dynamic> payload = pocModel.toJson();
      payload['createdById'] = userId;
      debugPrint('Map Payload: ${payload}');
      debugPrint('Map Payload: ${payload.runtimeType}');


      // Run request with timeout
      ERPResponse response = await ERPServices
          .postRequest('/poc/create', payload, context)
          .timeout(const Duration(seconds: 10));

      // Close loading once request finishes
      Navigator.pop(context);

      print(response.statusCode);
      print(response.body);

      // Save locally regardless
      // _databaseService.createPOC(pocModel);

      if (response.statusCode == 200) {
        ToastMessageUtils().showToastMessage(
          'New POC created successfully',
          ToastGravity.TOP,
          CustomColors.jadeGreen,
        );
        _dbService.deletePOCById(pocModel.pocId!);
        clearTextControllersValue();
        Navigator.of(context)
            .popAndPushNamed(MarketingOfficerConstants.mrStaffDashboardConst);
      } else {
        ToastMessageUtils()
            .showToastMessage(jsonDecode(response.body)['message']);
      }
    } on TimeoutException catch (_) {
      // Close loading after 10s
      Navigator.pop(context);

      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Network Timeout"),
            content: const Text(
              "The request is taking longer than 10 seconds.\nDo you want to save this POC locally?",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(); // close dialog
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  _dbService.createPOC(pocModel); // save locally
                  Navigator.of(ctx).pop(); // close dialog
                  ToastMessageUtils().showToastMessage(
                    'POC saved locally due to timeout',
                    ToastGravity.TOP,
                    CustomColors.lightYellow,
                  );
                },
                child: const Text("Save"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      debugPrint("Error while posting POC: $e");
      Navigator.pop(context);
    }
  }

  void setControllerValues(context,{required String pocId, bool isEdit = true}) async {
  clearTextControllersValue();
  _isEditPOC = isEdit;
  notifyListeners();
  ERPResponse response = await ERPServices.getRequest('/poc/$pocId?createdById=$userId', context);
  if(response.statusCode == 200){
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    pocDetails = PocDetails.fromJson(responseBody);
    debugPrint('${pocDetails?.number}');
    debugPrint('${pocDetails?.pocName}');
    _nameController.text = pocDetails?.pocName ?? '';
    // _ageController.text = pocDetails?.age.toString() ?? '';
    _selectedGender = pocDetails!.gender;
    _selectedCountry = pocDetails!.country;
    if(_selectedCountry == 'Nepal'){
      _selectedCountryCode = _countryCode[0];
      _phoneNoController.text = pocDetails!.number.substring(4);
      _selectedDistrict = pocDetails!.region;
      _districtController.text = _selectedDistrict;
    }else {
      _selectedCountryCode = _countryCode[1];
      _phoneNoController.text = pocDetails!.number.substring(3);
      _selectedState = pocDetails!.region;
      _stateController.text = _selectedState;
    }
    _selectedCity = pocDetails!.city;
    _cityController.text = _selectedCity;
    _addressController.text = pocDetails?.address ?? '';
    _selectedCategory = pocDetails!.category;
    _selectedSpecialization = pocDetails!.specialization;
    _organizationController.text = pocDetails?.organization ?? '';
    _ambulanceNumberController.text = pocDetails?.ambNumber ?? '';
  }else{
    clearTextControllersValue();
  }
    notifyListeners();
  }

  void setLocalControllerValues(context,{required PocModel poc, bool isEdit = true}) async {
    clearTextControllersValue();
    _isEditPOC = isEdit;
    notifyListeners();
    pocModel = poc;
    _selectedLocalPocId = pocModel.pocId!;
    debugPrint('${_selectedLocalPocId}');
    debugPrint('${pocModel.number}');
    debugPrint('${pocModel.pocName}');
    debugPrint('POC Model in local edit: ${pocModel.toJson()}');
    _nameController.text = pocModel.pocName!;
    // _ageController.text = pocDetails?.age.toString() ?? '';
    _selectedGender = pocModel.gender!;
    _selectedCountry =pocModel.country!;
    if(_selectedCountry == 'Nepal'){
      _selectedCountryCode = _countryCode[0];
      _phoneNoController.text = pocModel.number!.substring(4);
      _selectedDistrict = pocModel.region!;
      _districtController.text = _selectedDistrict;
    }else {
      _selectedCountryCode = _countryCode[1];
      _phoneNoController.text = pocModel.number!.substring(3);
      _selectedState = pocModel.region!;
      _stateController.text = _selectedState;
    }
    _selectedCity = pocModel.city!;
    _cityController.text = _selectedCity;
    _addressController.text = pocModel.address ?? '';
    _selectedCategory = pocModel.category!;
    _selectedSpecialization = pocModel.specialization!;
    _organizationController.text = pocModel.organization ?? '';
    _ambulanceNumberController.text = pocModel.ambNumber ?? '';
    _remarksController.text = pocModel.remarks ?? '';
    Navigator.of(context).pushNamed(MarketingOfficerConstants.newVisit);
    notifyListeners();
  }

  void updateLocalPoc(context) async {
    String finalNumber = formatPhoneNumber(
      _selectedCountryCode,
      _phoneNoController.value.text,
    );

    _body = {
      "pocId": _selectedLocalPocId,
      "pocName": _nameController.value.text,
      "gender": _selectedGender,
      "number": finalNumber.toString(),
      "country": _selectedCountry,
      "region":
      _selectedCountry == 'Nepal' ? _selectedDistrict : _selectedState,
      "city": _selectedCity,
      "address": _addressController.value.text,
      "category": _selectedCategory,
      "specialization": _selectedSpecialization,
      "ambNumber": _ambulanceNumberController.value.text,
      "organization": _organizationController.value.text,
      "remarks": _remarksController.value.text,
      "createdById": userId,
      "createdByName": userName,
      "mobileTime": _dateTime,
      "visitDate": DateTime.now().toString().split(".")[0],
      "latitude": _latitude,
      "longitude": _longitude,
    };

    debugPrint('Updating local POC with body: $_body');

    pocModel = PocModel.fromJson(_body);
    debugPrint('POC Model: ${pocModel.toJson()}');
    debugPrint('Updating local POC with ID: $_selectedLocalPocId');
    await _dbService.updatePOCById(_selectedLocalPocId, pocModel.toJson());
    ToastMessageUtils().showToastMessage('POC updated locally', ToastGravity.TOP, CustomColors.jadeGreen);
    clearTextControllersValue();
    Navigator.pop(context);
    notifyListeners();
  }

  void updatePOC(context) async {
    try{
      _body.clear();
      String finalNumber = formatPhoneNumber(
        _selectedCountryCode,
        _phoneNoController.value.text,
      );
      _body = {
        "pocName": _nameController.value.text,
        "gender": _selectedGender,
        "number": finalNumber.toString(),
        "country": _selectedCountry,
        "region":
        _selectedCountry == 'Nepal' ? _selectedDistrict : _selectedState,
        "city": _selectedCity,
        "address": _addressController.value.text,
        "category": _selectedCategory,
        "specialization": _selectedSpecialization,
        "ambNumber": _ambulanceNumberController.value.text,
        "organization": _organizationController.value.text,
        "createdById": userId,
      };
      ERPResponse response = await ERPServices.patchRequest('/poc/update/${pocDetails!.id}?createdById=$userId', _body, context);
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      // _dbService.createPOC(pocModel);
      if (response.statusCode == 200) {
        ToastMessageUtils().showToastMessage('POC details updated successfully',
            ToastGravity.TOP, CustomColors.jadeGreen);
        clearTextControllersValue();
        pocDetails = null;
        Navigator.pop(context);
        Navigator.of(context)
            .popAndPushNamed(MarketingOfficerConstants.mrStaffDashboardConst);
      } else {
        ToastMessageUtils()
            .showToastMessage(jsonDecode(response.body)['message']);
        Navigator.pop(context);
      }
    }catch (err){
      print('Error as $err');
    }
  }

  void savePocLocally(context) async {
    Navigator.pop(context);
    showDialog(context: context, builder: (_) => Center(child: CircularProgressIndicator(color: CustomColors.primaryColor),));
    bool response = await _dbService.createPOC(pocModel);
    if(response == true){
      debugPrint('Local save response: $response');
      clearTextControllersValue();
    }
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
