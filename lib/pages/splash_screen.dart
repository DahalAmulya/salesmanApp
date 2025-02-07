import 'dart:io' show Platform;
import 'package:flutter/material.dart';

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
    getValues();
    super.initState();
  }

  Future<void> getValues() async {
    // final cookieData =
    //     (await SecureStorage().readLoginCredentials(SecureStorage.userEmail)).value;
    // final emailData =
    //     (await SecureStorage().readLoginCredentials(Enviroment.email)).value;
    // final nameData =
    //     (await SecureStorage().readLoginCredentials(Enviroment.name)).value;
    // final administratorData =
    //     (await SecureStorage().readLoginCredentials(Enviroment.administrator))
    //         .value;
    // final operatingSystemData =
    //     (await SecureStorage().readLoginCredentials(Enviroment.operatingSystem))
    //         .value;
    // cookie = cookieData;
    // userName = nameData;
    // userEmail = emailData;
    // final convertToBool =
    //     administratorData.toString().isEmpty ? 'false' : administratorData;
    // administrator = bool.parse(convertToBool);
    // operatingSystem = operatingSystemData;
    debugPrint(
        '*********************************************************************');
    // debugPrint('cookie = $cookie');
    // debugPrint('userName = $userName');
    // debugPrint('userEmail = $userEmail');
    // debugPrint('administrator = $administrator');
    debugPrint('operatingSystem = $operatingSystem');
    // checkCookie(cookie);
  }

  Future<void> checkCookie(String cookie) async {
    debugPrint(
        '*********************************************************************');
    debugPrint('Checking cookie');
    // try {
    //   Map<String, String> headers = {
    //     'Content-Type': 'application/json',
    //     'Cookie': 'JSESSIONID=$cookie',
    //   };
    //   final response = await get(
    //     Uri.parse('$apiURL/api/devices'),
    //     headers: headers,
    //   );
    //   if (response.statusCode == 200) {
    //     loggedIn = true;
    //   }
    // } catch (err) {
    //   loggedIn = false;
    //   debugPrint('Error: $err');
    //   Utils().toastMessage('Session has expired.');
    // }
    // loggedIn ? Get.off(const Dashboard()) : Get.off(LoginPage());
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
