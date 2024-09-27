import 'dart:convert';

import 'package:http/http.dart' as http;

class ERPResponse {
  final int statusCode;
  final String body;
  // final Map<String, dynamic>? body;

  ERPResponse({
    required this.statusCode,
    required this.body,
    // this.bodies,
  });
}

class ERPServicer {
  static final String apiURL = 'http://108.181.195.185:5000/api/';
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
      return ERPResponse(statusCode: 0, body: err.toString());
    }
  }
}
