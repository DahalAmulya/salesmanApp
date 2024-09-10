import 'package:deskgoo/routes/app_route_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomGNavBar extends StatelessWidget {
  const CustomGNavBar({super.key, required this.onTap, this.selectedIndex = 2});

  final Function(int) onTap;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return GNav(
      onTabChange: onTap,
      selectedIndex: selectedIndex,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      backgroundColor: CustomColors.primaryBlack,
      color: CustomColors.primaryBackgroundColor,
      activeColor: CustomColors.primaryBackgroundColor,
      tabActiveBorder: Border.all(color: CustomColors.primaryBackgroundColor),
      tabBorderRadius: 100,
      tabMargin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
      tabs:  [
        GButton(
          // margin: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          icon: FontAwesomeIcons.house,
          gap: 12,
          text: 'Home',
        ),
        GButton(
          // margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          icon: FontAwesomeIcons.solidHeart,
          gap: 12,
          text: 'Favourite',
        ),
        GButton(
          // margin: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          icon: FontAwesomeIcons.magnifyingGlass,
          gap: 12,
          text: 'Search',
        ),
        GButton(
          onPressed: (){
            GoRouter.of(context).pushReplacementNamed(MyAppRouteConstants.remoteAttendanceRouteName);
          },
          // margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          icon: FontAwesomeIcons.gear,
          gap: 12,
          text: 'Settings',
        ),
      ],
    );
  }
}
