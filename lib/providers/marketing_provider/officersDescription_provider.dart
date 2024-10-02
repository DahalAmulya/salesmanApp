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
      'isApproved': false,
      'visitDetails': [
        {
          'clientName': 'Ram Shah',
          'address': 'Biratnagar, Airport-Road',
          'phoneNumber': '9819022062',
          'dateTime': '2022/01/15 10:30:19',
          'visitStatus': 'visited',
          'notes':
              'I visited Mr Ram Shah in the morning and he was suffering from fever.',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Rajesh Biswakarma',
          'address': 'Kathmandu, New Baneshwor',
          'phoneNumber': '9845678901',
          'dateTime': '2022/01/16 11:45:55',
          'visitStatus': 'visited',
          'notes':
              'I visited Mr Rajesh Biswakarma\'s house in the morning and he was not available',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Abhijeet Yadav ',
          'address': 'Lalitpur, Jhansi Road',
          'phoneNumber': '9876543210',
          'dateTime': '2022/01/17 12:30:40',
          'visitStatus': 'visitedOthers',
          'notes':
              'I visited Mr Abhijeet Yadav house in the afternoon and he was not available in the house his wife said me to come back tomorrow',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Rohan Bhattrai',
          'address': 'Lakeside Rd, Pokhara',
          'phoneNumber': '9898989898',
          'dateTime': '2022/01/18 01:15:35',
          'visitStatus': 'visitedOthers',
          'notes':
              'I visited Mr Abhijeet Yadav house in the afternoon and he was not available in the house his wife said me to come back tomorrow',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Milan Biswas',
          'address': 'NGO Rd, Bharatpur',
          'phoneNumber': '9874563210',
          'dateTime': '2022/01/19 02:00:19',
          'visitStatus': 'visitOnProgress',
          'notes':
              'I visited Mr Milan Biswas house in the afternoon and he was available in the house he will be visiting hospital tomorrow',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Siman Malla',
          'address': 'Milanchwok,Butwal',
          'phoneNumber': '9854321098',
          'dateTime': '2022/01/20 02:45:30',
          'visitStatus': 'notVisited',
          'notes':
              'I visited Mr Siman Malla house in the afternoon and he was not available in the house.',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
      ],
    },
    {
      "OfficerName": "Sudip Kumar Jha",
      "target": 20,
      "achieved": 6,
      "Visit Status": "Visited",
      'batteryLevel': 85,
      'connectivityType': 'mobile',
      'totalTravel': 14,
      'isApproved': false,
      'visitDetails': [
        {
          'clientName': 'Ram Shah',
          'address': 'Biratnagar, Airport-Road',
          'phoneNumber': '9819022062',
          'dateTime': '2022/01/15 10:30:19',
          'visitStatus': 'visited',
          'notes':
              'I visited Mr Ram Shah in the morning and he was suffering from fever.',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Rajesh Biswakarma',
          'address': 'Kathmandu, New Baneshwor',
          'phoneNumber': '9845678901',
          'dateTime': '2022/01/16 11:45:55',
          'visitStatus': 'visited',
          'notes':
              'I visited Mr Rajesh Biswakarma\'s house in the morning and he was not available',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Abhijeet Yadav ',
          'address': 'Lalitpur, Jhansi Road',
          'phoneNumber': '9876543210',
          'dateTime': '2022/01/17 12:30:40',
          'visitStatus': 'visitedOthers',
          'notes':
              'I visited Mr Abhijeet Yadav house in the afternoon and he was not available in the house his wife said me to come back tomorrow',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Rohan Bhattrai',
          'address': 'Lakeside Rd, Pokhara',
          'phoneNumber': '9898989898',
          'dateTime': '2022/01/18 01:15:35',
          'visitStatus': 'visitedOthers',
          'notes':
              'I visited Mr Abhijeet Yadav house in the afternoon and he was not available in the house his wife said me to come back tomorrow',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Milan Biswas',
          'address': 'NGO Rd, Bharatpur',
          'phoneNumber': '9874563210',
          'dateTime': '2022/01/19 02:00:19',
          'visitStatus': 'visitOnProgress',
          'notes':
              'I visited Mr Milan Biswas house in the afternoon and he was available in the house he will be visiting hospital tomorrow',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Siman Malla',
          'address': 'Milanchwok,Butwal',
          'phoneNumber': '9854321098',
          'dateTime': '2022/01/20 02:45:30',
          'visitStatus': 'notVisited',
          'notes':
              'I visited Mr Siman Malla house in the afternoon and he was not available in the house.',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
      ],
    },
    {
      "OfficerName": "Ram Baral",
      "target": 20,
      "achieved": 9,
      "Visit Status": "Visited On Progress",
      'batteryLevel': 90,
      'connectivityType': 'mobile',
      'totalTravel': 9,
      'isApproved': false,
      'visitDetails': [
        {
          'clientName': 'Ram Shah',
          'address': 'Biratnagar, Airport-Road',
          'phoneNumber': '9819022062',
          'dateTime': '2022/01/15 10:30:19',
          'visitStatus': 'visited',
          'notes':
              'I visited Mr Ram Shah in the morning and he was suffering from fever.',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Rajesh Biswakarma',
          'address': 'Kathmandu, New Baneshwor',
          'phoneNumber': '9845678901',
          'dateTime': '2022/01/16 11:45:55',
          'visitStatus': 'visited',
          'notes':
              'I visited Mr Rajesh Biswakarma\'s house in the morning and he was not available',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Abhijeet Yadav ',
          'address': 'Lalitpur, Jhansi Road',
          'phoneNumber': '9876543210',
          'dateTime': '2022/01/17 12:30:40',
          'visitStatus': 'visitedOthers',
          'notes':
              'I visited Mr Abhijeet Yadav house in the afternoon and he was not available in the house his wife said me to come back tomorrow',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Rohan Bhattrai',
          'address': 'Lakeside Rd, Pokhara',
          'phoneNumber': '9898989898',
          'dateTime': '2022/01/18 01:15:35',
          'visitStatus': 'visitedOthers',
          'notes':
              'I visited Mr Abhijeet Yadav house in the afternoon and he was not available in the house his wife said me to come back tomorrow',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Milan Biswas',
          'address': 'NGO Rd, Bharatpur',
          'phoneNumber': '9874563210',
          'dateTime': '2022/01/19 02:00:19',
          'visitStatus': 'visitOnProgress',
          'notes':
              'I visited Mr Milan Biswas house in the afternoon and he was available in the house he will be visiting hospital tomorrow',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Siman Malla',
          'address': 'Milanchwok,Butwal',
          'phoneNumber': '9854321098',
          'dateTime': '2022/01/20 02:45:30',
          'visitStatus': 'notVisited',
          'notes':
              'I visited Mr Siman Malla house in the afternoon and he was not available in the house.',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
      ]
    },
    {
      "OfficerName": "Hari Adhakari",
      "target": 20,
      "achieved": 4,
      "Visit Status": "Visited",
      'batteryLevel': 60,
      'connectivityType': 'wifi',
      'totalTravel': 25,
      'isApproved': false,
      'visitDetails': [
        {
          'clientName': 'Ram Shah',
          'address': 'Biratnagar, Airport-Road',
          'phoneNumber': '9819022062',
          'dateTime': '2022/01/15 10:30:19',
          'visitStatus': 'visited',
          'notes':
              'I visited Mr Ram Shah in the morning and he was suffering from fever.',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Rajesh Biswakarma',
          'address': 'Kathmandu, New Baneshwor',
          'phoneNumber': '9845678901',
          'dateTime': '2022/01/16 11:45:55',
          'visitStatus': 'visited',
          'notes':
              'I visited Mr Rajesh Biswakarma\'s house in the morning and he was not available',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Abhijeet Yadav ',
          'address': 'Lalitpur, Jhansi Road',
          'phoneNumber': '9876543210',
          'dateTime': '2022/01/17 12:30:40',
          'visitStatus': 'visitedOthers',
          'notes':
              'I visited Mr Abhijeet Yadav house in the afternoon and he was not available in the house his wife said me to come back tomorrow',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Rohan Bhattrai',
          'address': 'Lakeside Rd, Pokhara',
          'phoneNumber': '9898989898',
          'dateTime': '2022/01/18 01:15:35',
          'visitStatus': 'visitedOthers',
          'notes':
              'I visited Mr Abhijeet Yadav house in the afternoon and he was not available in the house his wife said me to come back tomorrow',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Milan Biswas',
          'address': 'NGO Rd, Bharatpur',
          'phoneNumber': '9874563210',
          'dateTime': '2022/01/19 02:00:19',
          'visitStatus': 'visitOnProgress',
          'notes':
              'I visited Mr Milan Biswas house in the afternoon and he was available in the house he will be visiting hospital tomorrow',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Siman Malla',
          'address': 'Milanchwok,Butwal',
          'phoneNumber': '9854321098',
          'dateTime': '2022/01/20 02:45:30',
          'visitStatus': 'notVisited',
          'notes':
              'I visited Mr Siman Malla house in the afternoon and he was not available in the house.',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
      ],
    },
    {
      "OfficerName": "Bibek Chaudhary",
      "target": 20,
      "achieved": 13,
      "Visit Status": "Not Visited",
      'batteryLevel': 45,
      'connectivityType': 'mobile',
      'totalTravel': 22,
      'isApproved': false,
      'visitDetails': [
        {
          'clientName': 'Ram Shah',
          'address': 'Biratnagar, Airport-Road',
          'phoneNumber': '9819022062',
          'dateTime': '2022/01/15 10:30:19',
          'visitStatus': 'visited',
          'notes':
              'I visited Mr Ram Shah in the morning and he was suffering from fever.',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Rajesh Biswakarma',
          'address': 'Kathmandu, New Baneshwor',
          'phoneNumber': '9845678901',
          'dateTime': '2022/01/16 11:45:55',
          'visitStatus': 'visited',
          'notes':
              'I visited Mr Rajesh Biswakarma\'s house in the morning and he was not available',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Abhijeet Yadav ',
          'address': 'Lalitpur, Jhansi Road',
          'phoneNumber': '9876543210',
          'dateTime': '2022/01/17 12:30:40',
          'visitStatus': 'visitedOthers',
          'notes':
              'I visited Mr Abhijeet Yadav house in the afternoon and he was not available in the house his wife said me to come back tomorrow',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Rohan Bhattrai',
          'address': 'Lakeside Rd, Pokhara',
          'phoneNumber': '9898989898',
          'dateTime': '2022/01/18 01:15:35',
          'visitStatus': 'visitedOthers',
          'notes':
              'I visited Mr Abhijeet Yadav house in the afternoon and he was not available in the house his wife said me to come back tomorrow',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Milan Biswas',
          'address': 'NGO Rd, Bharatpur',
          'phoneNumber': '9874563210',
          'dateTime': '2022/01/19 02:00:19',
          'visitStatus': 'visitOnProgress',
          'notes':
              'I visited Mr Milan Biswas house in the afternoon and he was available in the house he will be visiting hospital tomorrow',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Siman Malla',
          'address': 'Milanchwok,Butwal',
          'phoneNumber': '9854321098',
          'dateTime': '2022/01/20 02:45:30',
          'visitStatus': 'notVisited',
          'notes':
              'I visited Mr Siman Malla house in the afternoon and he was not available in the house.',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
      ],
    },
    {
      "OfficerName": "Saroj Shrestha",
      "target": 20,
      "achieved": 19,
      "Visit Status": "Visited",
      'batteryLevel': 55,
      'connectivityType': 'mobile',
      'totalTravel': 17,
      'isApproved': false,
      'visitDetails': [
        {
          'clientName': 'Ram Shah',
          'address': 'Biratnagar, Airport-Road',
          'phoneNumber': '9819022062',
          'dateTime': '2022/01/15 10:30:19',
          'visitStatus': 'visited',
          'notes':
              'I visited Mr Ram Shah in the morning and he was suffering from fever.',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Rajesh Biswakarma',
          'address': 'Kathmandu, New Baneshwor',
          'phoneNumber': '9845678901',
          'dateTime': '2022/01/16 11:45:55',
          'visitStatus': 'visited',
          'notes':
              'I visited Mr Rajesh Biswakarma\'s house in the morning and he was not available',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Abhijeet Yadav ',
          'address': 'Lalitpur, Jhansi Road',
          'phoneNumber': '9876543210',
          'dateTime': '2022/01/17 12:30:40',
          'visitStatus': 'visitedOthers',
          'notes':
              'I visited Mr Abhijeet Yadav house in the afternoon and he was not available in the house his wife said me to come back tomorrow',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Rohan Bhattrai',
          'address': 'Lakeside Rd, Pokhara',
          'phoneNumber': '9898989898',
          'dateTime': '2022/01/18 01:15:35',
          'visitStatus': 'visitedOthers',
          'notes':
              'I visited Mr Abhijeet Yadav house in the afternoon and he was not available in the house his wife said me to come back tomorrow',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Milan Biswas',
          'address': 'NGO Rd, Bharatpur',
          'phoneNumber': '9874563210',
          'dateTime': '2022/01/19 02:00:19',
          'visitStatus': 'visitOnProgress',
          'notes':
              'I visited Mr Milan Biswas house in the afternoon and he was available in the house he will be visiting hospital tomorrow',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Siman Malla',
          'address': 'Milanchwok,Butwal',
          'phoneNumber': '9854321098',
          'dateTime': '2022/01/20 02:45:30',
          'visitStatus': 'notVisited',
          'notes':
              'I visited Mr Siman Malla house in the afternoon and he was not available in the house.',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
      ],
    },
    {
      "OfficerName": "Jay Prakash Niraula",
      "target": 20,
      "achieved": 16,
      "Visit Status": "Visited On Progress",
      'batteryLevel': 70,
      'connectivityType': 'wifi',
      'totalTravel': 15,
      'isApproved': false,
      'visitDetails': [
        {
          'clientName': 'Ram Shah',
          'address': 'Biratnagar, Airport-Road',
          'phoneNumber': '9819022062',
          'dateTime': '2022/01/15 10:30:19',
          'visitStatus': 'visited',
          'notes':
              'I visited Mr Ram Shah in the morning and he was suffering from fever.',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Rajesh Biswakarma',
          'address': 'Kathmandu, New Baneshwor',
          'phoneNumber': '9845678901',
          'dateTime': '2022/01/16 11:45:55',
          'visitStatus': 'visited',
          'notes':
              'I visited Mr Rajesh Biswakarma\'s house in the morning and he was not available',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Abhijeet Yadav ',
          'address': 'Lalitpur, Jhansi Road',
          'phoneNumber': '9876543210',
          'dateTime': '2022/01/17 12:30:40',
          'visitStatus': 'visitedOthers',
          'notes':
              'I visited Mr Abhijeet Yadav house in the afternoon and he was not available in the house his wife said me to come back tomorrow',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Rohan Bhattrai',
          'address': 'Lakeside Rd, Pokhara',
          'phoneNumber': '9898989898',
          'dateTime': '2022/01/18 01:15:35',
          'visitStatus': 'visitedOthers',
          'notes':
              'I visited Mr Abhijeet Yadav house in the afternoon and he was not available in the house his wife said me to come back tomorrow',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Milan Biswas',
          'address': 'NGO Rd, Bharatpur',
          'phoneNumber': '9874563210',
          'dateTime': '2022/01/19 02:00:19',
          'visitStatus': 'visitOnProgress',
          'notes':
              'I visited Mr Milan Biswas house in the afternoon and he was available in the house he will be visiting hospital tomorrow',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
        {
          'clientName': 'Siman Malla',
          'address': 'Milanchwok,Butwal',
          'phoneNumber': '9854321098',
          'dateTime': '2022/01/20 02:45:30',
          'visitStatus': 'notVisited',
          'notes':
              'I visited Mr Siman Malla house in the afternoon and he was not available in the house.',
          'visitImage': '',
          'visitApprovalStatus': false,
        },
      ],
    }
  ];

  List<Map<String, dynamic>> _visitDetails = [];
  Map<String, dynamic> _selectedShowDetails = {};
  int _officerIndex = 0;
  String _selectedOfficerName = '';

  List<Map<String, dynamic>> get marketingOfficersDetails =>
      _marketingOfficersDetails;
  List<Map<String, dynamic>> get visitDetails => _visitDetails;
  Map<String, dynamic> get selectedShowDetails => _selectedShowDetails;
  int get officerIndex => _officerIndex;
  String get selectedOfficerName => _selectedOfficerName;

  void setSelectedOfficerVisitDetails(int index) {
    _officerIndex = index;
    _selectedOfficerName =
        '${_marketingOfficersDetails[_officerIndex]['OfficerName']}';
    _visitDetails = _marketingOfficersDetails[_officerIndex]['visitDetails'];
    notifyListeners();
  }

  void setOfficerVisitApprovals(bool value) {
    _marketingOfficersDetails[_officerIndex]['isApproved'] = value;
    notifyListeners();
  }

  void setVisitDetailsApprovalStatus(int index, bool value) {
    _visitDetails[index]['visitApprovalStatus'] = value;
    notifyListeners();
  }

  void setSelectedShowDetail(int index) {
    _selectedShowDetails = _visitDetails[index];
    notifyListeners();
  }

  void setIsApproved(bool value) {
    _marketingOfficersDetails[_officerIndex]['isApproved'] = value;
    notifyListeners();
  }

  void addFollowUpVisitDetails(String name, String address, String phone,
      String dateTime, String visitNote, String img) {
    _marketingOfficersDetails[0]['visitDetails'].add(
      {
        'clientName': name,
        'address': address,
        'phoneNumber': phone,
        'dateTime': dateTime,
        'visitStatus': 'visited',
        'notes': visitNote,
        'visitImage': img,
        'visitApprovalStatus': false,
      },
    );
    notifyListeners();
  }
}
