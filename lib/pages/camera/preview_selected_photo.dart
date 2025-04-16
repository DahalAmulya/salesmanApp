import 'dart:io';

import 'package:deskgoo/providers/camera_provider/camera_provider.dart';
import 'package:deskgoo/providers/visit_provider/visit_screen_provider.dart';
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

class PreviewSelectedPhoto extends StatefulWidget {
  const PreviewSelectedPhoto({super.key});

  @override
  State<PreviewSelectedPhoto> createState() => _PreviewSelectedPhotoState();
}

class _PreviewSelectedPhotoState extends State<PreviewSelectedPhoto> {
  VisitScreenProvider? _visitScreenProvider;
  String photo = '';

  @override
  void initState() {
    super.initState();
    _visitScreenProvider =
        Provider.of<VisitScreenProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      // drawer: _drawer(context),
      body: _buildUI(context),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Builder(builder: (context) {
        return Consumer<VisitScreenProvider>(
            builder: (context, visitScreenProvider, _) {
          return CustomAppBar(
            tabName: 'Preview',
            showLeading: true,
            leadingIcon: FontAwesomeIcons.arrowLeft,
            onTapLeadingIcon: () {
              visitScreenProvider.setIndex(4);
              Navigator.of(context).pop(MarketingManagerConstants.visitPage);
            },
          );
        });
      }),
    );
  }

  CustomDrawer _drawer(context) {
    return const CustomDrawer(
      isHomeActive: true,
    );
  }

  double _scale = 1.0;
  var _previousScale = null;

  Widget _buildUI(context) {
    final mediaSize = MediaQuery.of(context).size;
    return Consumer<CameraProvider>(
      builder: (context, cameraProvider, _) {
        if (cameraProvider.isNewVisit) {
          photo = cameraProvider.newVisitSelectedPhoto;
        } else if (cameraProvider.isFollowUp) {
          photo = cameraProvider.followUpSelectedPhoto;
        }
        return SafeArea(
          child: Stack(
            children: [
              InteractiveViewer(
                panEnabled: true, // Set it to false
                panAxis: PanAxis.free,
                boundaryMargin: const EdgeInsets.all(0),
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
                minScale: 1,
                maxScale: 2,
                child: Image.file(
                  File(photo),
                  width: mediaSize.width,
                  height: mediaSize.height,
                  fit: BoxFit.cover, // Fit the image to the screen
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
