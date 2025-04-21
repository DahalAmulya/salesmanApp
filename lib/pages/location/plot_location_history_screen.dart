import 'dart:async';

import 'package:deskgoo/providers/replay_provider/replay_provider.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../routes/route_generator_constants.dart';
import '../../themes/custom_colors.dart';
import '../../widgets/containers/custom_container.dart';

class PlotLocationHistoryScreen extends StatefulWidget {
  const PlotLocationHistoryScreen({super.key});

  @override
  State<PlotLocationHistoryScreen> createState() =>
      _PlotLocationHistoryScreenState();
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
      child: Consumer<ReplayProvider>(builder: (context, replayProvider, _) {
        return CustomAppBar(
          tabName: 'Location History',
          titleColor: CustomColors.primaryBlack,
          backgroundColor: CustomColors.primaryColor,
          centerTitle: true,
          automaticallyImplyLeading: true,
          leadingIconColor: CustomColors.primaryBlack,
          onTap: () {
            replayProvider.clearPlotLocationHistory();
            Navigator.of(context).pop(MarketingManagerConstants.homePage);
          },
        );
      }),
    );
  }

  Widget _body(context) {
    return Consumer<ReplayProvider>(
      builder: (context, replayProvider, _) {
        return Stack(
          children: [
            GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: const CameraPosition(
                target: LatLng(26.45845827202604, 87.28699164913807),
                zoom: 12,
              ),
              myLocationEnabled: false,
              compassEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: replayProvider.locationPoints,
              polylines: replayProvider.locationPointsPolyline,
            ),
            Positioned(
              right: 12,
              bottom: 8,
              child: Center(
                child: CustomContainer(
                  verticalPad: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CustomText(
                          text: 'Location History from',
                          isSubHeading: true,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: CustomText(
                              text: 'Date',
                              isContent: true,
                              maxLines: 2,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: CustomText(
                              text:
                                  '${replayProvider.from} to ${replayProvider.to}',
                              isContent: true,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: CustomText(
                              text: 'Total Distance',
                              isContent: true,
                              maxLines: 2,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: CustomText(
                              text:
                                  '${replayProvider.totalDistance.toStringAsFixed(2)} km',
                              isContent: true,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
