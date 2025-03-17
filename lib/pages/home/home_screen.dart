import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:deskgoo/classes/background_task_handler.dart';
import 'package:deskgoo/classes/notification_controller.dart';
import 'package:deskgoo/pages/mr_officers_pages/weeklyplan/weeklyplan_screen.dart';
import 'package:deskgoo/providers/deviceInfo_provider/deviceInfo_provider.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_navigation/gnav_bar.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drawers/custom_drawer.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import '../../consts.dart';
import '../../providers/login_provider/login_provider.dart';
import '../../providers/marketing_provider/officerName_provider.dart';
import '../../providers/marketing_provider/officersDescription_provider.dart';
import '../../utils/ScreenWIdth.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DeviceInfoProvider? _deviceinfoProvider;
  MarketingProvider? _marketingProvider;
  final LocalAuthentication auth = LocalAuthentication();
  int index = 0;
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
          floatingActionButton: FloatingActionButton(
            backgroundColor: CustomColors.primaryColor,
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => WeeklyPlanScreen()));
            },
            child: Icon(
              Icons.gps_fixed,
            ),
          ),
          bottomNavigationBar: _bottomNavBar(context),
        ),
      ),
    );
  }

  // PreferredSize _appBar(context) {
  //   return PreferredSize(
  //     preferredSize: Size.fromHeight(kToolbarHeight),
  //     child: Builder(
  //       builder: (context) => CustomAppBar(
  //         tabName: 'Dashboard',
  //         // titleColor: CustomColors.primaryBlack,
  //         titleColor: CustomColors.primaryBlack,
  //         backgroundColor: CustomColors.primaryColor,
  //         showLeading: true,
  //         leadingIcon: FontAwesomeIcons.bars,
  //         leadingIconColor: CustomColors.primaryBlack,
  //         onTapLeadingIcon: () {
  //           // Use the context under the Scaffold
  //           Scaffold.of(context).openDrawer();
  //         },
  //       ),
  //     ),
  //   );
  // }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Builder(
        builder: (context) =>
            Consumer<UserProvider>(builder: (context, userProvider, _) {
              return CustomAppBar(
                tabName: 'Hi, ${userName.split(' ')[0][0]}',
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
                height: 16,
              ),
              CustomContainer(
                color: Colors.white,
                verticalMargin: 0,
                verticalPad: 12,
                horizontalMargin: 8,
                horizontalPad: 0,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            MarketingManagerConstants.marketingOfficers);
                        // print('Tapped on Label');
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: CustomColors.primaryColor,
                              ),
                              width: 5,
                              height: 24,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: CustomText(
                                text: 'Marketing Officers',
                                size: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
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
                      itemCount:
                          marketingProvider.marketingOfficersDetails.length -
                              2, // Outer ListView
                      shrinkWrap:
                          true, // This allows it to take only the required height
                      physics:
                          NeverScrollableScrollPhysics(), // Disables scrolling for outer ListView, so the inner ListViews can handle scrolling
                      padding: EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        String name = marketingProvider
                            .marketingOfficersDetails[index]['OfficerName'];
                        int target = marketingProvider
                            .marketingOfficersDetails[index]['target'];
                        int achived = marketingProvider
                            .marketingOfficersDetails[index]['achieved'];
                        double indicatorValue = achived / target;
                        return InkWell(
                          onTap: () {
                            marketingProvider
                                .setSelectedOfficerVisitDetails(index);
                            Navigator.of(context).pushNamed(
                                MarketingManagerConstants
                                    .officerDescriptionPage);
                          },
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 16.0, top: 4),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          borderRadius:
                                              BorderRadius.circular(10),
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
}
