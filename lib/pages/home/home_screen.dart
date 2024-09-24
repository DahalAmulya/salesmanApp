import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:deskgoo/providers/deviceInfo_provider/deviceInfo_provider.dart';
import 'package:deskgoo/routes/app_route_constants.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_navigation/gnav_bar.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/drawers/custom_drawer.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
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
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                backgroundColor: CustomColors.primaryColor,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(
                      RouteGeneratorConstants.liveTrackingPage);
                  // if (!deviceinfoProvider.isRestartReplay) {
                  //   deviceinfoProvider.toggleIsRestartReplay();
                  // }
                  // deviceinfoProvider.clearMarkers();
                  // deviceinfoProvider.updateLocation();
                },
                child: Image.asset(
                  'assets/images/stream.png',
                  width: 28,
                  height: 28,
                ),
              ),
              SizedBox(height: 8.0),
              FloatingActionButton(
                backgroundColor: CustomColors.primaryColor,
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(RouteGeneratorConstants.cameraPage);
                  // deviceinfoProvider.toggleIsRestartReplay();
                  // deviceinfoProvider.clearMarkers();
                  // if (deviceinfoProvider.isPause) {
                  //   deviceinfoProvider.toggleIsPause();
                  // }
                  // deviceinfoProvider.locationReplay();
                },
                child: Image.asset(
                  'assets/images/camera.png',
                  width: 28,
                  height: 28,
                ),
              ),
              // SizedBox(height: 8.0),
              // FloatingActionButton(
              //   backgroundColor: CustomColors.primaryColor,
              //   onPressed: () {
              //     deviceinfoProvider.toggleIsPause();
              //   },
              //   child: Icon(
              //     deviceinfoProvider.isPause ? Icons.play_arrow : Icons.pause,
              //   ),
              // ),
            ],
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
          tabName: 'Home',
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

  // Widget _googleMap(context) {
  //   return Consumer<DeviceinfoProvider>(
  //     builder: (context, deviceInfoProvider, _) {
  //       // deviceInfoProvider.locationReplay();
  //       latitude = deviceInfoProvider.latitude;
  //       longitude = deviceInfoProvider.longitude;
  //       cameraPosition();
  //       // deviceInfoProvider.cameraPosition(_controller);
  //       return GoogleMap(
  //         mapType: MapType.hybrid,
  //         initialCameraPosition: const CameraPosition(
  //           target: LatLng(26.45845827202604, 87.28699164913807),
  //           zoom: 14,
  //         ),
  //         myLocationEnabled: true,
  //         tiltGesturesEnabled: true,
  //         compassEnabled: true,
  //         scrollGesturesEnabled: true,
  //         zoomGesturesEnabled: true,
  //         // trafficEnabled: traffic,
  //         mapToolbarEnabled: true,
  //         zoomControlsEnabled: false,
  //         // onMapCreated: _onMapCreated,
  //         onMapCreated: (GoogleMapController controller) {
  //           _controller.complete(controller);
  //         },
  //         markers: deviceInfoProvider.positionMarkers,
  //         polylines: deviceInfoProvider.polylines,
  //       );
  //     },
  //   );
  // }

  // Widget _osmMap(context) {
  //   return Consumer<DeviceinfoProvider>(
  //     builder: (context, deviceInfoProvider, _) {
  //       latitude = deviceInfoProvider.latitude;
  //       longitude = deviceInfoProvider.longitude;
  //       cameraPosition();
  //       // deviceInfoProvider.cameraPosition(_controller);
  //       return SfMaps(
  //         layers: [
  //           MapTileLayer(
  //             urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
