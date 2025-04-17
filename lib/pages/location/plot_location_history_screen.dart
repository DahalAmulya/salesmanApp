import 'dart:async';

import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../themes/custom_colors.dart';

class PlotLocationHistoryScreen extends StatefulWidget {
  const PlotLocationHistoryScreen({super.key});

  @override
  State<PlotLocationHistoryScreen> createState() => _PlotLocationHistoryScreenState();
}

class _PlotLocationHistoryScreenState extends State<PlotLocationHistoryScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _body(context),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Builder(
        builder: (context) => CustomAppBar(
          tabName: 'Replay',
          titleColor: CustomColors.primaryBlack,
          backgroundColor: CustomColors.primaryColor,
          showLeading: true,
          leadingIcon: FontAwesomeIcons.arrowLeft,
          leadingIconColor: CustomColors.primaryBlack,
          onTapLeadingIcon: () {
          },
        ),
      ),
    );
  }

  Widget _body(context){
    return GoogleMap(
      mapType: MapType.hybrid,
      initialCameraPosition: const CameraPosition(
        target: LatLng(26.45845827202604, 87.28699164913807),
        zoom: 14,
      ),
      myLocationEnabled: false,
      compassEnabled: true,
      zoomControlsEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      // markers: replayProvider.positionMarkers,
      // polylines: replayProvider.polylines,
    );
  }
}
