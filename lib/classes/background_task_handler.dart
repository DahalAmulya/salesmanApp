import 'dart:convert';

import 'package:background_task/background_task.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:deskgoo/classes/secure_storage.dart';
import 'package:deskgoo/consts.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:deskgoo/utils/notification.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

double _previousLatitude = 0;
double _previousLongitude = 0;

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371000; // Earth radius in meters

  double toRadians(double degree) => degree * pi / 180;

  double dLat = toRadians(lat2 - lat1);
  double dLon = toRadians(lon2 - lon1);

  double a = pow(sin(dLat / 2), 2) +
      cos(toRadians(lat1)) * cos(toRadians(lat2)) * pow(sin(dLon / 2), 2);

  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return earthRadius * c; // Distance in meters
}

@pragma('vm:entry-point')
void backgroundHandler(Location data) async {
  SecureStorageResponse _id =
      await SecureStorage().readLoginCredentials(SecureStorage.userId);
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  Connectivity _connectivity = Connectivity();
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  Battery _battery = Battery();

  int _batteryLevel = await _battery.batteryLevel;
  print('batteryLevel = $_batteryLevel');

  List<ConnectivityResult> result = await _connectivity.checkConnectivity();
  String _connectivityType = result[0].toString().split('.')[1];
  print('connection type = $_connectivityType');
  _connectionStatus = result;

  double? _liveLatitude = data.lat;
  double? _liveLongitude = data.lng;

  if (_previousLatitude == 0 && _previousLongitude == 0) {
    print('Inside Previous Latitude longitude if else');
    _previousLatitude = _liveLatitude!;
    _previousLongitude = _liveLongitude!;
  }

  print(
      'Previous Latitude, Longitude = $_previousLatitude, $_previousLongitude');
  print('Live Latitude, Longitude = $_liveLatitude, $_liveLongitude');

  LocationAccuracyStatus accuracyStatus =
      await Geolocator.getLocationAccuracy();
  print('$accuracyStatus = $accuracyStatus');

  String _accuracy = accuracyStatus.toString().split('.')[1];
  print('$_accuracy = $_accuracy');

  String unFormateDateTime = DateTime.now().toString().split('.')[0];
  String formattedDateTime =
      '${unFormateDateTime.split(' ')[1]} ${unFormateDateTime.split(' ')[0]}';
  print('formatDateTime = $formattedDateTime');

  double _distance = Geolocator.distanceBetween(
    _previousLatitude,
    _previousLongitude,
    _liveLatitude!,
    _liveLongitude!,
  );
  _distance = calculateDistance(
      _previousLatitude, _previousLongitude, _liveLatitude, _liveLongitude);
  print('distance = $_distance');

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    _connectionStatus = result;
    // print('Connectivity changed: $_connectionStatus');
  }

  Map<String, dynamic> _body = {
    "latitude": _liveLatitude,
    "longitude": _liveLongitude,
    "batteryPercentage": _batteryLevel,
    "accuracy": _accuracy,
    "localTime": DateTime.now().toString(),
    "mobileTime": formattedDateTime,
    "connectivityType": _connectivityType,
    "connectivityStatus": _connectionStatus[0].toString().split('.')[1],
    "distance": _distance
  };
  _previousLatitude = _liveLatitude;
  _previousLongitude = _liveLongitude;
  // ERPResponse response = await ERPServices.postRequest(
  //     '/location/latest?_id=67a58f5cf064e3e542714d4d', _body);
  Map<String, String> header = {
    'Content-Type': 'Application/json',
  };
  if (_distance >= 5.0) {
    final response = await http.post(
      Uri.parse('http://202.51.3.49:8002/api/location/latest?_id=${_id.value}'),
      headers: header,
      body: jsonEncode(_body),
    );

    print(response.statusCode);
    print(response.body);
  }
  print('_id = ${_id.value}');
  print('http://202.51.3.49:8002/api/location/latest?_id=${_id.value}');
  print(
      'Location LatLng = ${data.lat}, ${data.lng}, ${DateTime.now().toString().split('.')[0]}');
}

void getBackgroundLocation() async {
  await BackgroundTask.instance
      .stop(); // Ensure the background task is stopped before requesting permissions

  PermissionStatus locationStatus = await Permission.location.status;
  PermissionStatus alwaysStatus = await Permission.locationAlways.status;

  if (locationStatus.isGranted && alwaysStatus.isGranted) {
    print("Location permissions already granted. Starting background task...");
  } else {
    print("Requesting location permissions...");

    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.locationAlways,
    ].request();

    if (statuses[Permission.location] != PermissionStatus.granted ||
        statuses[Permission.locationAlways] != PermissionStatus.granted) {
      print("Location permission not granted. Background task cannot start.");
      return;
    }
  }

  if (isBackground) {
    await BackgroundTask.instance.start(
      isEnabledEvenIfKilled: true,
      pausesLocationUpdatesAutomatically: true,
      updateIntervalInMilliseconds: 1000,
      iOSDesiredAccuracy: DesiredAccuracy.best,
      androidDesiredAccuracy:
          AndroidDesiredAccuracy.priorityBalancedPowerAccuracy,
    );
  } else {
    await BackgroundTask.instance.stop();
  }
}
