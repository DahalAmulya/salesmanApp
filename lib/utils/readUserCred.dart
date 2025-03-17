import 'package:deskgoo/classes/secure_storage.dart';
import 'package:flutter/foundation.dart';

class UserCred extends ChangeNotifier {
  static String _email = '';
  static String _name = '';
  static String _password = '';
  static String _accessToken = '';
  static String _refreshToken = '';
  static String _userId = '';
  static String _rememberMe = '';
  static String _role = '';
  static String _roleValue = '';
  static String _profileImage = '';

  String get email => _email;
  String get name => _name;
  String get password => _password;
  String get accessToken => _accessToken;
  String get refreshToken => _refreshToken;
  String get userId => _userId;
  String get rememberMe => _rememberMe;
  String get role => _role;
  String get roleValue => _roleValue;
  String get profileImage => _profileImage;

  void readUserCred() async {
    SecureStorageResponse email =
        await SecureStorage().readLoginCredentials(SecureStorage.userEmail);
    SecureStorageResponse name =
        await SecureStorage().readLoginCredentials(SecureStorage.userName);
    SecureStorageResponse password =
        await SecureStorage().readLoginCredentials(SecureStorage.password);
    SecureStorageResponse accessToken =
        await SecureStorage().readLoginCredentials(SecureStorage.accessToken);
    SecureStorageResponse refreshToken =
        await SecureStorage().readLoginCredentials(SecureStorage.refreshToken);
    SecureStorageResponse userId =
        await SecureStorage().readLoginCredentials(SecureStorage.userId);
    SecureStorageResponse rememberMe =
        await SecureStorage().readLoginCredentials(SecureStorage.rememberMe);
    SecureStorageResponse role =
        await SecureStorage().readLoginCredentials(SecureStorage.role);
    SecureStorageResponse roleValue =
        await SecureStorage().readLoginCredentials(SecureStorage.roleValue);
    SecureStorageResponse profileImage =
        await SecureStorage().readLoginCredentials(SecureStorage.userProfileImage);

    _email = email.value;
    _name = name.value;
    _password = password.value;
    _refreshToken = accessToken.value;
    _refreshToken = refreshToken.value;
    _userId = userId.value;
    _rememberMe = rememberMe.value;
    _role = role.value;
    _roleValue = roleValue.value;
    _profileImage = profileImage.value;
    notifyListeners();

    print('****************************************************************');
    print('email: ${_email}');
    print('email: ${_name}');
    print('password: ${_password}');
    print('refreshToken: ${_refreshToken}');
    print('userID: ${_userId}');
    print('rememberMe: ${_rememberMe}');
    print('role: ${_role}');
    print('roleValue: ${_roleValue}');
    print('roleValue: ${_profileImage}');
    print('****************************************************************');
  }
}
