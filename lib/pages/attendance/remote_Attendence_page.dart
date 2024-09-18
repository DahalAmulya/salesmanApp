import 'package:deskgoo/providers/attendance_provider/remote_attendance_provider.dart';
import 'package:deskgoo/widgets/bottom_navigation/gnav_bar.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drawers/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final dateTimeController = TextEditingController();
  final gpsLocationController = TextEditingController();
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    getTime();
    dateTimeController.text = nepaliTime.toString();
    // NepaliDateFormat formattedTime = NepaliDateFormat("yyyy-MM-dd HH:mm");
    gpsLocationController.text =
        'Latitude: ${latitude.toString()}, Longitude: ${longitude.toString()}';
    getLocation();
  }

  Future<void> getTime() async {
    setState(() {
      var currentNepaliTime = NepaliDateTime.now();
      String formattedTime = NepaliDateFormat("yyyy-MM-dd HH:mm")
          .format(currentNepaliTime); // Format the date and time
      print(nepaliTime);
      setState(() {
        final nepaliTime = formattedTime; // Set it to the state variable.
      });
    });
  }

  Future<void> getLocation() async {
    try {
      await askPermission(); // This do not exists
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        gpsLocationController.text =
            'Latitude: ${latitude.toString()}, Longitude: ${longitude.toString()}';
      });
      print('longitude: $latitude');
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
    bool didAuthenticate = false;
    if (!_isAuthenticated) {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      if (canAuthenticateWithBiometrics) {
        try {
          didAuthenticate = await auth.authenticate(
              localizedReason: 'Please authenticate for remote attendance');
          return didAuthenticate;
        } catch (err) {
          print('err = $err');
          return didAuthenticate;
        }
      }
    }
    return didAuthenticate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryWhite,
      appBar: _appBar(context),
      drawer: CustomDrawer(
        isAttendanceActive: true,
      ),
      body: _buildUI(context),
      bottomNavigationBar: _bottomNavBar(context),
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
              print('CustomAppBar build');
              return CustomAppBar(
                tabName: 'Remote Attendance',
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
                          if (_formState.currentState!.validate()) {
                            bool response = await biometricAuthentication();
                            if (response) {
                              attendanceProvider.switchRemoteAttendanceSwitch();
                            }
                            print('response = $response');
                            print('valid form printed');
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
                              size: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            Switch.adaptive(
                              activeColor: Colors.blue,
                              value:
                                  attendanceProvider.isRemoteAttendanceSwitched,
                              onChanged: (value) {
                                if (_formState.currentState!.validate()) {
                                  attendanceProvider
                                      .switchRemoteAttendanceSwitch();
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
                      height: 8,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    CustomText(text: 'Date and Time'),
                    SizedBox(
                      height: 4,
                    ),
                    TextFromFieldWithPrefixSuffix(
                      controller: dateTimeController,
                      applyPrefix: false,
                      readOnly: true,
                      onTap: () {},
                      validator: (String) {
                        return null;
                      },
                      onChange: (value) {},
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    CustomText(text: 'GPS Location'),
                    SizedBox(
                      height: 4,
                    ),
                    TextFromFieldWithPrefixSuffix(
                      controller: gpsLocationController,
                      applyPrefix: false,
                      readOnly: true,
                      onTap: () {},
                      validator: (String) {
                        return null;
                      },
                      onChange: (value) {},
                    ),
                    SizedBox(
                      height: 16.0,
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
                                // if (!_isAuthenticated) {
                                //   final bool canAuthenticateWithBiometrics =
                                //       await auth.canCheckBiometrics;
                                //   if (canAuthenticateWithBiometrics) {
                                //     try {
                                //       print(canAuthenticateWithBiometrics);
                                //       final bool didAuthenticate =
                                //           await auth.authenticate(
                                //         localizedReason:
                                //             'Please authenticate for remote attendance',
                                //         options: const AuthenticationOptions(
                                //           biometricOnly: false,
                                //         ),
                                //       );
                                //       print(
                                //           'didAuthenticate = $didAuthenticate');
                                //       setState(() {
                                //         _isAuthenticated = didAuthenticate;
                                //       });
                                //       print(
                                //           '_isAuthenticated = $_isAuthenticated');
                                //       print(
                                //           'didAuthenticate = $didAuthenticate');
                                //       // _isAuthenticated = false;
                                //     } catch (err) {
                                //       print('err = $err');
                                //       print(
                                //           '_isAuthenticated = $_isAuthenticated');
                                //     }
                                //     print(
                                //         '_isAuthenticated = $_isAuthenticated');
                                //     _isAuthenticated = false;
                                //   }
                                // } else {
                                //   print('_isAuthenticated = $_isAuthenticated');
                                // }
                                // }
                                // else {
                                //   if (!_isAuthenticated) {
                                //     final bool canAuthenticateWithBiometrics =
                                //         await auth.canCheckBiometrics;
                                //     if (canAuthenticateWithBiometrics) {
                                //       try {
                                //         print(canAuthenticateWithBiometrics);
                                //         final bool didAuthenticate =
                                //             await auth.authenticate(
                                //           localizedReason:
                                //               'Please authenticate for remote attendance',
                                //           options: const AuthenticationOptions(
                                //             biometricOnly: false,
                                //           ),
                                //         );
                                //         setState(() {
                                //           _isAuthenticated = didAuthenticate;
                                //         });
                                //         // _isAuthenticated = false;
                                //       } catch (err) {
                                //         print('err = $err');
                                //       }
                                //       _isAuthenticated = false;
                                //     }
                                //   }
                                // }
                              },
                              icon: Icon(
                                Icons.fingerprint,
                                size: 48,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     CustomElevatedButton(
                    //       onPressed: () {
                    //         if (_formState.currentState!.validate()) {
                    //           print('valid form printed');
                    //         } else {
                    //           print(
                    //               '_formState.currentState!.validate() = ${_formState.currentState!.validate()}');
                    //         }
                    //       },
                    //       height: 50,
                    //       backgroundColor: CustomColors.primaryColor,
                    //       widget: CustomText(
                    //         text: 'Submit',
                    //         fontWeight: FontWeight.w500,
                    //       ),
                    //     ),
                    //   ],
                    // )
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
