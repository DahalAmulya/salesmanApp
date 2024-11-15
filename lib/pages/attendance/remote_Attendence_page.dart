import 'package:deskgoo/consts.dart';
import 'package:deskgoo/providers/attendance_provider/remote_attendance_provider.dart';
import 'package:deskgoo/routes/marketing_officer_consts.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/widgets/bottom_navigation/gnav_bar.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drawers/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/themes_provider/theme_changer_provider.dart';
import '../../themes/custom_colors.dart';
import '../../widgets/app_bars/custom_app_bars.dart';
import '../../widgets/text_fields/text_from_field.dart';
import '../../widgets/texts/custom_text.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_auth/local_auth.dart';

class RemoteAttendencePage extends StatefulWidget {
  const RemoteAttendencePage({super.key});

  @override
  State<RemoteAttendencePage> createState() => _RemoteAttendencePageState();
}

class _RemoteAttendencePageState extends State<RemoteAttendencePage> {
  final LocalAuthentication auth = LocalAuthentication();
  double latitude = 0.0;
  double longitude = 0.0;
  bool isSwitched = false;
  final NepaliDateTime nepaliTime = NepaliDateTime.now();
  final _formState = GlobalKey<FormState>();
  final descriptionTextController = TextEditingController();
  final checkInTimeController = TextEditingController();
  final checkOutTimeController = TextEditingController();
  final gpsLocationController = TextEditingController();
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    // getTime();
    // dateTimeController.text = nepaliTime.toString();
    // NepaliDateFormat formattedTime = NepaliDateFormat("yyyy-MM-dd HH:mm");
    gpsLocationController.text =
        'Latitude: ${latitude.toString()}, Longitude: ${longitude.toString()}';
    getLocation();
  }

  // Future<void> getTime() async {
  //   setState(() {
  //     var currentNepaliTime = NepaliDateTime.now();
  //     String formattedTime = NepaliDateFormat("yyyy-MM-dd HH:mm")
  //         .format(currentNepaliTime); // Format the date and time
  //     print(nepaliTime);
  //     setState(() {
  //       final nepaliTime = formattedTime; // Set it to the state variable.
  //     });
  //   });
  // }

  Future<void> getLocation() async {
    try {
      await askPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      if (mounted) {
        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
          gpsLocationController.text =
              'Latitude: ${latitude.toString()}, Longitude: ${longitude.toString()}';
          print(
              '****************************************************************');
          print('WeeklyPlanScreen = ${gpsLocationController.value.text}');
          print(
              '****************************************************************');
        });
      }
      print('latitude: $latitude');
      print('longitude: $longitude');
    } catch (e) {
      print(e);
    }
  }

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
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        // GoRouter.of(context)
        //     .pushReplacementNamed(MyAppRouteConstants.homeNavBarRouteName);
        if (isRoleManager) {
          Navigator.of(context).pushNamed(MarketingManagerConstants.homePage);
        } else if (isRoleOfficer) {
          Navigator.of(context)
              .pushNamed(MarketingOfficerConstants.mrStaffDashboardConst);
        }
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
          drawer: CustomDrawer(
            isAttendanceActive: true,
          ),
          body: _buildUI(context),
          bottomNavigationBar: _bottomNavBar(context),
        ),
      ),
    );
  }

  PreferredSize _appBar(context) {
    print('appbar build');
    return PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: Builder(
        builder: (context) {
          return Consumer<ThemeChangerProvider>(
            builder: (context, provider, _) {
              return CustomAppBar(
                tabName: 'Attendance',
                fontWeight: FontWeight.w600,
                showLeading: true,
                leadingIcon: FontAwesomeIcons.bars,
                onTapLeadingIcon: () {
                  print('Pressed');
                  Scaffold.of(context).openDrawer();
                },
                applyShadow: true,
                onPressedThemeIcon: () {
                  provider.toogleIsChooseThemePopUp();
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildUI(context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomContainer(
              width: 0.95,
              verticalPad: 16.0,
              horizontalPad: 16.0,
              child: Form(
                key: _formState,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 0,
                    ),
                    Consumer<AttendanceProvider>(
                        builder: (context, attendanceProvider, _) {
                      return InkWell(
                        onTap: () async {
                          // attendanceProvider.getDistance();
                          if (_formState.currentState!.validate()) {
                            bool response = await biometricAuthentication();
                            if (response) {
                              attendanceProvider.switchRemoteAttendanceSwitch();
                            }
                            print('response = $response');
                          } else {
                            print(
                                '_formState.currentState!.validate() = ${_formState.currentState!.validate()}');
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text:
                                  attendanceProvider.isRemoteAttendanceSwitched
                                      ? 'Check In'
                                      : 'Check Out',
                              color: Colors.black,
                              size: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            FaIcon(
                              attendanceProvider.isRemoteAttendanceSwitched
                                  ? FontAwesomeIcons.arrowRight
                                  : FontAwesomeIcons.arrowLeft,
                              color:
                                  attendanceProvider.isRemoteAttendanceSwitched
                                      ? CustomColors.primaryColor
                                      : CustomColors.primaryBlack,
                            ),
                            Switch.adaptive(
                              activeColor: CustomColors.primaryBlack,
                              activeTrackColor: CustomColors.primaryColor,
                              value:
                                  attendanceProvider.isRemoteAttendanceSwitched,
                              onChanged: (value) async {
                                if (_formState.currentState!.validate()) {
                                  bool response =
                                      await biometricAuthentication();
                                  if (response) {
                                    attendanceProvider
                                        .switchRemoteAttendanceSwitch();
                                  }
                                  print('response = $response');
                                  print('valid form printed');
                                } else {
                                  print(
                                      '_formState.currentState!.validate() = ${_formState.currentState!.validate()}');
                                }
                                print('value = $value');
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(
                      height: 8,
                    ),
                    TextFromFieldWithPrefixSuffix(
                      controller: descriptionTextController,
                      onTap: () {},
                      hintText: 'Remarks here ...',
                      minLine: 4,
                      maxLines: 4,
                      validator: (value) {
                        return value!.isEmpty
                            ? 'This field is required'
                            : value.length < 3
                                ? 'Remarks must be more than 3 letters'
                                : null;
                      },
                      onChange: (value) {},
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Consumer<AttendanceProvider>(
                      builder: (context, attendanceProvider, _) {
                        return TextFromFieldWithPrefixSuffix(
                          controller: attendanceProvider.checkInTimeController,
                          applyPrefix: false,
                          readOnly: true,
                          labelText: 'Check-in',
                          hintText: 'Login Time',
                          onTap: () {},
                          validator: (String) {
                            return null;
                          },
                          onChange: (value) {},
                        );
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Consumer<AttendanceProvider>(
                      builder: (context, attendanceProvider, _) {
                        return TextFromFieldWithPrefixSuffix(
                          controller: attendanceProvider.checkOutTimeController,
                          applyPrefix: false,
                          readOnly: true,
                          labelText: 'Check-out',
                          hintText: 'Attendance Time',
                          onTap: () {},
                          validator: (String) {
                            return null;
                          },
                          onChange: (value) {},
                        );
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    // CustomText(text: 'GPS Location'),
                    // SizedBox(
                    //   height: 4,
                    // ),
                    // TextFromFieldWithPrefixSuffix(
                    //   controller: gpsLocationController,
                    //   applyPrefix: false,
                    //   readOnly: true,
                    //   onTap: () {},
                    //   validator: (String) {
                    //     return null;
                    //   },
                    //   onChange: (value) {},
                    // ),
                    // SizedBox(
                    //   height: 16.0,
                    // ),
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
                                  // if (isSwitched) {
                                  if (_formState.currentState!.validate()) {
                                    bool response =
                                        await biometricAuthentication();
                                    if (response) {
                                      attendanceProvider
                                          .switchRemoteAttendanceSwitch();
                                    }
                                    print('response = $response');
                                    print('valid form printed');
                                  } else {
                                    print(
                                        '_formState.currentState!.validate() = ${_formState.currentState!.validate()}');
                                  }
                                },
                                icon: Icon(
                                  Icons.fingerprint,
                                  size: 48,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomGNavBar _bottomNavBar(context) {
    return CustomGNavBar(
      selectedIndex: 0,
      onTap: (value) {},
    );
  }
}
