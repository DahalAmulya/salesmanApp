import 'dart:convert';

import 'package:deskgoo/consts.dart';
import 'package:deskgoo/pages/mr_officers_pages/mr_officers_visits/model/poc_create_model.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:deskgoo/utils/toast_message.dart';
import 'package:flutter/material.dart';

import '../../services/database_service.dart';

class MrOfficeVisitLogProvider extends ChangeNotifier {
  List<dynamic> _visitLogs = [];
  List<String> _dateList = ["Today", "Yesterday", "Custom", "Offline Visit"];
  String _defaultValue = "Today";
  String _selectedDate = DateTime.now().toString().split(' ')[0];
  bool _isVisible = false;
  final DatabaseService _dbService = DatabaseService.instance;
  List<PocModel> _offlinePoc = [];
  bool _isOffline = false;

  List<dynamic> get visitLog => _visitLogs;
  String get selectedDate => _selectedDate;
  List<String> get dateList => _dateList;
  String get defaultValue => _defaultValue;
  bool get isVisible => _isVisible;
  bool get isOffline => _isOffline;
  List<PocModel> get offlinePoc => _offlinePoc;

  void setIsOffline(bool value) async {
    _isOffline = value;
    if(_isOffline == true){
      _defaultValue = _dateList[3];
      _visitLogs.clear();
      offlinePoc.clear();
      _offlinePoc = await _dbService.getAllPOCs();
    } else {
      debugPrint('VisitLog Offline mode = $_isOffline');
      _defaultValue = _dateList[0];
      _visitLogs.clear();
      _offlinePoc.clear();
    }
    notifyListeners();
  }

  void setSelectedDate(String date) {
    _selectedDate = date;
    notifyListeners();
  }

  Future<void> selectDate(
      BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
    );
    if (picked == null) {
      return;
    } else {
        _selectedDate = "${picked.year}-${picked.month}-${picked.day}";
        setSelectedDate(selectedDate);
    }
    print(_selectedDate);
    getVisitLogs(context);
    notifyListeners();
  }

  void updateSelectedDate(String newValue, context) async {
      _selectedDate = newValue;
      debugPrint('Selected Date updated to: $_selectedDate');
      if(_selectedDate == _dateList[3]){
        debugPrint('Offline Visit');
        _visitLogs.clear();
        _offlinePoc.clear();
        _offlinePoc = await _dbService.getAllPOCs();
        debugPrint('offlinePoc length: ${_offlinePoc.length}');
        if(_offlinePoc.length == 0){
          ToastMessageUtils().showToastMessage('No Offline Visits found');
        }
        notifyListeners();
        return;
      }

      if (_selectedDate == "Today") {
        _selectedDate =
        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
        setSelectedDate(selectedDate.toString().split(" ")[0]);
        getVisitLogs(context);
      }
      if (_selectedDate == "Yesterday") {
        DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
        _selectedDate = "${yesterday.year}-${yesterday.month}-${yesterday.day}";
        setSelectedDate(yesterday.toString().split(" ")[0]);
        getVisitLogs(context);
      }
      if(_selectedDate == "Custom"){
        // Open date picker for custom date selection
        selectDate(context);
      }
      print("Selected Date: $selectedDate");
      // notifyListeners();
    // });
  }

  void getVisitLogs(BuildContext context) async {
    try {
      _offlinePoc.clear();
      DateTime now = DateTime.now();
      String date = now.toString().split(' ')[0];
      debugPrint('Before _selectedDate before API call: $_selectedDate');
      _selectedDate = selectedDate.isEmpty ? date : _selectedDate;
      debugPrint('After _selectedDate before API call: $_selectedDate');

      ERPResponse response = await ERPServices.getRequest(
        '/visitLogs?visitLogId=$userId&from=$_selectedDate&to=$_selectedDate',
        context,
      );

      Map<String, dynamic> body = jsonDecode(response.body);

      print(body);

      // Defensive parsing
      if (body["visitLogs"] is Map &&
          body["visitLogs"].containsKey("visitLogs")) {
        _visitLogs = body["visitLogs"]["visitLogs"];
      } else if (body["visitLogs"] is List) {
        // If the API just returns an empty list
        _visitLogs = [];
        _visitLogs.clear();
      } else {
        _visitLogs = [];
        _visitLogs.clear();
      }
      notifyListeners();
    } catch (err) {
      ToastMessageUtils().showToastMessage(
          'No Internet Connection. Please check your connection and try again.');
      debugPrint('Error in getVisitLogs: $err');
      return;
    }
  }
}
