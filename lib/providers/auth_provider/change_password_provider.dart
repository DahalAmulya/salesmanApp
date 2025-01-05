import 'dart:ffi';

import 'package:flutter/material.dart';

class ChangePasswordProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  bool _oldPasswordObscure = true;
  bool _newPasswordObscure = true;
  bool _newConfirmPasswordObscure = true;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _newConfirmPasswordController = TextEditingController();
  String oldPassword = '';

  // GlobalKey get formKey => _formKey;
  bool get oldPasswordObscure => _oldPasswordObscure;
  bool get newPasswordObscure => _newPasswordObscure;
  bool get newConfirmPasswordObscure => _newConfirmPasswordObscure;
  TextEditingController get oldPasswordController => _passwordController;
  TextEditingController get newPasswordController => _newPasswordController;
  TextEditingController get newConfirmPasswordController =>
      _newConfirmPasswordController;

  void toggleOldPasswordObscure() {
    _oldPasswordObscure = !_oldPasswordObscure;
    notifyListeners();
  }

  void toggleNewPasswordObscure() {
    _newPasswordObscure = !_newPasswordObscure;
    notifyListeners();
  }

  void toggleNewConfirmPasswordObscure() {
    _newConfirmPasswordObscure = !_newConfirmPasswordObscure;
    notifyListeners();
  }

  void onSubmit() {
    if (formKey.currentState!.validate()) {
      print('Form is valid');
    } else {
      print('Form is not valid');
    }
  }
}
