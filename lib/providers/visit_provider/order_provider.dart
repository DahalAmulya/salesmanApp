import 'package:flutter/foundation.dart';

class Orders {
  final String productName;
  final int quantity;
  final double price;
  final double discountRate;
  final double netAmount;
  final double totalPrice;

  Orders({
    required this.productName,
    required this.quantity,
    required this.price,
    required this.discountRate,
    required this.netAmount,
    required this.totalPrice,
  });
}

class OrderProvider extends ChangeNotifier {
  List<Orders> _items = [];
  double _total = 0.0;
  double _price = 0.0;
  double _discountedRate = 0.0;
  double _discountedPrice = 0.0;
  int _quantity = 0;

  List<Orders> get items => _items;
  double get total => _total;
  double get price => _price;
  int get quantity => _quantity;
  double get discountRate => _discountedRate;
  double get discountedPrice => _discountedPrice;

  void addItem(Orders item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(Orders item) {
    _items.remove(item);
    notifyListeners();
  }

  void setPrice(price) {
    _price = price;
    _total = _price * _quantity;
    notifyListeners();
  }

  void setQuantity(quantity) {
    _quantity = quantity;
    _total = _price * _quantity;
    notifyListeners();
  }

  void setDiscountRate(discountRate) {
    _discountedRate = discountRate;
    notifyListeners();
  }

  void setDiscountedPrice() {
    _discountedPrice = _price - ((_discountedRate / 100) * _price);
    notifyListeners();
  }

  void totalPrice() {
    _total = 0.0;
    _total = _quantity * _discountedPrice;
    notifyListeners();
  }

  void clearValues() {
    _total = 0.0;
    _price = 0.0;
    _quantity = 0;
    _discountedRate = 0.0;
    _discountedPrice = 0.0;
  }
}
