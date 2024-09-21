import 'package:deskgoo/pages/auth_screens/forgot_password/forgot_password_screen.dart';
import 'package:deskgoo/pages/auth_screens/login/login_screen.dart';
import 'package:deskgoo/pages/error/error_page.dart';
import 'package:deskgoo/pages/home/home_screen.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case RouteGeneratorConstants.indexPage:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case RouteGeneratorConstants.forgotPage:
        if (args is String) {
          return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
        } else {
          return MaterialPageRoute(builder: (_) => ErrorPage());
        }
      case RouteGeneratorConstants.homePage:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      default:
        return MaterialPageRoute(builder: (_) => ErrorPage());
    }
  }
}
