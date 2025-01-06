import 'package:deskgoo/services/erp_services.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/utils/toast_message.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class MrOfficerVisitProvider with ChangeNotifier {
  // final _createVisitFormKey = GlobalKey<FormState>();
  List<String> _visitTypeList = [
    'New Visit',
    'FollowUp Visit',
  ];
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
  final _ageController = TextEditingController();
  final _searchController = TextEditingController();
  final _organizationController = TextEditingController();
  final _remarksController = TextEditingController();
  bool _isVisitFormValid = false;
  bool _isSwitched = false;
  List<String> _countryCode = ['+977', '+91'];
  String _selectedCountryCode = '+977';
  List<String> _country = ['Nepal', 'India'];
  String _selectedCountry = 'Nepal';
  List<String> _category = ['Doctor', 'Ambulance', 'Practitioner'];
  String _selectedCategory = 'Ambulance';
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
  String _selectedSpecialization = '';
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
  TextEditingController get ageController => _ageController;
  TextEditingController get searchController => _searchController;
  TextEditingController get organizationController => _organizationController;
  TextEditingController get remarksController => _remarksController;
  // GlobalKey<FormState> get createVisitFormKey => _createVisitFormKey;
  bool get isVisitFormValid => _isVisitFormValid;
  bool get isSwitched => _isSwitched;
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
    _ageController.text = age;
    _isSwitched = isToggled;
    // if (_isSwitched) {
    //   _WhatsappController.text = phoneNo;
    // } else {
    //   _WhatsappController.text = whatsApp;
    // }
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
    // print(enteredKeyWord);
    print('search result = $_searchResult');
    // _searchController.text = '';
    notifyListeners();
  }

  void createPOC(context) async {
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

    Map<String, dynamic> body = {
      "name": _nameController.value.text,
      "age": _ageController.value.text,
      "number": '$_selectedCountryCode${_phoneNoController.value.text}',
      "country": _selectedCountry,
      "region":
          _selectedCountry == 'Nepal' ? _selectedDistrict : _selectedState,
      "city": _selectedCity,
      "address": _addressController.value.text,
      "category": _selectedCategory,
      "specialization": _selectedSpecialization,
      "organization": _organizationController.value.text,
      // "remarks": _remarksController.value.text,
      "mobileTime": _dateTime
    };
    print(body);
    pocDetails(context, body);
  }

  void clearTextControllersValue() {
    _nameController.text = "";
    _districtController.text = "";
    _stateController.text = "";
    _cityController.text = "";
    _addressController.text = "";
    _phoneNoController.text = "";
    _ageController.text = "";
    _searchController.text = "";
    _organizationController.text = "";
    _remarksController.text = "";
    notifyListeners();
  }

  void postPOCDetails(body, context) async {
    ERPResponse response = await ERPServices.postRequest('/poc', body);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 201) {
      ToastMessageUtils().showToastMessage('New POC created successfully',
          ToastGravity.TOP, CustomColors.jadeGreen);
      clearTextControllersValue();
      Navigator.pop(context);
    } else {
      ToastMessageUtils().showToastMessage('Something went wrong');
      Navigator.pop(context);
    }
  }

  Future pocDetails(context, body) => showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: CustomColors.primaryWhite,
            elevation: 10,
            title: Center(
              child: CustomText(
                text: 'POC Details',
                fontWeight: FontWeight.bold,
                size: 22,
                color: CustomColors.primaryBlack,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: 'Full Name',
                          isContent: true,
                        ),
                      ),
                      Expanded(
                        child: CustomText(
                          maxLines: 3,
                          text: body['name'],
                          isContent: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: 'Age',
                          isContent: true,
                        ),
                      ),
                      Expanded(
                        child: CustomText(
                          maxLines: 3,
                          text: body['age'],
                          isContent: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: 'Number',
                          isContent: true,
                        ),
                      ),
                      Expanded(
                        child: CustomText(
                          maxLines: 3,
                          text: body['number'],
                          isContent: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: 'Country',
                          isContent: true,
                        ),
                      ),
                      Expanded(
                        child: CustomText(
                          maxLines: 3,
                          text: body['country'],
                          isContent: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        // flex: ,
                        child: CustomText(
                          text: _selectedCountry == 'Nepal'
                              ? 'District'
                              : 'State',
                          isContent: true,
                        ),
                      ),
                      Expanded(
                        // flex: 2,
                        child: CustomText(
                          maxLines: 3,
                          text: body['region'],
                          isContent: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: 'City',
                          isContent: true,
                        ),
                      ),
                      Expanded(
                        child: CustomText(
                          maxLines: 3,
                          text: body['city'],
                          isContent: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: 'Address',
                          isContent: true,
                        ),
                      ),
                      Expanded(
                        child: CustomText(
                          maxLines: 3,
                          text: body['address'],
                          isContent: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: 'Category',
                          isContent: true,
                        ),
                      ),
                      Expanded(
                        child: CustomText(
                          maxLines: 3,
                          text: body['category'],
                          isContent: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: 'Specialization',
                          isContent: true,
                        ),
                      ),
                      Expanded(
                        child: CustomText(
                          maxLines: 3,
                          text: body['specialization'],
                          isContent: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: 'Organization',
                          isContent: true,
                        ),
                      ),
                      Expanded(
                        child: CustomText(
                          maxLines: 3,
                          text: body['organization'],
                          isContent: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Expanded(
                  //       child: CustomText(
                  //         text: 'Remarks',
                  //         isContent: true,
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: CustomText(
                  //         maxLines: 3,
                  //         text: body['remarks'],
                  //         isContent: true,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // passing false
                    },
                    backgroundColor: CustomColors.lightRed,
                    widget: CustomText(
                      text: 'Edit',
                      color: CustomColors.primaryBlack,
                      isContent: true,
                    ),
                  ),
                  CustomElevatedButton(
                    onPressed: () {
                      createPOC(context);
                      postPOCDetails(body, context);
                      Navigator.pop(context); // passing false
                    },
                    backgroundColor: CustomColors.primaryColor,
                    widget: CustomText(
                      text: 'Submit',
                      color: CustomColors.primaryBlack,
                      isContent: true,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
}

class MrOfficerMoreDetailsProvider extends ChangeNotifier {
  String _selectedOption = 'Self';
  List<String> _dropDownOptions = ['Self', 'Others'];
  bool _isOpen = false;
  bool _isVisible = false;

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _diseasesController = TextEditingController();
  final _referenceController = TextEditingController();

  String get selectedOption => _selectedOption;
  List<String> get dropDownOptions => _dropDownOptions;
  bool get isOpen => _isOpen;
  bool get isVisible => _isVisible;
  TextEditingController get nameController => _nameController;
  TextEditingController get addressController => _addressController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get emailController => _emailController;
  TextEditingController get ageController => _ageController;
  TextEditingController get weightController => _weightController;
  TextEditingController get diseasesController => _diseasesController;
  TextEditingController get referenceController => _referenceController;

  void selectDropDownOptions(String value, bool isVisible) {
    _selectedOption = value;
    if (_selectedOption == 'Others') {
      _isVisible = !_isVisible;
    } else {
      _isVisible = false;
    }
    notifyListeners();
  }
}
