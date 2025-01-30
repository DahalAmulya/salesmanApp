import 'package:deskgoo/classes/secure_storage.dart';
import 'package:flutter/foundation.dart';

class UserCred extends ChangeNotifier {
  static String _email = '';
  static String _password = '';
  static String _refreshToken = '';
  static String _userID = '';
  static String _rememberMe = '';

  String get email => _email;
  String get password => _password;
  String get refreshToken => _refreshToken;
  String get userID => _userID;
  String get rememberMe => _rememberMe;

  void readUserCred() async {
    SecureStorageResponse email =
        await SecureStorage().readLoginCredentials(SecureStorage.userEmail);
    SecureStorageResponse password =
        await SecureStorage().readLoginCredentials(SecureStorage.password);
    SecureStorageResponse refreshToken =
        await SecureStorage().readLoginCredentials(SecureStorage.refreshToken);
    SecureStorageResponse userID =
        await SecureStorage().readLoginCredentials(SecureStorage.userId);
    SecureStorageResponse rememberMe =
        await SecureStorage().readLoginCredentials(SecureStorage.rememberMe);

    _email = email.value;
    _password = password.value;
    _refreshToken = refreshToken.value;
    _userID = userID.value;
    _rememberMe = rememberMe.value;
    notifyListeners();

    print('****************************************************************');
    print('email: ${_email}');
    print('password: ${_password}');
    print('refreshToken: ${_refreshToken}');
    print('userID: ${_userID}');
    print('rememberMe: ${_rememberMe}');
    print('****************************************************************');
  }
}
