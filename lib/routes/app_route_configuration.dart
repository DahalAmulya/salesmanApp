import 'package:deskgoo/pages/auth_screens/forgot_password/forgot_password_screen.dart';
import 'package:deskgoo/pages/error/error_page.dart';
import 'package:deskgoo/pages/auth_screens/login/login_screen.dart';
import 'package:deskgoo/routes/app_route_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyAppRouter {
  // static GoRouter returnRouter(bool isAuth) {
  GoRouter router = GoRouter(
    routes: [
      // ShellRoute(
      //   routes: [
      GoRoute(
        name: MyAppRouteConstants.homeRouteName,
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
      // GoRoute(
      //   name: MyAppRouteConstants.productsRouteName,
      //   path: '/products/:category',
      //   pageBuilder: (context, state) {
      //     return MaterialPage(
      //       child: ProductsPage(
      //         username: state.pathParameters['category']!,
      //         userId: state.extra.toString(),
      //         userEmail: state.extra.toString(),
      //       ),
      //     );
      //   },
      // ),
      // GoRoute(
      //   name: MyAppRouteConstants.cartRouteName,
      //   path: '/cart',
      //   pageBuilder: (context, state) {
      //     return MaterialPage(child: CartPage());
      //   },
      // ),
      //   ],
      // ),
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
