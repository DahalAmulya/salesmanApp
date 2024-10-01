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

class LiveTrackingProvider extends ChangeNotifier {
  TextEditingController _searchController = TextEditingController();
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  double _latitude = 0;
  double _longitude = 0;
  double? _selectedEmpLatitude;
  double? _selectedEmpLongitude;
  int _batteryPercentage = 0;
  String _employeeName = '';
  String _mobileTime = '';
  List<dynamic> _employeeLiveData = [];
  Set<Marker> _liveTrakingMarkers = {};
  late Timer _liveLocationTimer;
  int _seconds = 0;

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
  List<dynamic> get employeeLiveData => _employeeLiveData;
  Set<Marker> get liveTrackingMarkers => _liveTrakingMarkers;
  Timer get liveLocationTimer => _liveLocationTimer;
  int get seconds => _seconds;

  LiveTrackingProvider() {
    _liveTrakingMarkers.clear();
    updateLocation();
  }

  void setSelectedEmpLatLong(double? lat, double? long) {
    _selectedEmpLatitude = lat;
    _selectedEmpLongitude = long;
    notifyListeners();
  }

  void updateLocation() async {
    getAllEmployeesLocation();
    _liveLocationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 10) {
        _seconds = 0;
        getAllEmployeesLocation();
      } else {
        _seconds++;
      }
      // print('Seconds = $seconds');
    });
  }

  List<String> images = [
    'assets/images/johnCena.jpg',
    'assets/images/theRock.jpg',
    'assets/images/rdj.jpg',
    'assets/images/keanu.jpg',
  ];

  void getAllEmployeesLocation() async {
    ERPResponse response = await ERPServicer.getRequest('location');
    // print(response.statusCode);
    Map<String, dynamic> body = jsonDecode(response.body);
    _employeeLiveData = body['latestData'];

    // Clear the markers set before adding new markers
    _liveTrakingMarkers.clear();

    for (int i = 0; i < _employeeLiveData.length; i++) {
      Map<String, dynamic> latestLocation =
          _employeeLiveData[i]['latestLocation'];

      _employeeName = _employeeLiveData[i]['employee_name'];
      _latitude = latestLocation['latitude'];
      _longitude = latestLocation['longitude'];
      _batteryPercentage = latestLocation['batteryPercentage'];
      _mobileTime = latestLocation['deviceTime'];

      print('_employeeName = $_employeeName');

      final Uint8List? icon = await getBytesFromAsset('${images[i]}', 120);

      // Create a unique marker ID using the employee name or another identifier
      String markerId = 'marker_${_employeeLiveData[i]['employee_name']}';

      _liveTrakingMarkers.add(
        Marker(
          markerId: MarkerId(markerId), // Ensure the MarkerId is unique
          icon: BitmapDescriptor.bytes(
            icon!,
            bitmapScaling: MapBitmapScaling.auto,
            imagePixelRatio: 2.3,
          ),
          onTap: () {
            print(
                'name = ${_employeeLiveData[i]['employee_name']}, index = $i');
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
                        child: Image.asset(
                          '${images[i]}',
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
                              text: '${_employeeLiveData[i]['employee_name']}',
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
                              text:
                                  '${_employeeLiveData[i]['mobileIdentifier']}',
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

  // Future<Uint8List?> getBytesFromAsset(String path, int width) async {
  //   if (path.isNotEmpty) {
  //     ByteData data = await rootBundle.load(path);
  //     ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
  //         targetWidth: width);
  //     ui.FrameInfo fi = await codec.getNextFrame();
  //     return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
  //         .buffer
  //         .asUint8List();
  //   } else {
  //     return null;
  //   }
  // }
}
