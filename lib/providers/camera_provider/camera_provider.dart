import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class CameraProvider extends ChangeNotifier {
  List<CameraDescription> _cameras = [];
  bool _isRearCameraSelected = true;
  bool _showFocusCircle = false;
  double _x = 0.0;
  double _y = 0.0;
  bool _isFlashOn = false;
  FlashMode _flashMode = FlashMode.off;
  List<String> _followPhotos = [];
  String _followSelectedPhoto = '';
  List<String> _newVisitPhotos = [];
  String _newVisitSelectedPhoto = '';

  List<CameraDescription> get cameras => _cameras;
  bool get isRearCameraSelected => _isRearCameraSelected;
  bool get showFocusCircle => _showFocusCircle;
  double get x => _x;
  double get y => _y;
  bool get isFlashOn => _isFlashOn;
  FlashMode get flashMode => _flashMode;
  List<String> get followPhotos => _followPhotos;
  String get followSelectedPhoto => _followSelectedPhoto;
  List<String> get newVisitPhotos => _newVisitPhotos;
  String get newVisitSelectedPhoto => _newVisitSelectedPhoto;

  void toggleFlashMode() {
    _isFlashOn = !_isFlashOn;
    if (_isFlashOn) {
      _flashMode = FlashMode.always;
      notifyListeners();
    } else {
      _flashMode = FlashMode.off;
      notifyListeners();
    }
    notifyListeners();
  }

  void addFollowPhotos(String photo) {
    _followPhotos.add(photo);
    notifyListeners();
  }

  void addNewVisitPhotos(String photo) {
    _newVisitPhotos.add(photo);
    notifyListeners();
  }
}
