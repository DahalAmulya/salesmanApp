import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:flutter_udid/flutter_udid.dart';

class DeviceinfoProvider extends ChangeNotifier {
  Battery _battery = Battery();
  String _uniqueIdentifier = '';
  String _consistentUdid = '';
  int _batteryLevel = 0;
  double _latitude = 0.0;
  double _longitude = 0.0;
  late Timer _locationTimer;
  int _seconds = 0;
  Set<Marker> _positionMarkers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _coordinates = [];
  List<LatLng> _polylineCoordinates = [];
  List<LatLng> biratnagarRoute = [
    LatLng(26.45966529291194, 87.29537438814391), // 1
    LatLng(26.459613666176722, 87.29536231820155), // 2
    LatLng(26.45955123381684, 87.2953368372171), // 3
    LatLng(26.459589653734607, 87.29510750835712), // 4
    LatLng(26.459611264932718, 87.29494523471935), // 5
    LatLng(26.459619669285882, 87.2947816199655), // 6
    LatLng(26.459686904093523, 87.29436721867972), // 7
    LatLng(26.459743333277157, 87.29400646157006), // 8
    LatLng(26.459778151270687, 87.29376506275598), // 9
    LatLng(26.460008670135917, 87.29301270313339), // 10
    LatLng(26.46012513001229, 87.29267072147559), // 11
    LatLng(26.460044688666372, 87.29152273600606), // 12
    LatLng(26.460044483757283, 87.29109922582292), // 13
    LatLng(26.460037280052447, 87.2907800429516), // 14
    LatLng(26.46002801389772, 87.29050649782779), // 15
    LatLng(26.45992956320548, 87.2900827088085), // 16
    LatLng(26.45967503175692, 87.28954090258749), // 17
    LatLng(26.4595045433977, 87.28913454792546), // 18
    LatLng(26.459335287797273, 87.28877321260396), // 19
    LatLng(26.459067548134282, 87.28838563340489), // 20
    LatLng(26.45886698553118, 87.28809515769966), // 21
    LatLng(26.458631122501444, 87.28772859554988), // 22
    LatLng(26.458489665291726, 87.2874459190595), // 23
    LatLng(26.45843404416264, 87.28727253683215), // 24
    LatLng(26.458332398843748, 87.28701308637882), // 25
    LatLng(26.458386617809477, 87.28683291333833), // 26
    LatLng(26.458367641173734, 87.28660126228378), // 27
    LatLng(26.458331736258003, 87.28623152718343), // 28
    LatLng(26.458284294639427, 87.28568040965402), // 29
    LatLng(26.45825447418427, 87.28525798714915), // 30
  ];

  Battery get battery => _battery;
  String get uniqueIdentifier => _uniqueIdentifier;
  String get consistentUdid => _consistentUdid;
  int get batteryLevel => _batteryLevel;
  double get latitude => _latitude;
  double get longitude => _longitude;
  Timer get locationTimer => _locationTimer;
  int get seconds => _seconds;
  Set<Marker> get positionMarkers => _positionMarkers;
  Set<Polyline> get polylines => _polylines;
  List<LatLng> get coordinates => _coordinates;
  List<LatLng> get polylineCoordinates => _polylineCoordinates;

  void getUniqueIdentifier() async {
    String udid;
    String consistentUdid;
    try {
      udid = await FlutterUdid.udid;
      consistentUdid = await FlutterUdid.consistentUdid;
      _uniqueIdentifier = udid;
      _consistentUdid = consistentUdid;
    } on PlatformException {
      udid = 'Failed to get UDID.';
      consistentUdid = 'Failed to get UDID.';
    }
    // udid = 50fdc2bea5dfc3ce
    // consistentUdid = 122342691f2253efd26bb0a713b5586233404e6e7f7f1729a6c6333c8998063a
    print('_uniqueIdentifier = $_uniqueIdentifier');
    print('_consistentUdid = $_consistentUdid');
    notifyListeners();
  }

  void getBatteryLevel() {
    battery.onBatteryStateChanged.listen((BatteryState state) async {
      _batteryLevel = await battery.batteryLevel;
      print('batteryLevel = $_batteryLevel');
      notifyListeners();
    });
  }

  DeviceinfoProvider() {
    clearMarkers();
    locationReplay();
    getUniqueIdentifier();
    // updateLocation();
  }

  void updateLocation() async {
    _locationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 10) {
        _seconds = 0;
        getLocation();
      } else {
        _seconds++;
      }
      print('Seconds = $seconds');
    });
  }

  Stream<Position> positionStream = Geolocator.getPositionStream(
    locationSettings: LocationSettings(
      accuracy: LocationAccuracy.high, // High accuracy
      // timeLimit: Duration(seconds: 10),
      distanceFilter:
          15, // Minimum distance (in meters) before an update is triggered
    ),
  );

  void clearMarkers() {
    _positionMarkers
        .removeWhere((marker) => marker.markerId.value == 'start_marker');
    _positionMarkers
        .removeWhere((marker) => marker.markerId.value == 'end_marker');
    _positionMarkers
        .removeWhere((marker) => marker.markerId.value == 'temp_marker');

    // Clear the list of position markers
    _positionMarkers.clear();

    // Optionally, clear polyline coordinates if needed
    _polylineCoordinates.clear();

    // Notify listeners to update the UI
    notifyListeners();
  }

  void locationReplay() async {
    var iconPath = 'assets/images/location.png'; // For temporary markers
    var iconPath1 = 'assets/images/start.png'; // For permanent start marker
    var iconPath2 = 'assets/images/finish.png'; // For permanent end marker
    final Uint8List? icon = await getBytesFromAsset(iconPath, 80);
    final Uint8List? icon1 = await getBytesFromAsset(iconPath1, 100);
    final Uint8List? icon2 = await getBytesFromAsset(iconPath2, 100);

    // Add start marker (index 0) as permanent
    _positionMarkers.add(
      Marker(
        markerId: const MarkerId('start_marker'),
        icon: BitmapDescriptor.bytes(
          icon1!,
          bitmapScaling: MapBitmapScaling.auto,
          imagePixelRatio: 2.3,
        ),
        position:
            LatLng(biratnagarRoute[0].latitude, biratnagarRoute[0].longitude),
      ),
    );

    // Add end marker (index last) as permanent
    _positionMarkers.add(
      Marker(
        markerId: const MarkerId('end_marker'),
        icon: BitmapDescriptor.bytes(
          icon2!,
          bitmapScaling: MapBitmapScaling.auto,
          imagePixelRatio: 2.3,
        ),
        position: LatLng(
            biratnagarRoute.last.latitude, biratnagarRoute.last.longitude),
      ),
    );

    notifyListeners(); // Update UI with permanent start and end markers

    // Loop to update the temporary marker
    for (int i = 0; i < biratnagarRoute.length; i++) {
      _latitude = biratnagarRoute[i].latitude;
      _longitude = biratnagarRoute[i].longitude;

      // Update polyline coordinates
      _polylineCoordinates.add(biratnagarRoute[i]);
      _polylines.add(
        Polyline(
          polylineId: PolylineId('route_polyline'),
          points: _polylineCoordinates,
          color: Colors.blue,
          width: 5,
        ),
      );

      // Remove previous temporary marker, if any
      _positionMarkers
          .removeWhere((marker) => marker.markerId.value == 'temp_marker');

      // Add new temporary marker for the current position
      _positionMarkers.add(
        Marker(
          markerId: const MarkerId('temp_marker'),
          icon: BitmapDescriptor.bytes(
            icon!,
            bitmapScaling: MapBitmapScaling.auto,
            imagePixelRatio: 2.3,
          ),
          position: LatLng(_latitude, _longitude),
        ),
      );

      notifyListeners(); // Update UI with the temporary marker and updated polyline
      await Future.delayed(const Duration(seconds: 1));

      print('latlong $i = $_latitude,$_longitude');
    }

    print('LatLong = $_latitude, $_longitude');
  }

  void getLocation() async {
    // if (_positionMarkers.isNotEmpty) {
    // Marker marker = _positionMarkers
    //     .firstWhere((marker) => marker.markerId.value == "Hello");
    // _positionMarkers.remove(marker);
    // _positionMarkers.clear();
    // }
    var iconPath = 'assets/images/location.png';
    final Uint8List? icon = await getBytesFromAsset(iconPath, 100);
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
      ),
    );

    LocationAccuracyStatus accuracyStatus =
        await Geolocator.getLocationAccuracy();

    // positionStream.listen((Position position) {
    // _latitude = position.latitude;
    // _longitude = position.longitude;
    // _positionMarkers.add(Marker(
    //   markerId: const MarkerId('Hello'),
    //   icon: BitmapDescriptor.bytes(
    //     icon!,
    //     bitmapScaling: MapBitmapScaling.auto,
    //     imagePixelRatio: 2.3,
    //   ),
    //   position: LatLng(_latitude, _longitude),
    // ));
    for (int i = 0; i < biratnagarRoute.length; i++) {
      _latitude = biratnagarRoute[i].latitude;
      _longitude = biratnagarRoute[i].longitude;
      _polylineCoordinates.add(biratnagarRoute[i]);
      _positionMarkers.add(Marker(
        markerId: const MarkerId('Hello'),
        icon: BitmapDescriptor.bytes(
          icon!,
          bitmapScaling: MapBitmapScaling.auto,
          imagePixelRatio: 2.3,
        ),
        position: LatLng(_latitude, _longitude),
      ));
      _polylines.add(
        Polyline(
          polylineId: PolylineId('Hello'),
          points: _polylineCoordinates,
          color: Colors.blue,
          width: 3,
        ),
      );
      notifyListeners();
      await Future.delayed(const Duration(seconds: 1));
      print('latlong $i = $_latitude,$_longitude');
    }
    // _polylineCoordinates.add(LatLng(_latitude, _latitude));
    // _polylines.add(
    //   Polyline(
    //     polylineId: PolylineId('Hello'),
    //     points: biratnagarRoute,
    //     color: Colors.blue,
    //     width: 3,
    //   ),
    // );

    print('LatLong = $_latitude, $_longitude');
    print('Accuracy Status = $accuracyStatus');
    print('_uniqueIdentifier = $_uniqueIdentifier');
    print('_consistentUdid = $_consistentUdid');
    notifyListeners();
    // });
  }

  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    if (path.isNotEmpty) {
      ByteData data = await rootBundle.load(path);
      ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
          targetWidth: width);
      ui.FrameInfo fi = await codec.getNextFrame();
      return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
          .buffer
          .asUint8List();
    } else {
      return null;
    }
  }
}
