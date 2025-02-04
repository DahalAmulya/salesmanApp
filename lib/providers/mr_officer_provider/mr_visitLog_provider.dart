import 'dart:convert';

import 'package:deskgoo/consts.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:flutter/material.dart';

class MrOfficeVisitLogProvider extends ChangeNotifier {
  List<dynamic> _visitLogs = [];
  List<dynamic> get visitLog => _visitLogs;

  void getVisitLogs() async {
    DateTime now = DateTime.now();
    String date = now.toString().split(' ')[0];
    String from = '${date} 00:00:00';
    String to = '${date} 23:59:59';
    ERPResponse response = await ERPServices.getRequest(
        '/visitLogs?visitLogId=$userId&from=$from&to=$to');
    Map<String, dynamic> body = jsonDecode(response.body);
    _visitLogs = body["visitLogs"]["visitLogs"];
    print(response.statusCode);
    print(_visitLogs);
  }
}
