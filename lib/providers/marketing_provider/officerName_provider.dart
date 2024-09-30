
import 'package:flutter/foundation.dart';

class MarketingProvider extends ChangeNotifier{
  String _name = '';

  String get name => _name;

  void setName(String name) {
    _name = name;
      notifyListeners();
  }
}