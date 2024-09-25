import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:deskgoo/providers/camera_provider/camera_provider.dart';
import 'package:deskgoo/providers/deviceInfo_provider/deviceInfo_provider.dart';
import 'package:deskgoo/routes/app_route_constants.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_navigation/gnav_bar.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drawers/custom_drawer.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import 'ScreenWIdth.dart';
// import 'package:platform_device_id_v3/platform_device_id.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  int index = 0;
  double latitude = 0.0;
  double longitude = 0.0;
  final Completer<GoogleMapController> _controller = Completer();
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

  Future<void> cameraPosition() async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            latitude,
            longitude,
          ),
          zoom: 17,
        ),
      ),
    );
  }

  @override
  void initState() {
    getLocationPermission();
    // _provider = DeviceinfoProvider();
    // _provider.clearMarkers();
    // _provider.getUniqueIdentifier();
    // _provider.locationReplay();
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
          // drawerDragStartBehavior: DragStartBehavior.start,
          // body: _googleMap(context),
          body: _buildUI(context),
          floatingActionButton: FloatingActionButton(
            backgroundColor: CustomColors.primaryColor,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(RouteGeneratorConstants.cameraPage);
            },
            child: Image.asset(
              'assets/images/camera.png',
              width: 28,
              height: 28,
            ),
          ),
          bottomNavigationBar: _bottomNavBar(context),
        ),
      ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Builder(
        builder: (context) => CustomAppBar(
          tabName: 'Dashboard',
          titleColor: CustomColors.primaryBlack,
          backgroundColor: CustomColors.primaryColor,
          showLeading: true,
          leadingIcon: FontAwesomeIcons.bars,
          leadingIconColor: CustomColors.primaryBlack,
          onTapLeadingIcon: () {
            // Use the context under the Scaffold
            Scaffold.of(context).openDrawer();
          },
        ),
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
    double marketingContainerHeight = 0.0;

    print('width = $screenWidth');
    if (screenWidth < 375) {
      marketingContainerHeight = 0.88;
    }
    if (screenWidth >= 375 && screenWidth <= 393) {
      marketingContainerHeight = 0.78;
    }
    if (screenWidth >= 414 && screenWidth <= 430) {
      marketingContainerHeight = 0.80;
    }
    if (screenWidth > 430) {
      marketingContainerHeight = 0.88;
    }
    List<Map<String, dynamic>> marketingOfficersName = [
      {
        "OfficerName": "Rahul",
        "target": 20,
        "achieved": 10,
      },
      {
        "OfficerName": "Shuvam",
        "target": 20,
        "achieved": 6,
      },
      {
        "OfficerName": "Ram",
        "target": 20,
        "achieved": 9,
      },
      {
        "OfficerName": "Hari",
        "target": 20,
        "achieved": 4,
      },
      {
        "OfficerName": "Rajan",
        "target": 20,
        "achieved": 13,
      }
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            height:
                MediaQuery.of(context).size.width * marketingContainerHeight,
            // height: double.infinity,
            width: MediaQuery.of(context).size.width * 0.95,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 3,
                  spreadRadius: 1,
                  offset: const Offset(3, 3),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(
                //   height: 10,
                // ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: CustomColors.primaryColor,
                        ),
                        width: 5,
                        height: 18,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomText(
                        text: 'Marketing Officers',
                        size: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.chevron_right),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    indent: 2,
                    color: Colors.grey,
                  ),
                ),
                // Wrapping the ListView.builder with Expanded
                Expanded(
                  child: ListView.builder(
                    itemCount: marketingOfficersName
                        .length, // Adjust itemCount as necessary
                    itemBuilder: (BuildContext context, int index) {
                      double indicatorValue = marketingOfficersName[index]
                              ['achieved'] /
                          marketingOfficersName[index]['target'];
                      print('indicatorValue $index = $indicatorValue');
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed(
                              RouteGeneratorConstants.officerDescriptionPage);
                        },
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 16.0, top: 13),
                                child: Text(
                                  marketingOfficersName[index]['OfficerName'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.primaryBlack,
                                    // color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: LinearProgressIndicator(
                                        value: indicatorValue,
                                        backgroundColor:
                                            CustomColors.primaryWhite,
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
                                      '${marketingOfficersName[index]['achieved']}/${marketingOfficersName[index]['target']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade600,
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
                ),
              ],
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

// if (screenWidth < 375) {
// marketingContainerHeight = 0.88;
// }
// if (screenWidth > 384)
// if (screenWidth >= 430) {
// marketingContainerHeight = 0.78;
// }
// if(screenWidth >= 585 && screenWidth <=550){
// marketingContainerHeight = 0.86;
// }
// if(screenWidth >= 500){
// marketingContainerHeight = 0.90;
// }
// if(screenWidth >= 540 && screenWidth <=805){
// marketingContainerHeight = 0.88;
// }