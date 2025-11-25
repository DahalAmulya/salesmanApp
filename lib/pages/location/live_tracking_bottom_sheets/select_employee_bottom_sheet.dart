import 'package:deskgoo/providers/live_tracking_provider/live_tracking_provider.dart';
import 'package:deskgoo/providers/replay_provider/replay_provider.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/expansion_tile/custom_expansiontile.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../widgets/drop_downs/custom_dropdown.dart';
import '../../../widgets/text_fields/text_from_field.dart';

class SelectEmployeeBottomSheet {
  static void showBottomSheetForm(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.90,
        child: GestureDetector(
          onTap: () {
            // Dismiss the keyboard when tapping outside TextFormFields
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              FocusScope.of(context).unfocus();
            }
          },
          child: Scaffold(
            backgroundColor: CustomColors.primaryWhite,
            appBar: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              backgroundColor: CustomColors.primaryColor,
              title: CustomText(
                text: 'Select an Employee',
                size: 20.0,
                fontWeight: FontWeight.bold,
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  // clearMap();
                },
                icon: const FaIcon(FontAwesomeIcons.arrowLeft),
              ),
            ),
            body: Center(
              child: Consumer<LiveTrackingProvider>(
                  builder: (context, liveTrackingProvider, _) {
                return Consumer<ReplayProvider>(
                    builder: (context, _replayProvider, _) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 12.0,
                      ),
                      CustomExpansionTile(
                        initiallyExpanded: true,
                        applyAllBorderRadius: true,
                        title: 'Select User',
                        size: 20,
                        fontWeight: FontWeight.w600,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          CustomDropdown(
                            labelText: 'Select Date',
                            items: _replayProvider.visitDateTypeList,
                            value: _replayProvider.selectedVisitType,
                            onChanged: (value) {
                              _replayProvider.setSelectedVisitType(value);
                            },
                          ),
                          SizedBox(
                            height:
                                _replayProvider.selectedVisitType == 'Custom'
                                    ? 16
                                    : 0,
                          ),
                          if (_replayProvider.selectedVisitType == 'Custom')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextFromFieldWithPrefixSuffix(
                                    labelText: 'From',
                                    readOnly: true,
                                    controller: _replayProvider
                                        .fromTextEditingController,
                                    onTap: () {
                                      _replayProvider.selectDateFrom(context);
                                    },
                                    validator: (value) {
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextFromFieldWithPrefixSuffix(
                                    labelText: 'To',
                                    readOnly: true,
                                    controller:
                                        _replayProvider.toTextEditingController,
                                    onTap: () {
                                      _replayProvider.selectDateTo(context);
                                    },
                                    validator: (value) {
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Consumer<ReplayProvider>(
                          builder: (context, replayProvider, _) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount:
                                liveTrackingProvider.employeeLiveData.length,
                            itemBuilder: (context, index) {
                              String capitalize(String s) {
                                if (s.isEmpty) return s;
                                return s[0].toUpperCase() + s.substring(1);
                              }

                              String name = liveTrackingProvider
                                  .employeeLiveData[index]['username'];
                              String profileImage = liveTrackingProvider
                                  .employeeLiveData[index]['profileImage'];
                              return InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  print(liveTrackingProvider
                                      .employeeLiveData[index]['_id']);
                                  try {
                                    liveTrackingProvider.setSelectedImage(
                                        liveTrackingProvider.images[index]);
                                    replayProvider.cacheIcons(
                                        liveTrackingProvider.images[index],
                                        context);
                                  } catch (err) {
                                    liveTrackingProvider.setSelectedImage('');
                                    replayProvider.cacheIcons('', context);
                                  }
                                  print(liveTrackingProvider.selectedImg);
                                  print(
                                      '****************************************************************');
                                  print(
                                      'Locations = ${liveTrackingProvider.employeeLiveData[index]}');
                                  print(
                                      'LocationId = ${liveTrackingProvider.employeeLiveData[index]['_id']}');
                                  print(
                                      '****************************************************************');
                                  replayProvider.getEmployeeLocationById(
                                      liveTrackingProvider
                                          .employeeLiveData[index]['_id'],
                                      context);
                                  // Navigator.of(context).pushNamed(
                                  //     MarketingManagerConstants.replayPage);
                                  Navigator.of(context).pushNamed(
                                      MarketingManagerConstants.plotLocationHistory);
                                },
                                child: CustomContainer(
                                  width: 0.90,
                                  verticalPad: 8,
                                  verticalMargin: 4,
                                  horizontalMargin: 8,
                                  horizontalPad: 8,
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: SizedBox(
                                            height: 36,
                                            width: 36,
                                            child:
                                                // Image.asset(
                                                //   'assets/images/userLocation.png',
                                                //   fit: BoxFit.cover,
                                                // ),
                                                Image.network(
                                              profileImage,
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      CustomText(
                                        text: capitalize(name),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                // clearMap();
                              },
                              borderColor: CustomColors.lightRed,
                              widget: CustomText(
                                text: 'Cancel',
                                color: CustomColors.lightRed,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                });
              }),
            ),
          ),
        ),
      ),
    );
    // clearMap();
  }
}
