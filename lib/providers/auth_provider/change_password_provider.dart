import 'dart:convert';
import 'dart:ffi';

import 'package:deskgoo/services/erp_services.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/utils/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  void onSubmit(context) {
    resetPassword(context);
    // if (formKey.currentState!.validate()) {
    //   print('Form is valid');
    // } else {
    //   ToastMessageUtils()
    //       .showToastMessage('Form is not valid', ToastGravity.BOTTOM);
    //   print('Form is not valid');
    // }
  }

  void resetPassword(context) async {
    Map<String, dynamic> body = {
      'email': 'farhan@example.com',
      'password': newPasswordController.value.text,
      'confirmPassword': newConfirmPasswordController.value.text,
    };
    ERPResponse response =
        await ERPServicer.postRequest('/resetPassword', body);
    final data = jsonDecode(response.body);
    print(body);
    if (response.statusCode == 200) {
      ToastMessageUtils().showToastMessage('Password changed successfully',
          ToastGravity.TOP, CustomColors.jadeGreen);
      Navigator.pop(context);
    } else {
      ToastMessageUtils().showToastMessage(data['message']);
    }
  }
}
