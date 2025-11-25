import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../classes/secure_storage.dart';
import '../../consts.dart';
import 'package:http/http.dart' as http;

import '../../themes/custom_colors.dart';
import '../../utils/toast_message.dart';

class ProfileProvider extends ChangeNotifier {
  String _name = "";
  String _dob = "";
  String _gender = "";
  String _nationality = "";
  String _address = "";
  String _maritalStatus = "";
  String _email = "";
  String _doj = "";
  String _department = "";
  String _profilePic = "";
  File? _selectedImage;
  bool _uploadingImage = false;

  String get name => _name;
  String get gender => _gender;
  String get dob => _dob;
  String get nationality => _nationality;
  String get address => _address;
  String get materialStatus => _maritalStatus;
  String get email => _email;
  String get doj => _doj;
  String get department => _department;
  String get profilePic => _profilePic;
  File? get selectedImage => _selectedImage;
  bool get uploadingImage => _uploadingImage;

  void setUserInfo({
    required String name,
    required String gender,
    required String nationality,
    required String address,
    required String maritalStatus,
    required String email,
    required String doj,
    required String department,
    required String profilePic,
  }) {
    _name = name;
    _gender = gender;
    _dob = dob;
    _nationality = nationality;
    _address = address;
    _maritalStatus = maritalStatus;
    _email = email;
    _doj = doj;
    _department = department;
    _profilePic = profilePic;
    notifyListeners();
  }

  void setProfilePic(String profilePic) {
    _profilePic = profilePic;
    notifyListeners();
  }

  void setUploadingImage(bool value) {
    _uploadingImage = value;
    notifyListeners();
  }

  Future pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    _selectedImage = File(returnedImage.path);
    notifyListeners();
  }

  Future pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;
    _selectedImage = File(returnedImage.path);
    notifyListeners();
  }

  void uploadProfileImage(context) async {
    var request =
        http.MultipartRequest("POST", Uri.parse('$apiURL/img/upload'));
    request.fields['id'] = userId; // Add the ID as a field
    request.files.add(await http.MultipartFile.fromPath(
      'profileImage', // The field name expected by the server
      _selectedImage!.path,
      filename: _selectedImage!.path, // Extract filename
    ));

    try {
      var streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        ToastMessageUtils().showToastMessage('Image uploaded successfully',
            ToastGravity.TOP, CustomColors.jadeGreen);
        print("Response Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
        Map<String, dynamic> body = jsonDecode(response.body);
        _profilePic = body['user']['profileImage'];
        print(_profilePic);
        SecureStorage().writeLoginCredentials(
            SecureStorage.userProfileImage, _profilePic);
        print("Upload successful!");
        _uploadingImage = false;
        _selectedImage = null;
        Navigator.of(context).pop();
      } else {
        ToastMessageUtils().showToastMessage(
            'Image uploaded failed', ToastGravity.TOP, CustomColors.lightRed);
        print("Upload failed with status: ${response.statusCode}");
        _uploadingImage = false;
      }
    } catch (e) {
      ToastMessageUtils().showToastMessage(
          'Image uploaded failed', ToastGravity.TOP, CustomColors.lightRed);
      print("Error uploading: $e");
      _uploadingImage = false;
    }
    notifyListeners();
  }
}
