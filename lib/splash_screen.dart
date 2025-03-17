import 'dart:io' show Platform;
import 'package:deskgoo/classes/secure_storage.dart';
import 'package:deskgoo/consts.dart';
import 'package:deskgoo/models/environment.dart';
import 'package:deskgoo/routes/marketing_officer_consts.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:deskgoo/utils/readUserCred.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenPage> {
  bool loggedIn = false;
  String operatingSystem = Platform.operatingSystem.toLowerCase();
  @override
  void initState() {
    super.initState();
    checkToken();
  }

  Future<void> getValues() async {
    debugPrint(
        '*********************************************************************');
  }

  void checkToken() async {
    debugPrint(
        '************************** Splash Screen *******************************************');
    debugPrint('Checking token expire');
    SecureStorageResponse _id =
        await SecureStorage().readLoginCredentials(SecureStorage.userId);
    SecureStorageResponse accessTok =
        await SecureStorage().readLoginCredentials(SecureStorage.accessToken);
    SecureStorageResponse roleVal =
        await SecureStorage().readLoginCredentials(SecureStorage.roleValue);
    SecureStorageResponse roleN =
        await SecureStorage().readLoginCredentials(SecureStorage.role);
    SecureStorageResponse name =
        await SecureStorage().readLoginCredentials(SecureStorage.userName);
    SecureStorageResponse gen =
        await SecureStorage().readLoginCredentials(SecureStorage.userGender);
    SecureStorageResponse doj =
        await SecureStorage().readLoginCredentials(SecureStorage.userDoj);
    SecureStorageResponse dob =
        await SecureStorage().readLoginCredentials(SecureStorage.userDob);
    SecureStorageResponse national = await SecureStorage()
        .readLoginCredentials(SecureStorage.userNationality);
    SecureStorageResponse marStat = await SecureStorage()
        .readLoginCredentials(SecureStorage.userMaritalStatus);
    SecureStorageResponse addr =
        await SecureStorage().readLoginCredentials(SecureStorage.userAddress);
    SecureStorageResponse profileImg =
        await SecureStorage().readLoginCredentials(SecureStorage.userProfileImage);
    SecureStorageResponse depart = await SecureStorage()
        .readLoginCredentials(SecureStorage.userDepartment);
    userId = _id.value;
    accessToken = accessTok.value;
    role = roleN.value;
    userName = name.value;
    userAddress = addr.value;
    userDepartment = depart.value;
    userGender = gen.value;
    userDoj = doj.value;
    userDob = dob.value;
    userNationality = national.value;
    userMaritalStatus = marStat.value;
    profileImage = profileImg.value;

    userId = _id.value;
    accessToken = accessTok.value;
    role = roleN.value;
    userName = name.value;
    Map<String, String> header = {
      'Content-Type': 'Application/json',
      'Authorization': 'Bearer $accessToken',
      '_id': userId
    };
    if (userId.isNotEmpty) {
      roleValue = int.parse(roleVal.value);
      final response = await http.get(
        Uri.parse('${Environment.apiUrl}/hello'),
        headers: header,
      );
      print(response.statusCode);
      print(response.body);
      // ERPResponse response = await ERPServices.getRequest('/hello');
      if (response.statusCode == 200) {
        if (roleValue == 1011) {
          Navigator.of(context).pushNamed(MarketingManagerConstants.homePage);
          print('Administrator');
        } else if (roleValue == 3031) {
          Navigator.of(context)
              .pushNamed(MarketingOfficerConstants.mrStaffDashboardConst);
          print('Marketing Officer');
        }
      } else {
        Navigator.of(context).pushNamed(MarketingManagerConstants.indexPage);
      }
    } else {
      Navigator.of(context).pushNamed(MarketingManagerConstants.indexPage);
    }
    print(accessToken);
    print(userId);
    debugPrint(
        '*********************************************************************');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
