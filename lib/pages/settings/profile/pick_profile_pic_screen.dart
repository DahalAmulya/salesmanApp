import 'dart:io';

import 'package:deskgoo/providers/profile/profile_provider.dart';
import 'package:deskgoo/utils/toast_message.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../routes/route_generator_constants.dart';
import '../../../themes/custom_colors.dart';
import '../../../widgets/app_bars/custom_app_bars.dart';

class PickProfilePicScreen extends StatefulWidget {
  const PickProfilePicScreen({super.key});

  @override
  State<PickProfilePicScreen> createState() => _PickProfilePicScreenState();
}

class _PickProfilePicScreenState extends State<PickProfilePicScreen> {
  File? _selectedImage;
  bool uploadingImage = false;

  @override
  Widget build(BuildContext context) {
    return _buildUI(context);
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
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        return CustomContainer(
          width: 1,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomElevatedButton(
                  onPressed: () {
                    profileProvider.pickImageFromGallery();
                  },
                  backgroundColor: CustomColors.primaryColor,
                  widget: CustomText(text: 'Choose from Gallery'),
                ),
                const SizedBox(height: 16),
                CustomElevatedButton(
                  onPressed: () {
                    profileProvider.pickImageFromCamera();
                  },
                  backgroundColor: CustomColors.lightRed,
                  widget: CustomText(text: 'Take a picture'),
                ),
                const SizedBox(height: 16),

                // ✅ Fix: Use profileProvider.selectedImage safely
                if (profileProvider.selectedImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: Image.file(
                      profileProvider.selectedImage!,
                      height: 300,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                  ),

                if (profileProvider.selectedImage != null) const SizedBox(height: 16),

                if (profileProvider.selectedImage != null)
                  profileProvider.uploadingImage
                      ? const Center(child: CircularProgressIndicator())
                      : CustomElevatedButton(
                    onPressed: () {
                      print('Pressed on upload button');
                      if (profileProvider.selectedImage != null) {
                        profileProvider.setUploadingImage(true);
                        profileProvider.uploadProfileImage(context);
                      } else {
                        ToastMessageUtils().showToastMessage(
                            'Please select an image',
                            ToastGravity.TOP,
                            CustomColors.lightRed);
                      }
                    },
                    backgroundColor: CustomColors.primaryColor,
                    widget: CustomText(text: 'Upload Image'),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
