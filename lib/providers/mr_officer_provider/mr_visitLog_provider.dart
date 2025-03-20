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

  void getVisitLogs(context) async {
    DateTime now = DateTime.now();
    String date = now.toString().split(' ')[0];
    _selectedDate = selectedDate.isEmpty ? date : _selectedDate;
    // String from = _selectedDate;
    // String to = _selectedDate;
    print('selectedDate = ${_selectedDate}');
    ERPResponse response = await ERPServices.getRequest(
        '/visitLogs?visitLogId=$userId&from=$_selectedDate&to=$_selectedDate', context);
    print(response.statusCode);
    print(response.body);
    Map<String, dynamic> body = jsonDecode(response.body);
    if (body["visitLogs"].containsKey('visitLogs')) {
      _visitLogs = body["visitLogs"]["visitLogs"];
    } else {
      _visitLogs = [];
    }
    print(_visitLogs);
    notifyListeners();
  }
}
