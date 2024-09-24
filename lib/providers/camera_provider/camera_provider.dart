import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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

  void setCameras(cameras) {
    _cameras = cameras;
    notifyListeners();
  }

  void offsetXAndY() {
    _x = _x - 20;
    _y = _y - 20;
    notifyListeners();
  }

  void setShowFocus(bool focusValue) {
    _showFocusCircle = focusValue;
    notifyListeners();
  }

  // void offsetY(double y) {
  //   notifyListeners();
  // }

  // Future<void> onTap(CameraController _cameraController, BuildContext context,
  //     TapUpDetails details) async {
  //   if (_cameraController.value.isInitialized) {
  //     Future.microtask(() {
  //       _showFocusCircle = true;
  //       _x = details.localPosition.dx;
  //       _y = details.localPosition.dy;
  //       notifyListeners();
  //     });

  //     double fullWidth = MediaQuery.of(context).size.width;
  //     double cameraHeight = fullWidth * _cameraController.value.aspectRatio;

  //     double xp = _x / fullWidth;
  //     double yp = _y / cameraHeight;

  //     Offset point = Offset(xp, yp);
  //     print("point : $point");

  //     // Manually focus
  //     await _cameraController.setFocusPoint(point);

  //     Future.delayed(const Duration(seconds: 1)).whenComplete(() {
  //       _showFocusCircle = false;
  //       notifyListeners();
  //     });
  //   }
  // }

  void toggleIsRearCameraSelected() {
    _isRearCameraSelected = !_isRearCameraSelected;
    notifyListeners();
  }

  void toggleFlashMode() {
    _isFlashOn = !_isFlashOn;
    _flashMode = _isFlashOn ? FlashMode.always : FlashMode.off;
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
