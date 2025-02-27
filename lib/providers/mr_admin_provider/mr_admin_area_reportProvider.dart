import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MrAdminAreaReportProvider extends ChangeNotifier {

  List<String> _country = ['Nepal', 'India'];
  String _defaultValue = 'Nepal';

  String _selectedDistrict = '';
  String _selectedState = '';
  String _selectedCity = '';

  List<dynamic> _districtList = [];
  List<dynamic> _stateList = [];
  List<dynamic> _cityList = [];
  List<dynamic> _cities = [];
  List<dynamic> _districts = [];
  List<dynamic> _foundCities = [];
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
  List<dynamic> get stateList => _stateList;
  List<dynamic> get cityList => _cityList;
  List<dynamic> get districts => _districts;
  List<dynamic> get foundCities => _foundCities;
  List<dynamic> get cities => _cities;

  List<dynamic> get searchResult => _searchResult;

  String get defaultValue => _defaultValue;

  String get selectedDistrict => _selectedDistrict;
  String get selectedState => _selectedState;
  String get selectedCity => _selectedCity;


  void getDataForDistrict() async {
    final respose = await rootBundle.loadString('assets/district.json');
    print(respose.runtimeType);
    List<dynamic> districtData = json.decode(respose);
    // print(districtData);
    _districtList = districtData;
  }

  void getCities(List<dynamic> citiesList) {
    _cityList = citiesList;
    notifyListeners();
  }

  void setCountry(value){
    _defaultValue = value;
    notifyListeners();
  }

  void setSelectedDistrict(value){
    _selectedDistrict = value;
    _districtTextEditingController.text = _selectedDistrict;
    notifyListeners();
  }
  void setSelectedState(value) {
    _selectedState = value;
    _stateTextEditingController.text = _selectedState;
    notifyListeners();
  }

  void setSelectedCity(value) {
    _selectedCity = value;
    _cityTextEditingController.text = _selectedCity;
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

  void getCitiesForSelection(
      String selectedItem,
      ) {
    // Clear the previous list of cities
    _foundCities.clear();

    // Search for the state in the stateList
    for (var stateData in _stateList) {
      if (stateData["states"] == selectedItem) {
        // Extract the cities list
        _foundCities = List<String>.from(stateData["cities"] ?? []);
        print("Found Cities for State: $_foundCities");
        break; // Exit the loop once the state is found
      }
    }

    // Search for the district in the districtList
    for (var districtData in _districts) {
      if (districtData["district"] == selectedItem) {
        // Extract the cities list
        _foundCities = List<String>.from(districtData["cities"] ?? []);
        break; // Exit the loop once the district is found
      }
    }
    notifyListeners();

    // Print the result for debugging
    // print("Cities for $selectedItem: $foundCities");
  }

}