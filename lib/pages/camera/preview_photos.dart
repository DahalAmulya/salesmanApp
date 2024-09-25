import 'dart:io';

import 'package:deskgoo/providers/camera_provider/camera_provider.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/drawers/custom_drawer.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class PreviewCapturedPhotos extends StatefulWidget {
  const PreviewCapturedPhotos({super.key});

  @override
  State<PreviewCapturedPhotos> createState() => _PreviewCapturedPhotosState();
}

class _PreviewCapturedPhotosState extends State<PreviewCapturedPhotos> {
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

  double _scale = 1.0;
  var _previousScale = null;

  Widget _buildUI(context) {
    final mediaSize = MediaQuery.of(context).size;
    return Consumer<CameraProvider>(
      builder: (context, cameraProvider, _) {
        return SafeArea(
          child: Stack(
            children: [
              InteractiveViewer(
                panEnabled: true, // Set it to false
                panAxis: PanAxis.free,
                boundaryMargin: EdgeInsets.all(0),
                onInteractionStart: (ScaleStartDetails details) {
                  print('ScaleStartDetails = $details');
                  _previousScale = _scale;
                },
                onInteractionUpdate: (ScaleUpdateDetails details) {
                  print('ScaleUpdateDetails = $details');
                  setState(() {
                    _scale = _previousScale * details.scale;
                  });
                },
                onInteractionEnd: (ScaleEndDetails details) {
                  print('ScaleEndDetails = $details');
                  _previousScale = null;
                },
                // transformationController: TransformationController(),
                // scaleFactor: _scale,
                minScale: 1,
                maxScale: 2,
                child: Image.file(
                  File(cameraProvider.newVisitPhotos[cameraProvider.index]),
                  width: mediaSize.width,
                  height: mediaSize.height,
                  fit: BoxFit.cover, // Fit the image to the screen
                ),
              ),
              // GestureDetector(
              //   onScaleStart: (ScaleStartDetails details) {
              //     print('ScaleStartDetails = $details');
              //     _previousScale = _scale;
              //   },
              //   onScaleUpdate: (ScaleUpdateDetails details) {
              //     print('ScaleUpdateDetails = $details');
              //     setState(() {
              //       _scale = _previousScale * details.scale;
              //     });
              //   },
              //   onScaleEnd: (ScaleEndDetails details) {
              //     print('ScaleEndDetails = $details');
              //     _previousScale = null;
              //   },
              //   onDoubleTap: () {
              //     print('Double tapped');
              //   },
              // onPanUpdate: (details) {
              //     // Swiping in right direction.
              //     if (details.delta.dx > 0) {
              //       cameraProvider.index > 0
              //           ? cameraProvider.setIndex(cameraProvider.index - 1)
              //           : null;
              //       print('Swipped right');
              //     }

              //     // Swiping in left direction.
              //     if (details.delta.dx < 0) {
              //       cameraProvider.index <
              //               cameraProvider.newVisitPhotos.length - 1
              //           ? cameraProvider.setIndex(cameraProvider.index + 1)
              //           : null;
              //       print('Swipped left');
              //     }
              //   },
              //   child: Transform(
              //     transform:
              //         new Matrix4.diagonal3(Vector3(_scale, _scale, _scale)),
              //     alignment: FractionalOffset.center,
              //     child: Image.file(
              //       File(cameraProvider.newVisitPhotos[cameraProvider.index]),
              //       width: mediaSize.width,
              //       height: mediaSize.height,
              //       fit: BoxFit.cover, // Fit the image to the screen
              //     ),
              //   ),
              // ),
              Positioned(
                bottom: 0,
                child: Container(
                  // color: Colors.white.withOpacity(0.2),
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: mediaSize.width, // Use the screen width
                        height: 150, // Set a fixed height
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: cameraProvider.newVisitPhotos.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                cameraProvider.setIndex(index);
                              },
                              onPanUpdate: (details) {
                                // Swiping in right direction.
                                if (details.delta.dx > 0) {
                                  cameraProvider.index > 0
                                      ? cameraProvider
                                          .setIndex(cameraProvider.index - 1)
                                      : null;
                                  print('Swipped right');
                                }

                                // Swiping in left direction.
                                if (details.delta.dx < 0) {
                                  cameraProvider.index <
                                          cameraProvider.newVisitPhotos.length -
                                              1
                                      ? cameraProvider
                                          .setIndex(cameraProvider.index + 1)
                                      : null;
                                  print('Swipped left');
                                }
                              },
                              child: Container(
                                color: cameraProvider.index == index
                                    ? Colors.white.withOpacity(0.3)
                                    : Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: SizedBox(
                                    height: 100,
                                    width: 75,
                                    child: Image.file(
                                      File(
                                          cameraProvider.newVisitPhotos[index]),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        // color: Colors.red,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(RouteGeneratorConstants.cameraPage);
                              },
                              backgroundColor: CustomColors.primaryColor,
                              widget: CustomText(
                                text: 'Retake',
                                fontWeight: FontWeight.w600,
                                size: 18,
                              ),
                            ),
                            CustomElevatedButton(
                              onPressed: () {
                                cameraProvider.selectedNewVisitPhotos(
                                    cameraProvider
                                        .newVisitPhotos[cameraProvider.index]);
                              },
                              backgroundColor: CustomColors.primaryColor,
                              widget: CustomText(
                                text: 'Select',
                                fontWeight: FontWeight.w600,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
