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
