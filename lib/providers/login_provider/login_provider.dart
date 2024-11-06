import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {

  String _fullName = '';
  Map<String, dynamic> _userDetails = {};
  List<dynamic> _roles = [];

  String get fullName => _fullName;
  Map<String,dynamic> get user => _userDetails;
  List<dynamic> get roles => _roles;

  void setUserDetails(String userName, Map<String,dynamic>userDetail, List<dynamic>userRoles){
    _fullName = userName;
    _userDetails = userDetail;
    _roles = userRoles;
    notifyListeners();

  }
}
