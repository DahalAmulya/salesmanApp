import 'dart:async';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:deskgoo/pages/location/live_tracking_bottom_sheets/select_employee_bottom_sheet.dart';
import 'package:deskgoo/providers/deviceInfo_provider/deviceInfo_provider.dart';
import 'package:deskgoo/providers/live_tracking_provider/live_tracking_provider.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_sheets/custom_buttom_sheet.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
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
// import 'package:syncfusion_flutter_maps/maps.dart';

import '../../widgets/radio_button/custom_radio_button.dart';
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
          drawer: _drawer(context),
          body: _googleMap(context),
          floatingActionButton: Consumer<DeviceInfoProvider>(
              builder: (context, deviceInfoProvider, _) {
            return FloatingActionButton.small(
              backgroundColor: CustomColors.primaryColor,
              onPressed: () {
                SelectEmployeeBottomSheet.showBottomSheetForm(context);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Icon(
                  CupertinoIcons.play_fill,
                  color: CustomColors.primaryBlack,
                ),
              ),
            );
          }),
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
          icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
        ),
      ],
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
            Scaffold.of(context).openDrawer();
          },
          showTrailingIcons: true,
          trailingSearchIcon: true,
          onTapTrailingSearchIcon: () {
            CustomBottomSheet.showBottomSheetForm(context);
          },
        ),
      ),
    );
  }

  // PreferredSize _appBar(context) {
  CustomDrawer _drawer(context) {
    return const CustomDrawer(
      isLocationActive: true,
    );
  }

  Widget _ownGoogleMap(context) {
    return Consumer<DeviceInfoProvider>(
      builder: (context, deviceInfoProvider, _) {
        return GoogleMap(
          mapType: MapType.satellite,
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
          markers: deviceInfoProvider.livePositionMarkers,
        );
      },
    );
  }

  Widget _googleMap(context) {
    return Consumer<LiveTrackingProvider>(
      builder: (context, liveTrackingProvider, _) {
        if (liveTrackingProvider.selectedEmpLatitude != null &&
            liveTrackingProvider.selectedEmpLongitude != null) {
          cameraPosition(liveTrackingProvider.selectedEmpLatitude!,
              liveTrackingProvider.selectedEmpLongitude!);
          liveTrackingProvider.setSelectedEmpLatLong(null, null);
        }
        return liveTrackingProvider.employeeLiveData.isNotEmpty
            ? Stack(
                children: [
                  GoogleMap(
                    mapType: liveTrackingProvider.selectedMapType,
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
                    mapToolbarEnabled: true,
                    zoomControlsEnabled: true,
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
                  ),
                  CustomInfoWindow(
                    controller: liveTrackingProvider.customInfoWindowController,
                    height: 260,
                    width: 260,
                    offset: 50,
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.10,
                    right: 8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: ColoredBox(
                        color: Colors.white.withOpacity(0.7),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              openAlertDialog(context);
                            },
                            icon: Icon(
                              color: CustomColors.primaryBlack,
                              FontAwesomeIcons.layerGroup,
                              // size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
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

  void openAlertDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CustomColors.primaryWhite,
          elevation: 10,
          title: Consumer<LiveTrackingProvider>(
            builder: (context, liveTrackingProvider, _) {
              return Center(
                child: Column(
                  children: [
                    CustomText(
                      text: "Select Map Type",
                      isSubHeading: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomRadioButton(
                      radioGroupValue: liveTrackingProvider.radioGroupValue,
                      radioValue: liveTrackingProvider.mapType[0],
                      radioTitle: 'Normal',
                      onChange: (value) {
                        liveTrackingProvider.selectMapType(value);
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomRadioButton(
                      radioGroupValue: liveTrackingProvider.radioGroupValue,
                      radioValue: liveTrackingProvider.mapType[1],
                      radioTitle: 'Hybrid',
                      onChange: (value) {
                        liveTrackingProvider.selectMapType(value);
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomRadioButton(
                      radioGroupValue: liveTrackingProvider.radioGroupValue,
                      radioValue: liveTrackingProvider.mapType[2],
                      radioTitle: 'Terrain',
                      onChange: (value) {
                        liveTrackingProvider.selectMapType(value);
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      width: 1,
                      backgroundColor: CustomColors.primaryColor,
                      widget: CustomText(
                        text: "Done",
                        isContent: true,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
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
        );
      },
    );
  }
}
