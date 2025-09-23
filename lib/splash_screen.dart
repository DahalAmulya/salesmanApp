import 'dart:async';
import 'dart:io' show Platform;
import 'package:deskgoo/classes/secure_storage.dart';
import 'package:deskgoo/consts.dart';
import 'package:deskgoo/models/environment.dart';
import 'package:deskgoo/providers/profile/profile_provider.dart';
import 'package:deskgoo/routes/marketing_officer_consts.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenPage> {
  bool loggedIn = false;
  String operatingSystem = Platform.operatingSystem.toLowerCase();
  ProfileProvider? profileProvider;
  @override
  void initState() {
    super.initState();
    checkToken();
    profileProvider = Provider.of<ProfileProvider>(context,listen: false);
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
    SecureStorageResponse emailAddr =
    await SecureStorage().readLoginCredentials(SecureStorage.userEmail);
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
    SecureStorageResponse national =
    await SecureStorage().readLoginCredentials(SecureStorage.userNationality);
    SecureStorageResponse marStat = await SecureStorage()
        .readLoginCredentials(SecureStorage.userMaritalStatus);
    SecureStorageResponse addr =
    await SecureStorage().readLoginCredentials(SecureStorage.userAddress);
    SecureStorageResponse profileImg =
    await SecureStorage().readLoginCredentials(SecureStorage.userProfileImage);
    SecureStorageResponse depart =
    await SecureStorage().readLoginCredentials(SecureStorage.userDepartment);

    profileProvider!.setUserInfo(
      name: name.value,
      gender: gen.value,
      nationality: national.value,
      address: addr.value,
      maritalStatus: marStat.value,
      email: emailAddr.value,
      doj: doj.value,
      department: depart.value,
      profilePic: profileImg.value,
    );

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

    Map<String, String> header = {
      'Content-Type': 'Application/json',
      'Authorization': 'Bearer $accessToken',
      '_id': userId
    };

    if (userId.isNotEmpty) {
      roleValue = int.parse(roleVal.value);

      try {
        final response = await http
            .get(
          Uri.parse('${Environment.apiUrl}/hello'),
          headers: header,
        )
            .timeout(const Duration(seconds: 7)); // ⏳ timeout

        print(response.statusCode);
        print(response.body);

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
      } on TimeoutException {
        // if request > 10 sec
        debugPrint("Request timed out after 10 seconds");
        Navigator.of(context).pushNamed(MarketingManagerConstants.indexPage);
      } catch (e) {
        debugPrint("Error: $e");
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
