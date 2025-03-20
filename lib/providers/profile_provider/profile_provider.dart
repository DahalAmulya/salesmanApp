import 'dart:convert';
import 'package:deskgoo/services/erp_services.dart';
import 'package:flutter/foundation.dart';

class UserProfileProvider extends ChangeNotifier {
  String _name = '';
  String _address = '';
  String _email = '';
  String _department = '';
  String _designation = '';
  Map<String,dynamic> _userDetails = {};

  String get name => _name;
  String get address => _address;
  String get email => _email;
  String get department => _department;
  String get designation => _designation;
  Map<String, dynamic> get userDetails => _userDetails;

  void getUserProfile(context)async{
    ERPResponse response = await ERPServices.getRequest('/auth', context);
    _userDetails = jsonDecode(response.body);
    print(response.statusCode);
    print(response.body);
  }

}