import 'dart:async';
import 'package:deskgoo/providers/replay_provider/replay_provider.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/utils/capitalized_string.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_navigation/gnav_bar.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drawers/custom_drawer.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
// import 'package:platform_device_id_v3/platform_device_id.dart';

class ReplayScreen extends StatefulWidget {
  ReplayScreen({super.key});

  @override
  State<ReplayScreen> createState() => _ReplayScreenState();
}

class _ReplayScreenState extends State<ReplayScreen> {
  ReplayProvider? _replayProvider;
  final LocalAuthentication auth = LocalAuthentication();
  int index = 1;
  final Completer<GoogleMapController> _controller = Completer();
  // late DeviceinfoProvider _provider;

  Future<void> _moveCamera(double latitude, double longitude) async {
    final GoogleMapController controller = await _controller.future;
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
    super.initState();
    _replayProvider = Provider.of<ReplayProvider>(context, listen: false);
  }

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
        _replayProvider!.setLeavePage(true);
        _replayProvider!.resetValues();
        Navigator.of(context).pop(MarketingManagerConstants.liveTrackingPage);
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
          // drawer: _drawer(context),
          // drawerDragStartBehavior: DragStartBehavior.start,
          body: _googleMap(context),
          // floatingActionButton:
          //     Consumer<ReplayProvider>(builder: (context, replayProvider, _) {
          //   return Column(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       // FloatingActionButton(
          //       //   backgroundColor: CustomColors.primaryColor,
          //       //   onPressed: () {
          //       //     if (!deviceinfoProvider.isRestartReplay) {
          //       //       deviceinfoProvider.toggleIsRestartReplay();
          //       //     }
          //       //     deviceinfoProvider.clearMarkers();
          //       //     deviceinfoProvider.updateLocation();
          //       //   },
          //       //   child: Image.asset(
          //       //     'assets/images/stream.png',
          //       //     width: 28,
          //       //     height: 28,
          //       //   ),
          //       // ),
          //       // SizedBox(height: 8.0),
          //       FloatingActionButton(
          //         backgroundColor: CustomColors.primaryColor,
          //         onPressed: () {
          //           // replayProvider.getEmployeeLocationById();
          //           replayProvider.toggleIsRestartReplay();
          //           replayProvider.clearMarkers();
          //           if (replayProvider.isPause) {
          //             replayProvider.toggleIsPause();
          //           }
          //           replayProvider.locationReplay();
          //         },
          //         child: Image.asset(
          //           'assets/images/replay.png',
          //           width: 28,
          //           height: 28,
          //         ),
          //       ),
          //       SizedBox(height: 8.0),
          //       FloatingActionButton(
          //         backgroundColor: CustomColors.primaryColor,
          //         onPressed: () {
          //           replayProvider.toggleIsPause();
          //         },
          //         child: Icon(
          //           replayProvider.isPause ? Icons.play_arrow : Icons.pause,
          //         ),
          //       ),
          //     ],
          //   );
          // }),
          // bottomNavigationBar: _bottomNavBar(context),
        ),
      ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Builder(
        builder: (context) => CustomAppBar(
          tabName: 'Replay',
          titleColor: CustomColors.primaryBlack,
          backgroundColor: CustomColors.primaryColor,
          showLeading: true,
          leadingIcon: FontAwesomeIcons.arrowLeft,
          leadingIconColor: CustomColors.primaryBlack,
          onTapLeadingIcon: () {
            // Use the context under the Scaffold
            // Scaffold.of(context).openDrawer();
            _replayProvider!.setLeavePage(true);
            _replayProvider!.resetValues();
            Navigator.of(context)
                .pop(MarketingManagerConstants.liveTrackingPage);
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
    return Consumer<ReplayProvider>(
      builder: (context, replayProvider, _) {
        if (replayProvider.latitude != 0.0 && replayProvider.longitude != 0.0) {
          _moveCamera(replayProvider.latitude, replayProvider.longitude);
          print('${replayProvider.latitude}, ${replayProvider.longitude}');
        }
        return replayProvider.name.isNotEmpty
            ? Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.hybrid,
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(26.45845827202604, 87.28699164913807),
                      zoom: 14,
                    ),
                    myLocationEnabled: false,
                    compassEnabled: true,
                    zoomControlsEnabled: false,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    markers: replayProvider.positionMarkers,
                    polylines: replayProvider.polylines,
                  ),
                  Positioned(
                    right: 12,
                    bottom: 8,
                    child: Center(
                      child: CustomContainer(
                        verticalPad: 8,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: CommonFunctions.capitalize(
                                      replayProvider.name),
                                  fontWeight: FontWeight.w600,
                                  size: 18,
                                ),
                                // CustomElevatedButton(
                                //   width: 0.15,
                                //   borderRadius: 100,
                                //   height: 48,
                                //   // onPressed: (){},
                                //   onPressed: () {
                                //     replayProvider.toggleIsPause();
                                //   },
                                //   backgroundColor: CustomColors.primaryColor,
                                //   widget: Icon(
                                //     replayProvider.isPause
                                //         ? Icons.play_arrow
                                //         : Icons.pause,
                                //   ),
                                // )
                              ],
                            ),
                            // SizedBox(
                            //   height: 8,
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CustomText(
                                      text: replayProvider.mobileDateTime,
                                      fontWeight: FontWeight.w600,
                                      size: 16,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    // CustomText(
                                    //   text: replayProvider.mobileDateTime,
                                    //   fontWeight: FontWeight.w500,
                                    //   size: 14,
                                    // ),
                                  ],
                                ),
                                CustomText(
                                  text:
                                      '${replayProvider.distance.toStringAsFixed(2)} m',
                                  fontWeight: FontWeight.w600,
                                  size: 16,
                                ),
                                CustomText(
                                  text:
                                      '${(replayProvider.totalDistance / 1000).toStringAsFixed(2)} km',
                                  fontWeight: FontWeight.w600,
                                  size: 16,
                                ),
                              ],
                            ),
                            // CustomText(text: '')
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    right: 12,
                    child: InkWell(
                      onTap: () {
                        replayProvider.toggleIsPause();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          // height: 24,
                          // width: 24,
                          color: CustomColors.lightRed,
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            replayProvider.isPause
                                ? FontAwesomeIcons.play
                                : FontAwesomeIcons.pause,
                            color: Colors.white,
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

  Widget _osmMap(context) {
    return Consumer<ReplayProvider>(
      builder: (context, replayProvider, _) {
        // latitude = replayProvider.latitude;
        // longitude = replayProvider.longitude;
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
