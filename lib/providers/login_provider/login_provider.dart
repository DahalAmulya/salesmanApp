import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {

  String _fullName = '';
  Map<String, dynamic> _userDetails = {};
  List<dynamic> _userRolesList = [];
  String _role = '';
  List<String> _roleList = ['marketingManager','marketingAsstManager','marketingOfficer'];

  String get fullName => _fullName;
  Map<String,dynamic> get user => _userDetails;
  List<dynamic> get userRolesList => _userRolesList;
  String get role => _role;
  List<String> get roleList => _roleList;

  void setUserDetails(String userName,Map<String,dynamic> userDetail, List<dynamic> userRoles){
    _fullName = userName;
    _userDetails = userDetail;
    _userRolesList = userRoles;
    outerLoop:
    for(int i = 0; i < roleList.length; i++ ){
      for(int j = 0; j < _userRolesList.length; j++){
        if(roleList[i] == _userRolesList[j]){
          _role = roleList[i];
          print('hello');
          break outerLoop;
        }
      }

    }
    print('******************************************************************');
    print(_fullName);
    print(_userDetails);
    print(_userRolesList);
    print('******************************************************************');
    notifyListeners();

  }
}
