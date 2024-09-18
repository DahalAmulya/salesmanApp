import 'package:deskgoo/providers/visit_provider/order_items.dart';
import 'package:flutter/foundation.dart';

class Orders {
  String productName;
  int quantity;
  double price;
  double discountRate;
  double netAmount;
  double totalPrice;

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
  List<Product> _products = PRODUCTS;
  List<Product> _productSearchResults = [];
  List<Orders> _items = [];
  double _total = 0.0;
  double _price = 0.0;
  double _discountedRate = 0.0;
  double _discountedPrice = 0.0;
  int _quantity = 0;
  double _summaryTotalAmount = 0;

  List<Product> get products => _products;
  List<Product> get productSearchResults => _productSearchResults;
  List<Orders> get items => _items;
  double get total => _total;
  double get price => _price;
  int get quantity => _quantity;
  double get discountRate => _discountedRate;
  double get discountedPrice => _discountedPrice;
  double get summaryTotalAmount => _summaryTotalAmount;

  OrderProvider() {
    _productSearchResults = _products;
    notifyListeners();
  }

  void resetProductSearchResults() {
    _productSearchResults = _products;
    notifyListeners();
  }

  void runProductsSearchFilter(String enteredKeyWord) {
    List<Product> resluts = [];
    if (enteredKeyWord.isEmpty) {
      resluts = _products;
    } else {
      resluts = _products
          .where((product) => product.name
              .toString()
              .toLowerCase()
              .contains(enteredKeyWord.toLowerCase()))
          .toList();
    }
    _productSearchResults = resluts;
    notifyListeners();
  }

  void addItem(Orders item) {
    _items.add(item);
    notifyListeners();
  }

  void addOneQuantity(index) {
    items[index].quantity = items[index].quantity + 1;
    items[index].totalPrice = items[index].netAmount * items[index].quantity;
    notifyListeners();
  }

  void removeOneQuantity(index) {
    items[index].quantity = items[index].quantity > 1
        ? items[index].quantity - 1
        : items[index].quantity;
    items[index].totalPrice = items[index].netAmount * items[index].quantity;
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
    _discountedPrice == 0 ? _discountedPrice = _price : _discountedPrice;
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

  void setTotalPrice() {
    _total = 0;
    notifyListeners();
  }

  void totalPrice() {
    _total = _quantity * _discountedPrice;
    notifyListeners();
  }

  void setSummaryTotalPrice() {
    _summaryTotalAmount = 0.0;
    for (int i = 0; i < _items.length; i++) {
      _summaryTotalAmount += _items[i].totalPrice;
    }
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
