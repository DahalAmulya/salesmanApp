import 'dart:async';
import 'package:deskgoo/providers/deviceInfo_provider/deviceInfo_provider.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_navigation/gnav_bar.dart';
import 'package:deskgoo/widgets/drawers/custom_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_maps/maps.dart';
// import 'package:platform_device_id_v3/platform_device_id.dart';

class OwnLiveLocationScreen extends StatefulWidget {
  OwnLiveLocationScreen({super.key});

  @override
  State<OwnLiveLocationScreen> createState() => _OwnLiveLocationScreenState();
}

class _OwnLiveLocationScreenState extends State<OwnLiveLocationScreen> {
  int index = 1;
  double latitude = 0.0;
  double longitude = 0.0;
  final Completer<GoogleMapController> _controller = Completer();

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
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        Navigator.of(context).pushNamed(MarketingManagerConstants.homePage);
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
          floatingActionButton: FloatingActionButton.small(
            backgroundColor: CustomColors.primaryColor,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(MarketingManagerConstants.replayPage);
            },
            // shape: ShapeBorder.lerp(a, b, t),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                child: Icon(
                  CupertinoIcons.play_fill,
                  color: CustomColors.primaryBlack,
                ),
              ),
            ),
          ),
          bottomNavigationBar: _bottomNavBar(context),
        ),
      ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
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
    return const CustomDrawer(
      isHomeActive: true,
    );
  }

  Widget _googleMap(context) {
    return Consumer<DeviceInfoProvider>(
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
          myLocationEnabled: false,
          tiltGesturesEnabled: true,
          compassEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          // trafficEnabled: traffic,
          mapToolbarEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: deviceInfoProvider.livePositionMarkers,
        );
      },
    );
  }

  // Widget _osmMap(context) {
  //   return Consumer<DeviceInfoProvider>(
  //     builder: (context, deviceInfoProvider, _) {
  //       latitude = deviceInfoProvider.liveLatitude;
  //       longitude = deviceInfoProvider.liveLongitude;
  //       cameraPosition();
  //       // deviceInfoProvider.cameraPosition(_controller);
  //       return const SfMaps(
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
