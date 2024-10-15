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
  static Map<String, String> headers = {
    'Content-Type': 'Application/json',
  };

  static Future<ERPResponse> getRequest(String path, [String? extras]) async {
    String extraPath = extras ?? '';
    try {
      final response = await http.get(
        Uri.parse('$apiURL$path$extraPath'),
        headers: headers,
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
        headers: headers,
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
