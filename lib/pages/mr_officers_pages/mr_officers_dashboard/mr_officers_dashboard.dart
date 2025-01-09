import 'package:deskgoo/consts.dart';
import 'package:deskgoo/providers/attendance_provider/remote_attendance_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_sheets/mr_officer_sheets/attendance.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/CustomLineBar.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drawers/mr_officer_custom_drawer.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
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

class _MrOfficersDashboardScreenState extends State<MrOfficersDashboardScreen> {
  AttendanceProvider? attendanceProvider;
  List<String> colors = ['red', 'yellow', 'green'];
  String SelectedColors = '';
  int selectedIndex = 0;
  void result() async {
    final String jsonString =
        await rootBundle.loadString('assets/district.json');
    print(jsonString);
    // Decode the JSON
    // final List<dynamic> jsonData = jsonDecode(jsonString);
    // Print the parsed data
    // for (var district in jsonData) {
    //   print('District: ${district['district']}');
    //   print('Cities: ${district['cities']}');
    // }
  }

  Future<List<Map<String, dynamic>>> readDistrictJson() async {
    // Load the JSON file from the assets
    final String response = await rootBundle.loadString('assets/district.json');

    // Decode the JSON into a List of Maps
    final List<dynamic> data = json.decode(response);
    return List<Map<String, dynamic>>.from(data);
  }

  void loadData() async {
    final districts = await readDistrictJson();
    print(districts);
  }

  @override
  void initState() {
    attendanceProvider =
        Provider.of<AttendanceProvider>(context, listen: false);
    attendanceProvider?.getAttendanceStatus();
    // result();
    // loadData();
    super.initState();
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
        SizedBox(
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
                  CustomLineBar(),
                  SizedBox(
                    width: 8,
                  ),
                  CustomText(
                    isSubHeading: true,
                    text: 'Today\'s Plans',
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: Colors.black,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomText(
                      isSubHeading: true,
                      text: '2024/11/24, Sunday',
                    ),
                  ),
                ],
              ),
              SizedBox(
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
                            text: 'Marketing Meeting',
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
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
                            text: 'Brt to Ghuski, Harinagar, Bhutha',
                            isContent: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
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
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: CustomText(
                            maxLines: 4,
                            textOverflow: TextOverflow.visible,
                            text: 'All Marketing Officer & Hospital CEO',
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
        SizedBox(
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
                    CustomLineBar(),
                    SizedBox(
                      width: 8,
                    ),
                    CustomText(
                      isSubHeading: true,
                      text: 'Attendance',
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: Colors.black,
              ),
              SizedBox(
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
                      SizedBox(
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
                      SizedBox(
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
                      SizedBox(
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
        SizedBox(
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
                  CustomLineBar(),
                  SizedBox(
                    width: 8,
                  ),
                  CustomText(
                    isSubHeading: true,
                    text: 'Today\'s Visit',
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: Colors.black,
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
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
                      text: '08',
                      isContent: true,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
