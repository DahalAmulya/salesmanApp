import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:deskgoo/classes/notification_controller.dart';
import 'package:deskgoo/models/visit_models/clients.dart';
import 'package:deskgoo/models/visit_models/visit_client_model.dart';
import 'package:deskgoo/providers/camera_provider/camera_provider.dart';
import 'package:deskgoo/providers/deviceInfo_provider/deviceInfo_provider.dart';
import 'package:deskgoo/providers/live_tracking_provider/live_tracking_provider.dart';
import 'package:deskgoo/routes/app_route_constants.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/utils/notification.dart';
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
import 'package:http/http.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../providers/settings_providers/profile_provider/officerName_provider.dart';
import 'ScreenWIdth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:platform_device_id_v3/platform_device_id.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DeviceinfoProvider? _deviceinfoProvider;
  MarketingProvider? _marketingProvider;
  final LocalAuthentication auth = LocalAuthentication();
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  int index = 0;
  double latitude = 0.0;
  double longitude = 0.0;
  final Completer<GoogleMapController> _controller = Completer();
  // late DeviceinfoProvider _provider;
  double screenHeight = ScreenUtil.getScreenHeight();
  double screenWidth = ScreenUtil.getScreenWidth();

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status error $e');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
  }

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
    _deviceinfoProvider =
        Provider.of<DeviceinfoProvider>(context, listen: false);
    _marketingProvider = Provider.of<MarketingProvider>(context, listen: false);
    // _marketingProvider!.name
    getLocationPermission();
    // _provider = DeviceinfoProvider();
    // _provider.clearMarkers();
    // _provider.getUniqueIdentifier();
    // _provider.locationReplay();

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
    NotificationUtils.sendNotification(2, 'Home', 'You are on home screen');
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
            onPressed: () async {
              // Create visit details
              VisitDetails visit1 = VisitDetails(
                visitCount: 0,
                clientVisitedPerson: 'Rita Sharma',
                clientVisitedPersonRelation: 'Wife',
                visitedDate: '2024-09-26 05:29:32',
                note: 'Person was not at home. Please visit again',
                isFollowUp: true,
                newFollowUpdate: '2024-09-28',
              );

              VisitClientModel client1 = VisitClientModel(
                clientName: 'Ram Sharma',
                clientPhoneNumber: '9812345678',
                clientEmail: 'ramsharma@gmail.com',
                clientAddress: 'biratnagar,mahendra chowk',
                clientWhatsApp: '9812345678',
                // visitDetails: [visit1],
              );

              // Add the client to the list
              // ClientsList.addClient(client1);

              // ClientsList.addVisitDetails(
              //   0,
              //   VisitDetails(
              //     visitedDate: '${DateTime.now().toString().split('.')[0]}',
              //     note: 'Visited Person',
              //     isFollowUp: false,
              //     newFollowUpdate: '',
              //   ),
              // );

              // ClientsList.clients[0].visitDetails!.add(
              //   VisitDetails(
              //       visitCount:
              //           ClientsList.clients[0].visitDetails!.last.visitCount! +
              //               1,
              //       visitedDate: '2024-09-28',
              //       note: 'Hello World',
              //       isFollowUp: false,
              //       newFollowUpdate: ''),
              // );
              // print('${ClientsList.clients[0].visitDetails!.last.visitCount}');
              // print(
              //     '${ClientsList.clients[0].visitDetails!.last.visitCount.runtimeType}');

              // Print all clients
              // ClientsList.getClientsList();

              // Navigator.of(context)
              //     .pushNamed(RouteGeneratorConstants.cameraPage);
              // ERPResponse response = await ERPServicer.getRequest('device');
              // print(response.statusCode);
              // Map<String, dynamic> body = jsonDecode(response.body);
              // List<dynamic> latestData = body['latestData'];
              // for (int i = 0; i < latestData.length; i++) {
              //   print(latestData[i]);
              // }
              // LiveTrackingProvider liveTrackingProvider =
              //     Provider.of<LiveTrackingProvider>(context, listen: false);
              // liveTrackingProvider.getAllEmployeesLocation();
              // Navigator.of(context)
              //     .pushNamed(RouteGeneratorConstants.replayPage);

              // final appDocDir = await getApplicationDocumentsDirectory();
              // final appDocPath = appDocDir.path;
              // print('App Documents Directory: $appDocPath');
              // final filePath = '${appDocPath}fileName';
              // final file = File(filePath);
              // await file.writeAsString('Thie is the content of the file...');
              // print(file.path);
              // print(await file.readAsString());

              // final tempDir = await getTemporaryDirectory();
              // final tempPath = tempDir.path;
              // print('App Documents Directory: $tempPath');
              // final appCacheDir = await getApplicationCacheDirectory();
              // print('app Cache Directory: ${appCacheDir.path}');
              // final appCacheDires = await getExternalCacheDirectories();
              // print('app Cache Directories: ${appCacheDires}');
              // final appSupportDir = await getApplicationSupportDirectory();
              // print('app Support Directory: ${appSupportDir.path}');
              // // final appLibraryDir = await getLibraryDirectory();
              // // print('app Library Directories: ${appLibraryDir.path}');
              // final appExternalStorageDires =
              //     await getExternalStorageDirectories(
              //         type: StorageDirectory.downloads);
              // print('app External Directories: ${appExternalStorageDires}');
              // final appExternalStorageDir = await getExternalStorageDirectory();
              // print('app External Directory: ${appExternalStorageDir!.path}');
              // final appDownloadDir = await getDownloadsDirectory();
              // print('app Download Directory: ${appDownloadDir!.path}');
              NotificationUtils.sendNotification(
                  1, 'Test', 'This is test notification');
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
    return SingleChildScrollView(
      child: Center(
        child: ListView.builder(
          itemCount: 2, // Outer ListView
          shrinkWrap: true, // This allows it to take only the required height
          physics:
              NeverScrollableScrollPhysics(), // Disables scrolling for outer ListView, so the inner ListViews can handle scrolling
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Outer List Item $index'), // Title for outer item
                ListView.builder(
                  itemCount: 5, // Inner ListView
                  shrinkWrap:
                      true, // This allows it to take only the required height
                  physics:
                      NeverScrollableScrollPhysics(), // Prevents nested scrolling conflict
                  itemBuilder: (context, innerIndex) {
                    return ListTile(
                      title: CustomText(text: 'Inner item $innerIndex'),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Widget _buildUI(context) {
  //   double marketingContainerHeight = 0.0;

  //   print('width = $screenWidth');
  //   if (screenWidth < 375) {
  //     marketingContainerHeight = 0.88;
  //   }
  //   if (screenWidth >= 375 && screenWidth <= 393) {
  //     marketingContainerHeight = 0.78;
  //   }
  //   if (screenWidth >= 414 && screenWidth <= 430) {
  //     marketingContainerHeight = 0.80;
  //   }
  //   if (screenWidth >= 430) {
  //     marketingContainerHeight = 0.92;
  //   }
  //   List<Map<String, dynamic>> marketingOfficersName = [
  //     {
  //       "OfficerName": "Rahul",
  //       "target": 20,
  //       "achieved": 10,
  //     },
  //     {
  //       "OfficerName": "Shuvam",
  //       "target": 20,
  //       "achieved": 6,
  //     },
  //     {
  //       "OfficerName": "Ram",
  //       "target": 20,
  //       "achieved": 9,
  //     },
  //     {
  //       "OfficerName": "Hari",
  //       "target": 20,
  //       "achieved": 4,
  //     },
  //     {
  //       "OfficerName": "Rajan",
  //       "target": 20,
  //       "achieved": 13,
  //     }
  //   ];

  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Center(
  //         child: Container(
  //           padding: EdgeInsets.symmetric(vertical: 8.0),
  //           height:
  //               MediaQuery.of(context).size.width * marketingContainerHeight,
  //           // height: double.infinity,
  //           width: MediaQuery.of(context).size.width * 0.95,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(10),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black.withOpacity(0.1),
  //                 blurRadius: 3,
  //                 spreadRadius: 1,
  //                 offset: const Offset(3, 3),
  //               )
  //             ],
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               // const SizedBox(
  //               //   height: 10,
  //               // ),
  //               Row(
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.only(top: 10, bottom: 10),
  //                     child: Container(
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(50),
  //                         color: CustomColors.primaryColor,
  //                       ),
  //                       width: 5,
  //                       height: 18,
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.symmetric(horizontal: 8.0),
  //                     child: CustomText(
  //                       text: 'Marketing Officers',
  //                       size: 18,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   const Spacer(),
  //                   const Padding(
  //                     padding: EdgeInsets.all(8.0),
  //                     child: Icon(Icons.chevron_right),
  //                   ),
  //                 ],
  //               ),
  //               const Padding(
  //                 padding: EdgeInsets.only(left: 16.0),
  //                 child: Divider(
  //                   height: 1,
  //                   thickness: 1,
  //                   indent: 2,
  //                   color: Colors.grey,
  //                 ),
  //               ),
  //               // Wrapping the ListView.builder with Expanded
  //               Expanded(
  //                 child: ListView.builder(
  //                   itemCount: marketingOfficersName
  //                       .length, // Adjust itemCount as necessary
  //                   itemBuilder: (BuildContext context, int index) {
  //                     double indicatorValue = marketingOfficersName[index]
  //                             ['achieved'] /
  //                         marketingOfficersName[index]['target'];
  //                     print('indicatorValue $index = $indicatorValue');
  //                     return InkWell(
  //                       onTap: () {
  //                         _marketingProvider!.setName(
  //                             marketingOfficersName[index]['OfficerName']);
  //                         // print(marketingOfficersName[index]['OfficerName']);
  //                         Navigator.of(context).pushNamed(
  //                             RouteGeneratorConstants.officerDescriptionPage);
  //                       },
  //                       child: Container(
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             Padding(
  //                               padding:
  //                                   const EdgeInsets.only(left: 16.0, top: 13),
  //                               child: Consumer<MarketingProvider>(
  //                                   builder: (context, marketingProvider, _) {
  //                                 return CustomText(
  //                                   text: marketingOfficersName[index]
  //                                       ['OfficerName'],
  //                                   fontWeight: FontWeight.bold,
  //                                   color: CustomColors.primaryBlack,
  //                                   // color: Colors.grey.shade600,
  //                                 );
  //                               }),
  //                             ),
  //                             Row(
  //                               children: [
  //                                 Flexible(
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.symmetric(
  //                                         horizontal: 16.0),
  //                                     child: LinearProgressIndicator(
  //                                       value: indicatorValue,
  //                                       backgroundColor:
  //                                           CustomColors.primaryWhite,
  //                                       color: CustomColors.primaryColor,
  //                                       minHeight: 6,
  //                                       borderRadius: BorderRadius.circular(10),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 const SizedBox(
  //                                   width: 30,
  //                                 ),
  //                                 Padding(
  //                                   padding: EdgeInsets.only(right: 16.0),
  //                                   child: Text(
  //                                     '${marketingOfficersName[index]['achieved']}/${marketingOfficersName[index]['target']}',
  //                                     style: TextStyle(
  //                                       fontWeight: FontWeight.bold,
  //                                       color: Colors.grey.shade600,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
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
