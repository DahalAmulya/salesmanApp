import 'package:flutter/foundation.dart';

class OfficerDetailProvider extends ChangeNotifier{


  String _image = '';
  String _name = '';
  String _address = '';
  String _phoneNumber = '';
  String _dateTime = '';

  String get image => _image;
  String get name => _name;
  String get address => _address;
  String get phoneNumber => _phoneNumber;
  String get dateTime => _dateTime;


  void setImage(String image){
    _image = image;
    notifyListeners();
  }
  void setName(String name){
    _name = name;
    notifyListeners();
  }
  void setAddress(String address){
    _address = address;
    notifyListeners();
  }
  void setPhoneNumber(String phoneNumber){
    _phoneNumber = phoneNumber;
    notifyListeners();
  }
  void setDateTime(String dateTime){
    _dateTime = dateTime;
    notifyListeners();
  }
}