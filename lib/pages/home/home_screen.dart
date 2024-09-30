import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:deskgoo/classes/notification_controller.dart';
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
import '../../providers/marketing_provider/officerName_provider.dart';
import '../../providers/marketing_provider/officersDescription_provider.dart';
import '../../utils/ScreenWIdth.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DeviceinfoProvider? _deviceinfoProvider;
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
          body: _testListViewUI(context),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     Navigator.of(context)
          //         .pushNamed(RouteGeneratorConstants.backgroundLocationScreen);
          //   },
          //   child: Icon(
          //     Icons.gps_fixed,
          //   ),
          // ),
          // floatingActionButton: FloatingActionButton(
          //   backgroundColor: CustomColors.primaryColor,
          //   onPressed: () async {
          //     // Create visit details
          //     VisitDetails visit1 = VisitDetails(
          //       visitCount: 0,
          //       clientVisitedPerson: 'Rita Sharma',
          //       clientVisitedPersonRelation: 'Wife',
          //       visitedDate: '2024-09-26 05:29:32',
          //       note: 'Person was not at home. Please visit again',
          //       isFollowUp: true,
          //       newFollowUpdate: '2024-09-28',
          //     );

          // VisitClientModel client1 = VisitClientModel(
          //   clientName: 'Ram Sharma',
          //   clientPhoneNumber: '9812345678',
          //   clientEmail: 'ramsharma@gmail.com',
          //   clientAddress: 'biratnagar,mahendra chowk',
          //   clientWhatsApp: '9812345678',
          //   // visitDetails: [visit1],
          // );

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
          //   NotificationUtils.sendNotification(
          //       1, 'Test', 'This is test notification');
          // },
          //   child: Image.asset(
          //     'assets/images/camera.png',
          //     width: 28,
          //     height: 28,
          //   ),
          // ),
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

  Widget _testListViewUI(context) {
    return Consumer<DetailsProvider>(
      builder: (context, marketingProvider, _) {
        return ListView(
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
                      Navigator.of(context)
                          .pushNamed(RouteGeneratorConstants.marketingOfficers);
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
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: CustomText(
                            text: 'Marketing Officers',
                            size: 20,
                            fontWeight: FontWeight.bold,
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
                    // itemExtent: 60,
                    itemBuilder: (context, index) {
                      double indicatorValue = marketingProvider
                              .marketingOfficersDetails[index]['achieved'] /
                          marketingProvider.marketingOfficersDetails[index]
                              ['target'];
                      return InkWell(
                        onTap: () {
                          _marketingProvider!.setName(marketingProvider
                              .marketingOfficersDetails[index]['OfficerName']);
                          // print(marketingOfficersName[index]['OfficerName']);
                          Navigator.of(context).pushNamed(
                              RouteGeneratorConstants.officerDescriptionPage);
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
                                    text: marketingProvider
                                            .marketingOfficersDetails[index]
                                        ['OfficerName'],
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.primaryBlack,
                                    // color: Colors.grey.shade600,
                                  );
                                }),
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
                                      '${marketingProvider.marketingOfficersDetails[index]['achieved']}/${marketingProvider.marketingOfficersDetails[index]['target']}',
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
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
          ],
        );
      },
    );
  }

  Widget _buildUI(context) {
    double marketingContainerHeight = 0.0;

    print('width = $screenWidth');
    if (screenWidth < 375) {
      marketingContainerHeight = 0.88;
    }
    if (screenWidth >= 375 && screenWidth <= 393) {
      marketingContainerHeight = 0.74;
    }
    if (screenWidth > 393 && screenWidth < 414) {
      marketingContainerHeight = 0.84;
    }
    if (screenWidth >= 414 && screenWidth <= 430) {
      marketingContainerHeight = 0.80;
    }
    if (screenWidth >= 430) {
      marketingContainerHeight = 0.92;
    }
    if(screenWidth >= 500){
      marketingContainerHeight = 0.88;
    }
    return Consumer<DetailsProvider>(builder: (context, marketingProvider, _) {
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
                  Consumer<DetailsProvider>(
                      builder: (context, marketingProvider, _) {
                    double indicatorValue = marketingProvider
                            .marketingOfficersDetails[index]['achieved'] /
                        marketingProvider.marketingOfficersDetails[index]
                            ['target'];
                    return Flexible(
                      child: ListView.builder(
                        itemCount: marketingProvider.marketingOfficersDetails
                            .length, // Adjust itemCount as necessary
                        itemBuilder: (BuildContext context, int index) {
                          double indicatorValue = marketingProvider
                                  .marketingOfficersDetails[index]['achieved'] /
                              marketingProvider.marketingOfficersDetails[index]
                                  ['target'];
                          print('indicatorValue $index = $indicatorValue');
                          return InkWell(
                            onTap: () {
                              _marketingProvider!.setName(marketingProvider
                                      .marketingOfficersDetails[index]
                                  ['OfficerName']);
                              // print(marketingOfficersName[index]['OfficerName']);
                              Navigator.of(context).pushNamed(
                                  RouteGeneratorConstants
                                      .officerDescriptionPage);
                            },
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, top: 13),
                                    child: Consumer<DetailsProvider>(builder:
                                        (context, marketingProvider, _) {
                                      return CustomText(
                                        text: marketingProvider
                                                .marketingOfficersDetails[index]
                                            ['OfficerName'],
                                        fontWeight: FontWeight.bold,
                                        color: CustomColors.primaryBlack,
                                        // color: Colors.grey.shade600,
                                      );
                                    }),
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
                                          '${marketingProvider.marketingOfficersDetails[index]['achieved']}/${marketingProvider.marketingOfficersDetails[index]['target']}',
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
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      );
    });
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
