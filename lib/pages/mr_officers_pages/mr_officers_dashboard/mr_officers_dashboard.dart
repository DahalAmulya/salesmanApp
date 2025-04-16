import 'dart:developer';
import 'package:background_task/background_task.dart';
import 'package:deskgoo/classes/background_task_handler.dart';
import 'package:deskgoo/classes/is_token_expired.dart';
import 'package:deskgoo/classes/notification_controller.dart';
import 'package:deskgoo/classes/secure_storage.dart';
import 'package:deskgoo/consts.dart';
import 'package:deskgoo/providers/attendance_provider/remote_attendance_provider.dart';
import 'package:deskgoo/providers/deviceInfo_provider/deviceInfo_provider.dart';
import 'package:deskgoo/routes/marketing_officer_consts.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/utils/readUserCred.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_sheets/mr_officer_sheets/attendance.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/CustomLineBar.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drawers/mr_officer_custom_drawer.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show SystemNavigator, rootBundle;

import '../../../../providers/login_provider/login_provider.dart';

class MrOfficersDashboardScreen extends StatefulWidget {
  const MrOfficersDashboardScreen({super.key});

  @override
  State<MrOfficersDashboardScreen> createState() =>
      _MrOfficersDashboardScreenState();
}

class _MrOfficersDashboardScreenState extends State<MrOfficersDashboardScreen>
    with WidgetsBindingObserver {
  AttendanceProvider? attendanceProvider;
  DeviceInfoProvider? deviceInfoProvider;
  List<String> colors = ['red', 'yellow', 'green'];
  String SelectedColors = '';
  int selectedIndex = 0;
  Map<String, dynamic> todaysPlan = {};
  String activity = 'No activity for today';
  String area = 'No area for today';
  String remark = 'No remark for today';
  int totalVisit = 0;
  String todaysDateTime = DateFormat('yyyy/MM/dd, EEEE').format(DateTime.now());
  void result() async {
    final String jsonString =
        await rootBundle.loadString('assets/district.json');
    print(jsonString);
  }

  Future<List<Map<String, dynamic>>> readDistrictJson() async {
    // Load the JSON file from the assets
    final String response = await rootBundle.loadString('assets/district.json');

    // Decode the JSON into a List of Maps
    final List<dynamic> data = json.decode(response);
    return List<Map<String, dynamic>>.from(data);
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

  void loadData() async {
    final districts = await readDistrictJson();
    print(districts);
  }

  void updateStopDeviceLocationUpdates() {
    if (attendanceProvider!.isRemoteAttendanceSwitched) {
      deviceInfoProvider?.setIsAttendance(true);
      deviceInfoProvider?.updateLocation(context);
      print(
          'attendanceProvider.isRemoteAttendanceSwitched = ${attendanceProvider!.isRemoteAttendanceSwitched}, Posting device information');
    } else {
      deviceInfoProvider?.setIsAttendance(false);
      print(
          'attendanceProvider.isRemoteAttendanceSwitched = ${attendanceProvider!.isRemoteAttendanceSwitched}, Stop posting device information');
    }
  }

  void getTodayPlan() async {
    String planDate = DateTime.now().toString().split(' ')[0];
    ERPResponse response = await ERPServices.getRequest(
        "/plan/today?userId=$userId&planDate=$planDate", context);
    var decodedData = jsonDecode(response.body);
    print(decodedData);

    if (response.statusCode == 200) {
      todaysPlan = decodedData;
      // print(todaysPlan['activity'] ?? 'key not found');
      print(todaysPlan);

      if (todaysPlan.isNotEmpty) {
        setState(() {
          todaysDateTime = todaysPlan['todaysPlan']['mobileTime'];
          activity = todaysPlan['todaysPlan']['activity'];
          area = todaysPlan['todaysPlan']['area'];
          remark = todaysPlan['todaysPlan']['remark'];
        });
      }

      print(response.statusCode);
    } else {
      print(response.body);
    }
    // }
  }

  void getVisitLogs() async {
    DateTime now = DateTime.now();
    String date = now.toString().split(' ')[0];
    String from = '${date} 00:00:00';
    String to = '${date} 23:59:59';
    ERPResponse response = await ERPServices.getRequest(
        '/visitLogs?visitLogId=$userId&from=$from&to=$to', context);
    Map<String, dynamic> body = jsonDecode(response.body);
    print(body);
    if (response.statusCode == 200) {
      List<dynamic> visitLogs = body["visitLogs"]["visitLogs"];
      setState(() {
        totalVisit = visitLogs.length;
      });
      print(totalVisit);
      print(response.statusCode);
      print(response.body);
    }
    // print(_visitLogs);
  }

  // void checkToken() async {
    // await isTokenExpired(context);
  // }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding
        .ensureInitialized(); // Ensure Flutter bindings are initialized
    NotificationController.getPermissions();
    print('Not Running on browser');
    // WidgetsFlutterBinding.ensureInitialized();

    BackgroundTask.instance.setAndroidNotification(
      title: 'Deskgoo',
      message: 'Running in the background',
    );
    BackgroundTask.instance.setBackgroundHandler(backgroundHandler);

    WidgetsBinding.instance.addObserver(this);
    stopBackgroundServices();
    getLocationPermission();
    print(
        '*********************************** Checking Token *************************************');
    // checkToken();
    getTodayPlan();
    print(
        '************************************************************************');
    getVisitLogs();
    attendanceProvider =
        Provider.of<AttendanceProvider>(context, listen: false);
    deviceInfoProvider =
        Provider.of<DeviceInfoProvider>(context, listen: false);
    attendanceProvider?.getCurrentLocation();
    attendanceProvider?.getAttendanceStatus(context);
    deviceInfoProvider
        ?.setIsAttendance(attendanceProvider!.isRemoteAttendanceSwitched);
    UserCred().readUserCred();
  }

  void stopBackgroundServices() async {
    await BackgroundTask.instance.stop();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;

    if (state == AppLifecycleState.paused) {
      getBackgroundLocation();
      print('----------------------------------------------------------------');
      print('\t\tApp is in background');
      print('\t\tUserId = ${UserCred().userId}');
      isBackground = true;
      print('----------------------------------------------------------------');
    } else if (state == AppLifecycleState.resumed) {
      print('----------------------------------------------------------------');
      await BackgroundTask.instance.stop();
      isBackground = false;
      print('\t\tApp is in Foreground');
      print('----------------------------------------------------------------');
    }
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
              backgroundColor: CustomColors.primaryWhite,
              title: CustomText(
                text: 'Exit App?',
                isHeading: true,
                // fontWeight: FontWeight.bold,
                // size: 24.0,
                // color: Colors.red,
              ),
              content: CustomText(
                text: 'Are you sure you want to exit ?',
                maxLines: 2,
                isSubHeading: true,
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
                      backgroundColor: CustomColors.primaryColor,
                      widget: CustomText(
                        text: 'No',
                        isContent: true,
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
                      backgroundColor: CustomColors.lightRed,
                      widget: CustomText(
                        text: 'Yes',
                        isContent: true,
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
        body: _body(context),
        drawer: MrOfficerCustomDrawer(
          isHomeActive: true,
        ),
      ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Builder(
        builder: (context) =>
            Consumer<UserProvider>(builder: (context, userProvider, _) {
          return CustomAppBar(
            tabName: 'Hi, ${userName.split(' ')[0]}',
            centerTitle: false,
            titleColor: CustomColors.primaryBlack,
            backgroundColor: CustomColors.primaryColor,
            showLeading: true,
            isLeadingImage: true,
            imageName: 'assets/images/man.png',
            leadingIconColor: CustomColors.primaryBlack,
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
    );
  }

  Widget _body(context) {
    return ListView(
      children: [
        const SizedBox(
          height: 16,
        ),
        CustomContainer(
          horizontalPad: 0,
          horizontalMargin: 16,
          verticalPad: 12,
          applyShadow: true,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const CustomLineBar(),
                  const SizedBox(
                    width: 8,
                  ),
                  CustomText(
                    isSubHeading: true,
                    text: 'Today\'s Plans',
                  ),
                  const Spacer(),
                  const Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: Colors.black,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomText(
                      isSubHeading: true,
                      text: todaysDateTime,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: CustomText(
                            text: 'Activities',
                            isSubHeading: true,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: CustomText(
                            text: activity,
                            isContent: true,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: CustomText(
                            text: 'Areas',
                            isSubHeading: true,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: CustomText(
                            maxLines: 3,
                            textOverflow: TextOverflow.visible,
                            text: area,
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: CustomText(
                            text: 'Remarks',
                            isSubHeading: true,
                            maxLines: 2,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: CustomText(
                            maxLines: 4,
                            textOverflow: TextOverflow.visible,
                            text: remark,
                            isContent: true,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        CustomContainer(
          horizontalPad: 0,
          horizontalMargin: 16,
          verticalPad: 12,
          applyShadow: true,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    useSafeArea: true,
                    context: context,
                    builder: (context) => MrOfficerAttendanceBottomSheet(),
                  );
                  print('Pressed');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const CustomLineBar(),
                    const SizedBox(
                      width: 8,
                    ),
                    CustomText(
                      isSubHeading: true,
                      text: 'Attendance',
                    ),
                    const Spacer(),
                    const Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: Colors.black,
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Consumer<AttendanceProvider>(
                    builder: (context, attendanceProvider, _) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomText(
                              text: 'Status',
                              isSubHeading: true,
                              maxLines: 3,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: CustomText(
                              text: attendanceProvider.status,
                              isContent: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomText(
                              text: 'Check-in Time',
                              isSubHeading: true,
                              maxLines: 3,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: CustomText(
                              text: attendanceProvider.checkInTimeStr,
                              isContent: true,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomText(
                              text: 'Check-out Time',
                              isSubHeading: true,
                              maxLines: 3,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: CustomText(
                              text: attendanceProvider.checkOutTimeStr,
                              isContent: true,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomText(
                              text: 'Total Time',
                              isSubHeading: true,
                              maxLines: 3,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: attendanceProvider.hours,
                                  isContent: true,
                                ),
                                CustomText(
                                  text: 'H ',
                                  isSmallText: true,
                                ),
                                CustomText(
                                  text: attendanceProvider.minutes,
                                  isContent: true,
                                ),
                                CustomText(
                                  text: 'M',
                                  isSmallText: true,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        CustomContainer(
          horizontalPad: 0,
          horizontalMargin: 16,
          verticalPad: 12,
          applyShadow: true,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(MarketingOfficerConstants.visitLog);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const CustomLineBar(),
                    const SizedBox(
                      width: 8,
                    ),
                    CustomText(
                      isSubHeading: true,
                      text: 'Today\'s Visit',
                    ),
                    const Spacer(),
                    const Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: Colors.black,
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'Total Visit',
                      isSubHeading: true,
                    ),
                    CustomText(
                      maxLines: 3,
                      textOverflow: TextOverflow.clip,
                      text: totalVisit.toString(),
                      isContent: true,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
