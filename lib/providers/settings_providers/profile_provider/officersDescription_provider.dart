import 'dart:core';

import 'package:flutter/foundation.dart';

class DetailsProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _marketingOfficersDetails = [
    {
      "OfficerName": "Rahul",
      "target": 20,
      "achieved": 10,
      "Visit Status": "Visited Other"
    },
    {
      "OfficerName": "Shuvam",
      "target": 20,
      "achieved": 6,
      "Visit Status": "Visited"
    },
    {
      "OfficerName": "Ram",
      "target": 20,
      "achieved": 9,
      "Visit Status": "Visited On Progress"
    },
    {
      "OfficerName": "Hari",
      "target": 20,
      "achieved": 4,
      "Visit Status": "Visited"
    },
    {
      "OfficerName": "Rajan",
      "target": 20,
      "achieved": 13,
      "Visit Status": "Not Visited"
    },
    {
      "OfficerName": "Raja",
      "target": 20,
      "achieved": 19,
      "Visit Status": "Visited"
    },
    {
      "OfficerName": "Rajesh",
      "target": 20,
      "achieved": 16,
      "Visit Status": "Visited On Progress"
    }
  ];

  List<Map<String, dynamic>> get marketingOfficersDetails =>
      _marketingOfficersDetails;

  void setMarketingOfficersDetails() {
    _marketingOfficersDetails = marketingOfficersDetails;
    notifyListeners();
  }
}
