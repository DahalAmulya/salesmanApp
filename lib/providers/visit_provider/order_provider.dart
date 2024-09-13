import 'package:deskgoo/providers/visit_provider/order_items.dart';
import 'package:flutter/foundation.dart';

class OrderProvider extends ChangeNotifier {
  List<Product> _items = [];
  List<Product> get items => _items;

  void addItem(Product item) {
    _items.add(item);
    notifyListeners();
  }
}
