import 'package:deskgoo/pages/auth_screens/forgot_password/forgot_password_screen.dart';
import 'package:deskgoo/pages/auth_screens/login/login_screen.dart';
import 'package:deskgoo/pages/camera/camera_screen.dart';
import 'package:deskgoo/pages/camera/preview_photos.dart';
import 'package:deskgoo/pages/camera/preview_selected_photo.dart';
import 'package:deskgoo/pages/error/error_page.dart';
import 'package:deskgoo/pages/location/live_tracking_screen.dart';
import 'package:deskgoo/pages/location/replay_screen.dart';
import 'package:deskgoo/pages/location/show_own_location_screen.dart';
import 'package:deskgoo/pages/marketing_officers/marketing_officers_screen.dart';
import 'package:deskgoo/pages/mr_admin/mr_admin_pages/mr_admin_dashboard/mr_manager_dashboard.dart';
import 'package:deskgoo/pages/mr_admin/mr_admin_pages/reports/report_screen.dart';
import 'package:deskgoo/pages/mr_admin/mr_admin_pages/reports/visit_log_map_screen.dart';
import 'package:deskgoo/pages/mr_officers_pages/mr_officers_dashboard/mr_officers_dashboard.dart';
import 'package:deskgoo/pages/mr_officers_pages/mr_officers_visits/followUp_visit_screen.dart';
import 'package:deskgoo/pages/mr_officers_pages/mr_officers_visits/new_visit_screen.dart';
import 'package:deskgoo/pages/mr_officers_pages/mr_officers_visits/visit_log_screen.dart';
import 'package:deskgoo/pages/mr_officers_pages/offline_mode_dashboard.dart';
import 'package:deskgoo/pages/mr_officers_pages/referral/referral_log_screen.dart';
import 'package:deskgoo/pages/mr_officers_pages/referral/referral_screen.dart';
import 'package:deskgoo/pages/mr_officers_pages/weeklyplan/addtask_screen.dart';
import 'package:deskgoo/pages/mr_officers_pages/weeklyplan/weeklyplan_screen.dart';
import 'package:deskgoo/pages/settings/policies/privacy_policy_screen.dart';
import 'package:deskgoo/pages/settings/policies/terms_and_condition_screen.dart';
import 'package:deskgoo/pages/settings/profile/pick_profile_pic_screen.dart';
import 'package:deskgoo/pages/settings/setting.dart';
import 'package:deskgoo/pages/visit/visit_screen.dart';
import 'package:deskgoo/routes/marketing_officer_consts.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/splash_screen.dart';
import 'package:flutter/material.dart';
import '../pages/home/DescriptionPage/officer_DescriptionPage.dart';
import '../pages/home/DescriptionPage/officer_VisitDetailPage.dart';
import '../pages/location/plot_location_history_screen.dart';
import '../pages/mr_admin/mr_admin_pages/mr_admin_create_user/mr_admin_createuser.dart';
import '../pages/mr_admin/mr_admin_pages/mr_admin_create_user/mr_admin_viewuser.dart';
import '../pages/mr_admin/mr_admin_pages/reports/Area/report_area_screen.dart';

import '../pages/mr_admin/mr_admin_pages/reports/mr_admin_ambulance_report_screen/mr_admin_ambulance_reportpage.dart';
import '../pages/mr_admin/mr_admin_pages/reports/mr_admin_attendance_report/mr_admin_attendance_report_screen.dart';
import '../pages/mr_admin/mr_admin_pages/reports/mr_admin_average_reports_screen/mr_admin_average_report_screen.dart';
import '../pages/mr_admin/mr_admin_pages/reports/referral/mr_admin_referral_log_screen.dart';
import '../pages/mr_officers_pages/mr_officers_visits/product.dart';
import '../pages/settings/profile/profile_Page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      // Routes for MarketingManager
      case MarketingManagerConstants.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreenPage(),
        );
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
          builder: (_) => MarketingManagerDashboard(),
        );
      // case MarketingManagerConstants.cameraPage:
      //   return MaterialPageRoute(
      //     builder: (_) => const CameraPage(),
      //   );
      // case MarketingManagerConstants.previewCapturedPhotoPage:
      //   return MaterialPageRoute(
      //     builder: (_) => const PreviewCapturedPhotos(),
      //   );
      // case MarketingManagerConstants.previewSelectedPhotoPage:
      //   return MaterialPageRoute(
      //     builder: (_) => const PreviewSelectedPhoto(),
      //   );
      case MarketingManagerConstants.liveTrackingPage:
        return MaterialPageRoute(
          builder: (_) => LiveTrackingScreen(),
        );
      case MarketingManagerConstants.ownLiveLocationPage:
        return MaterialPageRoute(
          builder: (_) => OwnLiveLocationScreen(),
        );
      case MarketingManagerConstants.replayPage:
        return MaterialPageRoute(
          builder: (_) => ReplayScreen(),
        );
      case MarketingManagerConstants.plotLocationHistory:
        return MaterialPageRoute(
          builder: (_) => PlotLocationHistoryScreen(),
        );
      case MarketingManagerConstants.visitPage:
        return MaterialPageRoute(
          builder: (_) => VisitScreen(),
        );
      case MarketingManagerConstants.settingPage:
        return MaterialPageRoute(
          builder: (_) => SettingPage(),
        );
      case MarketingManagerConstants.profilePage:
        return MaterialPageRoute(
          builder: (_) => const Profile_page(),
        );
      case MarketingManagerConstants.officerDescriptionPage:
        return MaterialPageRoute(
          builder: (_) => const OfficerDescriptionPage(),
        );
      case MarketingManagerConstants.marketingOfficers:
        return MaterialPageRoute(
          builder: (_) => const MarketingOfficersScreen(),
        );
      case MarketingManagerConstants.officerVisitDetailPage:
        return MaterialPageRoute(
          builder: (_) => const OfficerVisitDetailPage(),
        );
      case MarketingManagerConstants.reportMarketingOfficersScreen:
        return MaterialPageRoute(
          builder: (_) => const MrAdminReportScreen(),
        );
      case MarketingManagerConstants.areaReportMarketingOfficersScreen:
        return MaterialPageRoute(
          builder: (_) => const MrAdminAreaReportScreen(),
        );
      case MarketingManagerConstants.mrManagerCreateUserPage:
        return MaterialPageRoute(
          builder: (_) => const MarketingAdminCreateUser(),
        );
      case MarketingManagerConstants.mrManagerViewUserPage:
        return MaterialPageRoute(
          builder: (_) => const MarketingAdminViewUser(),
        );
      case MarketingManagerConstants.mrManagerReferralLogPage:
        return MaterialPageRoute(
          builder: (_) => const ReferralLogScreen(),
        );
      case MarketingManagerConstants.mrAdminAttendanceReportScreen:
        return MaterialPageRoute(
          builder: (_) => const MrAdminAttendanceReportScreen(),
        );
      case MarketingManagerConstants.pickProfilePic:
        return MaterialPageRoute(
          builder: (_) => const PickProfilePicScreen(),
        );
        case MarketingManagerConstants.visitLogMapReportScreen:
        return MaterialPageRoute(
          builder: (_) => const VisitLogReportMapScreen(),
        );
      case MarketingManagerConstants.ambulanceReportScreen:
        return MaterialPageRoute(
          builder: (_) => const MrAdminAmbulanceReportScreen(),
        );
      case MarketingManagerConstants.averageVisitReportScreen:
        return MaterialPageRoute(
          builder: (_) => const MrAdminAverageReportScreen(),
        );

      // Routes for MarketingStaff
      case MarketingOfficerConstants.mrStaffDashboardConst:
        return MaterialPageRoute(builder: (_) => MrOfficersDashboardScreen());
      case MarketingOfficerConstants.weeklyPlanConst:
        return MaterialPageRoute(builder: (_) => WeeklyPlanScreen());
      case MarketingOfficerConstants.addTaskConst:
        return MaterialPageRoute(builder: (_) => AddTaskScreen());
      case MarketingOfficerConstants.newVisit:
        return MaterialPageRoute(builder: (_) => MrOfficerNewVisitScreen());
      case MarketingOfficerConstants.followUpVisit:
        return MaterialPageRoute(
            builder: (_) => MrOfficerFollowUpVisitScreen());
      case MarketingOfficerConstants.visitLog:
        return MaterialPageRoute(builder: (_) => MrOfficerVisitLogScreen());
      case MarketingOfficerConstants.referral:
        return MaterialPageRoute(builder: (_) => MrOfficerReferralScreen());
      case MarketingOfficerConstants.referralLog:
        return MaterialPageRoute(
            builder: (_) => MarketingOfficerReferralLogScreen());
      case MarketingOfficerConstants.productConst:
        return MaterialPageRoute(builder: (_) => ProductPage());
        case MarketingOfficerConstants.termsAndConditionScreen:
        return MaterialPageRoute(builder: (_) => TermsAndConditionScreen());
        case MarketingOfficerConstants.privacyPolicyScreen:
        return MaterialPageRoute(builder: (_) => PrivacyPolicyScreen());
        case MarketingOfficerConstants.offlineModeScreen:
        return MaterialPageRoute(builder: (_) => OfflineModeDashboardScreen());
      default:
        return MaterialPageRoute(builder: (_) => ErrorPage());
    }
  }
}
