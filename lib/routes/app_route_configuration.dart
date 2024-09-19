import 'package:deskgoo/pages/attendance/remote_Attendence_page.dart';
import 'package:deskgoo/pages/auth_screens/forgot_password/forgot_password_screen.dart';
import 'package:deskgoo/pages/error/error_page.dart';
import 'package:deskgoo/pages/auth_screens/login/login_screen.dart';
import 'package:deskgoo/pages/home/home_screen.dart';
import 'package:deskgoo/pages/settings/setting.dart';
import 'package:deskgoo/pages/visit/visit_client_screen.dart';
import 'package:deskgoo/pages/visit/visit_order_screen.dart';
import 'package:deskgoo/pages/visit/visit_screen.dart';
import 'package:deskgoo/routes/app_route_constants.dart';
import 'package:deskgoo/widgets/bottom_navigation/notched_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/visit/summary_Page.dart';

class MyAppRouter {
  GoRouter router = GoRouter(
    routes: [
      GoRoute(
        name: MyAppRouteConstants.loginRouteName,
        path: '/',
        pageBuilder: (context, state) {
          return MaterialPage(child: LoginPage());
        },
      ),
      GoRoute(
        name: MyAppRouteConstants.forgotPasswordRouteName,
        path: '/forgotPassword',
        pageBuilder: (context, state) {
          return MaterialPage(child: ForgotPasswordScreen());
        },
      ),
      GoRoute(
        name: MyAppRouteConstants.remoteAttendanceRouteName,
        path: '/remoteAttendance',
        pageBuilder: (context, state) {
          return MaterialPage(child: RemoteAttendencePage());
        },
      ),
      GoRoute(
        name: MyAppRouteConstants.notchedBottomNavBarRouteName,
        path: '/bottomNavBar',
        pageBuilder: (context, state) {
          return MaterialPage(child: NotchedBottomNavBar());
        },
      ),
      GoRoute(
        name: MyAppRouteConstants.homeNavBarRouteName,
        path: '/home_screen',
        pageBuilder: (context, state) {
          return MaterialPage(child: HomeScreen());
        },
      ),
      GoRoute(
        name: MyAppRouteConstants.visitRouteName,
        path: '/visit',
        pageBuilder: (context, state) {
          return MaterialPage(child: VisitScreen());
        },
      ),
      GoRoute(
        name: MyAppRouteConstants.visitSummaryRouteName,
        path: '/visit_summary',
        pageBuilder: (context, state) {
          return MaterialPage(child: VisitSummary());
        },
      ),
      GoRoute(
        name: MyAppRouteConstants.visitClientRouteName,
        path: '/visit_client',
        pageBuilder: (context, state) {
          return MaterialPage(child: VisitClientScreen());
        },
      ),
      GoRoute(
        name: MyAppRouteConstants.visitOrderRouteName,
        path: '/visit_order',
        pageBuilder: (context, state) {
          return MaterialPage(child: VisitOrderScreen());
        },
      ),
      GoRoute(
        name: MyAppRouteConstants.settingPageRouteName,
        path: '/settings',
        pageBuilder: (context, state) {
          return MaterialPage(child: SettingPage());
        },
      ),
    ],
    errorPageBuilder: (context, state) {
      return MaterialPage(child: ErrorPage());
    },
    //     redirect: (context, state) {
    //       print('State.location = ${state.uri.toString().startsWith('/')}');
    //       if (!isAuth && state.uri.toString().startsWith('/')) {
    //         return context.namedLocation(MyAppRouteConstants.productsRouteName);
    //       } else {
    //         return null;
    //       }
    //     },
  );
  //   return router;
  // }
}
