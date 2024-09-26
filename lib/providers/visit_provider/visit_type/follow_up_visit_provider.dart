import 'package:deskgoo/models/visit_models/visit_client_model.dart';
import 'package:flutter/material.dart';

class FollowUpVisitProvider extends ChangeNotifier {
  TextEditingController _followUpClientName = TextEditingController();
  TextEditingController _followUpClientNumber = TextEditingController();
  TextEditingController _followUpClientEmail = TextEditingController();
  TextEditingController _followUpClientAddress = TextEditingController();
  TextEditingController _followUpClientWhatsApp = TextEditingController();
  TextEditingController _followUpClientVisitedPerson = TextEditingController();
  TextEditingController _followUpClientVisitedPersonRelation =
      TextEditingController();

  TextEditingController get followUpClientName => _followUpClientName;
  TextEditingController get followUpClientNumber => _followUpClientNumber;
  TextEditingController get followUpClientEmail => _followUpClientEmail;
  TextEditingController get followUpClientAddress => _followUpClientAddress;
  TextEditingController get followUpClientWhatsApp => _followUpClientWhatsApp;
  TextEditingController get followUpClientVisitedPerson =>
      _followUpClientVisitedPerson;
  TextEditingController get followUpClientVisitedPersonRelation =>
      _followUpClientVisitedPersonRelation;

  void setFollowUpCilentDetails(VisitClientModel client) {
    _followUpClientName.text = client.clientName;
    _followUpClientNumber.text = client.clientPhoneNumber;
    _followUpClientEmail.text = client.clientEmail;
    _followUpClientAddress.text = client.clientAddress;
    _followUpClientWhatsApp.text = client.clientWhatsApp;
    // _followUpClientVisitedPerson.text = client.clientVisitedPerson ?? '';
    // _followUpClientVisitedPersonRelation.text =
    //     client.clientVisitedPersonRelation ?? '';
    notifyListeners();
  }

  void clearFollowUpTextControllersValue() {
    _followUpClientName.clear();
    _followUpClientNumber.clear();
    _followUpClientEmail.clear();
    _followUpClientAddress.clear();
    _followUpClientWhatsApp.clear();
    _followUpClientVisitedPerson.clear();
    _followUpClientVisitedPersonRelation.clear();
    notifyListeners();
  }
}
