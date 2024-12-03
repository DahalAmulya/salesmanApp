import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


class WeeklyPlanProvider with ChangeNotifier{
  // void setList(){
  //   var districtData = readDistrict();
  //   districtData.loadData();
  //
  // }
  bool _isOpen = false;
  bool _isVisible = false;
  bool _isVisibleForState = false;
  bool _isVisibleForDistrict = false;
  bool _isVisibleForDistrictList = false;
  bool _isVisibleForStateList = false;
  DateTime? _SelectedDate = DateTime.now();
  DateTime? get selectedDate => _SelectedDate;
  List<String> _country = ['Nepal', 'India'];
  List<String> _states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chattisgarh',
    'Goa',
    'Gujrat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bangal',
  ];
  List<String> _districts = [
    'Achham',
    'Arghakhanchi',
    'Baglung',
    'Baitadi',
    'Bajhang',
    'Bajura',
    'Banke',
    'Bara',
    'Bardiya',
    'Bhaktapur',
    'Bhojpur',
    'Chitwan',
    'Dadeldhura',
    'Dailekh',
    'Dang',
    'Darchula',
    'Dhading',
    'Dhankuta',
    'Dhanusha',
    'Dolakha',
    'Dolpa',
    'Doti',
    'Eastern Rukum',
    'Gorkha',
    'Gulmi',
    'Humla',
    'Ilam',
    'Jajarkot',
    'Jhapa',
    'Jumla',
    'Kailali',
    'Kalikot',
    'Kanchanpur',
    'Kapilvastu',
    'Kaski',
    'Kathmandu',
    'Kavrepalanchok',
    'khotang',
    'Lalitpur',
    'Lamjung',
    'Mahottari',
    'Makwanpur',
    'Manang',
    'Morang',
    'Mugu',
    'Mustang',
    'Myagdi',
    'Nawalparasi(East of Bardaghat Susta)',
    'Nawalparasi(West of Bardaghat Susta)',
    'Nuwakot',
    'Okhaldhunga',
    'Palpa',
    'Panchathar',
    'Parbat',
    'Parsa',
    'Pyuthan',
    'Ramechhap',
    'Rasuwa',
    'Rautahat',
    'Rolpa',
    'Rupandehi',
    'Salyan',
    'Sankhuwasabha',
    'Saptari',
    'Sarlahi',
    'Sindhuli',
    'Sindhupalchok',
    'Siraha',
    'Solukhumbu',
    'Sunsari',
    'Surkhet',
    'Syangja',
    'Tanahun',
    'Taplejung',
    'Tehrathum',
    'Udayapur',
    'Western Rukum',
  ];
  List<String> _districtList = [];
  List<String> _foundStates = [];
  List<String> _foundDistrict = [];
  String _selectedCountry = '';
  int _selectedIndex  = 0;

  TextEditingController _stateTextEditingController = TextEditingController();
  TextEditingController _districtTextEditingController = TextEditingController();


  bool get isOpen => _isOpen;
  bool get isVisible => _isVisible;
  bool get isVisibleForState => _isVisibleForState;
  bool get isVisibleForDistrict => _isVisibleForDistrict;
  bool get isVisibleForDistrictList => _isVisibleForDistrictList;
  bool get isVisibleForStateList => _isVisibleForStateList;
  String get selectedCountry => _selectedCountry;
  List<String> get country => _country;
  List<String> get states => _states;
  List<String> get districts => _districts;
  List<String> get foundStates => _foundStates;
  List<String> get foundDistrict => _foundDistrict;
  List<String> get districtList => _districtList;
  int get selectedIndex => _selectedIndex;

  TextEditingController get stateTextEditingController => _stateTextEditingController;
  TextEditingController get districtTextEditingController => _districtTextEditingController;

  WeeklyPlanProvider (){
    _foundStates = _states.where((state) => state.toLowerCase().contains('A'.toLowerCase())).toList();
    _foundDistrict = _districts.where((district) => district.toLowerCase().contains('A'.toLowerCase())).toList();
    // _foundDistrict = _districts.where((district) => district.toString().toLowerCase().toList();

  }


  //
  // void setDistrictList(){
  //   // _districtList =
  //   // _districtList = setList();
  // }

  void setDropDownValue(newValue){
    _selectedCountry = newValue;
    if (selectedCountry == _country[0]) {

      print('nepal');

    } if(selectedCountry == _country[1]){
      _isVisibleForState = !_isVisibleForState;
      _isVisibleForStateList = !_isVisibleForStateList;
      _isVisibleForDistrict = false;
      notifyListeners();
    }
  }

  void setStateList(){
    _isVisibleForStateList = true;
    notifyListeners();
  }

  void setDistrictList(){
    _isVisibleForDistrictList = true;
    _isVisibleForStateList = false;
    notifyListeners();
  }

  void setSelectedDate(newDate) {
    _SelectedDate = newDate;
    notifyListeners();
  }
  void setIndex(newIndex){
    _selectedIndex = newIndex;
    notifyListeners();
  }

  String formattedDateTime (){
    return DateFormat('y/MM/dd,EEEE').format(DateTime.now());
  }
  String getFormattedDate({String format = 'dd MMM y, EE'}) {
    if (selectedDate == null) {
      return 'No Date Selected';
    }
    return DateFormat(format).format(selectedDate!);
  }

   void runStateSearchFilter(String enteredKeyword){
     List<String> stateResult = [];
     if (enteredKeyword.isEmpty) {
       stateResult = _states;
     } else {
       stateResult = _states
           .where((state) => state
           .toString()
           .toLowerCase()
           .contains(enteredKeyword.toLowerCase()))
           .toList();
     }
       _foundStates = stateResult;
     notifyListeners();

   }

   void runDistrictSearchFilter(String enteredKeyword){
       List<String> districtResult = [];
       if (enteredKeyword.isEmpty) {
         districtResult = _districts;
       } else {
         districtResult = districts
             .where((district) => district
             .toString()
             .toLowerCase()
             .contains(enteredKeyword.toLowerCase()))
             .toList();
       }
         _foundDistrict = districtResult;
       notifyListeners();
   }
}

// class readDistrict{
//   Future<List<Map<String, dynamic>>> readDistrictJson() async {
//     // Load the JSON file from the assets
//     final String response = await rootBundle.loadString('assets/district.json');
//
//     // Decode the JSON into a List of Maps
//     final List<dynamic> data = json.decode(response);
//     return List<Map<String, dynamic>>.from(data);
//   }
//   void loadData() async {
//     final districts = await readDistrictJson();
//     for(int i = 0; i < districts.length; i ++){
//      print(districts[i]['district']);
//      // print(districts);
//     }
//   }
//
// }

