import 'dart:typed_data';
import 'package:deskgoo/providers/deviceInfo_provider/deviceInfo_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReplayProvider extends ChangeNotifier {
  double _latitude = 0.0;
  double _longitude = 0.0;
  Set<Marker> _positionMarkers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _coordinates = [];
  List<LatLng> _polylineCoordinates = [];
  bool _isRestartReplay = false;
  bool _isPause = false;
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
    LatLng(26.458179566079867, 87.28453192950644), // 31
    LatLng(26.45813102822457, 87.28407883455003), // 32
    LatLng(26.458091908809724, 87.28370727329275), // 33
    LatLng(26.45803908073219, 87.28317619592862), // 34
    LatLng(26.457967042404743, 87.28263975413914), // 35
    LatLng(26.45789980659067, 87.28177071843578), // 36
    LatLng(26.457794150233156, 87.2807997587812), // 37
    LatLng(26.45777974254049, 87.28037060533104), // 38
    LatLng(26.457800206553603, 87.28006868554252), // 39
    LatLng(26.45786263482737, 87.27970864882376), // 40
    LatLng(26.457912546240465, 87.27948635204493), // 41
    LatLng(26.45775143969878, 87.27940801889882), // 42
  ];

  double get latitude => _latitude;
  double get longitude => _longitude;
  Set<Marker> get positionMarkers => _positionMarkers;
  Set<Polyline> get polylines => _polylines;
  List<LatLng> get coordinates => _coordinates;
  List<LatLng> get polylineCoordinates => _polylineCoordinates;
  bool get isRestartReplay => _isRestartReplay;
  bool get isPause => _isPause;

  ReplayProvider() {
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

      _latitude = biratnagarRoute[i].latitude;
      _longitude = biratnagarRoute[i].longitude;

      // Update polyline coordinates
      _polylineCoordinates.add(biratnagarRoute[i]);
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
      await Future.delayed(const Duration(seconds: 1));

      print('latlong $i = $_latitude,$_longitude');
    }

    print('LatLong = $_latitude, $_longitude');
    // _isPause = false;
    // _isRestartReplay = false;
    // notifyListeners();
  }
}
