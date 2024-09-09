import 'package:flutter/foundation.dart';

class UserAuthProvider extends ChangeNotifier {
  bool _obscure = true;

  bool get obscure => _obscure;

  void toggleObscure() {
    _obscure = !_obscure;
    notifyListeners();
  }
}
