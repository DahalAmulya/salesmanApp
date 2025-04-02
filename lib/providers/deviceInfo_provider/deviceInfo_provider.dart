import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:deskgoo/consts.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:flutter_udid/flutter_udid.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class DeviceInfoProvider extends ChangeNotifier {
  bool _isAttendance = false;
  Battery _battery = Battery();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String _uniqueIdentifier = '';
  String _name = userName;
  String _consistentUdid = '';
  String _accuracy = '';
  String _deviceTime = '';
  String _connectivityType = '';
  String _connectivityStatus = '';
  int _batteryLevel = 0;
  double _previousLatitude = 0.0;
  double _previousLongitude = 0.0;
  double _liveLatitude = 0.0;
  double _liveLongitude = 0.0;
  double _distance = 0.0;
  late Timer _locationTimer;
  int _seconds = 0;
  Set<Marker> _livePositionMarkers = {};
  var baseApi = 'http://202.51.3.49:8090/api/location';
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  Connectivity _connectivity = Connectivity();
  // late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  Battery get battery => _battery;
  String get uniqueIdentifier => _uniqueIdentifier;
  String get name => _name;
  String get consistentUdid => _consistentUdid;
  String get accuracy => _accuracy;
  String get deviceTime => _deviceTime;
  String get connectivityType => _connectivityType;
  String get connectivityStatus => _connectivityStatus;
  int get batteryLevel => _batteryLevel;
  double get previousLatitude => _previousLatitude;
  double get previousLongitude => _previousLongitude;
  double get liveLatitude => _liveLatitude;
  double get liveLongitude => _liveLongitude;
  double get distance => _distance;
  Timer get locationTimer => _locationTimer;
  int get seconds => _seconds;
  Set<Marker> get livePositionMarkers => _livePositionMarkers;
  List<ConnectivityResult> get connectionStatus => _connectionStatus;
  Connectivity get connectivity => _connectivity;

  void getUniqueIdentifier() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      _name = '${androidInfo.brand} ${androidInfo.model}';
    }
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      _name = '${iosInfo.utsname.machine} ${iosInfo.model}';
    }
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
    _battery.onBatteryStateChanged.listen((BatteryState state) async {
      _batteryLevel = await _battery.batteryLevel;
      // print('battery status = ${await _battery.batteryState}');
      // print('battery save mode = ${await _battery.isInBatterySaveMode}');
      print('batteryLevel = $_batteryLevel');
      notifyListeners();
    });
  }

  void setIsAttendance(bool value) {
    _isAttendance = value;
  }

  deviceInfoProvider(context) {
    clearMarkers();
    getUniqueIdentifier();
    getBatteryLevel();
    getLocation(context);
    // updateLocation();
  }

  void cancelLocationTimer() {
    _locationTimer.cancel();
    print('Stopped updating location');
    notifyListeners();
  }

  void updateLocation(context) async {
    clearMarkers();
    // _locationTimer.cancel();
    if (_isAttendance) {
      _locationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_seconds == 3) {
          _seconds = 0;
          getLocation(context);
          // backgroundLocation();
        } else {
          _seconds++;
        }
        // print('Seconds = $seconds');
      });
    } else {
      _locationTimer.cancel();
    }
  }

  Stream<Position> positionStream = Geolocator.getPositionStream(
    locationSettings: LocationSettings(
      accuracy: LocationAccuracy.high, // High accuracy
      // timeLimit: Duration(seconds: 10),
      distanceFilter:
          15, // Minimum distance (in meters) before an update is triggered
    ),
  );

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      _connectivityType = result[0].toString().split('.')[1];
      print('connection type = $_connectivityType');
      notifyListeners();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status error');
      return;
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    _connectionStatus = result;
    // print('Connectivity changed: $_connectionStatus');
  }

  void clearMarkers() {
    _livePositionMarkers
        .removeWhere((marker) => marker.markerId.value == 'Hello');

    // Clear the list of position markers
    _livePositionMarkers.clear();

    // Notify listeners to update the UI
    notifyListeners();
  }

  void postDeviceInfo(context) async {
    print('****************************************************************');
    print('Uploading device information');
    Uri url = Uri.parse(baseApi);
    Map<String, dynamic> data = {
      'mobileIdentifier': _uniqueIdentifier,
      'employeeName': _name,
      'latitude': _liveLatitude,
      'longitude': _liveLongitude,
      'batteryPercentage': _batteryLevel,
      'accuracy': _accuracy,
      'deviceTime': _deviceTime,
      'connectivityType': _connectivityType,
      'connectivityStatus': _connectivityStatus,
      'distance': _distance,
    };

    // try {
    //   final response = await http.post(
    //     url,
    //     headers: {'Content-Type': 'application/json'},
    //     body: jsonEncode(data),
    //   );
    //   if (response.statusCode == 200 || response.statusCode == 201) {
    //     _connectivityStatus = 'connected';
    //     print('Data Post successfull');
    //     print('identifier = ${_uniqueIdentifier}');
    //     notifyListeners();
    //   } else {
    //     print(response.statusCode);
    //   }
    // } catch (e) {
    //   _connectivityStatus = 'no internet';
    //   notifyListeners();
    //   print('Error: $e');
    // }

    String formattedDateTime =
        '${DateTime.now().toString().split('.')[1]} ${DateTime.now().toString().split('.')[0]}';
    Map<String, dynamic> _body = {
      "latitude": _liveLatitude,
      "longitude": _liveLongitude,
      "batteryPercentage": _batteryLevel,
      "accuracy": _accuracy,
      "localTime": formattedDateTime,
      "mobileTime": DateTime.now().toString(),
      "connectivityType": _connectivityType,
      "connectivityStatus": _connectionStatus,
      "distance": _distance
    };
    print(
        'Location LatLng = ${_liveLatitude}, ${_liveLatitude}, ${DateTime.now().toString().split('.')[0]}');
    print(_body);
    ERPResponse response =
        await ERPServices.postRequest('/location/latest?_id=$userId', _body, context);
    print(response.statusCode);
    print(response.body);
    print('****************************************************************');
  }

  void getLocation(context) async {
    initConnectivity();
    var iconPath = 'assets/images/location.png';
    final Uint8List? icon = await getBytesFromAsset(iconPath, 100);
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 25,
      ),
    );

    LocationAccuracyStatus accuracyStatus =
        await Geolocator.getLocationAccuracy();
    if (_livePositionMarkers.isNotEmpty) {
      Marker marker = _livePositionMarkers
          .firstWhere((marker) => marker.markerId.value == "Hello");
      _livePositionMarkers.remove(marker);
      _livePositionMarkers.clear();
    }
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

    _deviceTime = DateTime.now().toString().split('.')[0];

    if (_previousLatitude == 0 && _previousLongitude == 0) {
      _previousLatitude = _liveLatitude;
      _previousLongitude = _liveLongitude;
    }

    _distance = Geolocator.distanceBetween(
      _previousLatitude,
      _previousLongitude,
      _liveLatitude,
      _liveLongitude,
    );

    if (_connectivityType != 'none' && _distance > 30) {
      _connectivityStatus = 'connected';
      postDeviceInfo(context);
      notifyListeners();
    }
    print('distance = $_distance');

    _previousLatitude = _liveLatitude;
    _previousLongitude = _liveLongitude;

    notifyListeners();
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
