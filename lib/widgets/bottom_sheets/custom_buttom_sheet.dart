import 'package:deskgoo/providers/live_tracking_provider/live_tracking_provider.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/text_fields/text_from_field.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CustomBottomSheet {
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
                text: 'Search Employee Location',
                size: 22.0,
                fontWeight: FontWeight.bold,
              ),
              leading: Consumer<LiveTrackingProvider>(
                  builder: (context, liveTrackingProvider, _) {
                return IconButton(
                  onPressed: () {
                    liveTrackingProvider.clearEmployeeSearchField();
                    Navigator.pop(context);
                    // clearMap();
                  },
                  icon: FaIcon(FontAwesomeIcons.arrowLeft),
                );
              }),
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
                      TextFromFieldWithPrefixSuffix(
                        autoFocus: true,
                        controller: liveTrackingProvider.searchController,
                        validator: (String? value) {
                          return null;
                        },
                        onChange: (value) => liveTrackingProvider
                            .runSearchEmployeeLiveLocationFilter(
                                liveTrackingProvider
                                    .searchController.value.text),
                        applyPrefix: true,
                        prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount:
                              liveTrackingProvider.employeeSearchResults.length,
                          itemBuilder: (context, index) {
                            String capitalize(String s) {
                              if (s.isEmpty) return s;
                              return s[0].toUpperCase() + s.substring(1);
                            }

                            String image = liveTrackingProvider.images[index];
                            String name = liveTrackingProvider
                                .employeeSearchResults[index]['username'];
                            print(liveTrackingProvider
                                .employeeSearchResults[index]);
                            return ListTile(
                              onTap: () {
                                print(liveTrackingProvider
                                        .employeeSearchResults[index]
                                    ['latestLocation']['latitude']);
                                print(liveTrackingProvider
                                        .employeeSearchResults[index]
                                    ['latestLocation']['longitude']);
                                double? lat = liveTrackingProvider
                                        .employeeSearchResults[index]
                                    ['latestLocation']['latitude'];
                                double? long = liveTrackingProvider
                                        .employeeSearchResults[index]
                                    ['latestLocation']['longitude'];
                                liveTrackingProvider.setSelectedEmpLatLong(
                                    lat, long);
                                liveTrackingProvider.clearEmployeeSearchField();
                                Navigator.pop(context);
                              },
                              title: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: SizedBox(
                                      height: 36,
                                      width: 36,
                                      child: Image.asset(
                                        image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  CustomText(
                                    text: capitalize(name),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     CustomElevatedButton(
                      //       onPressed: () {
                      //         Navigator.pop(context);
                      //         // clearMap();
                      //       },
                      //       // borderColor: CustomColors.red,
                      //       widget: CustomText(
                      //         text: 'Cancel',
                      //         // textColor: CustomColors.,
                      //       ),
                      //     ),
                      //     CustomElevatedButton(
                      //       onPressed: () {
                      //         // if (_formKey.currentState!.validate()) {
                      //         //   postGeofence();
                      //         //   if (isPostSuccess) {
                      //         //     Navigator.pop(context);
                      //         //     getGeofenceList();
                      //         //   }
                      //         // } else {
                      //         //   print('False');
                      //         // }
                      //       },
                      //       borderColor: CustomColors.primaryColor,
                      //       widget: CustomText(
                      //         text: 'Create',
                      //         color: CustomColors.primaryColor,
                      //       ),
                      //     ),
                      //   ],
                      // ),
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
