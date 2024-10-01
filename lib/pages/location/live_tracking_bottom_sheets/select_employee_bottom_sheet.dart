import 'package:deskgoo/providers/live_tracking_provider/live_tracking_provider.dart';
import 'package:deskgoo/providers/replay_provider/replay_provider.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/text_fields/text_from_field.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SelectEmployeeBottomSheet {
  static void showBottomSheetForm(context) {
    ReplayProvider _replayProvider =
        Provider.of<ReplayProvider>(context, listen: false);
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
                icon: FaIcon(FontAwesomeIcons.arrowLeft),
              ),
            ),
            body: Center(
              child: Consumer<LiveTrackingProvider>(
                  builder: (context, liveTrackingProvider, _) {
                return Column(
                  children: [
                    // TextFromFieldWithPrefixSuffix(
                    //   autoFocus: true,
                    //   controller: liveTrackingProvider.searchController,
                    //   validator: (String? value) {
                    //     return null;
                    //   },
                    //   applyPrefix: true,
                    //   prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass),
                    // ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: liveTrackingProvider.employeeLiveData.length,
                        itemBuilder: (context, index) {
                          String capitalize(String s) {
                            if (s.isEmpty) return s;
                            return s[0].toUpperCase() + s.substring(1);
                          }

                          String name = liveTrackingProvider
                              .employeeLiveData[index]['employee_name'];
                          return InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              print(liveTrackingProvider.employeeLiveData[index]
                                  ['mobile_id']);
                              liveTrackingProvider.setSelectedImage(
                                  liveTrackingProvider.images[index]);
                              _replayProvider.cacheIcons(
                                  liveTrackingProvider.images[index]);
                              print(liveTrackingProvider.selecetedImg);
                              _replayProvider.getEmployeeLocationById(
                                  liveTrackingProvider.employeeLiveData[index]
                                      ['mobile_id']);
                              Navigator.of(context).pushNamed(
                                  RouteGeneratorConstants.replayPage);
                            },
                            child: CustomContainer(
                              width: 0.90,
                              verticalPad: 8,
                              verticalMargin: 4,
                              horizontalMargin: 8,
                              horizontalPad: 8,
                              child: CustomText(
                                text: capitalize(name),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
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
                        // CustomElevatedButton(
                        //   onPressed: () {
                        //     // if (_formKey.currentState!.validate()) {
                        //     //   postGeofence();
                        //     //   if (isPostSuccess) {
                        //     //     Navigator.pop(context);
                        //     //     getGeofenceList();
                        //     //   }
                        //     // } else {
                        //     //   print('False');
                        //     // }
                        //   },
                        //   borderColor: CustomColors.primaryColor,
                        //   widget: CustomText(
                        //     text: 'Create',
                        //     color: CustomColors.primaryBlack,
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
    // clearMap();
  }
}
