import 'dart:async';
import 'dart:io';
import 'package:deskgoo/providers/deviceInfo_provider/deviceInfo_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_navigation/gnav_bar.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/drawers/custom_drawer.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:provider/provider.dart';
// import 'package:platform_device_id_v3/platform_device_id.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  int index = 0;
  bool _isAuthenticated = false;
  var deviceInfo = DeviceInfoPlugin();
  final Battery battery = Battery();
  final Completer<GoogleMapController> _controller = Completer();
  double latitude = 0.0;
  double longitude = 0.0;

  void getDeviceInfo() async {
    String udid;
    String consistentUdid;
    String? identifier;
    try {
      udid = await FlutterUdid.udid;
      consistentUdid = await FlutterUdid.consistentUdid;
    } on PlatformException {
      udid = 'Failed to get UDID.';
      consistentUdid = 'Failed to get UDID.';
      identifier = 'Failed to get identifier.';
    }
    print('udid = $udid');
    print('consistentUdid = $consistentUdid');
    print('identifier = $identifier');

// Be informed when the state (full, charging, discharging) changes
    battery.onBatteryStateChanged.listen((BatteryState state) async {
      print(await battery.batteryLevel);
    });

// Check if device in battery save mode
// Currently available on Android, iOS and Windows platforms only
    print(await battery.isInBatterySaveMode);
    // print('identifier: = $identifier');
    if (Platform.isAndroid) {
      // print('androidInfo.data = ${androidInfo.data}');
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      print(iosInfo.localizedModel);
      print(iosInfo.model);
      print(iosInfo.name);
      print(iosInfo.systemName);
      print(iosInfo.systemVersion);
      print(iosInfo.identifierForVendor);
      print(iosInfo.data);
    }
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
          zoom: 15,
        ),
      ),
    );
  }

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
                        SystemNavigator.pop();
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
      child: Scaffold(
        backgroundColor: CustomColors.primaryWhite,
        appBar: _appBar(context),
        drawer: _drawer(context),
        // drawerDragStartBehavior: DragStartBehavior.start,
        body: _buildUI(context),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: CustomColors.primaryColor,
              onPressed: () {
                getDeviceInfo();
                print('Pressed camera');
              },
              child: FaIcon(FontAwesomeIcons.camera),
            ),
          ],
        ),
        bottomNavigationBar: _bottomNavBar(context),
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

  Widget _buildUI(context) {
    return Consumer<DeviceinfoProvider>(
        builder: (context, deviceInfoProvider, _) {
      latitude = deviceInfoProvider.latitude;
      longitude = deviceInfoProvider.longitude;
      cameraPosition();
      // deviceInfoProvider.cameraPosition(_controller);
      return GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: const CameraPosition(
          target: LatLng(26.45845827202604, 87.28699164913807),
          zoom: 14,
        ),
        myLocationEnabled: false,
        tiltGesturesEnabled: true,
        compassEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        // trafficEnabled: traffic,
        mapToolbarEnabled: true,
        zoomControlsEnabled: true,
        // onMapCreated: _onMapCreated,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: deviceInfoProvider.positionMarkers,
        // {
        //   Marker(
        //     markerId: const MarkerId('value'),
        //     position: LatLng(
        //         deviceInfoProvider.latitude, deviceInfoProvider.longitude),
        //     // icon: BitmapDescriptor.fromBytes(icon!),
        //     // rotation: course,
        //     // infoWindow: InfoWindow(
        //     //   title: '${deviceName}',
        //     //   snippet: '${deviceSpeed.toStringAsFixed(0)} km/h',
        //     // ),
        //   ),
        // },
        // polylines: deviceLocationPolyline,
        // polylines: Set<Polyline>.of(polylines.values),
      );
    });

    // Container(
    //   width: double.infinity,
    //   height: double.infinity,
    //   margin: EdgeInsets.all(6),
    //   child: Center(
    //     child: Column(
    //       children: [
    //         // CustomText(
    //         //   text: _isAuthenticated ? 'Coming soon' : '********',
    //         //   fontWeight: FontWeight.w500,
    //         //   size: 20,
    //         // ),
    //         Consumer<DeviceinfoProvider>(
    //           builder: (context, deviceInfoProvider, _) {
    //             // deviceInfoProvider.updateLocation();
    //             return CustomText(
    //               text: 'longitude: ${deviceInfoProvider.latitude}',
    //               fontWeight: FontWeight.w500,
    //               size: 20,
    //             );
    //           },
    //         ),
    //         Consumer<DeviceinfoProvider>(
    //           builder: (context, deviceInfoProvider, _) {
    //             // deviceInfoProvider.updateLocation();
    //             return CustomText(
    //               text: 'longitude: ${deviceInfoProvider.longitude}',
    //               fontWeight: FontWeight.w500,
    //               size: 20,
    //             );
    //           },
    //         ),
    //         Consumer<DeviceinfoProvider>(
    //           builder: (context, deviceInfoProvider, _) {
    //             deviceInfoProvider.getBatteryLevel();
    //             return CustomText(
    //               text: 'batteryLevel: ${deviceInfoProvider.batteryLevel}',
    //               fontWeight: FontWeight.w500,
    //               size: 20,
    //             );
    //           },
    //         ),
    //       ],
    //     ),
    //   ),
    // );
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
