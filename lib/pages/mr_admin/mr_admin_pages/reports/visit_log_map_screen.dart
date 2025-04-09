import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../providers/mr_admin_provider/mr_admin_visit_logProvider.dart';
import '../../../../routes/route_generator_constants.dart';
import '../../../../widgets/app_bars/custom_app_bars.dart';

class VisitLogReportMapScreen extends StatefulWidget {
  const VisitLogReportMapScreen({super.key});

  @override
  State<VisitLogReportMapScreen> createState() =>
      _VisitLogReportMapScreenState();
}

class _VisitLogReportMapScreenState extends State<VisitLogReportMapScreen> {
  @override
  final Completer<GoogleMapController> _controller = Completer();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _buildUI(context),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Consumer<MrAdminVisitLogProvider>(
          builder: (context, mrAdminVisitLogProvider, _) {
        return CustomAppBar(
          tabName: 'Visit Log Map',
          centerTitle: true,
          automaticallyImplyLeading: true,
          onTap: () {
            mrAdminVisitLogProvider.clearMarkerOnMap();
            Navigator.of(context).pop(MarketingManagerConstants.homePage);
          },
        );
      }),
    );
  }

  Widget _buildUI(context) {
    return Consumer<MrAdminVisitLogProvider>(
      builder: (context, _mrAdminVisitLogProvider, _) {
        return Stack(
          children: [
            GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: const CameraPosition(
                target: LatLng(26.45845827202604, 87.28699164913807),
                zoom: 10,
              ),
              myLocationEnabled: false,
              tiltGesturesEnabled: true,
              compassEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              mapToolbarEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                _mrAdminVisitLogProvider.latitude;
                _mrAdminVisitLogProvider.customInfoWindowController
                    .googleMapController = controller;
              },
              markers: _mrAdminVisitLogProvider.visitLogMarkers,
              onTap: (location) {
                _mrAdminVisitLogProvider
                    .customInfoWindowController.hideInfoWindow!();
              },
              onCameraMove: (position) {
                _mrAdminVisitLogProvider
                    .customInfoWindowController.onCameraMove!();
              },
            ),
            CustomInfoWindow(
              controller: _mrAdminVisitLogProvider.customInfoWindowController,
              height: 320,
              width: 320,
              offset: 50,
            ),
          ],
        );
      },
    );
  }
}
