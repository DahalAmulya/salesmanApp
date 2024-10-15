import 'package:deskgoo/pages/error/error_page.dart';
import 'package:deskgoo/pages/mr_officers/mr_officers_dashboard/mr_officers_dashboard.dart';
import 'package:deskgoo/pages/mr_officers/mr_officers_routes/mr_officers_routes_consts.dart';
import 'package:deskgoo/pages/mr_officers/mr_officers_settings/mr_officers_setting.dart';
import 'package:flutter/material.dart';

class MrOfficersRoutes {
  static Route<dynamic> mrOfficersRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case MrOfficersRoutesConsts.mrOfficersRoutesDashboard:
        return MaterialPageRoute(builder: (_) => MrOfficersDashboardScreen());
      case MrOfficersRoutesConsts.mrOfficersRoutesSetting:
        return MaterialPageRoute(builder: (_) => MrOfficersSettingScreen());
      case MrOfficersRoutesConsts.mrOfficersRoutesBottomNavBar:
        return MaterialPageRoute(builder: (_) => MrOfficersDashboardScreen());
      default:
        return MaterialPageRoute(builder: (_) => ErrorPage());
    }
  }
}
