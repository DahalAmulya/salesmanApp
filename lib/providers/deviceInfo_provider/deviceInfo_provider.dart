import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:flutter_udid/flutter_udid.dart';
import 'package:http/http.dart';

class DeviceinfoProvider extends ChangeNotifier {
  Battery _battery = Battery();
  String _uniqueIdentifier = '';
  String _name = 'Nimesh';
  String _consistentUdid = '';
  String _accuracy = '';
  String _deviceTime = '2024-09-26: 04-37';
  int _batteryLevel = 0;
  double _liveLatitude = 0.0;
  double _liveLongitude = 0.0;
  double _distance = 0.0;
  late Timer _locationTimer;
  int _seconds = 0;
  Set<Marker> _livePositionMarkers = {};
  var baseApi = 'http://108.181.195.185:5000/api/device';

  Battery get battery => _battery;
  String get uniqueIdentifier => _uniqueIdentifier;
  String get name => _name;
  String get consistentUdid => _consistentUdid;
  String get accuracy => _accuracy;
  String get deviceTime => _deviceTime;
  int get batteryLevel => _batteryLevel;
  double get liveLatitude => _liveLatitude;
  double get liveLongitude => _liveLongitude;
  double get distance => _distance;
  Timer get locationTimer => _locationTimer;
  int get seconds => _seconds;
  Set<Marker> get livePositionMarkers => _livePositionMarkers;



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
    // _locationTimer.cancel();
    clearMarkers();
    getUniqueIdentifier();
    getLocation();
    updateLocation();
  }

  void updateLocation() async {
    // _locationTimer.cancel();
    _locationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 10) {
        _seconds = 0;
        getLocation();
        postData();
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
    _livePositionMarkers
        .removeWhere((marker) => marker.markerId.value == 'Hello');

    // Clear the list of position markers
    _livePositionMarkers.clear();

    // Notify listeners to update the UI
    notifyListeners();
  }

   void postData() async{
      Uri url = Uri.parse(baseApi);
      Map<String, dynamic> data = {
        // 'mobile_id': _uniqueIdentifier,
        // 'mobile_id': 2,
        'employee_name': _name,
        'latitude': _liveLatitude,
        'longitude': _liveLongitude,
        'battery_percentage': _batteryLevel,
        'accuracy': _accuracy,
        'deviceTime': _deviceTime,
      };

      try {
        print('Inside try block');
        var post = await http.post(url, headers:{ 'Content-Type': 'application/json'}, body: jsonEncode(data));
        print('after posting');
        if (post.statusCode == 200) {
          print('Inside if block');
          var data = json.decode(post.body);
          print('hello');
        }else{
          print('${post.statusCode}');
          print('Inside else block');
        }
        print('Outside if block');
      }catch (e) {
        print('Error: $e');
      }
  }

  // print('mobileIdentifier: ${_uniqueIdentifier}');
  // print('employeeName:${_name}');
  // print('Lat: ${_liveLatitude}');
  // print('Long: ${_liveLongitude}');
  // print('battery_Percentage: ${_batteryLevel}');
  // print('accuracy: ${_accuracy}');
  // print('deviceTime: ${_deviceTime}');
  void getLocation() async {
    if (_livePositionMarkers.isNotEmpty) {
      Marker marker = _livePositionMarkers
          .firstWhere((marker) => marker.markerId.value == "Hello");
      _livePositionMarkers.remove(marker);
      _livePositionMarkers.clear();
    }
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
    _liveLatitude = position.latitude;
    _liveLongitude = position.longitude;
    _accuracy = accuracyStatus.toString().split('.')[1];
    _livePositionMarkers.add(Marker(
      markerId: const MarkerId('Hello'),
      icon: BitmapDescriptor.bytes(
        icon!,
        bitmapScaling: MapBitmapScaling.auto,
        imagePixelRatio: 2.3,
      ),
      position: LatLng(_liveLatitude, _liveLongitude),
    ));

    _distance = Geolocator.distanceBetween(
      26.45773716586737,
      87.27957052288616,
      _liveLatitude,
      _liveLongitude,
    );

    // getBatteryLevel();

    print('Distance = $distance');

    notifyListeners();

    print('LatLong = $_liveLatitude, $_liveLongitude');
    print('Accuracy = $_accuracy');
    print('_uniqueIdentifier = $_uniqueIdentifier');
    print('_consistentUdid = $_consistentUdid');
    print('_batterylevel = $_batteryLevel');
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


