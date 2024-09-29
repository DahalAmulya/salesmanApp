import 'package:deskgoo/providers/live_tracking_provider/live_tracking_provider.dart';
import 'package:deskgoo/providers/replay_provider/replay_provider.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
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
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2.0,
                      blurRadius: 10.0,
                      offset: const Offset(3, 3),
                    )
                  ],
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
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
                      // const SizedBox(
                      //   height: 12.0,
                      // ),
                      Expanded(
                        child: ListView.builder(
                          itemCount:
                              liveTrackingProvider.employeeLiveData.length,
                          itemBuilder: (context, index) {
                            String capitalize(String s) {
                              if (s.isEmpty) return s;
                              return s[0].toUpperCase() + s.substring(1);
                            }

                            String name = liveTrackingProvider
                                .employeeLiveData[index]['employee_name'];
                            return ListTile(
                              title: CustomText(
                                text: capitalize(name),
                                fontWeight: FontWeight.w500,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                print(liveTrackingProvider
                                    .employeeLiveData[index]['mobile_id']);
                                // _replayProvider.setEmployeeId(
                                //     liveTrackingProvider.employeeLiveData[index]
                                //         ['mobile_id']);
                                // print(_replayProvider.employee_id);
                                // print(liveTrackingProvider.empl);
                                // liveTrackingProvider.
                                _replayProvider.getEmployeeLocationById(
                                    liveTrackingProvider.employeeLiveData[index]
                                        ['mobile_id']);
                                Navigator.of(context).pushNamed(
                                    RouteGeneratorConstants.replayPage);
                              },
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
                              color: CustomColors.primaryBlack,
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
      ),
    );
    // clearMap();
  }
}
