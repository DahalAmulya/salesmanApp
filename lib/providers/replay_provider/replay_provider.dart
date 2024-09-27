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
    getEmployeeLocationById();
    // locationReplay();
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
    DeviceinfoProvider _provider = DeviceinfoProvider();
    var iconPath = 'assets/images/location.png'; // For temporary markers
    var iconPath1 = 'assets/images/start.png'; // For permanent start marker
    var iconPath2 = 'assets/images/finish.png'; // For permanent end marker

    final Uint8List? icon = await _provider.getBytesFromAsset(iconPath, 80);
    final Uint8List? icon1 = await _provider.getBytesFromAsset(iconPath1, 100);
    final Uint8List? icon2 = await _provider.getBytesFromAsset(iconPath2, 100);

    // Add start marker (index 0) as permanent
    _positionMarkers.add(
      Marker(
        markerId: const MarkerId('start_marker'),
        icon: BitmapDescriptor.bytes(
          icon1!,
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
          icon2!,
          bitmapScaling: MapBitmapScaling.auto,
          imagePixelRatio: 2.3,
        ),
        position:
            LatLng(_locations.last['latitude'], _locations.last['longitude']),
      ),
    );

    notifyListeners(); // Update UI with permanent start and end markers

    // Loop to update the temporary marker
    for (int i = 0; i < _locations.length; i++) {
      if (_isRestartReplay) {
        break;
      }

      // Pause loop execution if _isPause is true
      while (_isPause) {
        if (_isRestartReplay) {
          break; // Exit while loop if _isRestartReplay becomes true
        }
        await Future.delayed(
            const Duration(milliseconds: 100)); // Small delay while paused
      }

      if (_isRestartReplay) {
        break; // Break out of the for loop if needed
      }

      _latitude = _locations[i]['latitude'];
      _longitude = _locations[i]['longitude'];

      _polylineCoordinates.add(LatLng(_latitude, _longitude));
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route_polyline'),
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
      await Future.delayed(const Duration(milliseconds: 100));

      print('latlong $i = $_latitude,$_longitude');
    }

    print('LatLong = $_latitude, $_longitude');
    // _isPause = false;
    // _isRestartReplay = false;
    // notifyListeners();
  }
}
