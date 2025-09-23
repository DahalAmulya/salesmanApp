import 'package:deskgoo/providers/attendance_provider/remote_attendance_provider.dart';
import 'package:deskgoo/providers/deviceInfo_provider/deviceInfo_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

class MrOfficerAttendanceBottomSheet extends StatefulWidget {
  const MrOfficerAttendanceBottomSheet({super.key});

  @override
  State<MrOfficerAttendanceBottomSheet> createState() =>
      _MrOfficerAttendanceBottomSheetState();
}

class _MrOfficerAttendanceBottomSheetState
    extends State<MrOfficerAttendanceBottomSheet> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticated = false;
  AttendanceProvider? _attendanceProvider;
  DeviceInfoProvider? deviceInfoProvider;

  Future<void> askPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return askPermission();
      }
    }
  }

  Future<bool> biometricAuthentication() async {
    if (_isAuthenticated) return true;
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      if (canAuthenticateWithBiometrics) {
        return await auth.authenticate(
            localizedReason: 'Please authenticate for remote attendance');
      }
    } catch (err) {
      print('Authentication error: $err');
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _attendanceProvider =
        Provider.of<AttendanceProvider>(context, listen: false);
    _attendanceProvider?.getAttendanceStatus(context);
    _attendanceProvider?.getCurrentLocation();
    _attendanceProvider?.resetCheckOutConfirmation();
    _isAuthenticated = false;
    askPermission();
  }

  void updateDeviceLocation(context) {
    deviceInfoProvider = Provider.of<DeviceInfoProvider>(context, listen: true);
    deviceInfoProvider?.deviceInfoProvider(context);
  }

  @override
  Widget build(BuildContext context) {
    return _buildUI(context);
  }

  Widget _buildUI(context) {
    return CustomContainer(
      width: 1,
      child: SingleChildScrollView(
        child: Consumer<DeviceInfoProvider>(
          builder: (context, deviceInfoProvider, _) {
            return Consumer<AttendanceProvider>(
              builder: (context, at, _) {
                return at.responseReceived == false ? CircularProgressIndicator() : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<AttendanceProvider>(
                      builder: (context, attendanceProvider, _) {
                        return InkWell(
                          onTap: () async {
                            bool response = await biometricAuthentication();
                            // if (response) {
                            attendanceProvider.switchRemoteAttendanceSwitch(context);
                            if (attendanceProvider.isRemoteAttendanceSwitched) {
                              // deviceInfoProvider.deviceInfoProvider();
                              print(
                                  'attendanceProvider.isRemoteAttendanceSwitched = ${attendanceProvider.isRemoteAttendanceSwitched}, Posting device information');
                            } else {
                              // deviceInfoProvider.cancelLocationTimer();
                              print(
                                  'attendanceProvider.isRemoteAttendanceSwitched = ${attendanceProvider.isRemoteAttendanceSwitched}, Stop posting device information');
                            }
                            // }
                            print('response = $response');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: 'Attendance',
                                color: Colors.black,
                                isSubHeading: true,
                              ),
                              FaIcon(
                                attendanceProvider.isRemoteAttendanceSwitched
                                    ? FontAwesomeIcons.arrowRight
                                    : FontAwesomeIcons.arrowLeft,
                                color: attendanceProvider.isRemoteAttendanceSwitched
                                    ? CustomColors.primaryColor
                                    : CustomColors.primaryBlack,
                              ),
                              Switch.adaptive(
                                activeColor: CustomColors.primaryBlack,
                                activeTrackColor: CustomColors.primaryColor,
                                inactiveThumbColor: CustomColors.primaryBlack,
                                inactiveTrackColor: CustomColors.primaryWhite,
                                value:
                                    attendanceProvider.isRemoteAttendanceSwitched,
                                onChanged: (value) async {
                                  bool response = await biometricAuthentication();
                                  if (response) {
                                    attendanceProvider
                                        .switchRemoteAttendanceSwitch(context);
                                    if (attendanceProvider
                                        .isRemoteAttendanceSwitched) {
                                      deviceInfoProvider.deviceInfoProvider(context);
                                      print(
                                          'attendanceProvider.isRemoteAttendanceSwitched = ${attendanceProvider.isRemoteAttendanceSwitched}, Posting device information');
                                    } else {
                                      // deviceInfoProvider.cancelLocationTimer();
                                      print(
                                          'attendanceProvider.isRemoteAttendanceSwitched = ${attendanceProvider.isRemoteAttendanceSwitched}, Stop posting device information');
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Consumer<AttendanceProvider>(
                      builder: (context, attendanceProvider, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Status',
                              isContent: true,
                            ),
                            CustomText(
                              text: attendanceProvider.status,
                              maxLines: 2,
                              isContent: true,
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Consumer<AttendanceProvider>(
                      builder: (context, attendanceProvider, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Check-in Time',
                              isContent: true,
                            ),
                            attendanceProvider.isAttendance
                                ? Row(
                                    children: [
                                      // Split the check-in time string
                                      if (attendanceProvider
                                          .checkInTimeStr.isNotEmpty)
                                        ...attendanceProvider.checkInTimeStr
                                            .split(' ')
                                            .map((part) {
                                          // Check if the part is the first element (date) or second element (time)
                                          if (part ==
                                              attendanceProvider.checkInTimeStr
                                                  .split(' ')[0]) {
                                            return CustomText(
                                              text: '$part ',
                                              isContent: true,
                                            );
                                          } else {
                                            return CustomText(
                                              text: '$part ',
                                              isSubContent: true,
                                            );
                                          }
                                        }).toList(),
                                    ],
                                  )
                                : CustomText(
                                    text: attendanceProvider.checkInTimeStr,
                                    isContent: true,
                                    maxLines: 2,
                                  ),
                          ],
                        );
                      },
                    ),
                    // Consumer<AttendanceProvider>(
                    //   builder: (context, attendanceProvider, _) {
                    //     return Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         CustomText(
                    //           text: 'Check-in Time',
                    //           isContent: true,
                    //         ),
                    //         attendanceProvider.isAttendance
                    //             ? Row(
                    //                 children: [
                    //                   CustomText(
                    //                     text:
                    //                         '${attendanceProvider.checkInTimeStr.split(' ')[0]} ',
                    //                     isContent: true,
                    //                   ),
                    //                   CustomText(
                    //                     text:
                    //                         '${attendanceProvider.checkInTimeStr.split(' ')[1]} ',
                    //                     isSubContent: true,
                    //                   ),
                    //                 ],
                    //               )
                    //             : CustomText(
                    //                 text: attendanceProvider.checkInTimeStr,
                    //                 isContent: true,
                    //               ),
                    //       ],
                    //     );
                    //   },
                    // ),
                    SizedBox(
                      height: 12,
                    ),
                    Consumer<AttendanceProvider>(
                      builder: (context, attendanceProvider, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Check-out Time',
                              isContent: true,
                            ),
                            attendanceProvider.isAttendance &&
                                    attendanceProvider.isCheckedOut
                                ? Row(
                                    children: [
                                      CustomText(
                                        text:
                                            '${attendanceProvider.checkOutTimeStr.split(' ')[0]} ',
                                        isContent: true,
                                      ),
                                      CustomText(
                                        text:
                                            '${attendanceProvider.checkOutTimeStr.split(' ')[1]}',
                                        isSubContent: true,
                                      ),
                                    ],
                                  )
                                : CustomText(
                                    text: attendanceProvider.checkOutTimeStr,
                                    isContent: true,
                                    textOverflow: TextOverflow.clip,
                                    maxLines: 2,
                                  ),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Consumer<AttendanceProvider>(
                      builder: (context, attendanceProvider, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: 'Total Time',
                              isContent: true,
                            ),
                            Row(
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
                            )
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Consumer<AttendanceProvider>(
                    //       builder: (context, attendanceProvider, _) {
                    //         return Container(
                    //           decoration: BoxDecoration(
                    //             color: CustomColors.primaryColor,
                    //             borderRadius: BorderRadius.circular(100),
                    //           ),
                    //           child: IconButton(
                    //             onPressed: () async {
                    //               // attendanceProvider.confirmCheckout(context);
                    //               bool response = await biometricAuthentication();
                    //               if (response) {
                    //                 attendanceProvider
                    //                     .switchRemoteAttendanceSwitch();
                    //                 if (attendanceProvider
                    //                     .isRemoteAttendanceSwitched) {
                    //                   deviceInfoProvider.deviceInfoProvider();
                    //                   print(
                    //                       'attendanceProvider.isRemoteAttendanceSwitched = ${attendanceProvider.isRemoteAttendanceSwitched}, Posting device information');
                    //                 } else {
                    //                   // deviceInfoProvider.cancelLocationTimer();
                    //                   print(
                    //                       'attendanceProvider.isRemoteAttendanceSwitched = ${attendanceProvider.isRemoteAttendanceSwitched}, Stop posting device information');
                    //                 }
                    //               }
                    //               print('response = $response');
                    //               print('valid form printed');
                    //             },
                    //             icon: Platform.isAndroid
                    //                 ? Icon(
                    //                     Icons.fingerprint,
                    //                     size: 48,
                    //                   )
                    //                 : CircleAvatar(
                    //                     radius: 24,
                    //                     backgroundColor: CustomColors.primaryColor,
                    //                     child: Image.asset(
                    //                       'assets/icons/faceid.png',
                    //                       width: 50,
                    //                       height: 50,
                    //                     ),
                    //                   ),
                    //           ),
                    //         );
                    //       },
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                );
              }
            );
          },
        ),
      ),
    );
  }
}
