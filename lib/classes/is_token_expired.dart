import 'dart:convert';

import 'package:deskgoo/consts.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/utils/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool> isTokenExpired(context) async {
  ERPResponse response = await ERPServices.getRequest('/testHello');
  if (response.statusCode == 200) {
    return true;
  } else if (response.statusCode == 403) {
    Map<String, dynamic> data = jsonDecode(response.body);
    if (data['customCode'] == 10) {
      ERPResponse response = await ERPServices.postRequest(
          '/refreshToken', {"_id": userId, "refreshToken": refreshToken});
      if (response.statusCode == 200) {
        refreshToken = data['accessToken'];
        return true;
      } else {
        Navigator.of(context).pushNamed(MarketingManagerConstants.indexPage);
        ToastMessageUtils().showToastMessage(
            'Session expired', ToastGravity.TOP, CustomColors.lightRed);
        return false;
      }
    } else {
      Navigator.of(context).pushNamed(MarketingManagerConstants.indexPage);
      ToastMessageUtils().showToastMessage(
          'Session expired', ToastGravity.TOP, CustomColors.lightRed);
    }
    return false;
  } else {
    return true;
  }
}
