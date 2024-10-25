import 'package:flutter/material.dart';

class MrOfficerCreateVisitProvider with ChangeNotifier {
  // final _createVisitFormKey = GlobalKey<FormState>();
  final _createNameController = TextEditingController();
  final _createAddressController = TextEditingController();
  final _createPhoneNoController = TextEditingController();
  final _createEmailController = TextEditingController();
  final _createWhatsappController = TextEditingController();
  final _createAgeController = TextEditingController();
  final _searchClientController = TextEditingController();
  bool _isVisitFormValid = false;
  bool _isSwitched = false;
  List<String> _countryCode = ['+977', '+91'];
  String _selectedCountryCode = '+977';

  // Getters and setters for form fields
  TextEditingController get createNameController => _createNameController;
  TextEditingController get createAddressController => _createAddressController;
  TextEditingController get createPhoneNoController => _createPhoneNoController;
  TextEditingController get createEmailController => _createEmailController;
  TextEditingController get createWhatsAppController =>
      _createWhatsappController;
  TextEditingController get createAgeController => _createAgeController;
  TextEditingController get searchClientController => _searchClientController;
  // GlobalKey<FormState> get createVisitFormKey => _createVisitFormKey;
  bool get isVisitFormValid => _isVisitFormValid;
  bool get isSwitched => _isSwitched;
  List<String> get countryCode => _countryCode;
  String get selectedCountryCode => _selectedCountryCode;

  void setCountryCode(value) {
    _selectedCountryCode = value;
    if (_isSwitched) {
      _createWhatsappController.text =
          '$_selectedCountryCode-${_createPhoneNoController.text}';
    }
    notifyListeners();
  }

  void setWhatsAppNumber(bool isToggled) {
    _isSwitched = isToggled;
    if (_isSwitched) {
      _createWhatsappController.text =
          '$_selectedCountryCode-${_createPhoneNoController.text}';
    }
    notifyListeners();
  }

  void setWhatsAppNumberOnChange(value) {
    if (_isSwitched) {
      _createWhatsappController.text =
          '$_selectedCountryCode-${_createPhoneNoController.text}';
    }
    notifyListeners();
  }

  void checkWhatsappAndPhoneNo(value) {
    if (_createWhatsappController.text.split('-')[1] ==
        _createPhoneNoController.text) {
      _isSwitched = true;
    } else {
      _isSwitched = false;
    }
    notifyListeners();
  }

  void createClientDetails(String name, String address, String phoneNo,
      [String age = '',
      String emial = '',
      String whatsApp = '',
      bool isToggled = false]) {
    _createNameController.text = name;
    _createAddressController.text = address;
    _createPhoneNoController.text = phoneNo;
    _createAgeController.text = age;
    _createEmailController.text = emial;
    _isSwitched = isToggled;
    if (_isSwitched) {
      _createWhatsappController.text = phoneNo;
    } else {
      _createWhatsappController.text = whatsApp;
    }
    notifyListeners();
  }
}

class MrOfficerMoreDetailsProvider extends ChangeNotifier{

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
   if(_selectedOption == 'Others'){
     _isVisible = !_isVisible;
   }
   else{
     _isVisible = false;
   }
    notifyListeners();
  }


}
