import 'dart:io';

import 'package:deskgoo/consts.dart';
import 'package:deskgoo/pages/settings/profile/pick_profile_pic_screen.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/utils/readUserCred.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../providers/profile/profile_provider.dart';
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
  File? _selectedImage;
  bool uploadingImage = false;

  @override
  void initState() {
    setState(() {
      UserCred().readUserCred();
    });
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
        Navigator.of(context).pop();
      }),
      child: Scaffold(
        backgroundColor: CustomColors.primaryWhite,
        appBar: _appBar(context),
        body: _buildUI(context),
        // bottomNavigationBar: _bottomNavBar(context),
        // body:
      ),
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
            Navigator.of(context).pop(MarketingManagerConstants.settingPage);
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
                  const SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          useSafeArea: true,
                          context: context,
                          builder: (context) => const PickProfilePicScreen(),
                          // _mrOfficerProfilePicPickerBottomSheet(context),
                        );
                        print('Tapped on image');
                        // Navigator.of(context).pushNamed(MarketingManagerConstants.pickProfilePic);
                      },
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(100), // Circular border
                        child: profileProvider.profilePic.isNotEmpty
                            ? Image.network(
                                profileProvider.profilePic,
                                fit: BoxFit.cover,
                                width: 120,
                                height: 120,
                              )
                            : Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: CustomColors.primaryColor,
                                ),
                                alignment: Alignment.center,
                                child: CustomText(
                                  text:
                                      '${userName.split(' ')[0][0]}${userName.split(' ')[1][0]}',
                                  size: 24,
                                  color: CustomColors.primaryBlack,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
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
                        const SizedBox(
                          height: 8,
                        ),
                        CustomText(
                          text: "Name: $userName",
                          size: textFontSize,
                          fontWeight: fontWeight,
                        ),
                        CustomText(
                          text: "DOB: $userDob",
                          size: textFontSize,
                          fontWeight: fontWeight,
                        ),
                        CustomText(
                          text: "Gender: $userGender",
                          size: textFontSize,
                          fontWeight: fontWeight,
                        ),
                        CustomText(
                          text: "Nationality: $userNationality",
                          size: textFontSize,
                          fontWeight: fontWeight,
                        ),
                        CustomText(
                          text: "Address: $userAddress",
                          size: textFontSize,
                          fontWeight: fontWeight,
                        ),
                        CustomText(
                          text: "Marital Status: $userMaritalStatus",
                          size: textFontSize,
                          fontWeight: fontWeight,
                        ),
                        CustomText(
                          text: "Email: $userEmail",
                          size: textFontSize,
                          fontWeight: fontWeight,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
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
                                text: 'Professional Info',
                                size: 18,
                                fontWeight: fontWeight,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomText(
                          text: "DOJ: $userDoj",
                          size: textFontSize,
                          fontWeight: fontWeight,
                        ),
                        CustomText(
                          text: "Department: $userDepartment",
                          size: textFontSize,
                          fontWeight: fontWeight,
                        ),
                        CustomText(
                          text: "Designation: $userDesignation",
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
}
