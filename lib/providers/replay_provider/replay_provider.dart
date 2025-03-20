import 'dart:convert';
import 'dart:typed_data';
import 'package:deskgoo/providers/deviceInfo_provider/deviceInfo_provider.dart';
import 'package:deskgoo/providers/live_tracking_provider/live_tracking_provider.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReplayProvider extends ChangeNotifier {
  int _employee_id = 0;
  String _name = '';
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _mobileDate = '';
  String _mobileTime = '';
  String _mobileDateTime = '';
  int _battery = 0;
  double _distance = 0.0;
  double _totalDistance = 0.0;
  String _connectionType = '';
  Set<Marker> _positionMarkers = {};
  Set<Polyline> _polylines = {};
  List<dynamic> _locations = [];
  List<LatLng> _coordinates = [];
  List<LatLng> _polylineCoordinates = [];
  bool _isRestartReplay = false;
  bool _isPause = false;
  bool _isLeavePage = false;
  String _selectedImage = '';

  Uint8List? _tempMarkerIcon;
  Uint8List? _startMarkerIcon;
  Uint8List? _endMarkerIcon;

  int get employee_id => _employee_id;
  String get name => _name;
  double get latitude => _latitude;
  double get longitude => _longitude;
  String get mobileDate => _mobileDate;
  String get mobileTime => _mobileTime;
  String get mobileDateTime => _mobileDateTime;
  int get battery => _battery;
  double get distance => _distance;
  double get totalDistance => _totalDistance;
  String get connectionType => _connectionType;
  Set<Marker> get positionMarkers => _positionMarkers;
  Set<Polyline> get polylines => _polylines;
  List<dynamic> get locations => _locations;
  List<LatLng> get coordinates => _coordinates;
  List<LatLng> get polylineCoordinates => _polylineCoordinates;
  bool get isRestartReplay => _isRestartReplay;
  bool get isPause => _isPause;
  bool get isLeavePage => _isLeavePage;
  String get selectedImage => _selectedImage;

  ReplayProvider(context) {
    cacheIcons(_selectedImage, context); // Pre-cache marker icons
    _isLeavePage = false;
  }

  void resetValues() {
    _positionMarkers = {};
    _polylines = {};
    _coordinates = [];
    _polylineCoordinates = [];
    _positionMarkers.clear();
    _polylines.clear();
    _coordinates.clear();
    _polylineCoordinates.clear();
    _totalDistance = 0.0;
    _distance = 0.0;
    _battery = 0;
    _name = '';
    _mobileDate = '';
    _mobileTime = '';
    _isRestartReplay = false;
    _isPause = false;
    // _isLeavePage = false;
    notifyListeners();
  }

  void setLeavePage(bool isLeave) {
    _isLeavePage = isLeave;
    _name = '';
    notifyListeners();
  }

  void setEmployeeImage(String img) {
    _selectedImage = img;
    notifyListeners();
  }

  void cacheIcons(String img, context) async {
    LiveTrackingProvider _imgprovider = LiveTrackingProvider(context);
    DeviceInfoProvider _provider = DeviceInfoProvider();
    String tempMarkerImg = img.isEmpty ? 'assets/images/userLocation.png' : img;
    _tempMarkerIcon = await _imgprovider.getBytesFromAsset(tempMarkerImg, 100);
    // img.isEmpty
    //     ? await _provider.getBytesFromAsset(tempMarkerImg, 80)
    // :
    _startMarkerIcon =
        await _provider.getBytesFromAsset('assets/images/start.png', 100);
    _endMarkerIcon =
        await _provider.getBytesFromAsset('assets/images/finish.png', 100);
  }

  void getEmployeeLocationById(String _id, context) async {
    resetValues();
    String from = '2025-02-01 00:00:00';
    String to = '${DateTime.now().toString().split(' ')[0]} 23:59:59';
    ERPResponse response = await ERPServices.getRequest(
        '/location/latestByDate?_id=$_id&from=2025-02-01&to=$to', context);
    print('****************************************************************');
    print('/location/latestByDate?_id=$_id&from=2025-02-01&to=$to');
    print(response.statusCode);
    Map<String, dynamic> body = jsonDecode(response.body);
    print('replay body = $body');
    _name = body['username'];
    _locations = body['locations'];
    print('Location length = ${_locations.length}');
    notifyListeners();
    print(locations);
    print('****************************************************************');
    locationReplay();
  }

  void toggleIsRestartReplay() {
    _isRestartReplay = !_isRestartReplay;
    notifyListeners();
  }

  void toggleIsPause() {
    _isPause = !_isPause;
    notifyListeners();
  }

  void clearMarkers() {
    _positionMarkers.clear();
    _polylineCoordinates.clear();
    notifyListeners();
  }

  void trimLocationData() {
    if (_locations.length > 1000) {
      _locations.removeRange(0, 500); // Trim the first 500 locations
    }
  }

  void locationReplay() async {
    // resetValues();
    _isLeavePage = false;
    // Add start marker (index 0) as permanent
    _positionMarkers.add(
      Marker(
        markerId: const MarkerId('start_marker'),
        icon: BitmapDescriptor.bytes(
          _startMarkerIcon!,
          bitmapScaling: MapBitmapScaling.auto,
          imagePixelRatio: 2.3,
        ),
        position: LatLng(_locations[0]['latitude'], _locations[0]['longitude']),
      ),
    );

    // Add end marker (index last) as permanent
    _positionMarkers.add(
      Marker(
        markerId: const MarkerId('end_marker'),
        icon: BitmapDescriptor.bytes(
          _endMarkerIcon!,
          bitmapScaling: MapBitmapScaling.auto,
          imagePixelRatio: 2.3,
        ),
        position:
            LatLng(_locations.last['latitude'], _locations.last['longitude']),
      ),
    );

    notifyListeners(); // Update UI with permanent start and end markers

    outerLoop:
    for (int i = 0; i < _locations.length; i++) {
      print('index $i = ${_locations[i]}');
      if (_isLeavePage || _isRestartReplay) {
        break outerLoop;
      }

      // Pause loop execution if _isPause is true
      while (_isPause) {
        if (_isRestartReplay) {
          break;
        } else if (_isLeavePage) {
          break outerLoop;
        }
        await Future.delayed(
            const Duration(milliseconds: 300)); // Small delay while paused
      }

      if (_isLeavePage || _isRestartReplay) {
        break outerLoop;
      }

      _latitude = _locations[i]['latitude'];
      _longitude = _locations[i]['longitude'];
      final dis = _locations[i]['distance'];
      print('$dis = ${dis.runtimeType}');
      _distance = double.parse(dis.toString());
      _totalDistance += _distance;
      // List<String> splitByMillisecond =
      //     locations[i]['deviceTime'].toString().split('.');
      // List<String> splitDateTime = splitByMillisecond[0].split('T');
      _mobileDate = _locations[i]['mobileTime'][0];
      _mobileTime = _locations[i]['mobileTime'][1];
      _mobileDateTime = _locations[i]['mobileTime'];

      // Add to polyline coordinates
      _polylineCoordinates.add(LatLng(_latitude, _longitude));

      // Limit the size of polyline coordinates to avoid memory issues
      // if (_polylineCoordinates.length > 500) {
      //   _polylineCoordinates.removeAt(0);
      // }

      // Update polylines
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route_polyline'),
          points: _polylineCoordinates,
          color: Colors.blue,
          width: 5,
        ),
      );

      // Find and update the temp marker instead of recreating it
      Marker tempMarker = _positionMarkers.firstWhere(
        (marker) => marker.markerId.value == 'temp_marker',
        orElse: () => Marker(markerId: const MarkerId('temp_marker')),
      );
      _positionMarkers.remove(tempMarker);
      _positionMarkers.add(
        tempMarker.copyWith(
          iconParam: BitmapDescriptor.bytes(
            _tempMarkerIcon!,
            bitmapScaling: MapBitmapScaling.auto,
            imagePixelRatio: 2.3,
          ),
          positionParam: LatLng(_latitude, _longitude),
        ),
      );
      print('LatLong = $_latitude, $_longitude');
      print('isLeavePage = $_isLeavePage');

      // Throttle UI updates (notify every 10 iterations)
      // if (i % 5 == 0) {
      notifyListeners();
      // }

      await Future.delayed(
          const Duration(milliseconds: 300)); // Simulate location replay delay
    }
  }
}
