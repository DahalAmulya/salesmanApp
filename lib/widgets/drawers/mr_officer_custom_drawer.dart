import 'dart:async';

import 'package:deskgoo/consts.dart';
import 'package:deskgoo/providers/attendance_provider/remote_attendance_provider.dart';
import 'package:deskgoo/providers/auth_provider/change_password_provider.dart';
import 'package:deskgoo/providers/login_provider/login_provider.dart';
import 'package:deskgoo/providers/mr_officer_provider/mr_visit_provider.dart';
import 'package:deskgoo/providers/profile/profile_provider.dart';
import 'package:deskgoo/routes/marketing_officer_consts.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/bottom_sheets/mr_officer_sheets/attendance.dart';
import 'package:deskgoo/widgets/bottom_sheets/mr_officer_sheets/select_referral_type.dart';
import 'package:deskgoo/widgets/bottom_sheets/mr_officer_sheets/select_visit_type.dart';
import 'package:deskgoo/widgets/drawers/drawers_items/custom_listTile.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';
import '../buttons/elevated_button.dart';
// import 'package:go_router/go_router.dart';

class MrOfficerCustomDrawer extends StatelessWidget {
  MrOfficerCustomDrawer({
    super.key,
    this.hasImage = true,
    // this.userImg,
    this.userImg = 'assets/images/man.png',
    // this.userName = 'John Cena',
    this.userRole = 'Wrestler',
    this.isHomeActive = false,
    this.isWeeklyPlanActive = false,
    this.isVisitActive = false,
    this.isAttendanceActive = false,
    this.isAlertDialog = false,
    this.isSwitched = false,
    this.previousTime = '',
    this.currentDifference = '',
  });

  final bool hasImage;
  final String? userImg;
  // final String userName;
  final String userRole;
  final bool isHomeActive;
  final bool isWeeklyPlanActive;
  final bool isVisitActive;
  final bool isAttendanceActive;
  final bool isAlertDialog;
  final bool isSwitched;
  String previousTime;
  String currentDifference;

  DateTime currentTime = DateTime.now();
  // Duration time = currentTime.difference(other)
  String? calculateCheckedInDuration() {
    previousTime = '2024-11-24 15:29:37.724407';
    DateTime currentTime = DateTime.now();
    Duration currentDifference =
        currentTime.difference(DateTime.parse(previousTime));
    // String formattedDate = DateFormat("hh:mm:ss").format(DateTime.parse(currentDifference));
    print(currentDifference);
  }

  void setTime() {
    Future.delayed(Duration(minutes: 12));
    () {
      print(calculateCheckedInDuration());
    };
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          return Consumer<ProfileProvider>(
            builder: (context, profileProvider, _) {
              return SafeArea(
                child: Container(
                  color: CustomColors.primaryColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
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
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100), // Circular border
                                    child: profileImage.isNotEmpty
                                        ? Image.network(
                                      profileImage,
                                      fit: BoxFit.cover,
                                      width: 80,
                                      height: 80,
                                    )
                                        : Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: CustomColors.primaryBlack,
                                      ),
                                      alignment: Alignment.center,
                                      child: CustomText(
                                        text: '${profileProvider.name.split(' ')[0][0]}${profileProvider.name.split(' ')[1][0]}',
                                        size: 24,
                                        color: CustomColors.primaryWhite,
                                        fontWeight: FontWeight.w600,
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
                                    text: profileProvider.name,
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
                                Navigator.of(context).pushNamed(
                                    MarketingOfficerConstants
                                        .mrStaffDashboardConst);
                              },
                              isTabActive: isHomeActive,
                              icon: FontAwesomeIcons.house,
                              text: 'Dashboard',
                            ),
                            CustomListTile(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    MarketingOfficerConstants.weeklyPlanConst);
                                print('WeeklyPlanScreen');
                              },
                              isTabActive: isWeeklyPlanActive,
                              text: 'Weekly Plan',
                              isIcon: false,
                              imgName: 'assets/images/plan.png',
                              imgBoxFit: BoxFit.scaleDown,
                              imgHeigt: 32,
                              imgWidth: 32,
                            ),
                            CustomListTile(
                              onTap: () {
                                Navigator.pop(context);
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  useSafeArea: true,
                                  context: context,
                                  builder: (context) =>
                                      MrOfficerSelectVisitTypeBottomSheet(),
                                );
                              },
                              isTabActive: isVisitActive,
                              isIcon: false,
                              imgName: 'assets/images/visitor.png',
                              imgBoxFit: BoxFit.scaleDown,
                              imgHeigt: 32,
                              imgWidth: 32,
                              // imgColor: Colors.transparent,
                              text: 'Visit',
                              textColor: CustomColors.primaryBlack,
                            ),
                            // CustomListTile(
                            //   onTap: () {
                            //     // GoRouter.of(context).pushReplacementNamed(
                            //     //     MyAppRouteConstants.visitRouteName);
                            //     Navigator.of(context)
                            //         .pushNamed(MarketingManagerConstants.visitPage);
                            //   },
                            //   isTabActive: isVisitActive,
                            //   isIcon: false,
                            //   imgName: 'assets/images/order.png',
                            //   imgBoxFit: BoxFit.scaleDown,
                            //   imgHeigt: 32,
                            //   imgWidth: 32,
                            //   // imgColor: Colors.transparent,
                            //   text: 'Order',
                            //   textColor: CustomColors.primaryBlack,
                            // ),
                            CustomListTile(
                              onTap: () {
                                Navigator.pop(context);
                                // MrOfficerAttendanceBottomSheet.attendanceBottomSheet(
                                //     context);
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  useSafeArea: true,
                                  context: context,
                                  builder: (context) =>
                                      MrOfficerAttendanceBottomSheet(),
                                );
                              },
                              isTabActive: isAttendanceActive,
                              isIcon: false,
                              imgName: 'assets/images/biometricAttendanceWhite.png',
                              imgBoxFit: BoxFit.scaleDown,
                              imgHeigt: 32,
                              imgWidth: 32,
                              imgColor: CustomColors.primaryBlack,
                              text: 'Attendance',
                              textColor: CustomColors.primaryBlack,
                            ),
                            CustomListTile(
                              onTap: () {
                                Navigator.pop(context);
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  useSafeArea: true,
                                  context: context,
                                  builder: (context) =>
                                      MrOfficerSelectReferralTypeBottomSheet(),
                                );
                              },
                              isTabActive: isAlertDialog,
                              text: 'Referral',
                              icon: Icons.share,
                            ),
                            CustomListTile(
                              onTap: () {
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

                                                // SystemNavigator.pop();
                                                AttendanceProvider?
                                                    attendanceProvider;
                                                MrOfficerVisitProvider?
                                                    mrOfficerVisitProvider;
                                                ChangePasswordProvider?
                                                    changePasswordProvider;
                                                attendanceProvider =
                                                    Provider.of<AttendanceProvider>(
                                                        context,
                                                        listen: false);
                                                mrOfficerVisitProvider = Provider
                                                    .of<MrOfficerVisitProvider>(
                                                        context,
                                                        listen: false);
                                                changePasswordProvider = Provider
                                                    .of<ChangePasswordProvider>(
                                                        context,
                                                        listen: false);
                                                attendanceProvider.resetValue();
                                                mrOfficerVisitProvider
                                                    .clearTextControllersValue();
                                                changePasswordProvider
                                                    .resetValues();
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
                                // Navigator.of(context)
                                //     .pushNamed(MarketingManagerConstants.indexPage);
                              },
                              isTabActive: isAlertDialog,
                              text: 'Logout',
                              icon: Icons.logout,
                              iconSize: 22.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          );
        },
      ),
    );
  }

  void openAlertDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              backgroundColor: CustomColors.primaryWhite,
              elevation: 10,
              title: Center(
                child: CustomText(
                  text: 'Select visit type',
                  fontWeight: FontWeight.bold,
                  size: 22,
                  color: CustomColors.primaryBlack,
                ),
              ),
              content: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Attendance',
                        fontWeight: FontWeight.w600,
                      ),
                      // Icon(Icons.arrow_forward_rounded,color: CustomColors.primaryColor,),
                      Switch.adaptive(value: isSwitched, onChanged: (value) {})
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text: 'Status'),
                      CustomText(text: 'Checked-out'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text: 'Check-in Time'),
                      CustomText(
                          text: currentTime
                              .toString()
                              .split('.')[0]
                              .split(' ')[1]),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text: 'Checked since'),
                      CustomText(text: '{formattedDate}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text: 'Check-out Time'),
                      CustomText(text: 'Not Checked-out'),
                    ],
                  ),
                  Center(child: Icon(Icons.fingerprint)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
