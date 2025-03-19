import 'dart:convert';
import 'dart:io';

import 'package:deskgoo/consts.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:deskgoo/utils/toast_message.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../classes/secure_storage.dart';
import '../../../routes/route_generator_constants.dart';
import '../../../themes/custom_colors.dart';
import '../../../widgets/app_bars/custom_app_bars.dart';
import 'package:http/http.dart' as http;

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
    return Scaffold(
      appBar: _appBar(context),
      body: _buildUI(context),
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
    return CustomContainer(
      child: Column(
        children: [
          CustomElevatedButton(
            onPressed: () {
              _pickImageFromGallery();
            },
            backgroundColor: CustomColors.primaryColor,
            widget: CustomText(text: 'Choose from Gallery'),
          ),
          const SizedBox(height: 16,),
          CustomElevatedButton(
            onPressed: () {
              _pickImageFromCamera();
            },
            backgroundColor: CustomColors.lightRed,
            widget: CustomText(text: 'Take a picture'),
          ),
          const SizedBox(height: 16,),
          _selectedImage != null ? Image.file(_selectedImage!) : Container(),
          const SizedBox(height: 16,),
          uploadingImage ? const Center(child: CircularProgressIndicator(),) : CustomElevatedButton(
            onPressed: () {
              print('Pressed on upload button');
              if(_selectedImage != null){
                postProfileImage();
                setState(() {
                  uploadingImage = true;
                });
              }else{
                ToastMessageUtils().showToastMessage('Please select an image',ToastGravity.TOP,
                    CustomColors.lightRed);
              }

            },
            backgroundColor: CustomColors.primaryColor,
            widget: CustomText(text: 'Upload Image'),
          ),
        ],
      ),
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

  void postProfileImage() async {
    // ERPResponse response = await ERPServices.postRequest('/img/upload', body)
    var request = http.MultipartRequest("POST", Uri.parse('$apiURL/img/upload'));
    request.fields['id'] = userId; // Add the ID as a field
    request.files.add(await http.MultipartFile.fromPath(
      'profileImage',  // The field name expected by the server
      _selectedImage!.path,
      filename: _selectedImage!.path, // Extract filename
    ));

    try {
      var streamedResponse = await request.send();

      // Convert StreamedResponse to Response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        ToastMessageUtils().showToastMessage('Image uploaded successfully',ToastGravity.TOP,
            CustomColors.jadeGreen);
        // Print the response body
        print("Response Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
        Map<String,dynamic> body = jsonDecode(response.body);
        profileImage = body['user']['profileImage'];
        print(profileImage);
        SecureStorage().writeLoginCredentials(
            SecureStorage.userProfileImage, profileImage);
        print("Upload successful!");
        Navigator.of(context).pop();
      } else {
        ToastMessageUtils().showToastMessage('Image uploaded failed',ToastGravity.TOP,
            CustomColors.lightRed);
        print("Upload failed with status: ${response.statusCode}");
      }
    } catch (e) {
      ToastMessageUtils().showToastMessage('Image uploaded failed',ToastGravity.TOP,
          CustomColors.lightRed);
      print("Error uploading: $e");
    }
  }
}
