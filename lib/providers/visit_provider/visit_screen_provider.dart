import 'package:flutter/foundation.dart';

class VisitScreenProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _vistiStatus = [
    {
      'client': 'Anu Yadav',
      'orderAmt': 0.0,
      'paidAmt': 0.0,
      'dueAmt': 0.0,
      'salesRepresentative': 'John Cena',
      'dateTime': '2081-05-27T09:05:32'
    },
    {
      'client': 'Raj Patel',
      'orderAmt': 150.0,
      'paidAmt': 100.0,
      'dueAmt': 50.0,
      'salesRepresentative': 'John Cena',
      'dateTime': '2081-05-27T09:05:32'
    },
    {
      'client': 'Sita Rai',
      'orderAmt': 200.0,
      'paidAmt': 200.0,
      'dueAmt': 0.0,
      'salesRepresentative': 'John Cena',
      'dateTime': '2081-05-27T09:05:32'
    },
    {
      'client': 'Ram Sharma',
      'orderAmt': 300.0,
      'paidAmt': 150.0,
      'dueAmt': 150.0,
      'salesRepresentative': 'John Cena',
      'dateTime': '2081-05-27T09:05:32'
    },
    {
      'client': 'Gita Shrestha',
      'orderAmt': 400.0,
      'paidAmt': 300.0,
      'dueAmt': 100.0,
      'salesRepresentative': 'John Cena',
      'dateTime': '2081-05-27T09:05:32'
    },
    {
      'client': 'Hari Singh',
      'orderAmt': 100.0,
      'paidAmt': 100.0,
      'dueAmt': 0.0,
      'salesRepresentative': 'John Cena',
      'dateTime': '2081-05-27T09:05:32'
    },
    {
      'client': 'Kiran Thapa',
      'orderAmt': 250.0,
      'paidAmt': 200.0,
      'dueAmt': 50.0,
      'salesRepresentative': 'John Cena',
      'dateTime': '2081-05-27T09:05:32'
    },
    {
      'client': 'Meena Karki',
      'orderAmt': 500.0,
      'paidAmt': 400.0,
      'dueAmt': 100.0,
      'salesRepresentative': 'John Cena',
      'dateTime': '2081-05-27T09:05:32'
    },
    {
      'client': 'Sunil Joshi',
      'orderAmt': 600.0,
      'paidAmt': 300.0,
      'dueAmt': 300.0,
      'salesRepresentative': 'John Cena',
      'dateTime': '2081-05-27T09:05:32'
    },
    {
      'client': 'Nina Maharjan',
      'orderAmt': 350.0,
      'paidAmt': 350.0,
      'dueAmt': 0.0,
      'salesRepresentative': 'John Cena',
      'dateTime': '2081-05-27T09:05:32'
    },
    {
      'client': 'Manish kumar Rajbanshi',
      'orderAmt': 0.0,
      'paidAmt': 350.0,
      'dueAmt': 0.0,
      'salesRepresentative': 'John Cena',
      'dateTime': '2081-05-27T09:05:32'
    }
  ];
  List<Map<String, dynamic>> get visitStatus => _vistiStatus;

  VisitScreenProvider() {
    // Create a deep copy of _vistiStatus
    _searchResults =
        _vistiStatus.map((map) => Map<String, dynamic>.from(map)).toList();
  }

  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> get searchResult => _searchResults;

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
