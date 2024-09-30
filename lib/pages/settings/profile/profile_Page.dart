import 'package:deskgoo/providers/settings_providers/profile_provider/profile_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_navigation/gnav_bar.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../routes/route_generator_constants.dart';
import '../../../widgets/containers/custom_container.dart';

class Profile_page extends StatefulWidget {
  const Profile_page({super.key});

  @override
  State<Profile_page> createState() => _Profile_pageState();
}

class _Profile_pageState extends State<Profile_page> {
  double textFontSize = 16.0;
  FontWeight fontWeight = FontWeight.w600;
  int index = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryWhite,
      appBar: _appBar(context),
      body: _buildUI(context),
      bottomNavigationBar: _bottomNavBar(context),
      // body:
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Builder(
        builder: (context) => CustomAppBar(
          tabName: 'Account',
          titleColor: CustomColors.primaryBlack,
          backgroundColor: CustomColors.primaryColor,
          showLeading: true,
          leadingIcon: FontAwesomeIcons.arrowLeft,
          leadingIconColor: CustomColors.primaryBlack,
          onTapLeadingIcon: () {
            Navigator.of(context).pop(RouteGeneratorConstants.settingPage);
          },
        ),
      ),
    );
  }

  Widget _buildUI(context) {
    return SafeArea(
      child: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          return SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage('assets/images/johnCena.jpg'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CustomContainer(
                      width: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: 'Personal Info',
                                  size: 18,
                                  fontWeight: fontWeight,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          CustomText(
                            text: "Name: ${profileProvider.employee_name}",
                            size: textFontSize,
                            fontWeight: fontWeight,
                          ),
                          CustomText(
                            text: "DOB: ${profileProvider.date_of_birth}",
                            size: textFontSize,
                            fontWeight: fontWeight,
                          ),
                          CustomText(
                            text: "Gender: ${profileProvider.gender}",
                            size: textFontSize,
                            fontWeight: fontWeight,
                          ),
                          CustomText(
                            text: "Address: ${profileProvider.address}",
                            size: textFontSize,
                            fontWeight: fontWeight,
                          ),
                          CustomText(
                            text:
                                "Marital Status: ${profileProvider.marital_status}",
                            size: textFontSize,
                            fontWeight: fontWeight,
                          ),
                          CustomText(
                            text:
                                "Email: ${profileProvider.prefered_contact_email}",
                            size: textFontSize,
                            fontWeight: fontWeight,
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  CustomContainer(
                    width: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: 'Work Info',
                                size: 18,
                                fontWeight: fontWeight,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        CustomText(
                          text: "DOJ: ${profileProvider.date_of_joining}",
                          size: textFontSize,
                          fontWeight: fontWeight,
                        ),
                        CustomText(
                          text: "Department: ${profileProvider.department}",
                          size: textFontSize,
                          fontWeight: fontWeight,
                        ),
                        CustomText(
                          text: "Designation: ${profileProvider.designation}",
                          size: textFontSize,
                          fontWeight: fontWeight,
                        ),
                        CustomText(
                          text: "Shift: ${profileProvider.default_shift}",
                          size: textFontSize,
                          fontWeight: fontWeight,
                        ),
                        CustomText(
                          text:
                              "Notice Period: ${profileProvider.notice_number_of_days}",
                          size: textFontSize,
                          fontWeight: fontWeight,
                        ),
                        CustomText(
                          text: "DOR: ${profileProvider.date_of_retirement}",
                          size: textFontSize,
                          fontWeight: fontWeight,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  CustomGNavBar _bottomNavBar(context) {
    return CustomGNavBar(
      selectedIndex: index,
      onTap: (value) {
        index = value;
        print(index);
      },
    );
  }
}
