import 'dart:async';
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
// import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
// import 'package:platform_device_id_v3/platform_device_id.dart';

class LiveTrackingScreen extends StatefulWidget {
  LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  int index = 1;
  double latitude = 0.0;
  double longitude = 0.0;
  final Completer<GoogleMapController> _controller = Completer();
  // late DeviceinfoProvider _provider;

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

  // @override
  // void initState() {
  //   _provider = DeviceinfoProvider();
  //   // _provider.clearMarkers();
  //   // _provider.getUniqueIdentifier();
  //   // _provider.locationReplay();
  //   super.initState();
  // }

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
        // GoRouter.of(context)
        //     .pushReplacementNamed(MyAppRouteConstants.loginRouteName);
        Navigator.of(context)
            .pushReplacementNamed(RouteGeneratorConstants.homePage);
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
          body: _googleMap(context),
          // floatingActionButton: Consumer<DeviceinfoProvider>(
          //     builder: (context, deviceinfoProvider, _) {
          //   return Column(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [],
          //   );
          // }),
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
          tabName: 'Live',
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

  Widget _googleMap(context) {
    return Consumer<DeviceinfoProvider>(
      builder: (context, deviceInfoProvider, _) {
        // deviceInfoProvider.locationReplay();
        latitude = deviceInfoProvider.liveLatitude;
        longitude = deviceInfoProvider.liveLongitude;
        cameraPosition();
        // deviceInfoProvider.cameraPosition(_controller);
        return GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: const CameraPosition(
            target: LatLng(26.45845827202604, 87.28699164913807),
            zoom: 14,
          ),
          myLocationEnabled: true,
          tiltGesturesEnabled: true,
          compassEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          // trafficEnabled: traffic,
          mapToolbarEnabled: true,
          zoomControlsEnabled: false,
          // onMapCreated: _onMapCreated,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: deviceInfoProvider.livePositionMarkers,
          // polylines: deviceInfoProvider.polylines,
        );
      },
    );
  }

  Widget _osmMap(context) {
    return Consumer<DeviceinfoProvider>(
      builder: (context, deviceInfoProvider, _) {
        latitude = deviceInfoProvider.liveLatitude;
        longitude = deviceInfoProvider.liveLongitude;
        cameraPosition();
        // deviceInfoProvider.cameraPosition(_controller);
        return SfMaps(
          layers: [
            MapTileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
          ],
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
