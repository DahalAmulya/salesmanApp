// import 'dart:convert';
//
// import 'package:deskgoo/consts.dart';
// import 'package:deskgoo/routes/route_generator_constants.dart';
// import 'package:deskgoo/services/erp_services.dart';
// import 'package:deskgoo/themes/custom_colors.dart';
// import 'package:deskgoo/utils/toast_message.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// Future<bool> isTokenExpired(context) async {
//   bool tokenExpired = true;
//   print('Checking if token is expired');
//   ERPResponse response = await ERPServices.getRequest('/hello');
//   print(response.statusCode);
//   print(response.statusCode);
//   print(response.body);
//   if (response.statusCode == 200) {
//     print(response.body);
//     tokenExpired = false;
//   } else {
//     print(response.statusCode);
//     Map<String, dynamic> data = jsonDecode(response.body);
//     if (data['customCode'] == 10) {
//       ERPResponse response = await ERPServices.postRequest(
//           '/refreshToken', {"_id": userId, "refreshToken": refreshToken});
//       if (response.statusCode == 200) {
//         accessToken = data['accessToken'];
//         tokenExpired = false;
//       } else {
//         Navigator.of(context).pushNamed(MarketingManagerConstants.indexPage);
//         ToastMessageUtils().showToastMessage(
//             'Session expired', ToastGravity.TOP, CustomColors.lightRed);
//         tokenExpired = true;
//       }
//     } else {
//       Navigator.of(context).pushNamed(MarketingManagerConstants.indexPage);
//       ToastMessageUtils().showToastMessage(
//           'Session expired', ToastGravity.TOP, CustomColors.lightRed);
//       tokenExpired = true;
//     }
//   }
//   return tokenExpired;
// }
