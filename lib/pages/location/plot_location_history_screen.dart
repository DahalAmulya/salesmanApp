import 'dart:async';

import 'package:deskgoo/providers/replay_provider/replay_provider.dart';
import 'package:deskgoo/utils/toast_message.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/radio_button/custom_radio_button.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../routes/route_generator_constants.dart';
import '../../themes/custom_colors.dart';
import '../../widgets/buttons/elevated_button.dart';
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
              mapType: replayProvider.selectedLocationPointMapType,
              initialCameraPosition: const CameraPosition(
                target: LatLng(26.45845827202604, 87.28699164913807),
                zoom: 10,
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
              top: MediaQuery.of(context).size.height * 0.10,
              right: 8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: ColoredBox(
                  color: Colors.white.withOpacity(0.7),
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        openAlertDialog(context);
                      },
                      icon: Icon(
                        color: CustomColors.primaryBlack,
                        FontAwesomeIcons.layerGroup,
                        // size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 12,
              bottom: MediaQuery.of(context).size.height * 0.02,
              child: Center(
                child: Stack(
                  children: [
                    CustomContainer(
                      verticalPad: 12,
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
                            height: 16,
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
                                      '${replayProvider.from.split(' ')[0]} to ${replayProvider.to.split(' ')[0]}',
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
                          const SizedBox(height: 12,),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: SizedBox(
                        height: 42,
                        width: 42,
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: ColoredBox(
                              color: CustomColors.primaryColor,
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    if(replayProvider.locationPoints.isEmpty){
                                      ToastMessageUtils().showToastMessage("No replay available");
                                    }else{
                                      Navigator.of(context).pushNamed(MarketingManagerConstants.replayPage);
                                      replayProvider.locationReplay();
                                    }
                                  },
                                  icon: Icon(FontAwesomeIcons.play),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void openAlertDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CustomColors.primaryWhite,
          elevation: 10,
          title: Consumer<ReplayProvider>(
            builder: (context, replayProvider, _) {
              return Center(
                child: Column(
                  children: [
                    CustomText(
                      text: "Select Map Type",
                      isSubHeading: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomRadioButton(
                      radioGroupValue: replayProvider.radioGroupValue,
                      radioValue: replayProvider.mapType[0],
                      radioTitle: 'Normal',
                      onChange: (value) {
                        replayProvider.setSelectLocationPointMapType(value);
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomRadioButton(
                      radioGroupValue: replayProvider.radioGroupValue,
                      radioValue: replayProvider.mapType[1],
                      radioTitle: 'Hybrid',
                      onChange: (value) {
                        replayProvider.setSelectLocationPointMapType(value);
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomRadioButton(
                      radioGroupValue: replayProvider.radioGroupValue,
                      radioValue: replayProvider.mapType[2],
                      radioTitle: 'Terrain',
                      onChange: (value) {
                        replayProvider.setSelectLocationPointMapType(value);
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      width: 1,
                      backgroundColor: CustomColors.primaryColor,
                      widget: CustomText(
                        text: "Done",
                        isContent: true,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
