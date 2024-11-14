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

class ERPServicer {
  static Map<String, String> headersJson = {
    'Content-Type': 'Application/json',
  };

  static Map<String, String> headersFromUrlencoded = {
    'Content-Type': 'Application/x-www-form-urlencoded',
  };

  static Future<ERPResponse> getRequest(String path, [String? extras]) async {
    String extraPath = extras ?? '';
    try {
      final response = await http.get(
        Uri.parse('$apiURL$path$extraPath'),
        headers: headersJson,
      );
      return ERPResponse(
        statusCode: response.statusCode,
        body: response.body,
      );
    } catch (err) {
      return ERPResponse(statusCode: 69, body: err.toString());
    }
  }

  static Future<ERPResponse> postRequest(String path, Map body,
      [String? extras]) async {
    String extraPath = extras ?? '';
    try {
      final response = await http.post(
        Uri.parse('$apiURL$path$extraPath'),
        headers: headersJson,
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

  static Future<ERPResponse> ERPlogin(Map<String, dynamic> body) async {
    try {
      String url = '$apiURLFrappe/method/login';
      final encodedBody = body.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');

      print(encodedBody.runtimeType);

      final response = await http.post(
        Uri.parse(url),
        headers: headersFromUrlencoded,
        body: encodedBody,
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
