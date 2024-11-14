import 'package:deskgoo/pages/attendance/remote_Attendence_page.dart';
import 'package:deskgoo/pages/auth_screens/forgot_password/forgot_password_screen.dart';
import 'package:deskgoo/pages/auth_screens/login/login_screen.dart';
import 'package:deskgoo/pages/background_location_screen/background_location_screen.dart';
import 'package:deskgoo/pages/camera/camera_screen.dart';
import 'package:deskgoo/pages/camera/preview_photos.dart';
import 'package:deskgoo/pages/camera/preview_selected_photo.dart';
import 'package:deskgoo/pages/error/error_page.dart';
import 'package:deskgoo/pages/home/home_screen.dart';
import 'package:deskgoo/pages/location/live_tracking_screen.dart';
import 'package:deskgoo/pages/location/replay_screen.dart';
import 'package:deskgoo/pages/location/show_own_location_screen.dart';
import 'package:deskgoo/pages/marketing_officers/marketing_officers_screen.dart';
import 'package:deskgoo/pages/settings/setting.dart';
import 'package:deskgoo/pages/visit/visit_screen.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:flutter/material.dart';
import '../pages/home/DescriptionPage/officer_DescriptionPage.dart';
import '../pages/home/DescriptionPage/officer_VisitDetailPage.dart';
import '../pages/settings/profile/profile_Page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      // Routes for MarketingManager
      case RouteGeneratorConstants.indexPage:
        return MaterialPageRoute(
          builder: (_) => LoginPage(),
        );
      case RouteGeneratorConstants.forgotPage:
        return MaterialPageRoute(
          builder: (_) => ForgotPasswordScreen(),
        );
      case RouteGeneratorConstants.homePage:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );
      case RouteGeneratorConstants.cameraPage:
        return MaterialPageRoute(
          builder: (_) => CameraPage(),
        );
      case RouteGeneratorConstants.previewCapturedPhotoPage:
        return MaterialPageRoute(
          builder: (_) => PreviewCapturedPhotos(),
        );
      case RouteGeneratorConstants.previewSelectedPhotoPage:
        return MaterialPageRoute(
          builder: (_) => PreviewSelectedPhoto(),
        );
      case RouteGeneratorConstants.liveTrackingPage:
        return MaterialPageRoute(
          builder: (_) => LiveTrackingScreen(),
        );
      case RouteGeneratorConstants.ownliveLocationPage:
        return MaterialPageRoute(
          builder: (_) => OwnLiveLocationScreen(),
        );
      case RouteGeneratorConstants.replayPage:
        return MaterialPageRoute(
          builder: (_) => ReplayScreen(),
        );
      case RouteGeneratorConstants.visitPage:
        return MaterialPageRoute(
          builder: (_) => VisitScreen(),
        );
      case RouteGeneratorConstants.remoteAttendancePage:
        return MaterialPageRoute(
          builder: (_) => RemoteAttendencePage(),
        );
      case RouteGeneratorConstants.settingPage:
        return MaterialPageRoute(
          builder: (_) => SettingPage(),
        );
      case RouteGeneratorConstants.profilePage:
        return MaterialPageRoute(
          builder: (_) => Profile_page(),
        );
      case RouteGeneratorConstants.officerDescriptionPage:
        return MaterialPageRoute(
          builder: (_) => OfficerDescriptionPage(),
        );
      case RouteGeneratorConstants.marketingOfficers:
        return MaterialPageRoute(
          builder: (_) => MarketingOfficersScreen(),
        );
      case RouteGeneratorConstants.officerVisitDetailPage:
        return MaterialPageRoute(
          builder: (_) => OfficerVisitDetailPage(),
        );
      // Routes for MarketingStaff
      default:
        return MaterialPageRoute(builder: (_) => ErrorPage());
    }
  }
}
