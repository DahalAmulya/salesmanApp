import 'dart:convert';
import 'dart:typed_data';
import 'package:deskgoo/providers/deviceInfo_provider/deviceInfo_provider.dart';
import 'package:deskgoo/services/erp_services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReplayProvider extends ChangeNotifier {
  double _latitude = 0.0;
  double _longitude = 0.0;
  Set<Marker> _positionMarkers = {};
  Set<Polyline> _polylines = {};
  List<dynamic> _locations = [];
  List<LatLng> _coordinates = [];
  List<LatLng> _polylineCoordinates = [];
  bool _isRestartReplay = false;
  bool _isPause = false;

  Uint8List? _tempMarkerIcon;
  Uint8List? _startMarkerIcon;
  Uint8List? _endMarkerIcon;

  double get latitude => _latitude;
  double get longitude => _longitude;
  Set<Marker> get positionMarkers => _positionMarkers;
  Set<Polyline> get polylines => _polylines;
  List<dynamic> get locations => _locations;
  List<LatLng> get coordinates => _coordinates;
  List<LatLng> get polylineCoordinates => _polylineCoordinates;
  bool get isRestartReplay => _isRestartReplay;
  bool get isPause => _isPause;

  ReplayProvider() {
    cacheIcons(); // Pre-cache marker icons
    getEmployeeLocationById();
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
  }

  void cacheIcons() async {
    DeviceinfoProvider _provider = DeviceinfoProvider();
    _tempMarkerIcon =
        await _provider.getBytesFromAsset('assets/images/location.png', 80);
    _startMarkerIcon =
        await _provider.getBytesFromAsset('assets/images/start.png', 100);
    _endMarkerIcon =
        await _provider.getBytesFromAsset('assets/images/finish.png', 100);
  }

  void getEmployeeLocationById() async {
    ERPResponse response = await ERPServicer.getRequest('location', '/1');
    print(response.statusCode);
    Map<String, dynamic> body = jsonDecode(response.body);
    _locations = body['locations'];
    print(locations);
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
    resetValues();
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

    for (int i = 0; i < _locations.length; i++) {
      if (_isRestartReplay) {
        break;
      }

      // Pause loop execution if _isPause is true
      while (_isPause) {
        if (_isRestartReplay) {
          break;
        }
        await Future.delayed(
            const Duration(milliseconds: 100)); // Small delay while paused
      }

      if (_isRestartReplay) {
        break;
      }

      _latitude = _locations[i]['latitude'];
      _longitude = _locations[i]['longitude'];

      // Add to polyline coordinates
      _polylineCoordinates.add(LatLng(_latitude, _longitude));

      // Limit the size of polyline coordinates to avoid memory issues
      if (_polylineCoordinates.length > 500) {
        _polylineCoordinates.removeAt(0);
      }

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

      // Throttle UI updates (notify every 10 iterations)
      if (i % 10 == 0) {
        notifyListeners();
      }

      await Future.delayed(
          const Duration(milliseconds: 100)); // Simulate location replay delay
    }
  }
}
