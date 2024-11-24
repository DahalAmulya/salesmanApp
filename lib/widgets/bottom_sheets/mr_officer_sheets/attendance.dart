import 'dart:io';

import 'package:deskgoo/providers/attendance_provider/remote_attendance_provider.dart';
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
  Widget build(BuildContext context) {
    return _buildUI(context);
  }

  Widget _buildUI(context) {
    return CustomContainer(
      width: 1,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<AttendanceProvider>(
              builder: (context, attendanceProvider, _) {
                return InkWell(
                  onTap: () async {
                    bool response = await biometricAuthentication();
                    if (response) {
                      attendanceProvider.switchRemoteAttendanceSwitch();
                    }
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
                        value: attendanceProvider.isRemoteAttendanceSwitched,
                        onChanged: (value) async {
                          bool response = await biometricAuthentication();
                          if (response) {
                            attendanceProvider.switchRemoteAttendanceSwitch();
                          }
                          print('response = $response');
                          print('valid form printed');
                          print('value = $value');
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(
              height: 8,
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
                      text: 'Checked-in',
                      isContent: true,
                    ),
                  ],
                );
              },
            ),
            SizedBox(
              height: 8,
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
                    Row(
                      children: [
                        CustomText(
                          text: '09:05 ',
                          isContent: true,
                        ),
                        CustomText(
                          text: '2024/11/24',
                          isSubContent: true,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            SizedBox(
              height: 8,
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
                    CustomText(
                      text: 'Not checked-out',
                      isContent: true,
                    ),
                  ],
                );
              },
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<AttendanceProvider>(
                  builder: (context, attendanceProvider, _) {
                    return Container(
                      decoration: BoxDecoration(
                        color: CustomColors.primaryColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: IconButton(
                        onPressed: () async {
                          bool response = await biometricAuthentication();
                          if (response) {
                            attendanceProvider.switchRemoteAttendanceSwitch();
                          }
                          print('response = $response');
                          print('valid form printed');
                        },
                        icon: Platform.isAndroid
                            ? Icon(
                                Icons.fingerprint,
                                size: 48,
                              )
                            : CircleAvatar(
                                radius: 24,
                                backgroundColor: CustomColors.primaryColor,
                                child: Image.asset(
                                  'assets/icons/faceid.png',
                                  width: 50,
                                  height: 50,
                                )),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}

// class MrOfficerAttendanceBottomSheet {
//   static void attendanceBottomSheet(context) {
//     final LocalAuthentication auth = LocalAuthentication();
//     bool _isAuthenticated = false;

//     Future<void> askPermission() async {
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           return askPermission();
//         }
//       }
//     }

//     Future<bool> biometricAuthentication() async {
//       if (_isAuthenticated) return true;
//       try {
//         final bool canAuthenticateWithBiometrics =
//             await auth.canCheckBiometrics;
//         if (canAuthenticateWithBiometrics) {
//           return await auth.authenticate(
//               localizedReason: 'Please authenticate for remote attendance');
//         }
//       } catch (err) {
//         print('Authentication error: $err');
//       }
//       return false;
//     }

//     showModalBottomSheet(
//       // isScrollControlled: true,
//       // useSafeArea: true,
//       context: context,
//       builder: (context) => CustomContainer(
//         width: 1,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Consumer<AttendanceProvider>(
//               builder: (context, attendanceProvider, _) {
//                 return InkWell(
//                   onTap: () async {
//                     bool response = await biometricAuthentication();
//                     if (response) {
//                       attendanceProvider.switchRemoteAttendanceSwitch();
//                     }
//                     print('response = $response');
//                   },
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       CustomText(
//                         text: 'Attendance',
//                         color: Colors.black,
//                         isSubHeading: true,
//                       ),
//                       FaIcon(
//                         attendanceProvider.isRemoteAttendanceSwitched
//                             ? FontAwesomeIcons.arrowRight
//                             : FontAwesomeIcons.arrowLeft,
//                         color: attendanceProvider.isRemoteAttendanceSwitched
//                             ? CustomColors.primaryColor
//                             : CustomColors.primaryBlack,
//                       ),
//                       Switch.adaptive(
//                         activeColor: CustomColors.primaryBlack,
//                         activeTrackColor: CustomColors.primaryColor,
//                         value: attendanceProvider.isRemoteAttendanceSwitched,
//                         onChanged: (value) async {
//                           bool response = await biometricAuthentication();
//                           if (response) {
//                             attendanceProvider.switchRemoteAttendanceSwitch();
//                           }
//                           print('response = $response');
//                           print('valid form printed');
//                           print('value = $value');
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//             SizedBox(
//               height: 8,
//             ),
//             Consumer<AttendanceProvider>(
//               builder: (context, attendanceProvider, _) {
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomText(
//                       text: 'Status',
//                       isContent: true,
//                     ),
//                     CustomText(
//                       text: 'Checked-in',
//                       isContent: true,
//                     ),
//                   ],
//                 );
//                 // TextFromFieldWithPrefixSuffix(
//                 //   controller: attendanceProvider.checkInTimeController,
//                 //   applyPrefix: false,
//                 //   readOnly: true,
//                 //   labelText: 'Check-in',
//                 //   hintText: 'Login Time',
//                 //   onTap: () {},
//                 //   validator: (String) {
//                 //     return null;
//                 //   },
//                 //   onChange: (value) {},
//                 // );
//               },
//             ),
//             SizedBox(
//               height: 8,
//             ),
//             Consumer<AttendanceProvider>(
//               builder: (context, attendanceProvider, _) {
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomText(
//                       text: 'Check-in Time',
//                       isContent: true,
//                     ),
//                     Row(
//                       children: [
//                         CustomText(
//                           text: '09:05 ',
//                           isContent: true,
//                         ),
//                         CustomText(
//                           text: '2024/11/24',
//                           isSubContent: true,
//                         ),
//                       ],
//                     ),
//                   ],
//                 );
//               },
//             ),
//             SizedBox(
//               height: 8,
//             ),
//             Consumer<AttendanceProvider>(
//               builder: (context, attendanceProvider, _) {
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomText(
//                       text: 'Check-out Time',
//                       isContent: true,
//                     ),
//                     CustomText(
//                       text: 'Not checked-out',
//                       isContent: true,
//                     ),
//                   ],
//                 );
//               },
//             ),
//             SizedBox(
//               height: 16,
//             ),
//             // Consumer<AttendanceProvider>(
//             //   builder: (context, attendanceProvider, _) {
//             //     return TextFromFieldWithPrefixSuffix(
//             //       controller: attendanceProvider.checkOutTimeController,
//             //       applyPrefix: false,
//             //       readOnly: true,
//             //       labelText: 'Check-out',
//             //       hintText: 'Attendance Time',
//             //       onTap: () {},
//             //       validator: (String) {
//             //         return null;
//             //       },
//             //       onChange: (value) {},
//             //     );
//             //   },
//             // ),
//             // SizedBox(
//             //   height: 16,
//             // ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Consumer<AttendanceProvider>(
//                   builder: (context, attendanceProvider, _) {
//                     return Container(
//                       decoration: BoxDecoration(
//                         color: CustomColors.primaryColor,
//                         borderRadius: BorderRadius.circular(100),
//                       ),
//                       child: IconButton(
//                         onPressed: () async {
//                           bool response = await biometricAuthentication();
//                           if (response) {
//                             attendanceProvider.switchRemoteAttendanceSwitch();
//                           }
//                           print('response = $response');
//                           print('valid form printed');
//                         },
//                         icon: Platform.isAndroid
//                             ? Icon(
//                                 Icons.fingerprint,
//                                 size: 48,
//                               )
//                             : CircleAvatar(
//                                 radius: 24,
//                                 backgroundColor: CustomColors.primaryColor,
//                                 child: Image.asset(
//                                   'assets/icons/faceid.png',
//                                   width: 50,
//                                   height: 50,
//                                 )),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
