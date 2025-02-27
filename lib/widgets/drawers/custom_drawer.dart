import 'package:deskgoo/consts.dart';
import 'package:deskgoo/pages/mr_officers_pages/weeklyplan/weeklyplan_screen.dart';
import 'package:deskgoo/providers/profile_provider/profile_provider.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/bottom_sheets/mr_officer_sheets/mr_admin_sheets/select_user_visit_type.dart';
import 'package:deskgoo/widgets/drawers/drawers_items/custom_listTile.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../buttons/elevated_button.dart';
// import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    this.hasImage = true,
    // this.userImg,
    this.userImg = 'assets/images/userLocation.png',
    // this.userName = 'John Cena',
    // this.userRole = 'Wrestler',
    this.isHomeActive = false,
    this.isLocationActive = false,
    this.isSettingActive = false,
    this.isWeeklyPlanActive = false,
    this.isVisitActive = false,
    this.isLogoutActive = false,
    this.isUsersActive = false,
  });

  final bool hasImage;
  final String? userImg;
  // final String userName;
  // final String userRole;
  final bool isHomeActive;
  final bool isLocationActive;
  final bool isSettingActive;
  final bool isWeeklyPlanActive;
  final bool isVisitActive;
  final bool isLogoutActive;
  final bool isUsersActive;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: SafeArea(
        child: Container(
          color: CustomColors.primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(MarketingManagerConstants.profilePage);
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    left: 16.0,
                    bottom: 8.0,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 34,
                        backgroundColor: CustomColors.primaryWhite,
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: hasImage
                                ? Image.asset(
                                    userImg!,
                                    fit: BoxFit.scaleDown,
                                  )
                                : Container(
                                    color: Colors.black,
                                    width: double.infinity,
                                    height: double.infinity,
                                    padding: EdgeInsets.all(4),
                                    child: Center(
                                      child: CustomText(
                                        text: userName,
                                        size: 24,
                                        color: CustomColors.primaryWhite,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: userName,
                            color: CustomColors.primaryBlack,
                            fontWeight: FontWeight.w600,
                          ),
                          CustomText(
                            text: role,
                            color: CustomColors.primaryBlack,
                            fontWeight: FontWeight.w500,
                            size: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: CustomColors.primaryBlack,
              ),
              Expanded(
                child: ListView(
                  children: [
                    CustomListTile(
                      onTap: () {
                        // GoRouter.of(context).pushReplacementNamed(
                        //     MyAppRouteConstants.homeNavBarRouteName);
                        Navigator.of(context)
                            .pushNamed(MarketingManagerConstants.homePage);
                      },
                      isTabActive: isHomeActive,
                      icon: FontAwesomeIcons.house,
                      text: 'Dashboard',
                    ),
                    CustomListTile(
                      onTap: () {
                        // GoRouter.of(context).pushReplacementNamed(
                        //     MyAppRouteConstants.homeNavBarRouteName);
                        Navigator.of(context).pushNamed(
                            MarketingManagerConstants.liveTrackingPage);
                      },
                      isTabActive: isLocationActive,
                      icon: FontAwesomeIcons.mapLocation,
                      text: 'Location',
                    ),
                    Consumer<UserProfileProvider>(
                      builder: (context, userProfileProvider, _) {
                        return CustomListTile(
                          onTap: () {
                            // GoRouter.of(context).pushReplacementNamed(
                            //     MyAppRouteConstants.homeNavBarRouteName);
                            // Navigator.of(context)
                            //     .pushNamed(MarketingManagerConstants.profilePage);
                            // createUserProvider.getUserDetails();
                            Navigator.pop(context);
                            showModalBottomSheet(
                              isScrollControlled: true,
                              useSafeArea: true,
                              context: context,
                              builder: (context) =>
                                  MrAdminSelectUserTypeBottomSheet(),
                            );
                            // Navigator.of(context).pushNamed(
                            //     MarketingManagerConstants.settingPage);
                          },
                          isTabActive: isUsersActive,
                          icon: FontAwesomeIcons.userLarge,
                          text: 'Users',
                        );
                      },
                    ),
                    Consumer<UserProfileProvider>(
                      builder: (context, userProfileProvider, _) {
                        return CustomListTile(
                          onTap: () {
                            // GoRouter.of(context).pushReplacementNamed(
                            //     MyAppRouteConstants.homeNavBarRouteName);
                            // Navigator.of(context)
                            //     .pushNamed(MarketingManagerConstants.profilePage);
                            Navigator.of(context).pushNamed(
                                MarketingManagerConstants.settingPage);
                          },
                          isTabActive: isSettingActive,
                          icon: FontAwesomeIcons.gear,
                          text: 'Settings',
                        );
                      },
                    ),
                    Consumer<UserProfileProvider>(
                      builder: (context, userProfileProvider, _) {
                        return CustomListTile(

                          onTap: () {
                            // GoRouter.of(context).pushReplacementNamed(
                            //     MyAppRouteConstants.homeNavBarRouteName);
                            // Navigator.of(context)
                            //     .pushNamed(MarketingManagerConstants.profilePage);
                            // Navigator.of(context).pushNamed(
                            //     MarketingManagerConstants.settingPage);
                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  elevation: 10,
                                  backgroundColor: CustomColors.primaryWhite,
                                  title: CustomText(
                                    text: 'Logout ?',
                                    isHeading: true,
                                    // fontWeight: FontWeight.bold,
                                    // size: 24.0,
                                    // color: Colors.red,
                                  ),
                                  content: CustomText(
                                    text: 'Are you sure you want to logout ?',
                                    maxLines: 2,
                                    isSubHeading: true,
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          // backgroundColor: Colors.green,
                                          backgroundColor:
                                          CustomColors.primaryColor,
                                          widget: CustomText(
                                            text: 'No',
                                            isContent: true,
                                          ),
                                        ),
                                        CustomElevatedButton(
                                          onPressed: () {
                                            // First navigate to the root page '/' and remove all other pages from the stack.
                                            // Navigate to the root page ('/') using GoRouter
                                            // context.go(MyAppRouteConstants.loginRouteName); // Navigates to the initial page (home)
                                            // Navigator.pop(context, false);
                                            Navigator.pop(context);
                                            Navigator.of(context).pushNamed(
                                                MarketingManagerConstants
                                                    .indexPage);
                                            // exit(0);
                                          },
                                          // backgroundColor: Colors.red,
                                          backgroundColor:
                                          CustomColors.lightRed,
                                          widget: CustomText(
                                            text: 'Yes',
                                            isContent: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          isTabActive: isLogoutActive,
                          icon: FontAwesomeIcons.arrowRightFromBracket,
                          text: 'Logout',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
