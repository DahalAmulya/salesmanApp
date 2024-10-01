import 'dart:core';

import 'package:flutter/foundation.dart';

class DetailsProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _marketingOfficersDetails = [
    {
      "OfficerName": "Rahul Sharma",
      "target": 20,
      "achieved": 10,
      "Visit Status": "Visited Other",
      'batteryLevel': 33,
      'connectivityType': 'wifi',
      'totalTravel': 30,
    },
    {
      "OfficerName": "Sudip Kumar Jha",
      "target": 20,
      "achieved": 6,
      "Visit Status": "Visited",
      'batteryLevel': 85,
      'connectivityType': 'mobile',
      'totalTravel': 14,
    },
    {
      "OfficerName": "Ram Baral",
      "target": 20,
      "achieved": 9,
      "Visit Status": "Visited On Progress",
      'batteryLevel': 90,
      'connectivityType': 'mobile',
      'totalTravel': 9,
    },
    {
      "OfficerName": "Hari Adhakari",
      "target": 20,
      "achieved": 4,
      "Visit Status": "Visited",
      'batteryLevel': 60,
      'connectivityType': 'wifi',
      'totalTravel': 25,
    },
    {
      "OfficerName": "Bibek Chaudhary",
      "target": 20,
      "achieved": 13,
      "Visit Status": "Not Visited",
      'batteryLevel': 45,
      'connectivityType': 'mobile',
      'totalTravel': 22,
    },
    {
      "OfficerName": "Saroj Shrestha",
      "target": 20,
      "achieved": 19,
      "Visit Status": "Visited",
      'batteryLevel': 55,
      'connectivityType': 'mobile',
      'totalTravel': 17,
    },
    {
      "OfficerName": "Jay Prakash Niraula",
      "target": 20,
      "achieved": 16,
      "Visit Status": "Visited On Progress",
      'batteryLevel': 70,
      'connectivityType': 'wifi',
      'totalTravel': 15,
    }
  ];

  List<Map<String, dynamic>> get marketingOfficersDetails =>
      _marketingOfficersDetails;

  void setMarketingOfficersDetails() {
    _marketingOfficersDetails = marketingOfficersDetails;
    notifyListeners();
  }
}
