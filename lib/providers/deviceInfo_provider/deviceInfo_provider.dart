import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class DeviceinfoProvider extends ChangeNotifier {
  Battery _battery = Battery();
  int _batteryLevel = 0;
  double _latitude = 0.0;
  double _longitude = 0.0;
  late Timer _locationTimer;
  int _seconds = 0;
  Set<Marker> _positionMarkers = {};

  Battery get battery => _battery;
  int get batteryLevel => _batteryLevel;
  double get latitude => _latitude;
  double get longitude => _longitude;
  Timer get locationTimer => _locationTimer;
  int get seconds => _seconds;
  Set<Marker> get positionMarkers => _positionMarkers;

  void getBatteryLevel() {
    battery.onBatteryStateChanged.listen((BatteryState state) async {
      _batteryLevel = await battery.batteryLevel;
      print('batteryLevel = $_batteryLevel');
      notifyListeners();
    });
  }

  DeviceinfoProvider() {
    getLocation();
    updateLocation();
  }

  void updateLocation() async {
    _locationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 20) {
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

  void getLocation() async {
    var iconPath = 'assets/images/johnCena.jpg';
    final Uint8List? icon = await getBytesFromAsset(iconPath, 120);
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 12,
      ),
    );

    LocationAccuracyStatus accuracyStatus =
        await Geolocator.getLocationAccuracy();

    // positionStream.listen((Position position) {
    _latitude = position.latitude;
    _longitude = position.longitude;
    _positionMarkers.add(Marker(
      markerId: const MarkerId('Hello'),
      icon: BitmapDescriptor.bytes(
        icon!,
        bitmapScaling: MapBitmapScaling.auto,
        imagePixelRatio: 2.3,
      ),
      position: LatLng(_latitude, _longitude),
    ));
    print('LatLong = $_latitude, $_longitude');
    print('Accuracy Status = $accuracyStatus');
    notifyListeners();
    // });
  }

  Future<void> cameraPosition(_controller) async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            _latitude,
            _longitude,
          ),
          zoom: 15,
        ),
      ),
    );
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
