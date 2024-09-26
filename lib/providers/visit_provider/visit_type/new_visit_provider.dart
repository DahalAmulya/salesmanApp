import 'package:deskgoo/models/visit_models/visit_client_model.dart';
import 'package:flutter/material.dart';

class NewVisitProvider extends ChangeNotifier {
  TextEditingController _newVisitClientName = TextEditingController();
  TextEditingController _newVisitClientNumber = TextEditingController();
  TextEditingController _newVisitClientEmail = TextEditingController();
  TextEditingController _newVisitClientAddress = TextEditingController();
  TextEditingController _newVisitClientWhatsApp = TextEditingController();
  TextEditingController _newVisitClientVisitedPerson = TextEditingController();
  TextEditingController _newVisitClientVisitedPersonRelation =
      TextEditingController();

  TextEditingController get newVisitClientName => _newVisitClientName;
  TextEditingController get newVisitClientNumber => _newVisitClientNumber;
  TextEditingController get newVisitClientEmail => _newVisitClientEmail;
  TextEditingController get newVisitClientAddress => _newVisitClientAddress;
  TextEditingController get newVisitClientWhatsApp => _newVisitClientWhatsApp;
  TextEditingController get newVisitClientVisitedPerson =>
      _newVisitClientVisitedPerson;
  TextEditingController get followUpClientVisitedPersonRelation =>
      _newVisitClientVisitedPersonRelation;

  void setNewVisitCilentDetails(VisitClientModel client) {
    _newVisitClientName.text = client.clientName;
    _newVisitClientNumber.text = client.clientPhoneNumber;
    _newVisitClientEmail.text = client.clientEmail;
    _newVisitClientAddress.text = client.clientAddress;
    _newVisitClientWhatsApp.text = client.clientWhatsApp;
    _newVisitClientVisitedPerson.text = client.clientVisitedPerson ?? '';
    _newVisitClientVisitedPersonRelation.text =
        client.clientVisitedPersonRelation ?? '';
    notifyListeners();
  }

  void clearFollowUpTextControllersValue() {
    _newVisitClientName.clear();
    _newVisitClientNumber.clear();
    _newVisitClientEmail.clear();
    _newVisitClientAddress.clear();
    _newVisitClientWhatsApp.clear();
    _newVisitClientVisitedPerson.clear();
    _newVisitClientVisitedPersonRelation.clear();
    notifyListeners();
  }
}
