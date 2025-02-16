import 'package:deskgoo/services/erp_services.dart';
import 'package:flutter/material.dart';

class MrAdminVisitLogProvider extends ChangeNotifier {
  List<dynamic> _visitLogsUsersList = [];
  List<dynamic> _visitLogsByUserId = [];
  List<String> _visitDateTypeList = ['Today', 'Yesterday', 'Custom'];
  String _selectedUserId = '';
  String _selectedVisitType = 'Today';
  TextEditingController _fromTextEditingController = TextEditingController();
  TextEditingController _toTextEditingController = TextEditingController();

  List<dynamic> get visitLogsByUser => _visitLogsUsersList;
  List<dynamic> get visitLogsByUserId => _visitLogsByUserId;
  List<String> get visitDateTypeList => _visitDateTypeList;
  String get selectedUserId => _selectedUserId;
  String get selectedVisitType => _selectedVisitType;
  TextEditingController get fromTextEditingController => _fromTextEditingController;
  TextEditingController get toTextEditingController => _toTextEditingController;

  void setSelectedVisitType(visitType) {
    _selectedVisitType = visitType;

    notifyListeners();
  }

  void getVisitLogs() async {
    ERPResponse response = await ERPServices.getRequest('/visitLogs/users');
    print(response.statusCode);
    print(response.body);
  }
}
