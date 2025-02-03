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
        statusCode: 400,
        body: err.toString(),
      );
    }
  }
}
