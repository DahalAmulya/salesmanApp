import 'dart:developer';
import 'package:background_task/background_task.dart';
import 'package:deskgoo/classes/background_task_handler.dart';
import 'package:deskgoo/consts.dart';
import 'package:deskgoo/notifications/notiService.dart';
import 'package:deskgoo/pages/mr_officers_pages/attendance_logs/todays_attendance_log_screen.dart';
import 'package:deskgoo/providers/attendance_provider/remote_attendance_provider.dart';
import 'package:deskgoo/providers/deviceInfo_provider/deviceInfo_provider.dart';
import 'package:deskgoo/providers/mr_officer_provider/mr_visit_provider.dart';
import 'package:deskgoo/routes/marketing_officer_consts.dart';
import 'package:deskgoo/services/database_service.dart';
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
import 'package:workmanager/workmanager.dart';

import '../../../../providers/login_provider/login_provider.dart';
import '../../../providers/mr_officer_provider/mr_visitLog_provider.dart';

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
    String from = '${DateTime.now().year}-${DateTime.now().month < 10 ? '0${DateTime.now().month}' : DateTime.now().month}-${DateTime.now().day}';
    String to = '${DateTime.now().year}-${DateTime.now().month < 10 ? '0${DateTime.now().month}' : DateTime.now().month}-${DateTime.now().day}';
    ERPResponse response = await ERPServices.getRequest(
        '/visitLogs?visitLogId=$userId&from=$from&to=$to', context);
    Map<String, dynamic> body = jsonDecode(response.body);
    print(body);
    if (response.statusCode == 200) {
      List<dynamic> visitLogs = body["visitLogs"]["visitLogs"];
      setState(() {
        totalVisit = visitLogs.length;
        debugPrint('*********************** \t\t Total Visits: $from \t\t *****************************');
        debugPrint('*********************** \t\t Total Visits: $to \t\t *****************************');
        debugPrint('*********************** \t\t Total Visits: $totalVisit \t\t *****************************');
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

  final DatabaseService _dbService = DatabaseService.instance;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding
        .ensureInitialized(); // Ensure Flutter bindings are initialized
    // NotificationController.getPermissions();
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
      child: Consumer<AttendanceProvider>(
        builder: (context, attendanceProvider, _) {
          return Scaffold(
            backgroundColor: CustomColors.primaryWhite,
            appBar: _appBar(context),
            body: _body(context),
            drawer: MrOfficerCustomDrawer(
              isHomeActive: true,
            ),
            // floatingActionButton: FloatingActionButton.small(
            //   onPressed: () async {
            //     // await _dbService.updatePOCById(1, {
            //     //   'remarks': 'new remark',
            //     // });
            //     await _dbService.deletePOCById(5);
            //     // _dbService.getAllPOCs();
            //     // Position position = await Geolocator.getCurrentPosition(
            //     //     desiredAccuracy: LocationAccuracy.best);
            //     // NotiService().showNotification(title: 'Test Notification', body: 'This is a test notification');
            //     // NotiService().scheduleNotification(title: 'Test Notification', body: 'This is a test notification', hour: 16, minute: 4);
            //     // Workmanager().registerOneOffTask('1234', 'download_task', initialDelay: Duration(seconds: 10), inputData: {
            //     //   'latitude': position.latitude,
            //     //   'longitude': position.longitude,
            //     // });
            //     //
            //     // Workmanager().registerPeriodicTask('65434', 'download_task', frequency: Duration(minutes: 15), inputData: {
            //     //   'latitude': position.latitude,
            //     //   'longitude': position.longitude,
            //     // });
            // }, child: Icon(Icons.notifications),),
          );
        }
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
    return Consumer<AttendanceProvider>(
      builder: (context, attendanceProvider, _) {
        return RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 300));
            attendanceProvider.getTodayAttendance(context);
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Today's Plans Section
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 6,
                  shadowColor: Colors.black12,
                  margin: const EdgeInsets.only(bottom: 20),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.event_note, color: Colors.blueAccent, size: 26),
                            SizedBox(width: 8),
                            Text("Today's Plan",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          todaysDateTime,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.grey, fontStyle: FontStyle.italic),
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Activity:",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            Expanded(
                              child: Text(activity,
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(color: Colors.black87)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Area:",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            Expanded(
                              child: Text(area,
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(color: Colors.black87)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Remark:",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            Expanded(
                              child: Text(remark,
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(color: Colors.black87)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Attendance Section
                InkWell(
                  onTap: (){
                    showModalBottomSheet(
                      isScrollControlled: true,
                      useSafeArea: true,
                      context: context,
                      builder: (context) =>
                          MrOfficerAttendanceBottomSheet(),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 6,
                    color: Colors.white,
                    shadowColor: Colors.black12,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Consumer<AttendanceProvider>(
                        builder: (context, attendanceProvider, _) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.access_time_filled,
                                      color: Colors.orangeAccent, size: 26),
                                  SizedBox(width: 8),
                                  Text("Attendance",
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const Divider(height: 24),
                              _infoRow("Status", attendanceProvider.status),
                              _infoRow("Check-in", attendanceProvider.checkInTimeStr),
                              _infoRow("Check-out", attendanceProvider.checkOutTimeStr),
                              _infoRow(
                                "Total Time",
                                "${attendanceProvider.hours}H ${attendanceProvider.minutes}M",
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: CustomColors.primaryColor,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14)),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                        const TodayAttendanceLogScreen()));
                                    attendanceProvider.setIsOffline(false);
                                    attendanceProvider.setSelectedAttendanceFilter(context, attendanceProvider.attendanceFilterList[0]);
                                    attendanceProvider.getTodayAttendance(context);
                                  },
                                  icon: Image.asset(
                                    'assets/images/biometricAttendanceWhite.png',
                                    scale: 14,
                                    color: Colors.black,
                                  ),
                                  label: const Text("View Today's Attendance Log",
                                      style: TextStyle(
                                        fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black)),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Today's Visits Section
                Consumer2<MrOfficeVisitLogProvider, MrOfficerVisitProvider>(
                  builder: (context, visitLogProvider, visitProvider, _) {
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 6,
                      color: Colors.white,
                      shadowColor: Colors.black12,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          visitLogProvider.setIsOffline(false);
                          visitProvider.setIsOffline(false);
                          visitLogProvider.updateSelectedDate(visitLogProvider.dateList[0], context);
                          visitLogProvider.getVisitLogs(context);
                          Navigator.of(context)
                              .pushNamed(MarketingOfficerConstants.visitLog);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.location_on,
                                      color: Colors.green, size: 26),
                                  SizedBox(width: 8),
                                  Text("Today's Visits",
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const Divider(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Total Visits",
                                      style: TextStyle(fontWeight: FontWeight.w600)),
                                  Text("$totalVisit",
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black87)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  /// Helper method for cleaner rows
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black54)),
          Text(value, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }

}
