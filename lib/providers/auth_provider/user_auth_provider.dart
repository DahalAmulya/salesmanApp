import 'dart:convert';

import 'package:deskgoo/consts.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:flutter/material.dart';

class UserAuthProvider extends ChangeNotifier {
  bool _obscure = true;
  bool _rememberMe = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool get obscure => _obscure;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  bool get rememberMe => _rememberMe;

  void toggleObscure() {
    _obscure = !_obscure;
    notifyListeners();
  }

  void toggleRememberMe(bool value) {
    _rememberMe = value;
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
    ERPResponse response = await ERPServices.ERPlogin(body);
    if (response.statusCode == 200) {
      print(response.statusCode);
      final data = jsonDecode(response.body);
      accessToken = data['accessToken'];
      userId = data['user']['userId'];
      print(data);
    }
  }
}
