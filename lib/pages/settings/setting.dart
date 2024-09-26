import 'package:deskgoo/routes/app_route_constants.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_navigation/gnav_bar.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});

  int index = 2;
  FontWeight labelFontWeight = FontWeight.w500;
  double labelSize = 18;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        // GoRouter.of(context)
        //     .pushReplacementNamed(MyAppRouteConstants.homeNavBarRouteName);
        Navigator.of(context)
            .pushReplacementNamed(RouteGeneratorConstants.homePage);
      }),
      child: GestureDetector(
        onTap: () {
          // Dismiss the keyboard when tapping outside TextFormFields
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            FocusScope.of(context).unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: CustomColors.primaryWhite,
          appBar: _appBar(context),
          body: _buildUI(context),
          bottomNavigationBar: _bottomNavBar(context),
        ),
      ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Builder(
        builder: (context) {
          return CustomAppBar(
            tabName: 'Settings',
          );
        },
      ),
    );
  }

  Widget _buildUI(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomContainer(
          borderRadius: 0,
          verticalMargin: 8,
          verticalPad: 8,
          horizontalPad: 0,
          width: 1,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CustomText(
                  text: 'Theme',
                  fontWeight: labelFontWeight,
                  size: labelSize,
                ),
              ),
              Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(RouteGeneratorConstants.profilePage);
                },
                child: CustomContainer(
                  verticalPad: 0,
                  horizontalMargin: 0,
                  verticalMargin: 0,
                  horizontalPad: 8,
                  width: 1,
                  // color: Colors.red,
                  child: CustomText(
                    text: 'Account',
                    fontWeight: labelFontWeight,
                    size: labelSize,
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CustomText(
                  text: 'About us',
                  fontWeight: labelFontWeight,
                  size: labelSize,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: CustomElevatedButton(
            width: 1,
            height: 50,
            onPressed: () {
              // GoRouter.of(context)
              //     .pushReplacementNamed(MyAppRouteConstants.loginRouteName);
              Navigator.of(context)
                  .pushReplacementNamed(RouteGeneratorConstants.indexPage);
              print('Logout Tapped');
            },
            backgroundColor: Colors.white,
            widget: CustomText(
              text: 'Logout',
              fontWeight: labelFontWeight,
              size: labelSize,
              color: CustomColors.lightRed,
            ),
          ),
        ),
      ],
    );
  }

  CustomGNavBar _bottomNavBar(context) {
    return CustomGNavBar(
      selectedIndex: index,
      onTap: (value) {
        index = value;
        print(index);
      },
    );
  }
}
