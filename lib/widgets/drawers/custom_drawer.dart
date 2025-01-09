import 'package:deskgoo/consts.dart';
import 'package:deskgoo/pages/mr_officers_pages/weeklyplan/weeklyplan_screen.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/drawers/drawers_items/custom_listTile.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    this.hasImage = true,
    // this.userImg,
    this.userImg = 'assets/images/johnCena.jpg',
    // this.userName = 'John Cena',
    // this.userRole = 'Wrestler',
    this.isHomeActive = false,
    this.isWeeklyPlanActive = false,
    this.isVisitActive = false,
    this.isAttendanceActive = false,
  });

  final bool hasImage;
  final String? userImg;
  // final String userName;
  // final String userRole;
  final bool isHomeActive;
  final bool isWeeklyPlanActive;
  final bool isVisitActive;
  final bool isAttendanceActive;

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
                    // CustomListTile(
                    //   onTap: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => WeeklyPlanScreen()));
                    //   },
                    //   isTabActive: isWeeklyPlanActive,
                    //   text: 'Weekly Plan',
                    //   icon: Icons.add,
                    // ),
                    // CustomListTile(
                    //   onTap: () {
                    //     GoRouter.of(context).pushReplacementNamed(
                    //         MyAppRouteConstants.remoteAttendanceRouteName);
                    //   },
                    //   isTabActive: isAttendanceActive,
                    //   isIcon: false,
                    //   imgName: 'assets/images/dashboard-monitor.png',
                    //   imgBoxFit: BoxFit.scaleDown,
                    //   imgHeigt: 32,
                    //   imgWidth: 32,
                    //   // imgColor: Colors.transparent,
                    //   text: 'Dashboard',
                    //   textColor: Colors.white,
                    // ),
                    // CustomListTile(
                    //   onTap: () {
                    //     // GoRouter.of(context).pushReplacementNamed(
                    //     //     MyAppRouteConstants.visitRouteName);
                    //     Navigator.of(context)
                    //         .pushNamed(MarketingManagerConstants.visitPage);
                    //   },
                    //   isTabActive: isVisitActive,
                    //   isIcon: false,
                    //   imgName: 'assets/images/visit.png',
                    //   imgBoxFit: BoxFit.scaleDown,
                    //   imgHeigt: 32,
                    //   imgWidth: 32,
                    //   // imgColor: Colors.transparent,
                    //   text: 'Visit',
                    //   textColor: CustomColors.primaryBlack,
                    // ),
                    // CustomListTile(
                    //   onTap: () {
                    //     // GoRouter.of(context).pushReplacementNamed(
                    //     //     MyAppRouteConstants.remoteAttendanceRouteName);
                    //     Navigator.of(context).pushNamed(
                    //         MarketingManagerConstants.remoteAttendancePage);
                    //   },
                    //   isTabActive: isAttendanceActive,
                    //   isIcon: false,
                    //   imgName: 'assets/images/biometricattendenceBold.png',
                    //   imgBoxFit: BoxFit.scaleDown,
                    //   imgHeigt: 32,
                    //   imgWidth: 32,
                    //   imgColor: CustomColors.primaryBlack,
                    //   text: 'Attendance',
                    //   textColor: CustomColors.primaryBlack,
                    // ),
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
