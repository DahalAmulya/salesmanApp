import 'dart:convert';

import 'package:deskgoo/consts.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../themes/custom_colors.dart';
import '../utils/toast_message.dart';

class ERPResponse {
  final int statusCode;
  final String body;

  ERPResponse({
    required this.statusCode,
    required this.body,
  });
}

class ERPServices {
  static Map<String, String> headersFromUrlencoded = {
    'Content-Type': 'Application/x-www-form-urlencoded',
  };

  static Future<ERPResponse> getRequest(String path, context) async {
    print('$apiURL$path');
    try {
      Map<String, String> header = {
        'Content-Type': 'Application/json',
        'Authorization': 'Bearer $accessToken',
        '_id': userId
      };
      final response = await http.get(
        Uri.parse('$apiURL$path'),
        headers: header,
      );
      if(response.statusCode == 403){
        ToastMessageUtils().showToastMessage(
            'Session Expired', ToastGravity.TOP, CustomColors.lightRed);
        Navigator.of(context).popAndPushNamed(MarketingManagerConstants.indexPage);
      }
      return ERPResponse(
        statusCode: response.statusCode,
        body: response.body,
      );
    } catch (err) {
      return ERPResponse(statusCode: 69, body: err.toString());
    }
  }

  static Future<ERPResponse> postRequest(String path, final body, context) async {
    try {
      Map<String, String> header = {
        'Content-Type': 'Application/json',
        'Authorization': 'Bearer $accessToken',
        '_id': userId
      };
      final response = await http.post(
        Uri.parse('$apiURL$path'),
        headers: header,
        body: jsonEncode(body),
      );
      if(response.statusCode == 403){
        ToastMessageUtils().showToastMessage(
                  'Session Expired', ToastGravity.TOP, CustomColors.lightRed);
        Navigator.of(context).pop(MarketingManagerConstants.indexPage);
      }
      return ERPResponse(
        statusCode: response.statusCode,
        body: response.body,
      );
    } catch (err) {
      return ERPResponse(
        statusCode: 69,
        body: err.toString(),
      );
    }
  }

  static Future<ERPResponse> putRequest(String path, final body, context) async {
    try {
      Map<String, String> header = {
        'Content-Type': 'Application/json',
        'Authorization': 'Bearer $accessToken',
        '_id': userId
      };
      final response = await http.put(
        Uri.parse('$apiURL$path'),
        headers: header,
        body: jsonEncode(body),
      );
      if(response.statusCode == 403){
        ToastMessageUtils().showToastMessage(
                  'Session Expired', ToastGravity.TOP, CustomColors.lightRed);
        Navigator.of(context).pop(MarketingManagerConstants.indexPage);
      }
      return ERPResponse(
        statusCode: response.statusCode,
        body: response.body,
      );
    } catch (err) {
      return ERPResponse(
        statusCode: 69,
        body: err.toString(),
      );
    }
  }

  static Future<ERPResponse> ERPlogin(Map<String, dynamic> body) async {
    try {
      String url = '$apiURL/auth';
      // final encodedBody = body.entries
      //     .map((e) =>
      //         '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      //     .join('&');

      // print(encodedBody.runtimeType);
      Map<String, String> header = {
        'Content-Type': 'Application/json',
      };
      final response = await http.post(
        Uri.parse(url),
        headers: header,
        body: jsonEncode(body),
      );

      return ERPResponse(
        statusCode: response.statusCode,
        body: response.body,
      );
    } catch (err) {
      return ERPResponse(
        statusCode: 69,
        body: err.toString(),
      );
    }
  }
}
