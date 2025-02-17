import 'dart:convert';

import 'package:deskgoo/consts.dart';
import 'package:http/http.dart' as http;

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

  static Future<ERPResponse> getRequest(String path) async {
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
      print(response.body);
      print(response.statusCode);
      return ERPResponse(
        statusCode: response.statusCode,
        body: response.body,
      );
    } catch (err) {
      return ERPResponse(statusCode: 69, body: err.toString());
    }
  }

  static Future<ERPResponse> postRequest(String path, Map body) async {
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
      // if (response.statusCode == 403) {
      //   Map<String, dynamic> data = jsonDecode(response.body);
      //   if (data['customCode'] == 11) {
      //     Navigator.of(context).pushNamed(MarketingManagerConstants.indexPage);
      //     ToastMessageUtils().showToastMessage(
      //         'Session Expired', ToastGravity.TOP, CustomColors.lightRed);
      //   } else if (data['customCode'] == 10) {
      //     final response = await http.post(
      //       Uri.parse('$apiURL$path'),
      //       headers: {'Content-Type': 'Application/json'},
      //       body: jsonEncode({"_id": userId, "refreshToken": refreshToken}),
      //     );
      //     Map<String, dynamic> decodedBody = jsonDecode(response.body);
      //     if (response.statusCode == 200) {
      //       accessToken = decodedBody['accessToken'];
      //     } else if (response.statusCode == 403) {
      //       Navigator.of(context)
      //           .pushNamed(MarketingManagerConstants.indexPage);
      //       ToastMessageUtils().showToastMessage(
      //           'Session Expired', ToastGravity.TOP, CustomColors.lightRed);
      //     }
      //   }
      // }
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
