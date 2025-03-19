import 'dart:convert';
import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:deskgoo/classes/notification_controller.dart';
import 'package:deskgoo/consts.dart';
import 'package:deskgoo/pages/notification_screen.dart';
import 'package:deskgoo/providers/attendance_provider/remote_attendance_provider.dart';
import 'package:deskgoo/providers/auth_provider/change_password_provider.dart';
import 'package:deskgoo/providers/deviceInfo_provider/deviceInfo_provider.dart';
import 'package:deskgoo/providers/login_provider/login_provider.dart';
import 'package:deskgoo/providers/marketing_provider/officerName_provider.dart';
import 'package:deskgoo/providers/marketing_provider/officersDescription_provider.dart';
import 'package:deskgoo/providers/mr_officer_provider/mr_visit_provider.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/utils/ScreenWIdth.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_navigation/gnav_bar.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/CustomLineBar.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drawers/custom_drawer.dart';
import 'package:deskgoo/widgets/indicators/indicator.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../../services/erp_services.dart';

class MarketingManagerDashboard extends StatefulWidget {
  MarketingManagerDashboard({super.key});

  @override
  State<MarketingManagerDashboard> createState() =>
      _MarketingManagerDashboardState();
}

class _MarketingManagerDashboardState extends State<MarketingManagerDashboard> {
  DeviceInfoProvider? _deviceinfoProvider;
  MarketingProvider? _marketingProvider;
  final LocalAuthentication auth = LocalAuthentication();
  String SelectedColors = '';
  int selectedIndex = 0;
  double percent = 0.0;
  Map<String,dynamic> logs = {};
  List<dynamic> userList = [];
  List<String> colors = ['red', 'yellow', 'green'];
  int index = 0;
  int touchedIndex = -1;
  String url = 'https://a02c-27-34-68-147.ngrok-free.app/api/location';
  // late DeviceinfoProvider _provider;
  double screenHeight = ScreenUtil.getScreenHeight();
  double screenWidth = ScreenUtil.getScreenWidth();

  void getLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      log('Location Denied');
      LocationPermission askPermission = await Geolocator.requestPermission();
    }
    // else {
    //   Position currentPosiont = await Geolocator.getCurrentPosition(
    //       desiredAccuracy: LocationAccuracy.best);
    // }
  }

  // void getUser()async{
  //   ERPResponse response = await ERPServices.getRequest('/visitLogs/users');
  //   // print(response.statusCode);
  //   // print(response.body);
  //   if(response.statusCode == 200){
  //     logs = jsonDecode(response.body);
  //     userList = logs["logs"];
  //     print(userList);
  //     percent = userList.length / 100;
  //   }
  // }

  void postData() {
    // Map<String, dynamic> data = {
    //   'mobileIdentifier': _uniqueIdentifier,
    //   'employeeName': _name,
    //   'latitude': _liveLatitude,
    //   'longitude': _liveLongitude,
    //   'batteryPercentage': _batteryLevel,
    //   'accuracy': _accuracy,
    //   'deviceTime': _deviceTime,
    //   'connectivityType': _connectivityType,
    //   'connectivityStatus': _connectivityStatus,
    //   'distance': _distance,
    // };
  }

  @override
  void initState() {
    _deviceinfoProvider =
        Provider.of<DeviceInfoProvider>(context, listen: false);
    _marketingProvider = Provider.of<MarketingProvider>(context, listen: false);
    getLocationPermission();

    NotificationController.getPermissions();
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );
    // getUser();
    // NotificationUtils.sendNotification(2, 'Home', 'You are on home screen');
    super.initState();
  }

  // @override
  // void dispose() {
  //   _provider.clearMarkers();
  //   _provider.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              elevation: 10,
              backgroundColor: CustomColors.primaryWhite,
              title: CustomText(
                text: 'Exit',
                fontWeight: FontWeight.bold,
                size: 24.0,
                color: Colors.red,
              ),
              content: CustomText(
                text: 'Are you sure you want to exit ?',
                fontWeight: FontWeight.w500,
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      // backgroundColor: Colors.green,
                      borderColor: CustomColors.primaryBlack,
                      widget: CustomText(
                        text: 'No',
                        fontWeight: FontWeight.w500,
                        color: CustomColors.primaryBlack,
                      ),
                    ),
                    CustomElevatedButton(
                      onPressed: () {
                        // First navigate to the root page '/' and remove all other pages from the stack.
                        // Navigate to the root page ('/') using GoRouter
                        // context.go(MyAppRouteConstants.loginRouteName); // Navigates to the initial page (home)
                        AttendanceProvider? attendanceProvider;
                        MrOfficerVisitProvider? mrOfficerVisitProvider;
                        ChangePasswordProvider? changePasswordProvider;
                        attendanceProvider = Provider.of<AttendanceProvider>(
                            context,
                            listen: false);
                        mrOfficerVisitProvider =
                            Provider.of<MrOfficerVisitProvider>(context,
                                listen: false);
                        changePasswordProvider =
                            Provider.of<ChangePasswordProvider>(context,
                                listen: false);
                        attendanceProvider.resetValue();
                        mrOfficerVisitProvider.clearTextControllersValue();
                        changePasswordProvider.resetValues();
                        Navigator.pop(context, false);
                        SystemNavigator.pop();
                        // exit(0);
                      },
                      // backgroundColor: Colors.red,
                      borderColor: Colors.red,
                      widget: CustomText(
                        text: 'Yes',
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
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
          drawer: _drawer(context),
          body: _buildUI(context),
          floatingActionButton: FloatingActionButton.small(
            backgroundColor: CustomColors.primaryColor,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NotificationScreen()));
            },
            child: Icon(Icons.add),
          ),
          // bottomNavigationBar: _bottomNavBar(context),
        ),
      ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Builder(
        builder: (context) =>
            Consumer<UserProvider>(builder: (context, userProvider, _) {
          return CustomAppBar(
            tabName: 'Hi, ${userName.split(' ')[0]}',
            centerTitle: false,
            titleColor: CustomColors.primaryBlack,
            backgroundColor: CustomColors.primaryColor,
            showLeading: true,
            isLeadingImage: true,
            imageName: 'assets/images/man.png',
            leadingIconColor: CustomColors.primaryBlack,
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
    );
  }

  // PreferredSize _appBar(context) {
  CustomDrawer _drawer(context) {
    return CustomDrawer(
      isHomeActive: true,
    );
  }

  Widget _buildUI(context) {
    return Consumer<DetailsProvider>(
      builder: (context, marketingProvider, _) {
        return RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
          },
          color: CustomColors.primaryColor,
          backgroundColor: Colors.white,
          child: ListView(
            children: [
              SizedBox(
                height: 8,
              ),
              // Center(
              //   child: CustomContainer(
              //     color: Colors.transparent,
              //     borderRadius: 8,
              //     width: 0.90,
              //     verticalPad: 8,
              //     horizontalPad: 0,
              //     child: Row(
              //       children: [
              //         CustomLineBar(),
              //         SizedBox(
              //           width: 8,
              //         ),
              //         CustomText(
              //           text: 'Quick Reports',
              //           isSubHeading: true,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // CarouselSlider.builder(
              //   options: CarouselOptions(
              //     height: 220,
              //     enlargeCenterPage: true,
              //     enlargeStrategy: CenterPageEnlargeStrategy.height,
              //     onPageChanged: (index, reason) => setState(
              //       () {
              //         selectedIndex = index;
              //       },
              //     ),
              //   ),
              //   itemCount: colors.length,
              //   itemBuilder: (BuildContext context, index, int realIndex) {
              //     SelectedColors = colors[index];
              //     return InkWell(
              //       onTap: (){
              //         Navigator.of(context).pushNamed(MarketingManagerConstants
              //             .MrAdminAttendanceReportScreen);
              //       },
              //       child: CustomContainer(
              //         horizontalMargin: 8,
              //         verticalPad: 0,
              //         horizontalPad: 0,
              //         verticalMargin: 0,
              //         color: Colors.white,
              //         borderRadius: 16,
              //         applyShadow: true,
              //         child: AspectRatio(
              //           aspectRatio: 1.3,
              //           child: ColoredBox(
              //             color: Colors.transparent,
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.start,
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Container(
              //                   color: Colors.amber,
              //                   padding: const EdgeInsets.all(8.0),
              //                   child: CustomText(
              //                     text: 'Today\'s Attendance',
              //                     isSubHeading: true,
              //                   ),
              //                 ),
              //                 SizedBox(
              //                   height: 24,
              //                 ),
              //                 Row(
              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                   crossAxisAlignment: CrossAxisAlignment.center,
              //                   children: <Widget>[
              //                     const SizedBox(
              //                       height: 16,
              //                     ),
              //                     Expanded(
              //                       child: SizedBox(
              //                         height: 100,
              //                         width: 100,
              //                         // aspectRatio: 1,
              //                         child: PieChart(
              //                           PieChartData(
              //                             pieTouchData: PieTouchData(
              //                                 touchCallback: (FlTouchEvent event,
              //                                     pieTouchResponse) {
              //                               setState(() {
              //                                 if (!event
              //                                         .isInterestedForInteractions ||
              //                                     pieTouchResponse == null ||
              //                                     pieTouchResponse
              //                                             .touchedSection ==
              //                                         null) {
              //                                   touchedIndex = -1;
              //                                   return;
              //                                 }
              //                                 touchedIndex = pieTouchResponse
              //                                     .touchedSection!
              //                                     .touchedSectionIndex;
              //                                 print(
              //                                     'touchedIndex = $touchedIndex');
              //                               });
              //                             }),
              //                             borderData: FlBorderData(
              //                               show: false,
              //                             ),
              //                             sectionsSpace: 0,
              //                             centerSpaceRadius: 30,
              //                             sections: showingSections(),
              //                           ),
              //                         ),
              //                       ),
              //                     ),
              //                     Column(
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       crossAxisAlignment: CrossAxisAlignment.start,
              //                       children: <Widget>[
              //                         Indicator(
              //                           color: CustomColors.jadeGreen,
              //                           // noOfObj: '10',
              //                           // objInPercentage: '10',
              //                           text: 'On-Time',
              //                           isSquare: true,
              //                         ),
              //                         SizedBox(
              //                           height: 4,
              //                         ),
              //                         Indicator(
              //                           color: CustomColors.lightYellow,
              //                           text: 'Grace-Time',
              //                           // noOfObj: '10',
              //                           // objInPercentage: '10',
              //                           isSquare: true,
              //                         ),
              //                         SizedBox(
              //                           height: 4,
              //                         ),
              //                         Indicator(
              //                           color: CustomColors.lightRed,
              //                           text: 'Late',
              //                           // noOfObj: '10',
              //                           // objInPercentage: '10',
              //                           isSquare: true,
              //                         ),
              //                         SizedBox(
              //                           height: 18,
              //                         ),
              //                       ],
              //                     ),
              //                     const SizedBox(
              //                       width: 28,
              //                     ),
              //                   ],
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //
              //         ////////////////////////////////////////////////////////
              //         // Stack(
              //         //   alignment: Alignment.center,
              //         //   children: [
              //         //     CustomText(text: 'Today\'s Attendance'),
              //         //     PieChart(
              //         //       swapAnimationDuration:
              //         //           const Duration(milliseconds: 500),
              //         //       swapAnimationCurve: Curves.easeInOut,
              //         //       PieChartData(
              //         //         sections: [
              //         //           PieChartSectionData(
              //         //             value: 33,
              //         //             color: CustomColors.lightGreen,
              //         //           ),
              //         //           PieChartSectionData(
              //         //             value: 33,
              //         //             color: CustomColors.lightYellow,
              //         //           ),
              //         //           PieChartSectionData(
              //         //             value: 33,
              //         //             color: CustomColors.lightRed,
              //         //           ),
              //         //         ],
              //         //       ),
              //         //     ),
              //         //   ],
              //         // ),
              //       ),
              //     );
              //   },
              // ),
              SizedBox(
                height: 8,
              ),
              // Center(
              //   child: buildIndicator(),
              // ),
              InkWell(
                onTap: (){
                  Navigator.of(context).pushNamed(MarketingManagerConstants
                      .mrAdminAttendanceReportScreen);
                },
                child: CustomContainer(
                  horizontalMargin: 8,
                  verticalPad: 16,
                  horizontalPad: 16,
                  verticalMargin: 0,
                  borderRadius: 16,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // CircularPercentIndicator(
                      //     radius: 96,
                      //     lineWidth: 32,
                      //   percent: 0.4,
                      //   progressColor: CustomColors.primaryColor,
                      //   backgroundColor: Colors.grey.shade300,
                      //   circularStrokeCap: CircularStrokeCap.round,
                      //   center: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       FittedBox(
                      //         fit: BoxFit.scaleDown,
                      //         child: CustomText(
                      //           text: 'Total Employee',
                      //           size: 14,
                      //           fontWeight: FontWeight.w600,
                      //         ),
                      //       ),
                      //       CustomText(text:'${userList.length.toString()}',isContent: true,),
                      //     ],
                      //   ),
                      // ),
                      Row(
                        children: [
                          CustomLineBar(),
                          SizedBox(
                            width: 8,
                          ),
                          CustomText(
                            text: 'Attendance Reports',
                            isSubHeading: true,
                          ),
                          Spacer(),
                          Icon(
                            FontAwesomeIcons.chevronRight,
                            size: 18,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Divider(),
                      ),
                      Row(
                        children: [
                          Image.asset('assets/images/attendance2.png',
                            height: 80,
                            width: 80,
                          ),
                          SizedBox(width: 48,),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Image.asset('assets/images/check-in.png',
                                    height: 24,
                                    width: 24,
                                    // color: CustomColors.primaryColor,
                                  ),
                                  SizedBox(width: 16,),
                                  CustomText(text: 'Checked In',isContent: true,),
                                ],
                              ),
                              SizedBox(height: 8,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Image.asset('assets/images/exit.png',
                                      height: 24,
                                      width: 24,
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  CustomText(text: 'Checked Out',isContent: true,),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              _reports(context),
              SizedBox(
                height: 16,
              ),
              _marketingOfficerReport(context, marketingProvider),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        );
      },
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

  Widget _reports(context) {
    return Center(
      child: CustomContainer(
        verticalPad: 12,
        horizontalPad: 0,
        // width:,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomLineBar(),
                    SizedBox(
                      width: 8,
                    ),
                    CustomText(
                      text: 'Reports',
                      isSubHeading: true,
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Icon(
                    FontAwesomeIcons.chevronRight,
                    size: 18,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Divider(),
            ),
            _reportRows(
              context,
              imgName: 'officer',
              title: 'Marketing Officers',
              onTap: () {
                Navigator.of(context).pushNamed(
                    MarketingManagerConstants.reportMarketingOfficersScreen);
              },
            ),
            _reportRows(
              context,
              imgName: 'ambulance',
              title: 'Ambulance',
              onTap: () {
                print('Tapped Ambulance');
              },
            ),
            _reportRows(
              context,
              imgName: 'referral',
              title: 'Referral',
              onTap: () {
                Navigator.of(context).pushNamed(
                    MarketingManagerConstants.mrManagerReferralLogPage);
              },
            ),
            _reportRows(
              context,
              imgName: 'area',
              title: 'Area',
              onTap: () {
                print('Tapped Area');
                Navigator.of(context).pushNamed(MarketingManagerConstants
                    .areaReportMarketingOfficersScreen);
              },
            ),
            _reportRows(
              context,
              imgName: 'visits',
              title: 'Average Visits',
              onTap: () {
                Navigator.of(context).pushNamed(MarketingManagerConstants
                                .mrAdminAttendanceReportScreen);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _reportRows(context,
      {required String imgName,
      required String title,
      required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/reports_img/$imgName.png',
                  width: 42,
                  height: 42,
                ),
                SizedBox(
                  width: 12,
                ),
                CustomText(
                  text: title,
                  isContent: true,
                ),
              ],
            ),
            Icon(
              FontAwesomeIcons.chevronRight,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _marketingOfficerReport(context, marketingProvider) {
    return Center(
      child: CustomContainer(
        color: Colors.white,
        verticalMargin: 0,
        verticalPad: 12,
        horizontalPad: 0,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(MarketingManagerConstants.marketingOfficers);
                // print('Tapped on Label');
              },
              child: Row(
                children: [
                  CustomLineBar(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomText(
                        text: 'Marketing Officers',
                        isSubHeading: true,
                      ),
                    ),
                  ),
                  // const Spacer(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Icon(
                      FontAwesomeIcons.chevronRight,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Divider(),
            ),
            ListView.builder(
              itemCount: marketingProvider.marketingOfficersDetails.length -
                  2, // Outer ListView
              shrinkWrap:
                  true, // This allows it to take only the required height
              physics:
                  NeverScrollableScrollPhysics(), // Disables scrolling for outer ListView, so the inner ListViews can handle scrolling
              padding: EdgeInsets.all(0),
              itemBuilder: (context, index) {
                String name = marketingProvider.marketingOfficersDetails[index]
                    ['OfficerName'];
                int target =
                    marketingProvider.marketingOfficersDetails[index]['target'];
                int achived = marketingProvider.marketingOfficersDetails[index]
                    ['achieved'];
                double indicatorValue = achived / target;
                return InkWell(
                  onTap: () {
                    marketingProvider.setSelectedOfficerVisitDetails(index);
                    Navigator.of(context).pushNamed(
                        MarketingManagerConstants.officerDescriptionPage);
                  },
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 4),
                          child: Consumer<DetailsProvider>(
                            builder: (context, marketingProvider, _) {
                              return CustomText(
                                text: name,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.primaryBlack,
                                // color: Colors.grey.shade600,
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: LinearProgressIndicator(
                                  value: indicatorValue,
                                  backgroundColor: Colors.grey.shade300,
                                  color: CustomColors.primaryColor,
                                  minHeight: 6,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: Text(
                                '${achived < 10 ? '0$achived' : achived}/$target',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 14.0;
      final radius = isTouched ? 50.0 : 40.0;
      final shadows = [
        Shadow(
          color: Colors.black.withOpacity(0.8),
          blurRadius: 2,
        )
      ];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: CustomColors.jadeGreen,
            value: 20,
            title: '20%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: CustomColors.lightYellow,
            value: 20,
            title: '20%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: CustomColors.lightRed,
            value: 20,
            title: '20%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: selectedIndex,
        count: colors.length,
        effect: WormEffect(
          activeDotColor: CustomColors.primaryColor,
          dotColor: Colors.grey,
        ),
      );
}
