import 'dart:convert';
import 'dart:io';

import 'package:deskgoo/consts.dart';
import 'package:deskgoo/providers/profile_provider/profile_provider.dart';
import 'package:deskgoo/providers/settings_providers/profile_provider/profile_provider.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/bottom_navigation/gnav_bar.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
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
  File ? _selectedImage;

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
    print("Profile image = " + profileImage);
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          print('Tapped on image');
                          // _pickImageFromGallery();
                          _pickImageFromCamera();
                          // showModalBottomSheet(
                          //   isScrollControlled: true,
                          //   useSafeArea: true,
                          //   context: context,
                          //   builder: (context) => SelectProfile(context),
                          // );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100), // Circular border
                          child: profileImage.isNotEmpty
                              ? Image.network(
                            profileImage,
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                          )
                              : Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: CustomColors.primaryColor,
                            ),
                            alignment: Alignment.center,
                            child: CustomText(
                              text: '${userName.split(' ')[0][0]}${userName.split(' ')[1][0]}',
                              size: 24,
                              color: CustomColors.primaryBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _selectedImage != null ? Image.file(_selectedImage!) : CustomText(text: 'Please select an image'),
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
                          SizedBox(
                            height: 8,
                          ),
                          CustomText(
                            text: "Name: ${userName}",
                            size: textFontSize,
                            fontWeight: fontWeight,
                          ),
                          CustomText(
                            text: "DOB: ${userDob}",
                            size: textFontSize,
                            fontWeight: fontWeight,
                          ),
                          CustomText(
                            text: "Gender: ${userGender}",
                            size: textFontSize,
                            fontWeight: fontWeight,
                          ),
                          CustomText(
                            text: "Nationality: ${userNationality}",
                            size: textFontSize,
                            fontWeight: fontWeight,
                          ),
                          CustomText(
                            text: "Address: ${userAddress}",
                            size: textFontSize,
                            fontWeight: fontWeight,
                          ),
                          CustomText(
                            text: "Marital Status: ${userMaritalStatus}",
                            size: textFontSize,
                            fontWeight: fontWeight,
                          ),
                          CustomText(
                            text: "Email: ${userEmail}",
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
                                text: 'Professional Info',
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
                          text: "DOJ: ${userDoj}",
                          size: textFontSize,
                          fontWeight: fontWeight,
                        ),
                        CustomText(
                          text: "Department: ${userDepartment}",
                          size: textFontSize,
                          fontWeight: fontWeight,
                        ),
                        CustomText(
                          text: "Designation: ${userDesignation}",
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

  //----------------------------------------------------------------Bottom Sheet----------------------------------------------------------------//

   Widget SelectProfile(context){
    return Container(
      color: CustomColors.primaryWhite,
      height: MediaQuery.of(context).size.height * 0.80,
      child: Column(
        children: [

        ],
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

  Future _pickImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }

  Future _pickImageFromCamera() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.camera);

    if(returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }
}
