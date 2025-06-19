import 'dart:convert';

import 'package:deskgoo/consts.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:flutter/material.dart';

class UserAuthProvider extends ChangeNotifier {
  bool _obscure = true;
  bool _rememberMe = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isAgreedTermsAndConditions = false;
  bool _onTapTermsAndConditionsBtn = false;
  bool _isAgreedPrivacyPolicy = false;
  bool _onTapPrivacyPolicyBtn = false;

  bool get obscure => _obscure;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  bool get rememberMe => _rememberMe;
  bool get isAgreedTermsAndConditions => _isAgreedTermsAndConditions;
  bool get isAgreedPrivacyPolicy => _isAgreedPrivacyPolicy;

  void toggleTermsAndConditions(bool value) {
    _isAgreedTermsAndConditions = value;
    notifyListeners();
  }

  void togglePrivacyPolicy(bool value) {
    _isAgreedPrivacyPolicy = value;
    notifyListeners();
  }

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
