import 'dart:async';

import 'package:deskgoo/providers/mr_admin_provider/mr_admin_visit_logProvider.dart';
import 'package:deskgoo/routes/route_generator_constants.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/widgets/app_bars/custom_app_bars.dart';
import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/drop_downs/custom_dropdown.dart';
import 'package:deskgoo/widgets/expansion_tile/custom_expansiontile.dart';
import 'package:deskgoo/widgets/text_fields/text_from_field.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MrAdminReportScreen extends StatefulWidget {
  const MrAdminReportScreen({super.key});

  @override
  State<MrAdminReportScreen> createState() => _MrAdminReportScreenState();
}

class _MrAdminReportScreenState extends State<MrAdminReportScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    MrAdminVisitLogProvider mrAdminVisitLogProvider = Provider.of<MrAdminVisitLogProvider>(context, listen: false);
    mrAdminVisitLogProvider.getVisitLogsList(context);
  }

  Future<void> _moveCamera(double latitude, double longitude) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            latitude,
            longitude,
          ),
          zoom: 13,
        ),
      ),
    );
  }

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
          backgroundColor: CustomColors.primaryWhite,
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
        tabName: 'Visit Log Report',
        centerTitle: true,
        automaticallyImplyLeading: true,
        onTap: () {
          Navigator.of(context).pop(MarketingManagerConstants.homePage);
        },
      ),
    );
  }

  Widget _buildI(context) {
    return Consumer<MrAdminVisitLogProvider>(
      builder: (context, adminVisitLogsProvider, _) {
        return ListView(
          children: [
            SizedBox(
              height: 16,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomContainer(
                  horizontalPad: 0,
                  verticalPad: 0,
                  color: Colors.transparent,
                  child: CustomExpansionTile(
                    initiallyExpanded: true,
                    applyAllBorderRadius: true,
                    title: 'Select User',
                    size: 20,
                    fontWeight: FontWeight.w600,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 16,
                          ),
                          CustomDropdown(
                            labelText: 'Select User',
                            items: adminVisitLogsProvider.visitLogsUserList,
                            value: adminVisitLogsProvider.selectedUser,
                            onChanged: (value) {
                              adminVisitLogsProvider.setSelectedUser(value);
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          CustomDropdown(
                            labelText: 'Select Date',
                            items: adminVisitLogsProvider.visitDateTypeList,
                            value: adminVisitLogsProvider.selectedVisitType,
                            onChanged: (value) {
                              adminVisitLogsProvider
                                  .setSelectedVisitType(value);
                            },
                          ),
                          SizedBox(
                            height: adminVisitLogsProvider.selectedVisitType == 'Custom' ? 16 : 0,
                          ),
                          if (adminVisitLogsProvider.selectedVisitType == 'Custom')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextFromFieldWithPrefixSuffix(
                                    labelText: 'From',
                                    readOnly: true,
                                    controller: adminVisitLogsProvider
                                        .fromTextEditingController,
                                    onTap: () {
                                      adminVisitLogsProvider
                                          .selectDateFrom(context);
                                    },
                                    validator: (value) {},
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextFromFieldWithPrefixSuffix(
                                    labelText: 'To',
                                    readOnly: true,
                                    controller: adminVisitLogsProvider
                                        .toTextEditingController,
                                    onTap: () {
                                      adminVisitLogsProvider
                                          .selectDateTo(context);
                                    },
                                    validator: (value) {},
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(
                            height: 16,
                          ),
                          CustomElevatedButton(
                            onPressed: () {
                              adminVisitLogsProvider.getVisitLogsById(context);
                            },
                            width: 0.90,
                            height: 50,
                            backgroundColor: CustomColors.primaryColor,
                            widget: CustomText(
                              text: 'Submit',
                              fontWeight: FontWeight.w600,
                              color: CustomColors.primaryBlack,
                              size: 20.0,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            adminVisitLogsProvider.visitList.length != 0
                ? ListView.builder(
                    shrinkWrap:
                        true, // This allows it to take only the required height
                    physics:
                        NeverScrollableScrollPhysics(), // Disables scrolling for outer ListView, so the inner ListViews can handle scrolling
                    itemCount: adminVisitLogsProvider.visitList.length,
                    itemBuilder: (context, index) {
                      String pocName =
                          adminVisitLogsProvider.visitList[index]['pocName'];
                      String remarks =
                          adminVisitLogsProvider.visitList[index]['remarks'];
                      String visitType =
                          adminVisitLogsProvider.visitList[index]['visitType'];
                      String mobileTime =
                          adminVisitLogsProvider.visitList[index]['mobileTime'];
                      double latitude =
                          adminVisitLogsProvider.visitList[index]['latitude'];
                      double longitude =
                          adminVisitLogsProvider.visitList[index]['longitude'];
                      _moveCamera(latitude, longitude);
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: CustomText(
                                            text: 'Date',
                                            isContent: true,
                                          ),
                                        ),
                                        Expanded(
                                          child: CustomText(
                                            text: mobileTime,
                                            isContent: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: CustomText(
                                            text: 'POC',
                                            isContent: true,
                                          ),
                                        ),
                                        Expanded(
                                          child: CustomText(
                                            text: pocName,
                                            isContent: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: CustomText(
                                            text: 'Visit Type',
                                            isContent: true,
                                          ),
                                        ),
                                        Expanded(
                                          child: CustomText(
                                            text: visitType,
                                            isContent: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: CustomText(
                                            text: 'Remarks',
                                            isContent: true,
                                          ),
                                        ),
                                        Expanded(
                                          child: CustomText(
                                            text: remarks,
                                            isContent: true,
                                            textOverflow: TextOverflow.visible,
                                            maxLines: 3,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                  borderRadius: const BorderRadius.only(
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
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                  child: GoogleMap(
                                    initialCameraPosition: const CameraPosition(
                                      target: LatLng(26.453046355563462,
                                          87.27468530596374),
                                      zoom: 13,
                                    ),
                                    compassEnabled: true,
                                    zoomControlsEnabled: false,
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      _controller.complete(controller);
                                    },
                                    markers: {
                                      Marker(
                                        markerId: MarkerId('1'),
                                        position: LatLng(latitude, longitude),
                                      ),
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 64.0),
                      child: CustomText(
                        text: 'No visit log found',
                        isSubHeading: true,
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }
}
