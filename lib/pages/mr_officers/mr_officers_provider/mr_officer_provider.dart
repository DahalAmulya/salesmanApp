import 'package:flutter/material.dart';

class MrOfficerCreateVisitProvider with ChangeNotifier {
  final _newVisitFormKey = GlobalKey<FormState>();
  final _createNameController = TextEditingController();
  final _createAddressController = TextEditingController();
  final _createPhoneNoController = TextEditingController();
  final _createEmailController = TextEditingController();
  final _createWhatsappController = TextEditingController();
  final _createAgeController = TextEditingController();
  final _searchClientController = TextEditingController();
  bool _isVisitFormValid = false;
  bool _isSwitched = false;

  // Getters and setters for form fields
  TextEditingController get createNameController => _createNameController;
  TextEditingController get createAddressController => _createAddressController;
  TextEditingController get createPhoneNoController => _createPhoneNoController;
  TextEditingController get createEmailController => _createEmailController;
  TextEditingController get createWhatsAppController =>
      _createWhatsappController;
  TextEditingController get createAgeController => _createAgeController;
  TextEditingController get searchClientController => _searchClientController;
  GlobalKey<FormState> get newVisitFormKey => _newVisitFormKey;
  bool get isVisitFormValid => _isVisitFormValid;
  bool get isSwitched => _isSwitched;

  void setWhatsAppNumber(bool isToggled) {
    _isSwitched = isToggled;
    if (_isSwitched) {
      _createWhatsappController.text = _createPhoneNoController.text;
    }
    notifyListeners();
  }

  void checkWhatsappAndPhoneNo(value) {
    print(value);
    _createWhatsappController.text = value;
    if (_createWhatsappController.text == _createPhoneNoController.text) {
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
