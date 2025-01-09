import 'package:deskgoo/consts.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _fullName = '';
  Map<String, dynamic> _userDetails = {};
  List<dynamic> _userRolesList = [];
  String _role = '';

  String get fullName => _fullName;
  Map<String, dynamic> get user => _userDetails;
  List<dynamic> get userRolesList => _userRolesList;
  String get role => _role;

  void setBasicUserInfo(username, role) {
    _fullName = username;
    _role = role;
    notifyListeners();
  }
}
