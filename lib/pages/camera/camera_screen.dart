import 'dart:io';

import 'package:camera/camera.dart';
import 'package:deskgoo/providers/camera_provider/camera_provider.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/drawers/custom_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraProvider? _cameraProvider;
  CameraController? _cameraController;
  // List<CameraDescription> cameras = [];
  // bool _isRearCameraSelected = true;
  bool showFocusCircle = false;
  double x = 0;
  double y = 0;
  // List<String> photos = [];
  // bool _isFlashOn = false;
  // FlashMode _flashMode = FlashMode.off;

  Future<void> _setupCameraController() async {
    // Obtain a list of the available cameras on the device.
    List<CameraDescription> _cameras = await availableCameras();

    // Check if the list of cameras is not empty before accessing it.
    if (_cameras.isNotEmpty) {
      _cameraProvider!.setCameras(_cameras);
      initCamera(_cameraProvider!.cameras[0]);
      // setState(() {
      //   cameras = _cameras;
      //   initCamera(cameras[0]);
      // });
    } else {
      print('No cameras found');
    }
    print('cameras = ${_cameraProvider!.cameras}');
  }

  Future initCamera(CameraDescription cameraDescription) async {
    // create a CameraController
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);

    // Next, initialize the controller. This returns a Future.
    try {
      await _cameraController!.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  Future<void> _onTap(TapUpDetails details) async {
    if (_cameraController!.value.isInitialized) {
      showFocusCircle = true;
      x = details.localPosition.dx;
      y = details.localPosition.dy;

      double fullWidth = MediaQuery.of(context).size.width;
      double cameraHeight = fullWidth * _cameraController!.value.aspectRatio;

      double xp = x / fullWidth;
      double yp = y / cameraHeight;

      Offset point = Offset(xp, yp);
      print("point : $point");

      // Manually focus
      await _cameraController!.setFocusPoint(point);

      // Manually set light exposure
      //controller.setExposurePoint(point);

      setState(() {
        Future.delayed(const Duration(seconds: 2)).whenComplete(() {
          setState(() {
            showFocusCircle = false;
          });
        });
      });
    }
  }

  Future takePicture() async {
    if (!_cameraController!.value.isInitialized) {
      return null;
    }
    if (_cameraController!.value.isTakingPicture) {
      return null;
    }
    try {
      await _cameraController!.setFlashMode(_cameraProvider!.flashMode);
      _cameraController!.setFocusPoint(Offset(x, y));
      XFile picture = await _cameraController!.takePicture();
      _cameraProvider!.addNewVisitPhotos(picture.path);
      Navigator.of(context)
          .pushNamed(RouteGeneratorConstants.previewCapturedPhotoPage);
      // setState(() {
      //   photos.add(picture.path);
      // });
      // print(photos.length);
      // Gal.putImage(picture.path);
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => PreviewPage(
      //               picture: picture,
      //             )));
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _cameraProvider = Provider.of<CameraProvider>(context, listen: false);
    _setupCameraController();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      drawer: _drawer(context),
      body: _buildUI(context),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Builder(builder: (context) {
        return CustomAppBar(
          tabName: 'Camera',
          showLeading: true,
          leadingIcon: FontAwesomeIcons.bars,
          onTapLeadingIcon: () {
            Scaffold.of(context).openDrawer();
          },
        );
      }),
    );
  }

  CustomDrawer _drawer(context) {
    return CustomDrawer(
      isHomeActive: true,
    );
  }

  Widget _buildUI(context) {
    final mediaSize = MediaQuery.of(context).size;

    // Check if the camera controller has been initialized
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final scale =
        1 / (_cameraController!.value.aspectRatio * mediaSize.aspectRatio);
    return _cameraController!.value.isInitialized
        ? SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: GestureDetector(
              onTapUp: (details) {
                _onTap(details);
              },
              child: Stack(
                children: [
                  _cameraProvider!.isRearCameraSelected
                      ? Transform.scale(
                          scale: scale,
                          child: CameraPreview(
                            _cameraController!,
                          ),
                        )
                      : Transform.scale(
                          scale: scale,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(math.pi),
                            child: CameraPreview(
                              _cameraController!,
                            ),
                          ),
                        ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1,
                      color: Colors.black.withOpacity(0.5),
                      child: Consumer<CameraProvider>(
                        builder: (context, cameraProvider, _) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              cameraProvider.newVisitPhotos.isNotEmpty
                                  ? SizedBox(
                                      height: 125,
                                      width: double.infinity,
                                      child: ListView.builder(
                                        itemCount: cameraProvider
                                            .newVisitPhotos.length,
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  cameraProvider
                                                      .setIndex(index);
                                                  Navigator.of(context).pushNamed(
                                                      RouteGeneratorConstants
                                                          .previewCapturedPhotoPage);
                                                  print(
                                                      'Selected photo $index ${cameraProvider.newVisitPhotos[index]}');
                                                },
                                                onLongPress: () {
                                                  print(
                                                      'Long press Selected photo  $index ${cameraProvider.newVisitPhotos[index]}');
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                                  child: SizedBox(
                                                    height: 125,
                                                    width: 75,
                                                    child: Image.file(
                                                      File(cameraProvider
                                                              .newVisitPhotos[
                                                          index]),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    )
                                  : Container(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    // color: Colors.black.withOpacity(0.5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          iconSize: 32,
                                          icon: Icon(
                                              cameraProvider
                                                      .isRearCameraSelected
                                                  ? CupertinoIcons.switch_camera
                                                  : CupertinoIcons
                                                      .switch_camera_solid,
                                              color: Colors.white),
                                          onPressed: () {
                                            cameraProvider
                                                .toggleIsRearCameraSelected();
                                            initCamera(cameraProvider.cameras[
                                                cameraProvider
                                                        .isRearCameraSelected
                                                    ? 0
                                                    : 1]);
                                          },
                                        ),
                                        IconButton(
                                          onPressed: takePicture,
                                          iconSize: 72,
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          icon: const Icon(Icons.circle,
                                              color: Colors.white),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            cameraProvider.toggleFlashMode();
                                            // print('FlashMode = $_flashMode');
                                            // print('_isFlashOn = $_isFlashOn');
                                            // print(photos.length);
                                            // print(
                                            // '_isRearCameraSelected = ${_isRearCameraSelected}');
                                          },
                                          iconSize: 32,
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          icon: Icon(
                                              cameraProvider.isFlashOn
                                                  ? Icons.flash_on
                                                  : Icons.flash_off,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  if (showFocusCircle)
                    Positioned(
                      top: y - 20,
                      left: x - 20,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
