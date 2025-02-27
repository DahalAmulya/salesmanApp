import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MrAdminAreaReportProvider extends ChangeNotifier {

  List<String> _country = ['Nepal', 'India'];
  String _defaultValue = 'Nepal';
  List<dynamic> _districtList = [];
  List<dynamic> _searchResult = [];

  final _stateTextEditingController = TextEditingController();
  final _districtTextEditingController = TextEditingController();
  final _cityTextEditingController = TextEditingController();
  final _searchController = TextEditingController();

  TextEditingController get stateTextEditingController => _stateTextEditingController;
  TextEditingController get districtTextEditingController => _districtTextEditingController;
  TextEditingController get cityTextEditingController => _cityTextEditingController;

  TextEditingController get searchController => _searchController;

  List<String> get country => _country;

  List<dynamic> get districtList => _districtList;
  List<dynamic> get searchResult => _searchResult;

  String get defaultValue => _defaultValue;


  void getDataForDistrict() async {
    final respose = await rootBundle.loadString('assets/district.json');
    print(respose.runtimeType);
    List<dynamic> districtData = json.decode(respose);
    // print(districtData);
    _districtList = districtData;
  }

  void setCountry(value){
    _defaultValue = value;
    notifyListeners();
  }
  void searchAddressResult(String enteredKeyWord, List<dynamic> addressList) {
    _searchResult = addressList;
    if (enteredKeyWord.isEmpty) {
      _searchResult = addressList;
    } else {
      try {
        if (addressList[0] is String) {
          print('List of cities');
          _searchResult = addressList
              .where((city) => city
              .toString()
              .toLowerCase()
              .contains(enteredKeyWord.toLowerCase()))
              .toList();
        } else if (addressList[0].containsKey('district')) {
          print('List of district');
          _searchResult = addressList
              .where((district) => district['district']
              .toString()
              .toLowerCase()
              .contains(enteredKeyWord.toLowerCase()))
              .toList();
        } else if (addressList[0].containsKey('states')) {
          print('List of states');
          _searchResult = addressList
              .where((states) => states['states']
              .toString()
              .toLowerCase()
              .contains(enteredKeyWord.toLowerCase()))
              .toList();
        }
      } catch (err) {
        print('Error as $err');
      }
    }
    // print(enteredKeyWord);
    print('search result = $_searchResult');
    // _searchController.text = '';
    notifyListeners();
  }

}