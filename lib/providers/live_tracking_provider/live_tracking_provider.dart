import 'dart:async';
import 'dart:convert';

import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class LiveTrackingProvider extends ChangeNotifier {
  TextEditingController _searchController = TextEditingController();
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  List<String> _mapType = ['normal', 'hybrid', 'terrain'];
  MapType _selectedMapType = MapType.normal;
  double _latitude = 0;
  double _longitude = 0;
  double? _selectedEmpLatitude;
  double? _selectedEmpLongitude;
  int _batteryPercentage = 0;
  String _employeeName = '';
  String _mobileTime = '';
  String _profileImage = '';
  List<dynamic> _employeeLiveData = [];
  List<dynamic> _employeesNameList = [];
  List<dynamic> _employeeSearchResults = [];
  Set<Marker> _liveTrakingMarkers = {};
  late Timer _liveLocationTimer;
  int _seconds = 0;
  String _selectedImg = '';
  String _img = '';
  List<String> _images = [
  ];
  String _radioGroupValue = 'normal';

  List<String> get mapType => _mapType;
  String get radioGroupValue => _radioGroupValue;
  MapType get selectedMapType =>  _selectedMapType;
  TextEditingController get searchController => _searchController;
  CustomInfoWindowController get customInfoWindowController =>
      _customInfoWindowController;
  double get latitude => _latitude;
  double get longitude => _longitude;
  double? get selectedEmpLatitude => _selectedEmpLatitude;
  double? get selectedEmpLongitude => _selectedEmpLongitude;
  int get batteryPercentage => _batteryPercentage;
  String get employeeName => _employeeName;
  String get mobileTime => _mobileTime;
  String get profileImage => _profileImage;
  List<dynamic> get employeeLiveData => _employeeLiveData;
  List<dynamic> get employeesNameList => _employeesNameList;
  List<dynamic> get employeeSearchResults => _employeeSearchResults;
  Set<Marker> get liveTrackingMarkers => _liveTrakingMarkers;
  Timer get liveLocationTimer => _liveLocationTimer;
  int get seconds => _seconds;
  String get selectedImg => _selectedImg;
  String get img => _img;
  List<String> get images => _images;

  void selectMapType(value) {
    _radioGroupValue = value;
    if (value == _mapType[0]) {
      _selectedMapType = MapType.normal;
    } else if (value == _mapType[1]) {
      _selectedMapType = MapType.hybrid;
    } else {
      _selectedMapType = MapType.terrain;
    }
    print('_radioGroupValue = $_radioGroupValue');
    notifyListeners();
  }

  LiveTrackingProvider(context) {
    _liveTrakingMarkers.clear();
    updateLocation(context);
  }

  void setSelectedImage(String img) {
    _selectedImg = img;
    notifyListeners();
  }

  void setSelectedEmpLatLong(double? lat, double? long) {
    _selectedEmpLatitude = lat;
    _selectedEmpLongitude = long;
  }

  void updateLocation(context) async {
    getAllEmployeesLocation(context);
    _liveLocationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 10) {
        _seconds = 0;
        getAllEmployeesLocation(context);
      } else {
        _seconds++;
      }
    });
  }

  void getAllEmployeesLocation(context) async {
    Map<String, String> headersJson = {
      'Content-Type': 'Application/json',
    };
    ERPResponse response =
        await ERPServices.getRequest('/location/latest', context);
    print(response.statusCode);
    print(response.body);
    _employeeLiveData = jsonDecode(response.body);
    _employeeSearchResults = _employeeLiveData;

    _liveTrakingMarkers.clear();

    for (int i = 0; i < _employeeLiveData.length; i++) {
      print(employeeLiveData[i]['latestLocation']);
      Map<String, dynamic> latestLocation =
          _employeeLiveData[i]['latestLocation'];
      if (latestLocation.isEmpty) {
        continue;
      }

      _employeeName = _employeeLiveData[i]['username'];
      _latitude = latestLocation['latitude'];
      _longitude = latestLocation['longitude'];
      _batteryPercentage = latestLocation['batteryPercentage'];
      _mobileTime = latestLocation['mobileTime'];
      _profileImage = employeeLiveData[i]['profileImage'];

      final Uint8List? icon =
          await getImageBytes(_employeeLiveData[i]['profileImage'], 120);

      String markerId = 'marker_${_employeeLiveData[i]['username']}';

      _liveTrakingMarkers.add(
        Marker(
          markerId: MarkerId(markerId), // Ensure the MarkerId is unique
          icon: BitmapDescriptor.bytes(
            icon!,
            bitmapScaling: MapBitmapScaling.auto,
            imagePixelRatio: 2.3,
          ),
          onTap: () {
            print('name = ${_employeeLiveData[i]['username']}, index = $i');
            if (_customInfoWindowController.addInfoWindow != null) {
              _customInfoWindowController.addInfoWindow!(
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: Image.network(
                          _employeeLiveData[i]['profileImage'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: '${_employeeLiveData[i]['username']}',
                              fontWeight: ui.FontWeight.w500,
                            ),
                            CustomText(
                              text: '${latestLocation['connectivityType']}',
                              fontWeight: ui.FontWeight.w500,
                            ),
                            CustomText(
                              text: '${latestLocation['batteryPercentage']} %',
                              fontWeight: ui.FontWeight.w500,
                            ),
                            CustomText(
                              text: latestLocation['mobileTime'].toString(),
                              fontWeight: ui.FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                LatLng(
                  latestLocation['latitude'],
                  latestLocation['longitude'],
                ),
              );
            }
          },
          position: LatLng(_latitude, _longitude),
        ),
      );
    }

    // Notify listeners to update the map
    notifyListeners();
  }

  void runSearchEmployeeLiveLocationFilter(String enteredKeyWord) {
    List<dynamic> results = [];
    if (enteredKeyWord.isEmpty) {
      results = _employeeLiveData;
    } else {
      results = _employeeLiveData
          .where((emp) => emp['employee_name']
              .toString()
              .toLowerCase()
              .contains(enteredKeyWord.toLowerCase()))
          .toList();
    }
    _employeeSearchResults = results;
    print('_Employee Search Result = $_employeeSearchResults');
    notifyListeners();
  }

  void clearEmployeeSearchField() {
    searchController.clear();
    _employeeSearchResults = _employeeLiveData;
    notifyListeners();
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

  Future<Uint8List?> getImageBytes(String path, int size) async {
    try {
      Uint8List imageData;

      if (path.startsWith('http')) {
        // Load from network
        final response = await http.get(Uri.parse(path));
        if (response.statusCode != 200) return null;
        imageData = response.bodyBytes;
      } else {
        // Load from asset
        ByteData data = await rootBundle.load(path);
        imageData = data.buffer.asUint8List();
      }

      ui.Codec codec = await ui.instantiateImageCodec(
        imageData,
        targetWidth: size,
        targetHeight: size,
      );
      ui.FrameInfo fi = await codec.getNextFrame();

      ui.PictureRecorder recorder = ui.PictureRecorder();
      Canvas canvas = Canvas(recorder);

      Paint paint = Paint()..isAntiAlias = true;
      double radius = size / 2;
      canvas.drawCircle(Offset(radius, radius), radius, paint);

      canvas.clipPath(Path()
        ..addOval(
            Rect.fromCircle(center: Offset(radius, radius), radius: radius)));

      paintImage(
        canvas: canvas,
        rect: Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        image: fi.image,
        fit: BoxFit.cover,
      );

      final img = await recorder.endRecording().toImage(size, size);
      final dataBytes = await img.toByteData(format: ui.ImageByteFormat.png);
      return dataBytes?.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }
}
