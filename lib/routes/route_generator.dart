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
import 'package:deskgoo/pages/mr_officers/mr_officers_pages/mr_officers_dashboard/mr_officers_dashboard.dart';
import 'package:deskgoo/pages/mr_officers/mr_officers_pages/weeklyplan/weeklyplan_screen.dart';
import 'package:deskgoo/pages/settings/setting.dart';
import 'package:deskgoo/pages/visit/visit_screen.dart';
import 'package:deskgoo/routes/marketing_officer_consts.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:flutter/material.dart';
import '../pages/home/DescriptionPage/officer_DescriptionPage.dart';
import '../pages/home/DescriptionPage/officer_VisitDetailPage.dart';
import '../pages/mr_officers/mr_officers_pages/weeklyplan/addtask_screen.dart';
import '../pages/settings/profile/profile_Page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      // Routes for MarketingManager
      case MarketingManagerConstants.indexPage:
        return MaterialPageRoute(
          builder: (_) => LoginPage(),
        );
      case MarketingManagerConstants.forgotPage:
        return MaterialPageRoute(
          builder: (_) => ForgotPasswordScreen(),
        );
      case MarketingManagerConstants.homePage:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );
      case MarketingManagerConstants.cameraPage:
        return MaterialPageRoute(
          builder: (_) => CameraPage(),
        );
      case MarketingManagerConstants.previewCapturedPhotoPage:
        return MaterialPageRoute(
          builder: (_) => PreviewCapturedPhotos(),
        );
      case MarketingManagerConstants.previewSelectedPhotoPage:
        return MaterialPageRoute(
          builder: (_) => PreviewSelectedPhoto(),
        );
      case MarketingManagerConstants.liveTrackingPage:
        return MaterialPageRoute(
          builder: (_) => LiveTrackingScreen(),
        );
      case MarketingManagerConstants.ownliveLocationPage:
        return MaterialPageRoute(
          builder: (_) => OwnLiveLocationScreen(),
        );
      case MarketingManagerConstants.replayPage:
        return MaterialPageRoute(
          builder: (_) => ReplayScreen(),
        );
      case MarketingManagerConstants.visitPage:
        return MaterialPageRoute(
          builder: (_) => VisitScreen(),
        );
      case MarketingManagerConstants.remoteAttendancePage:
        return MaterialPageRoute(
          builder: (_) => RemoteAttendencePage(),
        );
      case MarketingManagerConstants.settingPage:
        return MaterialPageRoute(
          builder: (_) => SettingPage(),
        );
      case MarketingManagerConstants.profilePage:
        return MaterialPageRoute(
          builder: (_) => Profile_page(),
        );
      case MarketingManagerConstants.officerDescriptionPage:
        return MaterialPageRoute(
          builder: (_) => OfficerDescriptionPage(),
        );
      case MarketingManagerConstants.marketingOfficers:
        return MaterialPageRoute(
          builder: (_) => MarketingOfficersScreen(),
        );
      case MarketingManagerConstants.officerVisitDetailPage:
        return MaterialPageRoute(
          builder: (_) => OfficerVisitDetailPage(),
        );

      // Routes for MarketingStaff
      case MarketingOfficerConstants.mrStaffDashboardConst:
        return MaterialPageRoute(builder: (_) => MrOfficersDashboardScreen());
      case MarketingOfficerConstants.weeklyPlanConst:
        return MaterialPageRoute(builder: (_) => WeeklyPlanScreen());
      case MarketingOfficerConstants.addTaskConst:
        return MaterialPageRoute(builder: (_) => AddTaskScreen());
      default:
        return MaterialPageRoute(builder: (_) => ErrorPage());
    }
  }
}
