import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:custom_info_window/custom_info_window.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/utils/toast_message.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:path/path.dart' as path;

import '../../widgets/texts/custom_text.dart';

class MrAdminVisitLogProvider extends ChangeNotifier {
  Color _badgeColor = CustomColors.lightYellow;
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  List<String> _approvalType = ['approved', 'pending', 'rejected'];
  List<Map<String, dynamic>> _approvedVisitLogs = [];
  bool _myAnimation = false;
  double _width = 0;
  List<String> _visitLogsUsersList = ["Select User"];
  List<dynamic> _visitLogsById = [];
  List<dynamic> _usersList = [];
  List<String> _visitDateTypeList = ['Today', 'Yesterday', 'Custom'];
  Map<String, dynamic> _foundVisit = {};
  List<dynamic> _visitList = [];
  String _selectedUserId = '';
  String _selectedUser = 'Select User';
  String _selectedVisitType = 'Today';
  String _selectedVisitAddress = 'Country';
  String _from = DateTime.now().toString().split(' ')[0];
  String _to = DateTime.now().toString().split(' ')[0];
  String _executiveName = '';
  NepaliDateTime nepaliDateTime = NepaliDateTime.now();
  NepaliDateFormat yearMonthDateBSFormat = NepaliDateFormat('yyyy-MM-dd G');
  NepaliDateTime selectedDate = NepaliDateTime.now();
  List<String> _visitType = ["Country", "Region", "City"];
  List<String> _countryList = [
    'Nepal',
    'India',
  ];
  List<dynamic> _districts = [];
  List<dynamic> _stateList = [];
  List<dynamic> _searchResult = [];
  List<String> _foundDistrictList = [];
  List<String> _foundStateList = [];
  List<String> _foundCities = [];
  List<dynamic> _cities = [];
  String _selectVisitTypeByAddress = 'Country';
  String _selectedCountry = 'Nepal';
  String _selectedDistrict = 'Morang';
  String _selectedStates = 'Andhra Pradesh';
  String _selectedCity = 'Biratnagar';
  String _selectedRegion = '';
  String _selectedCities = '';
  String _selectedState = '';
  Set<Marker> _visitLogMarkers = {};
  double _latitude = 0;
  double _longitude = 0;
  String _pocName = '';
  String _pocAddress = '';
  String _pocNumber = '';
  String _profileImage = '';

  TextEditingController _fromTextEditingController = TextEditingController();
  TextEditingController _toTextEditingController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _districtController = TextEditingController();
  TextEditingController _stateController = TextEditingController();

  List<String> get approvalType => _approvalType;
  bool get myAnimation => _myAnimation;
  double get width => _width;
  TextEditingController get fromTextEditingController =>
      _fromTextEditingController;
  TextEditingController get toTextEditingController => _toTextEditingController;
  TextEditingController get searchController => _searchController;
  TextEditingController get cityController => _cityController;
  TextEditingController get districtController => _districtController;
  TextEditingController get stateController => _stateController;

  String get selectVisitTypeByAddress => _selectVisitTypeByAddress;
  List<dynamic> get districts => _districts;
  List<dynamic> get stateList => _stateList;
  List<dynamic> get searchResult => _searchResult;
  List<String> get foundCities => _foundCities;
  List<String> get foundDistrictList => _foundDistrictList;
  List<String> get foundStateList => _foundStateList;
  List<String> get visitType => _visitType;
  List<String> get countryList => _countryList;
  List<dynamic> get cities => _cities;
  String get selectedVisitType => _selectedVisitType;
  String get selectedCountry => _selectedCountry;
  String get selectedDistrict => _selectedDistrict;
  String get selectedStates => _selectedStates;
  String get selectedCity => _selectedCity;
  String get selectedCities => _selectedCities;
  String get selectedState => _selectedState;
  String get selectedRegion => _selectedRegion;

  List<String> get visitLogsUserList => _visitLogsUsersList;
  List<dynamic> get visitLogsById => _visitLogsById;
  List<String> get visitDateTypeList => _visitDateTypeList;
  String get selectedVisitAddress => _selectedVisitAddress;
  Map<String, dynamic> get foundVisit => _foundVisit;
  List<dynamic> get visitList => _visitList;
  String get selectedUserId => _selectedUserId;
  List<dynamic> get usersList => _usersList;
  String get selectedUser => _selectedUser;
  String get from => _from;
  String get to => _to;
  String get executiveName => _executiveName;
  Color get badgeColor => _badgeColor;
  CustomInfoWindowController get customInfoWindowController =>
      _customInfoWindowController;
  Set<Marker> get visitLogMarkers => _visitLogMarkers;
  double get latitude => _latitude;
  double get longitude => _longitude;

  void triggerAnimation() {
    _myAnimation = false;

    Future.delayed(const Duration(milliseconds: 200), () {
      _myAnimation = true;
    });
  }

  void setSelectedVisitDateType(visitType) {
    DateTime currentDate = DateTime.now();
    DateTime yesterday = currentDate.subtract(Duration(days: 1));
    _selectedVisitType = visitType;
    if (_selectedVisitType == _visitDateTypeList[0]) {
      _from = currentDate.toString().split(' ')[0];
      _to = currentDate.toString().split(' ')[0];
    } else if (_selectedVisitType == _visitDateTypeList[1]) {
      _from = yesterday.toString().split(' ')[0];
      _to = yesterday.toString().split(' ')[0];
    } else {}

    notifyListeners();
  }

  void setSelectedVisitType(newValue) {
    _selectedVisitAddress = newValue;
    notifyListeners();
  }

  Future<void> selectDateFrom(context) async {
    print('Select date from');
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
    );
    if (picked == null) {
      return;
    } else {
      _from = '${picked.year}-${picked.month}-${picked.day}';
    }
    _fromTextEditingController.text = _from;
    notifyListeners();
  }

  Future<void> selectDateTo(context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
    );
    if (picked == null) {
      return;
    } else {
      _to = '${picked.year}-${picked.month}-${picked.day}';
    }
    _toTextEditingController.text = _to;
    notifyListeners();
  }

  void setSelectedUser(user) {
    _selectedUser = user;
    print(_selectedUser);

    for (int i = 0; i < _usersList.length; i++) {
      if (_usersList[i]['username'] == _selectedUser) {
        _selectedUserId = _usersList[i]['_id'];
        break;
      }
    }

    notifyListeners();
  }

  void setSelectedCountry(newValue) {
    _selectedCountry = newValue;
    notifyListeners();
  }

  void setSelectedDistrict(value) {
    _selectedRegion = value;
    _districtController.text = _selectedRegion;
    notifyListeners();
  }

  void setSelectedState(value) {
    _selectedRegion = value;
    _stateController.text = _selectedRegion;
    notifyListeners();
  }

  void getCities(List<dynamic> citiesList) {
    _cities = citiesList;
    notifyListeners();
  }

  void setSelectedCity(value) {
    _selectedCities = value;
    _cityController.text = _selectedCities;
    notifyListeners();
  }

  void getVisitLogsList(context) async {
    _visitLogsUsersList = ["Select User"];
    _selectedUser = 'Select User';
    _selectedVisitType = 'Today';
    _selectedUserId = '';
    ERPResponse response =
        await ERPServices.getRequest('/visitLogs/users', context);
    // print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      _usersList = body['logs'];
      for (int i = 0; i < _usersList.length; i++) {
        _visitLogsUsersList.add(_usersList[i]['username']);
      }
    }
    notifyListeners();
  }

  void clearMarkerOnMap() {
    _visitLogMarkers.clear();
    _visitLogMarkers = {};
  }

  void approvalStatus(int index, String value) {
    visitList[index]['approvalStatus'] = value;
    Map<String, dynamic> log = {
      "_id": visitList[index]["logId"],
      "approvalStatus": visitList[index]['approvalStatus']
    };
    _approvedVisitLogs.add(log);
    print(_approvedVisitLogs);
    if (visitList[index]['approvalStatus'] == 'approved') {
      _badgeColor = CustomColors.primaryColor;
    } else if (visitList[index]['approvalStatus'] == 'pending') {
      _badgeColor = CustomColors.lightYellow;
    } else {
      _badgeColor = CustomColors.lightRed;
    }
    notifyListeners();
  }

  void searchAddressResult(String enteredKeyWord, List<dynamic> addressList) {
    print("AddressList = $addressList");
    _searchResult = addressList;
    if (enteredKeyWord.isEmpty) {
      _searchResult = addressList;
    } else {
      try {
        if (addressList[0] is String) {
          print('List of cities');
          _searchResult = addressList
              .where((city) => city
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyWord.toLowerCase()))
              .toList();
        } else if (addressList[0].containsKey('district')) {
          print('List of district');
          _searchResult = addressList
              .where((district) => district['district']
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyWord.toLowerCase()))
              .toList();
        } else if (addressList[0].containsKey('states')) {
          print('List of states');
          _searchResult = addressList
              .where((states) => states['states']
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyWord.toLowerCase()))
              .toList();
        }
      } catch (err) {
        print('Error as $err');
      }
    }
    // print(enteredKeyWord);
    print('search result = $_searchResult');
    // _searchController.text = '';
    notifyListeners();
  }

  void downloadVisitLogReport() async {
    try {
      // Step 1: Make the request (your existing logic)
      ERPResponse response = await ERPServices.getRequest(
        '/visitLogs/download?visitLogId=$_selectedUserId&from=$_from&to=$_to',
        null,
      );

      if (response.statusCode == 200) {
        String csvContent = response.body;

        // 2. Get the download directory (Android only)
        Directory downloadDir = Directory('/storage/emulated/0/Download');

        // 3. Create VisitLogs/Rajan Kumar folder
        String folderPath = path.join(downloadDir.path, 'VisitLogs', _selectedUser);
        Directory nestedDir = Directory(folderPath);

        if (!nestedDir.existsSync()) {
          nestedDir.createSync(recursive: true); // Create all folders
        }

        // 4. Create file inside the folder
        String filePath = path.join(nestedDir.path, '${selectedUser}_VisitLog_${_from}_to_$_to.csv');
        File file = File(filePath);

        await file.writeAsString(csvContent);

        ToastMessageUtils().showToastMessage(
          "Success! CSV file saved to: \n$filePath", ToastGravity.TOP, CustomColors.jadeGreen
        );
      } else {
        ToastMessageUtils().showToastMessage("Error! Failed to download visit log.");
      }
    } catch (e) {
      print('Error: $e');
      ToastMessageUtils().showToastMessage("Error!\nSomething went wrong while saving the file.");
    }
  }

  void getVisitLogsById(context) async {
    if (_selectedUserId.isEmpty) {
      ToastMessageUtils().showToastMessage('Please select a user');
    } else {
      ERPResponse response = await ERPServices.getRequest(
          '/visitLogs?visitLogId=$_selectedUserId&from=$_from&to=$_to',
          context);
      _visitLogMarkers.clear();
      if (response.statusCode == 200) {
        ToastMessageUtils().showToastMessage(
            'Logs found successful', ToastGravity.TOP, CustomColors.jadeGreen);
        final body = jsonDecode(response.body);
        _foundVisit = body['visitLogs'];
        _visitList = _foundVisit['visitLogs'];
        _executiveName = _foundVisit['username'];
        // print(body);
        // print(_foundVisit);
        // print(_visitList);

        for (int index = 0; index < _visitList.length; index++) {
          _pocName = _visitList[index]['pocName'];
          _pocAddress = _visitList[index]['pocAddress'];
          _pocNumber = _visitList[index]['pocNumber'];
          _latitude = _visitList[index]['latitude'];
          _longitude = _visitList[index]['longitude'];
          String executiveName = _selectedUser;
          // String pocNumber = adminVisitLogsProvider.foundVisit['visitLogs']['pocNumber'];
          String approvalStatus = visitList[index]['approvalStatus'];
          String pocName = visitList[index]['pocName'];
          String pocAddress = visitList[index]['pocAddress'];
          String pocNumber = visitList[index]['pocNumber'];
          String pocCategory = visitList[index]['pocCategory'];
          String pocSpecialization = visitList[index]['pocSpecialization'];
          String remarks = visitList[index]['remarks'];
          String visitType = visitList[index]['visitType'];
          String mobileTime = visitList[index]['mobileTime'];

          final Uint8List? icon =
              await getBytesFromAsset('assets/images/userLocation.png', 120);

          String markerId = _visitList[index].toString();

          _visitLogMarkers.add(
            Marker(
              markerId: MarkerId(markerId), // Ensure the MarkerId is unique
              icon: BitmapDescriptor.bytes(
                icon!,
                bitmapScaling: MapBitmapScaling.auto,
                imagePixelRatio: 2.3,
              ),
              onTap: () {
                print(_visitList[index]);
                if (_customInfoWindowController.addInfoWindow != null) {
                  _customInfoWindowController.addInfoWindow!(
                    CustomContainer(
                      applyShadow: true,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomText(
                                    text: 'POC',
                                    isContent: true,
                                  ),
                                ),
                                Expanded(
                                  child: CustomText(
                                    text: pocName,
                                    isContent: true,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomText(
                                    text: 'Visit Type',
                                    isContent: true,
                                  ),
                                ),
                                Expanded(
                                  child: CustomText(
                                    text: visitType,
                                    isContent: true,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomText(
                                    text: 'Category',
                                    isContent: true,
                                  ),
                                ),
                                Expanded(
                                  child: CustomText(
                                    text: pocCategory,
                                    isContent: true,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomText(
                                    text: 'Specialization',
                                    isContent: true,
                                  ),
                                ),
                                Expanded(
                                  child: CustomText(
                                    text: pocSpecialization,
                                    isContent: true,
                                    textOverflow: TextOverflow.visible,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomText(
                                    text: 'Remarks',
                                    isContent: true,
                                  ),
                                ),
                                Expanded(
                                  child: CustomText(
                                    text: remarks,
                                    isContent: true,
                                    textOverflow: TextOverflow.visible,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomText(
                                    text: 'Executive',
                                    isContent: true,
                                  ),
                                ),
                                Expanded(
                                  child: CustomText(
                                    text: executiveName,
                                    isContent: true,
                                    textOverflow: TextOverflow.visible,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomText(
                                    text: 'Address',
                                    isContent: true,
                                  ),
                                ),
                                Expanded(
                                  child: CustomText(
                                    text: pocAddress,
                                    isContent: true,
                                    textOverflow: TextOverflow.visible,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomText(
                                    text: 'Number',
                                    isContent: true,
                                  ),
                                ),
                                Expanded(
                                  child: CustomText(
                                    text: pocNumber,
                                    isContent: true,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomText(
                                    text: 'Date',
                                    isContent: true,
                                  ),
                                ),
                                Expanded(
                                  child: CustomText(
                                    text: mobileTime,
                                    isContent: true,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    LatLng(
                      _visitList[index]['latitude'],
                      _visitList[index]['longitude'],
                    ),
                  );
                }
              },
              position: LatLng(_latitude, _longitude),
            ),
          );
        }
      } else {
        ToastMessageUtils().showToastMessage('No visit log found');
        _visitList = [];
      }
    }
    notifyListeners();
  }

  void resetValues() {
    _selectedUserId = '';
    _selectedUser = 'Select User';
    _selectedVisitType = 'Today';
  }

  void updateVisitLogApprovals(context) async {
    ERPResponse response = await ERPServices.putRequest(
        '/visitLogs?visitLogId=$_selectedUserId&from=$_from&to=$_to',
        _approvedVisitLogs,
        context);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      ToastMessageUtils().showToastMessage('Logs Approved successfully',
          ToastGravity.TOP, CustomColors.jadeGreen);
      Navigator.pop(context);
    } else {
      ToastMessageUtils().showToastMessage(
          'Logs Approved failed', ToastGravity.TOP, CustomColors.lightRed);
    }
  }

  Future<Uint8List?> getBytesFromAsset(String path, int size) async {
    if (path.isNotEmpty) {
      ByteData data = await rootBundle.load(path);
      ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
          targetWidth: size, targetHeight: size);
      ui.FrameInfo fi = await codec.getNextFrame();

      ui.PictureRecorder recorder = ui.PictureRecorder();
      Canvas canvas = Canvas(recorder);

      // Paint a circular path
      Paint paint = Paint()..isAntiAlias = true;
      double radius = size / 2;
      canvas.drawCircle(Offset(radius, radius), radius, paint);

      // Clip the canvas to a circle
      canvas.clipPath(Path()
        ..addOval(
            Rect.fromCircle(center: Offset(radius, radius), radius: radius)));

      // Draw the image
      paintImage(
        canvas: canvas,
        rect: Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        image: fi.image,
        fit: BoxFit.fill,
      );

      final img = await recorder.endRecording().toImage(size, size);
      final dataBytes = await img.toByteData(format: ui.ImageByteFormat.png);

      return dataBytes?.buffer.asUint8List();
    } else {
      return null;
    }
  }
}
