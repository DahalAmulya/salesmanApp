import 'dart:convert';
import 'dart:typed_data';
import 'package:deskgoo/providers/deviceInfo_provider/deviceInfo_provider.dart';
import 'package:deskgoo/providers/live_tracking_provider/live_tracking_provider.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReplayProvider extends ChangeNotifier {
  List<String> _mapTypes = ['normal', 'hybrid', 'terrain'];
  String _selectedReplayMapTypeValue = 'normal';
  String _selectedLocationPointMapTypeValue = 'normal';
  MapType _selectedReplayMapType = MapType.normal;
  MapType _selectedLocationPointMapType = MapType.normal;
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
  List<String> _visitDateTypeList = ['Today', 'Yesterday', 'Custom'];
  String _selectedVisitType = 'Today';
  String _from = DateTime.now().toString().split(' ')[0];
  String _to = DateTime.now().toString().split(' ')[0];
  Set<Marker> _locationPoints = {};
  Set<Polyline> _locationPointsPolyline = {};
  List<LatLng> _locationPointsPolylineCoordinates = [];

  Set<Marker> get locationPoints => _locationPoints;
  Set<Polyline> get locationPointsPolyline => _locationPointsPolyline;
  List<LatLng> get locationPointsPolylineCoordinates =>
      _locationPointsPolylineCoordinates;

  TextEditingController _fromTextEditingController = TextEditingController();
  TextEditingController _toTextEditingController = TextEditingController();

  Uint8List? _tempMarkerIcon;
  Uint8List? _startMarkerIcon;
  Uint8List? _endMarkerIcon;

  String _radioGroupValue = 'normal';

  String get radioGroupValue => _radioGroupValue;

  List<String> get mapType => _mapTypes;
  String get selectedReplayMapTypeValue => _selectedReplayMapTypeValue;
  String get selectedLocationPointMapTypeValue =>
      _selectedLocationPointMapTypeValue;
  MapType get selectedReplayMapType => _selectedReplayMapType;
  MapType get selectedLocationPointMapType => _selectedLocationPointMapType;
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
  List<String> get visitDateTypeList => _visitDateTypeList;
  String get selectedVisitType => _selectedVisitType;
  String get from => _from;
  String get to => _to;

  TextEditingController get fromTextEditingController =>
      _fromTextEditingController;
  TextEditingController get toTextEditingController => _toTextEditingController;

  ReplayProvider(context) {
    cacheIcons(_selectedImage, context);
    _isLeavePage = false;
  }

  void selectMapType(value) {
    _radioGroupValue = value;
    if (value == _mapTypes[0]) {
      _selectedLocationPointMapType = MapType.normal;
    } else if (value == _mapTypes[1]) {
      _selectedLocationPointMapType = MapType.hybrid;
    } else {
      _selectedLocationPointMapType = MapType.terrain;
    }
    notifyListeners();
  }

  void setSelectedVisitType(visitType) {
    DateTime currentDate = DateTime.now();
    _selectedVisitType = visitType;
    if (_selectedVisitType == _visitDateTypeList[0]) {
      _from = '${currentDate.toString().split(' ')[0]} 00:00:00';
      _to = '${currentDate.toString().split(' ')[0]} 23:59:59';
    } else if (_selectedVisitType == _visitDateTypeList[1]) {
      _from =
          '${currentDate.subtract(const Duration(days: 1)).toString().split(' ')[0]} 00:00:00';
      _to =
          '${currentDate.subtract(const Duration(days: 1)).toString().split(' ')[0]} 23:59:59';
    } else {}
    print(_from + _to);

    notifyListeners();
  }

  void locationPointsSelectMapType(String value) {
    if (value == _mapTypes[0]) {
      _selectedLocationPointMapType == MapType.normal;
    } else if (value == _mapTypes[1]) {
      _selectedLocationPointMapType == MapType.hybrid;
    } else {
      _selectedLocationPointMapType = MapType.terrain;
    }
  }

  void sSelectReplayMapType(String value) {
    if (value == _mapTypes[0]) {
      _selectedLocationPointMapType == MapType.normal;
    } else if (value == _mapTypes[1]) {
      _selectedLocationPointMapType == MapType.hybrid;
    } else {
      _selectedLocationPointMapType = MapType.terrain;
    }
  }

  Future<void> selectDateFrom(context) async {
    print('Select date from');
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2099),
    );
    if (picked == null) {
      return;
    } else {
      _from = '${picked.year}-${picked.month}-${picked.day}';
    }
    _fromTextEditingController.text = _from;
    print(_from + _to);
    notifyListeners();
  }

  Future<void> selectDateTo(context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2099),
    );
    if (picked == null) {
      return;
    } else {
      _to = '${picked.year}-${picked.month}-${picked.day}';
    }
    _toTextEditingController.text = _to;
    print(_from + _to);
    notifyListeners();
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
    LiveTrackingProvider _imgProvider = LiveTrackingProvider(context);
    DeviceInfoProvider _provider = DeviceInfoProvider();
    String tempMarkerImg = img.isEmpty ? 'assets/images/userLocation.png' : img;
    _tempMarkerIcon = await _imgProvider.getBytesFromAsset(tempMarkerImg, 100);
    // img.isEmpty
    //     ? await _provider.getBytesFromAsset(tempMarkerImg, 80)
    // :
    _startMarkerIcon =
        await _provider.getBytesFromAsset('assets/images/start.png', 100);
    _endMarkerIcon =
        await _provider.getBytesFromAsset('assets/images/finish.png', 100);
  }

  void getLatestLocation(String id, context) async {
    ERPResponse response =
        await ERPServices.getRequest('/location/latest?_id=$id', context);
    print(response.body);
    print(response.statusCode);
  }

  void getEmployeeLocationById(String _id, context) async {
    resetValues();
    ERPResponse response = await ERPServices.getRequest(
        '/location/latestByDate?_id=$_id&from=$_from&to=$_to', context);
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
    plotLocationHistory();
    // locationReplay();
  }

  void clearPlotLocationHistory() {
    _locations.clear();
    _locations = [];
    _locationPoints = {};
    _locationPointsPolyline = {};
    _locationPointsPolylineCoordinates = [];
    _locationPoints.clear();
    _locationPointsPolyline.clear();
    _locationPointsPolylineCoordinates.clear();
    _totalDistance = 0;
    notifyListeners();
  }

  void plotLocationHistory() {
    _locationPoints.clear();
    _locationPointsPolyline.clear();
    _locationPointsPolylineCoordinates.clear();

    for (int i = 0; i < _locations.length; i++) {
      _latitude = _locations[i]['latitude'];
      _longitude = _locations[i]['longitude'];
      _mobileTime = _locations[i]['mobileTime'];
      _connectionType = _locations[i]['connectivityType'];
      _battery = _locations[i]['batteryPercentage'];
      _distance = _locations[i]['distance'];
      _totalDistance += _distance / 1000;
      String markerId = 'marker_${_locations[i]['_id']}';

      _locationPoints.add(Marker(
          markerId: MarkerId(markerId),
          icon: BitmapDescriptor.defaultMarker,
          position: LatLng(_latitude, _longitude),
          onTap: () {
            print('latitude and longitude $_latitude, $_longitude');
          }));

      _locationPointsPolylineCoordinates.add(LatLng(_latitude, _longitude));

      _locationPointsPolyline.add(
        Polyline(
          polylineId: const PolylineId('route_polyline'),
          points: _locationPointsPolylineCoordinates,
          color: Colors.blue,
          width: 5,
        ),
      );
    }
    print('************************************************');
    print(_totalDistance);
    print('************************************************');
    notifyListeners();
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
