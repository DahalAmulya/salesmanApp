import 'dart:convert';

import 'package:deskgoo/consts.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:flutter/material.dart';

class MrOfficeVisitLogProvider extends ChangeNotifier {
  List<dynamic> _visitLogs = [];
  String _selectedDate = DateTime.now().toString().split(' ')[0];

  List<dynamic> get visitLog => _visitLogs;
  String get selectedDate => _selectedDate;

  void setSelectedDate(String date) {
    _selectedDate = date;
    notifyListeners();
  }

  void getVisitLogs(String logDate) async {
    DateTime now = DateTime.now();
    String date = now.toString().split(' ')[0];
    logDate = selectedDate.isEmpty ? date : logDate;
    String from = '${_selectedDate} 00:00:00';
    String to = '${date} 23:59:59';
    ERPResponse response = await ERPServices.getRequest(
        '/visitLogs?visitLogId=$userId&from=$from&to=$to');
    Map<String, dynamic> body = jsonDecode(response.body);
    _visitLogs = body["visitLogs"]["visitLogs"];
    print(response.statusCode);
    print(_visitLogs);
    notifyListeners();
  }
}
