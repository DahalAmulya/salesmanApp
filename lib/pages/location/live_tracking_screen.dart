import 'dart:async';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:deskgoo/pages/location/live_tracking_bottom_sheets/select_employee_bottom_sheet.dart';
import 'package:deskgoo/providers/deviceInfo_provider/deviceInfo_provider.dart';
import 'package:deskgoo/providers/live_tracking_provider/live_tracking_provider.dart';
// import 'package:deskgoo/routes/app_route_constants.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_navigation/gnav_bar.dart';
import 'package:deskgoo/widgets/bottom_sheets/custom_buttom_sheet.dart';
// import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/drawers/custom_drawer.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
// import 'package:platform_device_id_v3/platform_device_id.dart';

class LiveTrackingScreen extends StatefulWidget {
  LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  int index = 1;
  bool isAdmin = true;
  final Completer<GoogleMapController> _controller = Completer();
  // late DeviceinfoProvider _provider;

  Future<void> cameraPosition(double lat, double long) async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            lat,
            long,
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
          // appBar: _searchAppBar(context),
          drawer: _drawer(context),
          // drawerDragStartBehavior: DragStartBehavior.start,
          // body: _googleMap(context),
          // body: isAdmin ? _googleMap(context) : _ownGoogleMap(context),
          body: _ownGoogleMap(context),
          floatingActionButton: Consumer<DeviceInfoProvider>(
              builder: (context, deviceInfoProvider, _) {
            return FloatingActionButton.small(
              backgroundColor: CustomColors.primaryColor,
              onPressed: () {
                deviceInfoProvider.deviceInfoProvider();
                // SelectEmployeeBottomSheet.showBottomSheetForm(context);
                // Navigator.of(context)
                //     .pushNamed(RouteGeneratorConstants.replayPage);
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
            );
          }),
          bottomNavigationBar: _bottomNavBar(context),
        ),
      ),
    );
  }

  AppBar _searchAppBar(context) {
    return AppBar(
      title: CustomText(text: 'Live Tracking'),
      actions: [
        IconButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: CustomSearchDelegate(),
            );
          },
          icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
        ),
      ],
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
          showTrailingIcons: true,
          trailingSearchIcon: true,
          onTapTrailingSearchIcon: () {
            CustomBottomSheet.showBottomSheetForm(context);
            // showSearch(
            //   context: context,
            //   delegate: CustomSearchDelegate(),
            // );
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

  Widget _ownGoogleMap(context) {
    return Consumer<DeviceInfoProvider>(
      builder: (context, deviceInfoProvider, _) {
        // deviceInfoProvider.locationReplay();
        // latitude = deviceInfoProvider.liveLatitude;
        // longitude = deviceInfoProvider.liveLongitude;
        // if (latitude != null && longitude != null) {
        //   cameraPosition();
        // }
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

  Widget _googleMap(context) {
    return Consumer<LiveTrackingProvider>(
      builder: (context, liveTrackingProvider, _) {
        if (liveTrackingProvider.selectedEmpLatitude != null &&
            liveTrackingProvider.selectedEmpLongitude != null) {
          // longitude = liveTrackingProvider.selectedEmpLatitude!;
          // latitude = liveTrackingProvider.selectedEmpLongitude!;
          cameraPosition(liveTrackingProvider.selectedEmpLatitude!,
              liveTrackingProvider.selectedEmpLongitude!);
          liveTrackingProvider.setSelectedEmpLatLong(null, null);
        }
        return liveTrackingProvider.employeeLiveData.isNotEmpty
            ? Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.hybrid,
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(26.753945732907727, 87.52088961681855),
                      zoom: 9,
                    ),
                    myLocationEnabled: false,
                    tiltGesturesEnabled: true,
                    compassEnabled: true,
                    scrollGesturesEnabled: true,
                    zoomGesturesEnabled: true,
                    // trafficEnabled: traffic,
                    mapToolbarEnabled: false,
                    zoomControlsEnabled: false,
                    // onMapCreated: _onMapCreated,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      // customInfoWindow(controller);
                      liveTrackingProvider.latitude;
                      liveTrackingProvider.customInfoWindowController
                          .googleMapController = controller;
                      // _customInfoWindowController.googleMapController = controller;
                    },
                    markers: liveTrackingProvider.liveTrackingMarkers,
                    onTap: (location) {
                      liveTrackingProvider
                          .customInfoWindowController.hideInfoWindow!();
                    },
                    onCameraMove: (position) {
                      liveTrackingProvider
                          .customInfoWindowController.onCameraMove!();
                    },
                    // polylines: deviceInfoProvider.polylines,
                  ),
                  CustomInfoWindow(
                    controller: liveTrackingProvider.customInfoWindowController,
                    height: 260,
                    width: 250,
                    offset: 50,
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(
                  color: CustomColors.primaryColor,
                ),
              );
      },
    );
  }

  Widget _osmMap(context) {
    return Consumer<DeviceInfoProvider>(
      builder: (context, deviceInfoProvider, _) {
        // latitude = deviceInfoProvider.liveLatitude;
        // longitude = deviceInfoProvider.liveLongitude;
        // cameraPosition();
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

class CustomSearchDelegate extends SearchDelegate {
  // LiveTrackingProvider _liveTrackingProvider =
  //     Provider.of<LiveTrackingProvider>(context,listen: false);
  List<String> searchTerms = [
    'samsung SM-G980F',
    'Redmi M2006C3MII',
    'iQOO I2301',
    'Redmi M2006C3MII',
    'samsung SM-E225F'
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var names in searchTerms) {
      if (names.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(names);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          //     onTap: () {
          // },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var names in searchTerms) {
      if (names.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(names);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          // onTap: () {
          //   // update the search bar with the selected suggestion
          //   updateSearch(context, result);
          //   close(context, null);
          // },
        );
      },
    );
  }
}
