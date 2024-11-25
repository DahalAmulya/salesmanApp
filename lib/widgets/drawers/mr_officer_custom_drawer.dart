import 'dart:async';

import 'package:deskgoo/providers/login_provider/login_provider.dart';
import 'package:deskgoo/routes/marketing_officer_consts.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/bottom_sheets/mr_officer_sheets/attendance.dart';
import 'package:deskgoo/widgets/bottom_sheets/mr_officer_sheets/select_visit_type.dart';
import 'package:deskgoo/widgets/drawers/drawers_items/custom_listTile.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../pages/mr_officers/mr_officers_pages/mr_officers_visits/mr_officers_visits.dart';
import '../../pages/mr_officers/mr_officers_providers/mr_officer_visit_provider.dart';
import '../buttons/elevated_button.dart';
import '../containers/custom_container.dart';
import '../radio_button/custom_radio_button.dart';
// import 'package:go_router/go_router.dart';

class MrOfficerCustomDrawer extends StatelessWidget {
  MrOfficerCustomDrawer({
    super.key,
    this.hasImage = true,
    // this.userImg,
    this.userImg = 'assets/images/johnCena.jpg',
    this.userName = 'John Cena',
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
  final String userName;
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
  String? calculateCheckedInDuration(){
    previousTime = '2024-11-24 15:29:37.724407';
    DateTime currentTime = DateTime.now();
    Duration currentDifference = currentTime.difference(DateTime.parse(previousTime));
    // String formattedDate = DateFormat("hh:mm:ss").format(DateTime.parse(currentDifference));
    print(currentDifference);
  }
  void setTime(){
    Future.delayed(Duration(minutes: 12));(){
      print(calculateCheckedInDuration());
    };
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Consumer<UserProvider>(builder: (context, userProvider, _) {
        return SafeArea(
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
                                          text:
                                              '${userName.split(' ')[0][0]} ${userName.split(' ')[1][0]}',
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
                              text: userProvider.fullName,
                              color: CustomColors.primaryBlack,
                              fontWeight: FontWeight.w600,
                            ),
                            CustomText(
                              text: userProvider.role,
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
                          Navigator.of(context).pushNamed(
                              MarketingOfficerConstants.mrStaffDashboardConst);
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
                        icon: Icons.add,
                      ),
                      CustomListTile(
                        onTap: () {
                          Navigator.pop(context);
                          // MrOfficerAttendanceBottomSheet.attendanceBottomSheet(
                          //     context);
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) =>
                                MrOfficerSelectVisitTypeBottomSheet(),
                          );
                          // Navigator.of(context)
                          //     .pushNamed(MarketingManagerConstants.visitPage);
                        },
                        isTabActive: isVisitActive,
                        isIcon: false,
                        imgName: 'assets/images/visit.png',
                        imgBoxFit: BoxFit.scaleDown,
                        imgHeigt: 32,
                        imgWidth: 32,
                        // imgColor: Colors.transparent,
                        text: 'Visit',
                        textColor: CustomColors.primaryBlack,
                      ),
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
                        imgName: 'assets/images/biometricattendenceBold.png',
                        imgBoxFit: BoxFit.scaleDown,
                        imgHeigt: 32,
                        imgWidth: 32,
                        imgColor: CustomColors.primaryBlack,
                        text: 'Attendance',
                        textColor: CustomColors.primaryBlack,
                      ),
                      CustomListTile(
                        onTap: () {
                          // GoRouter.of(context).pushReplacementNamed(
                          //     MyAppRouteConstants.remoteAttendanceRouteName);
                          // Navigator.of(context).pushNamed(
                          //     MarketingManagerConstants.remoteAttendancePage);
                          // openAlertDialog(context);
                          previousTime = '2024-11-24 15:29:37.724407';
                          DateTime currentTime = DateTime.now();
                          currentDifference = currentTime.difference(DateTime.parse(previousTime)).toString();
                          print(currentDifference);
                          int seconds = 0;
                          // Timer that runs every 2 seconds
                          Timer.periodic(Duration(seconds: 1), (Timer timer) {
                            seconds++;
                            DateTime currentTime = DateTime.now();
                            Duration currentDifference = currentTime.difference(DateTime.parse(previousTime));
                            print('time = $currentDifference');
                            print(DateTime.parse(currentDifference.toString()));
                           String formattedDate = DateFormat('hh:mm:ss').format(DateTime.now());
                            print(formattedDate);
                            // Stop the timer after 5 ticks
                            if (seconds == 60) {
                             timer.cancel();
                              // seconds = 60;
                              print("Timer stopped");
                            }
                          });
                        },
                        isTabActive: isAlertDialog,
                        text: 'Alert Dialog',
                        icon: Icons.add_alert,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
  void openAlertDialog(context){
    showDialog(
        context: context,
        builder: (BuildContext context){
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
                        Switch.adaptive(
                            value: isSwitched,
                            onChanged: (value){

                            })
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
                        CustomText(text: currentTime.toString().split('.')[0].split(' ')[1]),
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

          // AlertDialog(
          //   backgroundColor: Colors.white,
          //   title: Center(
          //     child: SingleChildScrollView(
          //       child: CustomContainer(
          //         // width: 1,
          //         verticalPad: 16,
          //         horizontalPad: 0,
          //         child: Consumer<MrOfficerVisitProvider>(
          //           builder: (context, visitProvider, _) {
          //             return Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               children: [
          //                 Column(
          //                   children: [
          //                     CustomText(
          //                       text: 'Select Visit Type',
          //                       fontWeight: FontWeight.w600,
          //                       size: 22,
          //                     ),
          //                     SizedBox(
          //                       height: 8,
          //                     ),
          //                     CustomRadioButton(
          //                       radioGroupValue: visitProvider.radioGroupValue,
          //                       radioValue: visitProvider.vistTypeList[0],
          //                       radioTitle: visitProvider.vistTypeList[0],
          //                       onChange: (value) {
          //                         visitProvider.selectVisitType(value);
          //                       },
          //                     ),
          //                     CustomRadioButton(
          //                       radioGroupValue: visitProvider.radioGroupValue,
          //                       radioValue: visitProvider.vistTypeList[1],
          //                       radioTitle: visitProvider.vistTypeList[1],
          //                       showTrailingWidget: true,
          //                       trailingWidgetTitle: '15',
          //                       onChange: (value) {
          //                         visitProvider.selectVisitType(value);
          //                       },
          //                     ),
          //                     CustomRadioButton(
          //                       radioGroupValue: visitProvider.radioGroupValue,
          //                       radioValue: visitProvider.vistTypeList[2],
          //                       radioTitle: visitProvider.vistTypeList[2],
          //                       showTrailingWidget: true,
          //                       trailingWidgetTitle: '5',
          //                       onChange: (value) {
          //                         visitProvider.selectVisitType(value);
          //                       },
          //                     ),
          //                     SizedBox(
          //                       height: 8,
          //                     ),
          //                     Row(
          //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         CustomElevatedButton(
          //                           onPressed: () {
          //                             visitProvider.unSelectVisitType();
          //                             Navigator.of(context)
          //                                 .pop(MarketingManagerConstants.homePage);
          //                           },
          //                           // backgroundColor: ,
          //                           backgroundColor: CustomColors.lightRed,
          //                           widget: CustomText(
          //                             text: 'Cancel',
          //                             color: CustomColors.primaryBlack,
          //                             fontWeight: FontWeight.w500,
          //                           ),
          //                         ),
          //                         CustomElevatedButton(
          //                           onPressed: () {
          //                             bool isSelected =
          //                             visitProvider.setSelectedVisitType();
          //                             if (isSelected) {
          //                               Navigator.of(context).push(MaterialPageRoute(
          //                                   builder: (context) =>
          //                                       MROfficersVisitsScreen()));
          //                             }
          //                           },
          //                           backgroundColor: CustomColors.primaryColor,
          //                           widget: CustomText(
          //                             text: 'Next',
          //                             color: CustomColors.primaryBlack,
          //                             fontWeight: FontWeight.w500,
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                     const SizedBox(
          //                       height: 8,
          //                     ),
          //                   ],
          //                 ),
          //               ],
          //             );
          //           },
          //         ),
          //       ),
          //     ),
          //   ),
          // )
        });
  }
}
