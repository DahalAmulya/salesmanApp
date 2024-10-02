import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraProvider extends ChangeNotifier {
  bool _isNewVisit = false;
  bool _isFollowUp = false;
  List<CameraDescription> _cameras = [];
  bool _isRearCameraSelected = true;
  bool _showFocusCircle = false;
  double _x = 0.0;
  double _y = 0.0;
  int _index = 0;
  bool _isFlashOn = false;
  FlashMode _flashMode = FlashMode.off;
  List<String> _photos = [];
  List<String> _followUpPhotos = [];
  String _followUpSelectedPhoto = '';
  List<String> _newVisitPhotos = [];
  String _newVisitSelectedPhoto = '';

  bool get isNewVisit => _isNewVisit;
  bool get isFollowUp => _isFollowUp;
  List<CameraDescription> get cameras => _cameras;
  bool get isRearCameraSelected => _isRearCameraSelected;
  bool get showFocusCircle => _showFocusCircle;
  double get x => _x;
  double get y => _y;
  int get index => _index;
  bool get isFlashOn => _isFlashOn;
  FlashMode get flashMode => _flashMode;
  List<String> get photos => _photos;
  List<String> get followUpPhotos => _followUpPhotos;
  String get followUpSelectedPhoto => _followUpSelectedPhoto;
  List<String> get newVisitPhotos => _newVisitPhotos;
  String get newVisitSelectedPhoto => _newVisitSelectedPhoto;

  void setIsNewVisit() {
    _isNewVisit = true;
    _isFollowUp = false;
    notifyListeners();
  }

  void setIsFollowUp() {
    _isFollowUp = true;
    _isNewVisit = false;
    notifyListeners();
  }

  void setCameras(cameras) {
    _cameras = cameras;
    notifyListeners();
  }

  void setIndex(int index) {
    _index = index;
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

  void resetCameraStroredPhotos() {
    _photos = [];
    _followUpPhotos = [];
    _followUpSelectedPhoto = '';
    _newVisitPhotos = [];
    _newVisitSelectedPhoto = '';
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

  void addFollowUpPhotos(String photo) {
    _followUpPhotos.add(photo);
    _photos = _followUpPhotos;
    notifyListeners();
  }

  void addNewVisitPhotos(String photo) {
    _newVisitPhotos.add(photo);
    _photos = _newVisitPhotos;
    notifyListeners();
  }

  void selectedNewVisitPhotos(String photo) {
    _newVisitSelectedPhoto = photo;
    notifyListeners();
  }

  void selectedFollowUpPhotos(String photo) {
    _followUpSelectedPhoto = photo;
    notifyListeners();
  }
}
