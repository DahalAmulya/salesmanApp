import 'package:flutter/foundation.dart';

class VisitScreenProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _vistiStatus = [
    {
      'client': 'Anu Yadav',
      'address': 'roadcess, biratnagar',
      'phone': 9812345678,
      'email': 'anuyadav@gmail.com',
      'pan': '0123456789',
      'orderAmt': 0.0,
      'paidAmt': 0.0,
      'dueAmt': 0.0,
      'salesRepresentative': 'John Cena',
      'dateTime': '2081-05-27T09:05:32'
    },
    {
      'client': 'Raj Patel',
      'address': 'hanumandas road, biratnagar',
      'phone': 9802245678,
      'email': 'rajpatel@gmail.com',
      'pan': '0223456789',
      'orderAmt': 150.0,
      'paidAmt': 100.0,
      'dueAmt': 50.0,
      'salesRepresentative': 'John Cena',
      'dateTime': '2081-05-27T09:05:32'
    },
    {
      'client': 'Sita Rai',
      'address': 'mahendra chowk, biratnagar',
      'phone': 9811345678,
      'email': 'sitarai@gmail.com',
      'pan': '0333456789',
      'orderAmt': 200.0,
      'paidAmt': 200.0,
      'dueAmt': 0.0,
      'salesRepresentative': 'John Cena',
      'dateTime': '2081-05-27T09:05:32'
    },
    {
      'client': 'Ram Sharma',
      'address': 'roadcess, biratnagar',
      'phone': 9831245678,
      'email': 'ramsharma@gmail.com',
      'pan': '0444456789',
      'orderAmt': 300.0,
      'paidAmt': 150.0,
      'dueAmt': 150.0,
      'salesRepresentative': 'John Cena',
      'dateTime': '2081-05-27T09:05:32'
    },
    {
      'client': 'Gita Shrestha',
      'address': 'roadcess, biratnagar',
      'phone': 9812345678,
      'email': 'anuyadav@gmail.com',
      'pan': '0123456789',
      'orderAmt': 400.0,
      'paidAmt': 300.0,
      'dueAmt': 100.0,
      'salesRepresentative': 'John Cena',
      'dateTime': '2081-05-27T09:05:32'
    },
    {
      'client': 'Hari Singh',
      'address': 'roadcess, biratnagar',
      'phone': 9812345678,
      'email': 'anuyadav@gmail.com',
      'pan': '0123456789',
      'orderAmt': 100.0,
      'paidAmt': 100.0,
      'dueAmt': 0.0,
      'salesRepresentative': 'John Cena',
      'dateTime': '2081-05-27T09:05:32'
    },
    {
      'client': 'Kiran Thapa',
      'address': 'roadcess, biratnagar',
      'phone': 9812345678,
      'email': 'anuyadav@gmail.com',
      'pan': '0123456789',
      'orderAmt': 250.0,
      'paidAmt': 200.0,
      'dueAmt': 50.0,
      'salesRepresentative': 'John Cena',
      'dateTime': '2081-05-27T09:05:32'
    },
    {
      'client': 'Meena Karki',
      'address': 'roadcess, biratnagar',
      'phone': 9812345678,
      'email': 'anuyadav@gmail.com',
      'pan': '0123456789',
      'orderAmt': 500.0,
      'paidAmt': 400.0,
      'dueAmt': 100.0,
      'salesRepresentative': 'John Cena',
      'dateTime': '2081-05-27T09:05:32'
    },
    {
      'client': 'Sunil Joshi',
      'address': 'roadcess, biratnagar',
      'phone': 9812345678,
      'email': 'anuyadav@gmail.com',
      'pan': '0123456789',
      'orderAmt': 600.0,
      'paidAmt': 300.0,
      'dueAmt': 300.0,
      'salesRepresentative': 'John Cena',
      'dateTime': '2081-05-27T09:05:32'
    },
    {
      'client': 'Nina Maharjan',
      'address': 'roadcess, biratnagar',
      'phone': 9812345678,
      'email': 'anuyadav@gmail.com',
      'pan': '0123456789',
      'orderAmt': 350.0,
      'paidAmt': 350.0,
      'dueAmt': 0.0,
      'salesRepresentative': 'John Cena',
      'dateTime': '2081-05-27T09:05:32'
    },
    {
      'client': 'Manish kumar Rajbanshi',
      'address': 'roadcess, biratnagar',
      'phone': 9812345678,
      'email': 'anuyadav@gmail.com',
      'pan': '0123456789',
      'orderAmt': 0.0,
      'paidAmt': 350.0,
      'dueAmt': 0.0,
      'salesRepresentative': 'John Cena',
      'dateTime': '2081-05-27T09:05:32'
    }
  ];
  String _clientName = '';

  List<Map<String, dynamic>> get visitStatus => _vistiStatus;
  String get clientName => _clientName;

  VisitScreenProvider() {
    // Create a deep copy of _vistiStatus
    _searchResults =
        _vistiStatus.map((map) => Map<String, dynamic>.from(map)).toList();
  }

  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> get searchResult => _searchResults;

  void setClientName(name) {
    _clientName = name;
    notifyListeners();
  }

  void setSearchResult() {
    _searchResults = _vistiStatus;
    notifyListeners();
  }

  void runFilter(String enteredKeyWord) {
    List<Map<String, dynamic>> resluts = [];
    if (enteredKeyWord.isEmpty) {
      resluts = _vistiStatus;
    } else {
      resluts = _vistiStatus
          .where((client) => client['client']
              .toString()
              .toLowerCase()
              .contains(enteredKeyWord.toLowerCase()))
          .toList();
    }
    _searchResults = resluts;
    notifyListeners();
  }
}
