import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drop_downs/custom_dropdown.dart';
import 'package:deskgoo/widgets/expansion_tile/custom_expansiontile.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MrAdminReportScreen extends StatefulWidget {
  const MrAdminReportScreen({super.key});

  @override
  State<MrAdminReportScreen> createState() => _MrAdminReportScreenState();
}

class _MrAdminReportScreenState extends State<MrAdminReportScreen> {
  List<String> filterBy = [
    'Area-wise',
    'Coverage-wise',
    'Officer-wise',
    'visit-wise',
  ];
  String selectedFilter = '';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        Navigator.of(context).pop(MarketingManagerConstants.homePage);
      }),
      child: GestureDetector(
        onTap: () {
          // Dismiss the keyboard when tapping outside TextFormFields
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            FocusScope.of(context).unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          appBar: _appBar(context),
          body: _buildI(context),
        ),
      ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        tabName: 'Report',
        centerTitle: true,
        automaticallyImplyLeading: true,
        onTap: () {
          Navigator.of(context).pop(MarketingManagerConstants.homePage);
        },
      ),
    );
  }

  Widget _buildI(context) {
    selectedFilter = filterBy[0];
    return ListView(
      // scrollDirection: ,
      children: [
        SizedBox(
          height: 16,
        ),
        ListView.builder(
          shrinkWrap: true, // This allows it to take only the required height
          physics:
              NeverScrollableScrollPhysics(), // Disables scrolling for outer ListView, so the inner ListViews can handle scrolling
          itemCount: 4,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                print('Tapped $index');
              },
              child: Center(
                child: Column(
                  children: [
                    CustomContainer(
                      applyShadow: true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomText(
                                  text: 'Date',
                                  isContent: true,
                                ),
                              ),
                              Expanded(
                                child: CustomText(
                                  text: '6/25/2024 18:10',
                                  isContent: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomText(
                                  text: 'POC',
                                  isContent: true,
                                ),
                              ),
                              Expanded(
                                child: CustomText(
                                  text: 'Dr. B.N Khatiwada',
                                  isContent: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomText(
                                  text: 'Visit Type',
                                  isContent: true,
                                ),
                              ),
                              Expanded(
                                child: CustomText(
                                  text: 'Old',
                                  isContent: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomText(
                                  text: 'Category',
                                  isContent: true,
                                ),
                              ),
                              Expanded(
                                child: CustomText(
                                  text: 'Doctor',
                                  isContent: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomText(
                                  text: 'Specialization',
                                  isContent: true,
                                ),
                              ),
                              Expanded(
                                child: CustomText(
                                  text: 'Cardiologist',
                                  isContent: true,
                                  textOverflow: TextOverflow.visible,
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomText(
                                  text: 'Area',
                                  isContent: true,
                                ),
                              ),
                              Expanded(
                                child: CustomText(
                                  text: 'East',
                                  isContent: true,
                                  textOverflow: TextOverflow.visible,
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomText(
                                  text: 'City',
                                  isContent: true,
                                ),
                              ),
                              Expanded(
                                child: CustomText(
                                  text: 'Damak',
                                  isContent: true,
                                  textOverflow: TextOverflow.visible,
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomText(
                                  text: 'Address',
                                  isContent: true,
                                ),
                              ),
                              Expanded(
                                child: CustomText(
                                  text: 'Damak',
                                  isContent: true,
                                  textOverflow: TextOverflow.visible,
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomText(
                                  text: 'Remarks',
                                  isContent: true,
                                ),
                              ),
                              Expanded(
                                child: CustomText(
                                  text: 'All Good!',
                                  isContent: true,
                                  textOverflow: TextOverflow.visible,
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomText(
                                  text: 'Executive',
                                  isContent: true,
                                ),
                              ),
                              Expanded(
                                child: CustomText(
                                  text: 'Munna Rajbanshi',
                                  isContent: true,
                                  textOverflow: TextOverflow.visible,
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: 180,
                        decoration: BoxDecoration(
                          // color: Colors.red,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2.0,
                              blurRadius: 1.0,
                              offset: const Offset(3, 3),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          child: GoogleMap(
                            initialCameraPosition: const CameraPosition(
                              target: LatLng(26.6612808, 87.6765751),
                              zoom: 13,
                            ),
                            markers: {
                              Marker(
                                markerId: MarkerId('1'),
                                position: LatLng(26.6612808, 87.6765751),
                              ),
                            },
                          ),
                        )),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            );
          },
        )
        // Center(
        //   child: CustomContainer(
        //     color: Colors.transparent,
        //     horizontalPad: 0,
        //     verticalPad: 0,
        //     verticalMargin: 8,
        //     child: CustomExpansionTile(
        //       initiallyExpanded: true,
        //       applyShadow: true,
        //       applyAllBorderRadius: true,
        //       title: 'Area-Wise Summary',
        //       children: [
        //         // CustomText(
        //         //   text: 'Marking Officers',
        //         //   isSubHeading: true,
        //         // ),
        //         SizedBox(
        //           height: 8,
        //         ),
        //         CustomDropdown(
        //           labelText: 'Filter by',
        //           items: filterBy,
        //           value: selectedFilter,
        //           onChanged: (newValue) {
        //             setState(() {
        //               selectedFilter = newValue!;
        //             });
        //           },
        //         ),
        //         SizedBox(
        //           height: 16,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // Center(
        //   child: CustomContainer(
        //     color: Colors.transparent,
        //     horizontalPad: 0,
        //     verticalPad: 0,
        //     verticalMargin: 8,
        //     child: CustomExpansionTile(
        //       initiallyExpanded: false,
        //       applyShadow: true,
        //       applyTopBorderRadius: true,
        //       title: 'Area-Wise Coverage',
        //       children: [
        //         // CustomText(
        //         //   text: 'Marking Officers',
        //         //   isSubHeading: true,
        //         // ),
        //         SizedBox(
        //           height: 8,
        //         ),
        //         CustomDropdown(
        //           labelText: 'Filter by',
        //           items: filterBy,
        //           value: selectedFilter,
        //           onChanged: (newValue) {
        //             setState(() {
        //               selectedFilter = newValue!;
        //             });
        //           },
        //         ),
        //         SizedBox(
        //           height: 16,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // Center(
        //   child: CustomContainer(
        //     color: Colors.transparent,
        //     horizontalPad: 0,
        //     verticalPad: 0,
        //     verticalMargin: 8,
        //     child: CustomExpansionTile(
        //       initiallyExpanded: false,
        //       applyShadow: true,
        //       radiusTopLeft: 16,
        //       radiusTopRight: 16,
        //       radiusBottomLeft: 16,
        //       radiusBottomRight: 16,
        //       title: 'Officer-wise Summary',
        //       children: [
        //         // CustomText(
        //         //   text: 'Marking Officers',
        //         //   isSubHeading: true,
        //         // ),
        //         SizedBox(
        //           height: 8,
        //         ),
        //         CustomDropdown(
        //           labelText: 'Filter by',
        //           items: filterBy,
        //           value: selectedFilter,
        //           onChanged: (newValue) {
        //             setState(() {
        //               selectedFilter = newValue!;
        //             });
        //           },
        //         ),
        //         SizedBox(
        //           height: 16,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // Center(
        //   child: CustomContainer(
        //     color: Colors.transparent,
        //     horizontalPad: 0,
        //     verticalPad: 0,
        //     verticalMargin: 8,
        //     child: CustomExpansionTile(
        //       initiallyExpanded: false,
        //       applyShadow: true,
        //       radiusTopLeft: 16,
        //       radiusTopRight: 16,
        //       radiusBottomLeft: 16,
        //       radiusBottomRight: 16,
        //       title: 'Visit-wise Summary',
        //       children: [
        //         // CustomText(
        //         //   text: 'Marking Officers',
        //         //   isSubHeading: true,
        //         // ),
        //         SizedBox(
        //           height: 8,
        //         ),
        //         CustomDropdown(
        //           labelText: 'Filter by',
        //           items: filterBy,
        //           value: selectedFilter,
        //           onChanged: (newValue) {
        //             setState(() {
        //               selectedFilter = newValue!;
        //             });
        //           },
        //         ),
        //         SizedBox(
        //           height: 16,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
