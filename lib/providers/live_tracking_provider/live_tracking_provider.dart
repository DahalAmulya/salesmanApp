import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveTrackingProvider extends ChangeNotifier {
  Set<Marker> _liveTrakingMarkers = {};

  Set<Marker> get liveTrackingMarkers => _liveTrakingMarkers;
}
