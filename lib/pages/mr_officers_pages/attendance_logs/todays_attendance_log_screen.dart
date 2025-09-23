import 'package:deskgoo/providers/attendance_provider/remote_attendance_provider.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/drop_downs/custom_dropdown.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../themes/custom_colors.dart';

class TodayAttendanceLogScreen extends StatefulWidget {
  const TodayAttendanceLogScreen({super.key});

  @override
  State<TodayAttendanceLogScreen> createState() =>
      _TodayAttendanceLogScreenState();
}

class _TodayAttendanceLogScreenState extends State<TodayAttendanceLogScreen>
    with SingleTickerProviderStateMixin {
  final DateFormat formatter = DateFormat("hh:mm a"); // Pretty time format

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryWhite,
      appBar: _appBar(context),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => Consumer<AttendanceProvider>(
                builder: (context, attendanceProvider, _) {
              return AlertDialog(
                backgroundColor: CustomColors.primaryWhite,
                title: CustomText(
                  text: 'Filter Options',
                  isSubHeading: true,
                ),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDropdown(
                        labelText: '',
                        items: attendanceProvider.attendanceFilterList,
                        value: attendanceProvider.selectedAttendanceFilter,
                        onChanged: (value) {
                          attendanceProvider
                              .setSelectedAttendanceFilter(context, value!);
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    backgroundColor: CustomColors.lightRed,
                    widget: CustomText(
                      text: 'Cancel',
                      isContent: true,
                    ),
                  ),
                  CustomElevatedButton(
                    onPressed: () {
                      if (attendanceProvider.selectedAttendanceFilter ==
                          attendanceProvider.attendanceFilterList[0]) {
                        Navigator.pop(context);
                        attendanceProvider.getTodayAttendance(context);
                      }
                      if (attendanceProvider.selectedAttendanceFilter ==
                          attendanceProvider.attendanceFilterList[1]) {
                        Navigator.pop(context);
                        attendanceProvider.getOfflineAttendanceList(context);
                      }
                    },
                    backgroundColor: CustomColors.primaryColor,
                    widget: CustomText(
                      text: 'Apply',
                      isContent: true,
                    ),
                  )
                ],
              );
            }),
          );
        },
        backgroundColor: CustomColors.primaryColor,
        child: Icon(FontAwesomeIcons.filter, color: Colors.black),
      ),
      body: Consumer<AttendanceProvider>(
          builder: (context, attendanceProvider, _) {
        return RefreshIndicator(
          backgroundColor: CustomColors.primaryColor,
          color: Colors.black,
          onRefresh: () async {
            Future.delayed(const Duration(milliseconds: 500));
            if (attendanceProvider.selectedAttendanceFilter ==
                attendanceProvider.attendanceFilterList[0]) {
              attendanceProvider.getTodayAttendance(context);
            }
            if (attendanceProvider.selectedAttendanceFilter ==
                attendanceProvider.attendanceFilterList[1]) {
              attendanceProvider.getOfflineAttendanceList(context);
            }
          },
          child: Consumer<AttendanceProvider>(
            builder: (context, provider, _) {
              final logs =
                  provider.todayAttendanceLog.attendance?.attendanceLogs ?? [];

              if (logs.isEmpty &&
                  attendanceProvider.offlineAttendanceList.isEmpty) {
                return ListView(
                  children: [
                    SizedBox(height: 300),
                    Center(
                      child: Text(
                        attendanceProvider.selectedAttendanceFilter ==
                                attendanceProvider.attendanceFilterList[0]
                            ? "No attendance data found"
                            : "No offline attendance data found",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ],
                );
              }

              return attendanceProvider.selectedAttendanceFilter !=
                      attendanceProvider.attendanceFilterList[1]
                  ? ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        final log = logs[index];

                        return TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: Duration(milliseconds: 400 + (index * 100)),
                          curve: Curves.easeOut,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 40 * (1 - value)),
                              child: Opacity(opacity: value, child: child),
                            );
                          },
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(22)),
                                ),
                                builder: (_) {
                                  return DraggableScrollableSheet(
                                    expand: false,
                                    initialChildSize: 0.5,
                                    maxChildSize: 0.8,
                                    minChildSize: 0.3,
                                    builder: (context, scrollController) {
                                      return SingleChildScrollView(
                                        controller: scrollController,
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 5,
                                              margin: const EdgeInsets.only(
                                                  bottom: 20),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            const Icon(Icons.access_time_filled,
                                                size: 50,
                                                color: Colors.blueAccent),
                                            const SizedBox(height: 12),
                                            const Text(
                                              "Attendance Details",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 20),
                                            ListTile(
                                              leading: const Icon(Icons.login,
                                                  color: Colors.green),
                                              title: const Text("Check In"),
                                              subtitle: Text(
                                                  _formatTime(log.checkIn)),
                                            ),
                                            ListTile(
                                              leading: const Icon(Icons.logout,
                                                  color: Colors.red),
                                              title: const Text("Check Out"),
                                              subtitle: Text(log
                                                      .checkOut.isNotEmpty
                                                  ? _formatTime(log.checkOut)
                                                  : "Not Checked Out"),
                                            ),
                                            ListTile(
                                              leading: const Icon(Icons.timer,
                                                  color: Colors.blue),
                                              title: const Text("Total Hours"),
                                              subtitle: Text(
                                                  "${log.totalHour.toStringAsFixed(2)} hrs"),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            borderRadius: BorderRadius.circular(18),
                            child: Card(
                              color: Colors.white,
                              elevation: 6,
                              shadowColor: Colors.black12,
                              margin: const EdgeInsets.only(bottom: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundColor: CustomColors.primaryColor
                                          .withOpacity(0.12),
                                      child: const Icon(Icons.access_time,
                                          size: 30, color: Colors.blue),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Check In: ${_formatTime(log.checkIn)}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            log.checkOut.isNotEmpty
                                                ? "Check Out: ${_formatTime(log.checkOut)}"
                                                : "Not Checked Out",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: log.checkOut.isNotEmpty
                                                    ? Colors.black87
                                                    : Colors.red,
                                                fontStyle: log.checkOut.isEmpty
                                                    ? FontStyle.italic
                                                    : FontStyle.normal,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const Icon(Icons.timelapse,
                                                  size: 16,
                                                  color: Colors.black38),
                                              const SizedBox(width: 4),
                                              Text(
                                                "Total: ${log.totalHour.toStringAsFixed(2)} hrs",
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black38),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_forever,
                                          color: Colors.redAccent, size: 26),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            title:
                                                const Text("Delete Attendance"),
                                            content: const Text(
                                                "Are you sure you want to delete this attendance record?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text("Cancel"),
                                              ),
                                              Consumer<AttendanceProvider>(
                                                builder:
                                                    (context, provider, _) =>
                                                        ElevatedButton.icon(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    provider
                                                        .deleteUserAttendanceById(
                                                            context, log.id);
                                                    Navigator.pop(context);
                                                  },
                                                  icon: const Icon(Icons.delete,
                                                      color: Colors.white),
                                                  label: const Text("Delete"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount:
                          attendanceProvider.offlineAttendanceList.length,
                      itemBuilder: (context, index) {
                        return TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: Duration(milliseconds: 400 + (index * 100)),
                          curve: Curves.easeOut,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 40 * (1 - value)),
                              child: Opacity(opacity: value, child: child),
                            );
                          },
                          child: InkWell(
                            onTap: () {},
                            child: Card(
                              color: Colors.white,
                              elevation: 6,
                              shadowColor: Colors.black12,
                              margin: const EdgeInsets.only(bottom: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundColor: CustomColors.primaryColor
                                          .withOpacity(0.12),
                                      child: const Icon(Icons.access_time,
                                          size: 30, color: Colors.blue),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Status: ${attendanceProvider.offlineAttendanceList[index].status}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.timelapse,
                                                  size: 16, color: Colors.grey),
                                              const SizedBox(width: 4),
                                              Text(
                                                attendanceProvider
                                                    .offlineAttendanceList[
                                                        index]
                                                    .deviceTime!,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                          child: const Icon(
                                              Icons.delete_forever,
                                              color: Colors.redAccent,
                                              size: 26),
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                title: const Text(
                                                    "Delete Attendance"),
                                                content: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      CustomText(
                                                        text:
                                                            "Are you sure you want to delete this attendance record?",
                                                        isContent: true,
                                                        maxLines: 3,
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      CustomText(
                                                        text:
                                                            "Status: ${attendanceProvider.offlineAttendanceList[index].status}",
                                                        isSubContent: true,
                                                      ),
                                                      CustomText(
                                                        text:
                                                            "Time: ${attendanceProvider.offlineAttendanceList[index].deviceTime}",
                                                        isSubContent: true,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: CustomText(
                                                      text: "Cancel",
                                                      isSubContent: true,
                                                    ),
                                                  ),
                                                  Consumer<AttendanceProvider>(
                                                    builder: (context, provider,
                                                            _) =>
                                                        ElevatedButton.icon(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.redAccent,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        attendanceProvider
                                                            .deleteOfflineAttendanceById(
                                                                context,
                                                                attendanceProvider
                                                                    .offlineAttendanceList[
                                                                        index]
                                                                    .attendanceId);
                                                      },
                                                      icon: const Icon(
                                                          Icons.delete,
                                                          color: Colors.white),
                                                      label: CustomText(
                                                        text: "Delete",
                                                        isSubContent: true,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        if(attendanceProvider.isOffline == false)
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        if(attendanceProvider.isOffline == false)
                                        InkWell(
                                          onTap: () {
                                            debugPrint('Attendance isOffline = ${attendanceProvider.isOffline}');
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                title: const Text(
                                                    "Submit Attendance"),
                                                content: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      CustomText(
                                                        text:
                                                            "Are you sure you want to submit this attendance record?",
                                                        isContent: true,
                                                        maxLines: 3,
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      CustomText(
                                                        text:
                                                            "Status: ${attendanceProvider.offlineAttendanceList[index].status}",
                                                        isSubContent: true,
                                                      ),
                                                      CustomText(
                                                        text:
                                                            "Time: ${attendanceProvider.offlineAttendanceList[index].deviceTime}",
                                                        isSubContent: true,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: CustomText(
                                                      text: "Cancel",
                                                      isSubContent: true,
                                                    ),
                                                  ),
                                                  Consumer<AttendanceProvider>(
                                                    builder: (context, provider,
                                                            _) =>
                                                        ElevatedButton.icon(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            CustomColors
                                                                .jadeGreen,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        attendanceProvider
                                                            .postOfflineAttendance(
                                                                context,
                                                                attendance:
                                                                    attendanceProvider
                                                                            .offlineAttendanceList[
                                                                        index]);
                                                      },
                                                      icon: const Icon(
                                                          Icons.delete,
                                                          color: Colors.white),
                                                      label: CustomText(
                                                        text: "Submit",
                                                        isSubContent: true,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Icon(Icons.check_box,
                                              color: CustomColors.jadeGreen,
                                              size: 26),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
            },
          ),
        );
      }),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        tabName: 'Today\'s Attendances',
        centerTitle: true,
        automaticallyImplyLeading: true,
        onTapLeadingIcon: () => Navigator.of(context).pop(),
      ),
    );
  }

  String _formatTime(String dateTime) {
    try {
      final dt = DateTime.parse(dateTime);
      return formatter.format(dt);
    } catch (_) {
      return dateTime; // fallback if parse fails
    }
  }
}
