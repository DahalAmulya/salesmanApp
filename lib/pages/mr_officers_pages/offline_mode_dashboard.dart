import 'package:deskgoo/pages/mr_officers_pages/attendance_logs/model/attendance_model.dart';
import 'package:deskgoo/providers/attendance_provider/remote_attendance_provider.dart';
import 'package:deskgoo/providers/mr_officer_provider/mr_visit_provider.dart';
import 'package:deskgoo/routes/marketing_officer_consts.dart';
import 'package:deskgoo/services/database_service.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/drop_downs/custom_dropdown.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/mr_officer_provider/mr_visitLog_provider.dart';
import '../../routes/route_generator_constants.dart';
import 'attendance_logs/todays_attendance_log_screen.dart';

class OfflineModeDashboardScreen extends StatefulWidget {
  OfflineModeDashboardScreen({super.key});

  @override
  State<OfflineModeDashboardScreen> createState() => _OfflineModeDashboardScreenState();
}

class _OfflineModeDashboardScreenState extends State<OfflineModeDashboardScreen> {
  final DatabaseService _dbService = DatabaseService.instance;

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<AttendanceProvider>(context, listen: false).getLastAttendanceOffline(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) async {
        if (didpop) {
          return;
        }
        await _logoutDialog(context);
      }),
      child: Scaffold(
        backgroundColor: CustomColors.primaryWhite,
        appBar: _appBar(context),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Consumer<AttendanceProvider>(
                        builder: (context, attendanceProvider, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InkWell(
                            onTap: () async {
                              attendanceProvider.setIsOffline(true);
                              await attendanceProvider.getLocationPermission();
                              attendanceProvider.getCurrentLocation();
                              showDialog(
                                  context: context,
                                  builder: (_) => _attendanceDialog(context));
                              AttendanceModel attendance = AttendanceModel();
                            },
                            child: _sectionCard(
                              context,
                              title: "Offline Attendance",
                              icon: Icons.access_time_filled,
                              iconColor: attendanceProvider.lastAttendance.status == null ? Colors.orangeAccent : attendanceProvider.lastAttendance.status == "Check-In" ? CustomColors.jadeGreen : CustomColors.lightRed,
                              children: [
                                _infoRow("Status", attendanceProvider.lastAttendance.status ?? "Unknown"),
                                if(attendanceProvider.lastAttendance.status == "Check-In")
                                _infoRow("Check-In", attendanceProvider.lastAttendance.deviceTime!),
                                if(attendanceProvider.lastAttendance.status == "Check-Out")
                                _infoRow("Check-Out",  attendanceProvider.lastAttendance.deviceTime!),
                                if(attendanceProvider.lastAttendance.status == null)
                                _infoRow("Check-In", "Unknown"),
                                if(attendanceProvider.lastAttendance.status == null)
                                  _infoRow("Check-Out", "Unknown"),
                                const SizedBox(height: 12,),
                                _gradientButton(
                                  text: "View Offline Attendance",
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                      const TodayAttendanceLogScreen()));
                                    attendanceProvider.setIsOffline(true);
                                    attendanceProvider.setSelectedAttendanceFilter(context, attendanceProvider.attendanceFilterList[1]);

                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Consumer<MrOfficerVisitProvider>(
                              builder: (context, visitProvider, _) {
                            return _sectionCard(
                              context,
                              title: "Offline Visits",
                              icon: Icons.location_on,
                              iconColor: Colors.green,
                              children: [
                                const SizedBox(height: 16),
                                _gradientButton(
                                  text: "Create Offline Visit",
                                  onPressed: () {
                                    visitProvider.setIsOffline(true);
                                    Navigator.of(context).pushNamed(
                                      MarketingOfficerConstants.newVisit,
                                    );
                                  },
                                ),
                                const SizedBox(height: 12),
                                Consumer<MrOfficeVisitLogProvider>(
                                    builder: (context, visitLogProvider, _) {
                                  return _gradientButton(
                                    text: "View Offline Visits",
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                      MarketingOfficerConstants.visitLog,
                                    );
                                      visitLogProvider.updateSelectedDate(visitLogProvider.dateList[3], context);
                                      visitProvider.setIsOffline(true);
                                      visitLogProvider.setIsOffline(true);
                                    },
                                  );
                                }),
                              ],
                            );
                          }),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Offline Mode',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: CustomColors.primaryColor,
      centerTitle: true,
      elevation: 6,
      automaticallyImplyLeading: false,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, size: 26, color: Colors.black,),
          onPressed: () async{
            await _logoutDialog(context);
          },
        ),
      ],
    );
  }

  Widget _sectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CustomColors.primaryWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: iconColor.withOpacity(0.15),
                radius: 22,
                child: Icon(icon, color: iconColor, size: 26),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Divider(),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _gradientButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
        ),
        onPressed: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [CustomColors.primaryColor, Colors.blueAccent],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _attendanceDialog(context) {
    return Consumer<AttendanceProvider>(
      builder: (context, attendanceProvider, _) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Offline Attendance',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Consumer<AttendanceProvider>(
            builder: (context, attendanceProvider, _) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Attendance Status',
                      fontWeight: FontWeight.w600,
                      size: 18,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomDropdown(
                        labelText: '',
                        items: attendanceProvider.attendanceStatusList,
                        value: attendanceProvider.selectedAttendanceStatus,
                        onChanged: (value) {
                          attendanceProvider
                              .setSelectedAttendanceStatus(value!);
                        }),
                  ],
                ),
              );
            },
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.lightRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: CustomText(
                text: 'Cancel',
                isContent: true,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                await attendanceProvider.saveAttendanceOffline(context);
              },
              child: CustomText(
                text: 'Save',
                isContent: true,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logoutDialog(context){
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Go to Login Screen',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to return to the login screen?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: CustomText(text: 'Cancel', isSubContent: true,),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(
                MarketingManagerConstants.indexPage,
              );
            },
            child: CustomText(text: 'Confirm', isSubContent: true,),
          ),
        ],
      ),
    );
  }
}
