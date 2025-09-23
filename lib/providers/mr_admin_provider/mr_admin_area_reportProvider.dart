import 'dart:convert';

import 'package:deskgoo/services/erp_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MrAdminAreaReportProvider extends ChangeNotifier {

  List<String> _countryList = [
    'Nepal',
    'India',
  ];
  List<dynamic> _districts = [];
  List<dynamic> _stateList = [];
  List<dynamic> _searchResult = [];
  List<String> _foundDistrictList = [];
  List<String> _foundStateList = [];
  List<String> _foundCities = [];
  List<dynamic> _cities = [];
  String _selectedRegion = '';
  String _selectedCities = '';
  String _selectedState = '';
  String _selectVisitTypeByAddress = 'Country';
  String _selectedCountry = 'Nepal';
  String _selectedDistrict = 'Morang';
  String _selectedStates = 'Andhra Pradesh';
  String _selectedCity = 'Biratnagar';

  TextEditingController _fromTextEditingController = TextEditingController();
  TextEditingController _toTextEditingController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _districtController = TextEditingController();
  TextEditingController _stateController = TextEditingController();

  TextEditingController get searchController => _searchController;
  TextEditingController get cityController => _cityController;
  TextEditingController get districtController => _districtController;
  TextEditingController get stateController => _stateController;

  List<dynamic> get districts => _districts;
  List<dynamic> get stateList => _stateList;
  List<dynamic> get searchResult => _searchResult;
  List<String> get foundCities => _foundCities;
  List<String> get foundDistrictList => _foundDistrictList;
  List<String> get foundStateList => _foundStateList;
  List<String> get countryList => _countryList;
  List<dynamic> get cities => _cities;
  String get selectedCountry => _selectedCountry;
  String get selectedDistrict => _selectedDistrict;
  String get selectedStates => _selectedStates;
  String get selectedCity => _selectedCity;
  String get selectedCities => _selectedCities;
  String get selectedState => _selectedState;
  String get selectedRegion => _selectedRegion;

  void setSelectedCountry(newValue) {
    _selectedCountry = newValue;
    notifyListeners();
  }

  void setSelectedDistrict(value) {
    _selectedRegion = value;
    _districtController.text = _selectedRegion;
    notifyListeners();
  }

  void setSelectedState(value) {
    _selectedRegion = value;
    _stateController.text = _selectedRegion;
    notifyListeners();
  }

  void getCities(List<dynamic> citiesList) {
    _cities = citiesList;
    notifyListeners();
  }

  void setSelectedCity(value) {
    _selectedCities = value;
    _cityController.text = _selectedCities;
    notifyListeners();
  }

  void searchAddressResult(String enteredKeyWord, List<dynamic> addressList) {
    print("AddressList = $addressList");
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
        _foundCities = List<String>.from(districtData["cities"] ?? []);
        break;
      }
    }
    notifyListeners();
  }

  void getAreaReport(context) async {
    ERPResponse response = await ERPServices.getRequest('/poc/area$_selectedCountry$_selectedCity', context);
    print(response.body);
    print(response.statusCode);
  }

  // New Area Report Method and Variables

  bool _showFilter = true;
  bool get showFilter => _showFilter;

  void toggleFilter() {
    _showFilter = !_showFilter;
    notifyListeners();
  }

  void setSelectedVisitTypeByAddress(String value) {
    _selectVisitTypeByAddress = value;
    notifyListeners();
  }

}