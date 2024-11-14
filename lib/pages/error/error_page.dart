import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        // GoRouter.of(context)
        //     .pushReplacementNamed(MyAppRouteConstants.loginRouteName);
        Navigator.of(context).pushNamed(MarketingManagerConstants.indexPage);
      }),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          centerTitle: true,
          title: CustomText(
            text: 'Error Page',
            size: 32,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        body: Center(
          child: CustomText(
            text: '404 Page Not Found',
            size: 24,
            fontWeight: FontWeight.w500,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
