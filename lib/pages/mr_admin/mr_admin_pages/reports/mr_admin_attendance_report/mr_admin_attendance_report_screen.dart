import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/expansion_tile/custom_expansiontile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../routes/route_generator_constants.dart';
import '../../../../../themes/custom_colors.dart';
import '../../../../../widgets/app_bars/custom_app_bars.dart';
import '../../../../../widgets/buttons/elevated_button.dart';
import '../../../../../widgets/drop_downs/custom_dropdown.dart';
import '../../../../../widgets/text_fields/text_from_field.dart';
import '../../../../../widgets/texts/custom_text.dart';
import '../../../mr_admin_providers/mr_admin_attendancereport_provider.dart';

class MrAdminAttendanceReportScreen extends StatefulWidget {
  const MrAdminAttendanceReportScreen({super.key});

  @override
  State<MrAdminAttendanceReportScreen> createState() =>
      _MrAdminAttendanceReportScreenState();
}

class _MrAdminAttendanceReportScreenState
    extends State<MrAdminAttendanceReportScreen> {
  bool myAnimation = false;
  double width = 0;

  @override
  void initState() {
    super.initState();
    MrAdminAttendanceProvider mrAdminAttendanceProvider =
        Provider.of<MrAdminAttendanceProvider>(context, listen: false);
    mrAdminAttendanceProvider.getVisitLogsList(context);
  }

  void _triggerAnimation() {
    setState(() {
      myAnimation = false;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        myAnimation = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        Navigator.of(context).pop(MarketingManagerConstants.homePage);
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
          body: _body(context),
        ),
      ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        tabName: 'Attendance Report',
        centerTitle: true,
        automaticallyImplyLeading: true,
        onTap: () {
          Navigator.of(context).pop(MarketingManagerConstants.homePage);
        },
      ),
    );
  }

  Widget _body(context) {
    return Consumer<MrAdminAttendanceProvider>(
        builder: (context, mrAdminAttendanceProvider, _) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 16,
            ),
            CustomContainer(
              horizontalPad: 0,
              verticalPad: 0,
              color: Colors.transparent,
              child: CustomExpansionTile(
                initiallyExpanded: mrAdminAttendanceProvider.isExpanded,
                applyAllBorderRadius: true,
                title: 'Select User',
                size: 20,
                fontWeight: FontWeight.w600,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      CustomDropdown(
                        labelText: 'Select User',
                        items:
                            mrAdminAttendanceProvider.attendanceLogsUsersList,
                        value: mrAdminAttendanceProvider.selectedUser,
                        onChanged: (value) {
                          mrAdminAttendanceProvider.setSelectedUser(value);
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomDropdown(
                        labelText: 'Select Date',
                        items: mrAdminAttendanceProvider.visitDateTypeList,
                        value: mrAdminAttendanceProvider.selectedVisitType,
                        onChanged: (value) {
                          mrAdminAttendanceProvider.setSelectedVisitType(value);
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      if (mrAdminAttendanceProvider.selectedVisitType ==
                          'Custom')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextFromFieldWithPrefixSuffix(
                                labelText: 'From',
                                readOnly: true,
                                controller: mrAdminAttendanceProvider
                                    .fromTextEditingController,
                                onTap: () {
                                  mrAdminAttendanceProvider
                                      .selectDateFrom(context);
                                },
                                validator: (value) {},
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              flex: 1,
                              child: TextFromFieldWithPrefixSuffix(
                                labelText: 'To',
                                readOnly: true,
                                controller: mrAdminAttendanceProvider
                                    .toTextEditingController,
                                onTap: () {
                                  mrAdminAttendanceProvider
                                      .selectDateTo(context);
                                },
                                validator: (value) {},
                              ),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: mrAdminAttendanceProvider.selectedVisitType ==
                                mrAdminAttendanceProvider.visitDateTypeList[2]
                            ? 16
                            : 0,
                      ),
                      CustomElevatedButton(
                        onPressed: () {
                          if (mrAdminAttendanceProvider.selectedUser ==
                              mrAdminAttendanceProvider
                                  .attendanceLogsUsersList[0]) {
                            mrAdminAttendanceProvider
                                .getAllUserAttendanceReport(context);
                          } else {
                            mrAdminAttendanceProvider
                                .getAttendanceReport(context);
                          }
                          _triggerAnimation();
                        },
                        width: 0.90,
                        height: 50,
                        backgroundColor: CustomColors.primaryColor,
                        widget: CustomText(
                          text: 'Submit',
                          fontWeight: FontWeight.w600,
                          color: CustomColors.primaryBlack,
                          size: 20.0,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            mrAdminAttendanceProvider.selectedUser ==
                    mrAdminAttendanceProvider.attendanceLogsUsersList[0] && mrAdminAttendanceProvider.allUserAttendanceReport.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true, // Shrink-wrap the ListView
                    physics: BouncingScrollPhysics(),
                    itemCount: mrAdminAttendanceProvider
                        .allUserAttendanceReport.length,
                    itemBuilder: (context, index) {
                      String userName = mrAdminAttendanceProvider.allUserAttendanceReport[index]['username'];
                      String totalHours = mrAdminAttendanceProvider.allUserAttendanceReport[index]['totalHoursWorked'].toString();
                      String totalAttendance = mrAdminAttendanceProvider.allUserAttendanceReport[index]['totalAttendance'].toString();
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 400 + (index * 250)),
                        curve: Curves.easeInToLinear,
                        transform: Matrix4.translationValues(
                            myAnimation ? 0 : width, 0, 0),
                        child: Column(
                          children: [
                            CustomContainer(
                              horizontalMargin: 16,
                              applyShadow: true,
                              child: Badge(
                                label: CustomText(
                                  text: '${index + 1}',
                                  isContent: true,
                                ),
                                backgroundColor: CustomColors.primaryColor,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: CustomText(
                                            text: 'Username',
                                            isContent: true,
                                            size: 16,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: CustomText(
                                            text: userName,
                                            isContent: true,
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: CustomText(
                                            text: 'Total Attendance',
                                            isContent: true,
                                            size: 16,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: CustomText(
                                            text: totalAttendance,
                                            isContent: true,
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: CustomText(
                                            text: 'Total Hours',
                                            isContent: true,
                                            size: 16,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: CustomText(
                                            text: totalHours,
                                            isContent: true,
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: CustomText(
                        text: 'No Attendance log found',
                        isSubHeading: true,
                      ),
                    ),
                  ),
            mrAdminAttendanceProvider.foundAttendance.isNotEmpty &&
                    mrAdminAttendanceProvider.selectedUser !=
                        mrAdminAttendanceProvider.attendanceLogsUsersList[0]
                ? CustomContainer(
                    horizontalPad: 0,
                    verticalPad: 0,
                    color: Colors.transparent,
                    child: CustomExpansionTile(
                      title: 'Attendance Log',
                      applyAllBorderRadius: true,
                      size: 20,
                      fontWeight: FontWeight.w600,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: CustomText(
                                    text: 'Marketing Officer',
                                    isContent: true,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: CustomText(
                                    text:
                                        mrAdminAttendanceProvider.selectedUser,
                                    isContent: true,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: CustomText(
                                    text: 'Total Attendance',
                                    isContent: true,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: CustomText(
                                    text: mrAdminAttendanceProvider
                                        .attendanceLogs.length
                                        .toString(),
                                    isContent: true,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: CustomText(
                                    text: 'Total Hours',
                                    isContent: true,
                                  ),
                                ),
                                // const SizedBox(width: 8),
                                Expanded(
                                  flex: 2,
                                  child: CustomText(
                                    text: mrAdminAttendanceProvider.totalHours
                                        .toStringAsFixed(3),
                                    isContent: true,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : mrAdminAttendanceProvider.selectedUser != mrAdminAttendanceProvider.attendanceLogsUsersList[0] ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: CustomText(
                        text: '',
                        isSubHeading: true,
                      ),
                    ),
                  ) : Container(),
            const SizedBox(
              height: 16,
            ),
            mrAdminAttendanceProvider.attendanceLogs.isNotEmpty &&
                    mrAdminAttendanceProvider.selectedUser !=
                        mrAdminAttendanceProvider.attendanceLogsUsersList[0]
                ? ListView.builder(
                    shrinkWrap: true, // Shrink-wrap the ListView
                    physics: const BouncingScrollPhysics(),
                    itemCount: mrAdminAttendanceProvider.attendanceLogs.length,
                    itemBuilder: (context, index) {
                      String checkIn = mrAdminAttendanceProvider
                          .attendanceLogs[index]['checkIn'];
                      String checkInLatitude = mrAdminAttendanceProvider
                          .attendanceLogs[index]['checkInLatitude']
                          .toString();
                      String checkInLongitude = mrAdminAttendanceProvider
                          .attendanceLogs[index]['checkInLongitude']
                          .toString();
                      String checkOut = mrAdminAttendanceProvider
                          .attendanceLogs[index]['checkOut'];
                      String checkOutLatitude = mrAdminAttendanceProvider
                          .attendanceLogs[index]['checkOutLatitude']
                          .toString();
                      String checkOutLongitude = mrAdminAttendanceProvider
                          .attendanceLogs[index]['checkOutLongitude']
                          .toString();
                      String totalHour = mrAdminAttendanceProvider
                          .attendanceLogs[index]['totalHour']
                          .toStringAsFixed(2);
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 400 + (index * 250)),
                        curve: Curves.easeInToLinear,
                        transform: Matrix4.translationValues(
                            myAnimation ? 0 : width, 0, 0),
                        child: Column(
                          children: [
                            CustomContainer(
                              horizontalMargin: 16,
                              applyShadow: true,
                              child: Badge(
                                label: CustomText(
                                  text: '${index + 1}',
                                  isContent: true,
                                ),
                                backgroundColor: CustomColors.primaryColor,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: CustomText(
                                            text: 'Check-in Time',
                                            isContent: true,
                                            size: 16,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: CustomText(
                                            text: checkIn,
                                            isContent: true,
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: CustomText(
                                            text: 'Check-in Latitude',
                                            isContent: true,
                                            size: 16,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: CustomText(
                                            text: checkInLatitude,
                                            isContent: true,
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: CustomText(
                                            text: 'Check-in Longitude',
                                            isContent: true,
                                            size: 16,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: CustomText(
                                            text: checkInLongitude,
                                            isContent: true,
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: CustomText(
                                            text: 'Check-out Time',
                                            isContent: true,
                                            size: 16,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: CustomText(
                                            text: checkOut,
                                            isContent: true,
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: CustomText(
                                            text: 'Check-out Latitude',
                                            isContent: true,
                                            size: 16,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: CustomText(
                                            text: checkOutLatitude,
                                            isContent: true,
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: CustomText(
                                            text: 'Check-out Longitude',
                                            isContent: true,
                                            size: 16,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: CustomText(
                                            text: checkOutLongitude,
                                            isContent: true,
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: CustomText(
                                            text: 'Total Hour',
                                            isContent: true,
                                            size: 16,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: CustomText(
                                            text: totalHour,
                                            isContent: true,
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      );
                    })
                : mrAdminAttendanceProvider.selectedUser != mrAdminAttendanceProvider.attendanceLogsUsersList[0] ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 64.0),
                      child: CustomText(
                        text: 'No Attendance log found',
                        isSubHeading: true,
                      ),
                    ),
                  ) : Container(),
          ],
        ),
      );
    });
  }
}
