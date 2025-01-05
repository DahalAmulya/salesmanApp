import 'dart:convert';

import 'package:deskgoo/consts.dart';
import 'package:deskgoo/routes/marketing_officer_consts.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:flutter/material.dart';

class UserAuthProvider extends ChangeNotifier {
  bool _obscure = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool get obscure => _obscure;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  void toggleObscure() {
    _obscure = !_obscure;
    notifyListeners();
  }

  void login(context) async {
    Map<String, dynamic> body = {
      'email': _emailController.value.text.isEmpty
          ? 'farhan@example.com'
          : _emailController.value.text,
      'password': _passwordController.value.text.isEmpty
          ? 'farhan@123'
          : _passwordController.value.text,
    };
    ERPResponse response = await ERPServicer.ERPlogin(body);
    if (response.statusCode == 200) {
      print(response.statusCode);
      final data = jsonDecode(response.body);
      accessToken = data['accessToken'];
      userId = data['user']['userId'];
      print(data);
      // full_name = data['full_name'];
      // employee_details = data['employee_details'];
      // user_roles = data['user_roles'];
      // _userProvider!.setUserDetails(
      //   full_name,
      //   employee_details,
      //   user_roles,
      // );
      // print('user_roles = $user_roles');
      // if (_userProvider!.role == 'marketingOfficer') {
      //   Navigator.of(context)
      //       .pushNamed(MarketingOfficerConstants.mrStaffDashboardConst);
      //   print('Marketing Officer');
      // } else {
      //   Navigator.of(context).pushNamed(MarketingManagerConstants.homePage);
      //   print('Marketing manager');
      // }
    }
  }
}
