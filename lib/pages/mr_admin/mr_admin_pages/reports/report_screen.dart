import 'dart:async';
import 'dart:convert';

import 'package:deskgoo/consts.dart';
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
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../consts.dart';

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
    MrAdminVisitLogProvider mrAdminVisitLogProvider =
        Provider.of<MrAdminVisitLogProvider>(context, listen: false);
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
      child: Consumer<MrAdminVisitLogProvider>(
          builder: (context, mrAdminVisitLogProvider, _) {
        return CustomAppBar(
          tabName: 'Visit Report',
          centerTitle: true,
          automaticallyImplyLeading: true,
          showTrailingIcons: true,
          applyShadow: true,
          showApproveButton: true,
          onTapTrailingApproveIcon: () {
            mrAdminVisitLogProvider.updateVisitLogApprovals(context);
          },
          onTap: () {
            Navigator.of(context).pop(MarketingManagerConstants.homePage);
          },
        );
      }),
    );
  }

  Widget _buildI(context) {
    return Consumer<MrAdminVisitLogProvider>(
      builder: (context, adminVisitLogsProvider, _) {
        return ListView(
          children: [
            const SizedBox(
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
                          const SizedBox(
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
                          const SizedBox(
                            height: 16,
                          ),
                          CustomDropdown(
                            labelText: 'Select Date',
                            items: adminVisitLogsProvider.visitDateTypeList,
                            value: adminVisitLogsProvider.selectedVisitType,
                            onChanged: (value) {
                              adminVisitLogsProvider
                                  .setSelectedVisitDateType(value);
                            },
                          ),
                          SizedBox(
                            height: adminVisitLogsProvider.selectedVisitType ==
                                    'Custom'
                                ? 16
                                : 0,
                          ),
                          if (adminVisitLogsProvider.selectedVisitType ==
                              'Custom')
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
                                const SizedBox(
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
                          const SizedBox(
                            height: 16,
                          ),
                          CustomDropdown(
                            labelText: 'Select Visit Type',
                            items: adminVisitLogsProvider.visitType,
                            value: adminVisitLogsProvider.selectedVisitAddress,
                            onChanged: (value) {
                              adminVisitLogsProvider
                                  .setSelectedVisitType(value);
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          if (adminVisitLogsProvider.selectedVisitAddress ==
                              'Country')
                            Column(
                              children: [
                                CustomDropdown(
                                  labelText: 'Select Country',
                                  items: adminVisitLogsProvider.countryList,
                                  value: adminVisitLogsProvider.selectedCountry,
                                  applyCountryFlag: true,
                                  onChanged: (value) {
                                    adminVisitLogsProvider
                                        .setSelectedCountry(value);
                                  },
                                ),
                              ],
                            ),
                          if (adminVisitLogsProvider.selectedVisitAddress ==
                              'Region')
                            Column(
                              children: [
                                CustomDropdown(
                                  labelText: 'Country',
                                  items: adminVisitLogsProvider.countryList,
                                  value: adminVisitLogsProvider.selectedCountry,
                                  applyCountryFlag: true,
                                  onChanged: (newValue) {
                                    adminVisitLogsProvider
                                        .setSelectedCountry(newValue);
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFromFieldWithPrefixSuffix(
                                  controller: adminVisitLogsProvider
                                              .selectedCountry ==
                                          adminVisitLogsProvider.countryList[0]
                                      ? adminVisitLogsProvider
                                          .districtController
                                      : adminVisitLogsProvider.stateController,
                                  readOnly: true,
                                  labelText: adminVisitLogsProvider
                                              .selectedCountry ==
                                          adminVisitLogsProvider.countryList[0]
                                      ? 'Select District'
                                      : 'Select State',
                                  validator: (newValue) {},
                                  onTap: () async {
                                    String fileName = adminVisitLogsProvider
                                                .selectedCountry ==
                                            adminVisitLogsProvider
                                                .countryList[0]
                                        ? 'district'
                                        : 'states';
                                    final file = await rootBundle
                                        .loadString('assets/$fileName.json');
                                    final content = await jsonDecode(file);
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        useSafeArea: true,
                                        context: context,
                                        builder: (context) =>
                                            districtBottomSheet(
                                                context, '$fileName', content));
                                    adminVisitLogsProvider
                                        .searchController.text = '';
                                    adminVisitLogsProvider.searchAddressResult(
                                        adminVisitLogsProvider
                                            .searchController.value.text,
                                        content);
                                  },
                                ),
                              ],
                            ),
                          // Condition for City
                          if (adminVisitLogsProvider.selectedVisitAddress ==
                              'City')
                            Column(
                              children: [
                                CustomDropdown(
                                  labelText: 'Country',
                                  items: adminVisitLogsProvider.countryList,
                                  value: adminVisitLogsProvider.selectedCountry,
                                  applyCountryFlag: true,
                                  onChanged: (newValue) {
                                    adminVisitLogsProvider
                                        .setSelectedCountry(newValue);
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFromFieldWithPrefixSuffix(
                                  controller: adminVisitLogsProvider
                                              .selectedCountry ==
                                          adminVisitLogsProvider.countryList[0]
                                      ? adminVisitLogsProvider
                                          .districtController
                                      : adminVisitLogsProvider.stateController,
                                  readOnly: true,
                                  labelText: adminVisitLogsProvider
                                              .selectedCountry ==
                                          adminVisitLogsProvider.countryList[0]
                                      ? 'Select District *'
                                      : 'Select State *',
                                  validator: (newValue) {},
                                  onTap: () async {
                                    String fileName = adminVisitLogsProvider
                                                .selectedCountry ==
                                            adminVisitLogsProvider
                                                .countryList[0]
                                        ? 'district'
                                        : 'states';
                                    final file = await rootBundle
                                        .loadString('assets/$fileName.json');
                                    final content = await jsonDecode(file);
                                    print('Content = $content');
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        useSafeArea: true,
                                        context: context,
                                        builder: (context) =>
                                            districtBottomSheet(
                                                context, '$fileName', content));
                                    adminVisitLogsProvider
                                        .searchController.text = '';
                                    adminVisitLogsProvider.searchAddressResult(
                                        adminVisitLogsProvider
                                            .searchController.value.text,
                                        content);
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFromFieldWithPrefixSuffix(
                                  controller:
                                      adminVisitLogsProvider.cityController,
                                  readOnly: true,
                                  labelText: 'City *',
                                  validator: (newValue) {},
                                  onTap: () async {
                                    adminVisitLogsProvider
                                        .searchController.text = '';
                                    adminVisitLogsProvider.searchAddressResult(
                                        adminVisitLogsProvider
                                            .searchController.value.text,
                                        adminVisitLogsProvider.cities);
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        useSafeArea: true,
                                        context: context,
                                        builder: (context) => citiesBottomSheet(
                                            context,
                                            adminVisitLogsProvider.cities));
                                  },
                                ),
                              ],
                            ),
                          const SizedBox(
                            height: 16,
                          ),
                          CustomElevatedButton(
                            onPressed: () {
                              adminVisitLogsProvider.getVisitLogsById(context);
                              adminVisitLogsProvider.triggerAnimation();
                            },
                            width: 1,
                            height: 45,
                            backgroundColor: CustomColors.primaryColor,
                            widget: CustomText(
                              text: 'Submit',
                              isSubHeading: true,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                adminVisitLogsProvider.visitList.isNotEmpty
                    ? CustomContainer(
                        horizontalPad: 0,
                        verticalPad: 0,
                        color: Colors.transparent,
                        child: CustomExpansionTile(
                          title: 'Visit Log',
                          applyAllBorderRadius: true,
                          size: 20,
                          fontWeight: FontWeight.w600,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: CustomText(
                                        text: 'User',
                                        isContent: true,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: CustomText(
                                        text:
                                            adminVisitLogsProvider.selectedUser,
                                        isContent: true,
                                      ),
                                    ),
                                    // ClipRRect(
                                    //   borderRadius: BorderRadius.circular(1000),
                                    //   child: SizedBox(
                                    //     height: 52,
                                    //     width: 52,
                                    //     child: Image.network(
                                    //       adminVisitLogsProvider
                                    //           .profileImage,
                                    //       fit: BoxFit.cover,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: CustomText(
                                        text: 'Total Visit',
                                        isContent: true,
                                      ),
                                    ),
                                    // const SizedBox(width: 8),
                                    Expanded(
                                      flex: 2,
                                      child: CustomText(
                                        text: adminVisitLogsProvider
                                            .visitList.length
                                            .toString(),
                                        isContent: true,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: CustomText(
                                        isContent: true,
                                        text: adminVisitLogsProvider
                                                    .selectedVisitAddress ==
                                                'Country'
                                            ? 'Country'
                                            : (adminVisitLogsProvider
                                                        .selectedVisitAddress ==
                                                    'Region'
                                                ? 'Region'
                                                : 'City'),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: CustomText(
                                        text:
                                            adminVisitLogsProvider
                                                        .selectedVisitAddress ==
                                                    'Country'
                                                ? adminVisitLogsProvider
                                                    .selectedCountry
                                                : (adminVisitLogsProvider
                                                            .selectedVisitAddress ==
                                                        'City'
                                                    ? adminVisitLogsProvider
                                                        .selectedCities
                                                    : (adminVisitLogsProvider
                                                                .selectedVisitAddress ==
                                                            'Region'
                                                        ? adminVisitLogsProvider
                                                            .selectedDistrict
                                                        : adminVisitLogsProvider
                                                            .selectedState)),
                                        isContent: true,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: CustomText(
                                        text: 'From',
                                        isContent: true,
                                      ),
                                    ),
                                    // const SizedBox(width: 8),
                                    Expanded(
                                      flex: 2,
                                      child: CustomText(
                                        text: adminVisitLogsProvider.from,
                                        isContent: true,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: CustomText(
                                        text: 'To',
                                        isContent: true,
                                      ),
                                    ),
                                    // const SizedBox(width: 8),
                                    Expanded(
                                      flex: 2,
                                      child: CustomText(
                                        text: adminVisitLogsProvider.to,
                                        isContent: true,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CustomElevatedButton(
                                        onPressed: () {
                                          adminVisitLogsProvider.downloadVisitLogReport();
                                        },
                                        // width: 1,
                                        height: 45,
                                        backgroundColor: CustomColors.primaryColor,
                                        widget: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.download,
                                              color: CustomColors.primaryBlack,
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            CustomText(
                                              text: 'Download',
                                              isSubHeading: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8,),
                                    Expanded(
                                      child: CustomElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                              MarketingManagerConstants
                                                  .visitLogMapReportScreen);
                                        },
                                        width: 0.40,
                                        height: 45,
                                        backgroundColor: CustomColors.primaryColor,
                                        widget: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.mapLocation,
                                              color: CustomColors.primaryBlack,
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            CustomText(
                                              text: 'Map',
                                              isSubHeading: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            adminVisitLogsProvider.visitList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap:
                        true, // This allows it to take only the required height
                    physics:
                        const NeverScrollableScrollPhysics(), // Disables scrolling for outer ListView, so the inner ListViews can handle scrolling
                    itemCount: adminVisitLogsProvider.visitList.length,
                    itemBuilder: (context, index) {
                      // Color badgeColor = CustomColors.lightYellow;
                      String executiveName =
                          adminVisitLogsProvider.executiveName;
                      // String pocNumber = adminVisitLogsProvider.foundVisit['visitLogs']['pocNumber'];
                      String approvalStatus = adminVisitLogsProvider
                          .visitList[index]['approvalStatus'];
                      String pocName =
                          adminVisitLogsProvider.visitList[index]['pocName'];
                      String pocAddress =
                          adminVisitLogsProvider.visitList[index]['pocAddress'];
                      String pocNumber =
                          adminVisitLogsProvider.visitList[index]['pocNumber'];
                      String pocCategory = adminVisitLogsProvider
                          .visitList[index]['pocCategory'];
                      String pocSpecialization = adminVisitLogsProvider
                          .visitList[index]['pocSpecialization'];
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
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 400 + (index * 250)),
                        curve: Curves.easeInToLinear,
                        transform: Matrix4.translationValues(
                            adminVisitLogsProvider.myAnimation
                                ? 0
                                : adminVisitLogsProvider.width,
                            0,
                            0),
                        child: InkWell(
                          onTap: () {
                            print('Tapped $index');
                          },
                          child: Center(
                            child: Column(
                              children: [
                                CustomContainer(
                                  applyShadow: true,
                                  child: Badge(
                                    label: CustomText(
                                      text: '${index + 1}',
                                      isContent: true,
                                    ),
                                    backgroundColor:
                                        approvalStatus == 'approved'
                                            ? CustomColors.primaryColor
                                            : approvalStatus == 'pending'
                                                ? CustomColors.lightYellow
                                                : CustomColors.lightRed,
                                    // backgroundColor: adminVisitLogsProvider.badgeColor,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
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
                                                text: pocCategory,
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
                                                text: pocSpecialization,
                                                isContent: true,
                                                textOverflow:
                                                    TextOverflow.visible,
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
                                                textOverflow:
                                                    TextOverflow.visible,
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
                                                text: executiveName,
                                                isContent: true,
                                                textOverflow:
                                                    TextOverflow.visible,
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
                                                text: pocAddress,
                                                isContent: true,
                                                textOverflow:
                                                    TextOverflow.visible,
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
                                                text: 'Number',
                                                isContent: true,
                                              ),
                                            ),
                                            Expanded(
                                              child: CustomText(
                                                text: pocNumber,
                                                isContent: true,
                                                maxLines: 2,
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
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CustomText(
                                                text: 'Approval Status',
                                                isContent: true,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.45,
                                              child: CustomDropdown(
                                                labelText: '',
                                                items: adminVisitLogsProvider
                                                    .approvalType,
                                                value: approvalStatus,
                                                onChanged: (value) {
                                                  adminVisitLogsProvider
                                                      .approvalStatus(
                                                          index, value!);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Container(
                                //   width: MediaQuery.of(context).size.width * 0.85,
                                //   height: 180,
                                //   decoration: BoxDecoration(
                                //     // color: Colors.red,
                                //     borderRadius: const BorderRadius.only(
                                //       bottomLeft: Radius.circular(16),
                                //       bottomRight: Radius.circular(16),
                                //     ),
                                //     boxShadow: [
                                //       BoxShadow(
                                //         color: Colors.black.withOpacity(0.1),
                                //         spreadRadius: 2.0,
                                //         blurRadius: 1.0,
                                //         offset: const Offset(3, 3),
                                //       )
                                //     ],
                                //   ),
                                //   child: ClipRRect(
                                //     borderRadius: const BorderRadius.only(
                                //       bottomLeft: Radius.circular(16),
                                //       bottomRight: Radius.circular(16),
                                //     ),
                                //     child: GoogleMap(
                                //       initialCameraPosition: const CameraPosition(
                                //         target: LatLng(26.453046355563462,
                                //             87.27468530596374),
                                //         zoom: 13,
                                //       ),
                                //       compassEnabled: true,
                                //       zoomControlsEnabled: true,
                                //       onMapCreated:
                                //           (GoogleMapController controller) {
                                //         _controller.complete(controller);
                                //       },
                                //       markers: {
                                //         Marker(
                                //           markerId: MarkerId(index.toString()),
                                //           position: LatLng(latitude, longitude),
                                //         ),
                                //       },
                                //     ),
                                //   ),
                                // ),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
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

  Widget citiesBottomSheet(context, List<dynamic> content) {
    return Consumer<MrAdminVisitLogProvider>(
      builder: (context, adminVisitLogsProvider, _) {
        return Container(
          color: CustomColors.primaryWhite,
          height: MediaQuery.of(context).size.height * 0.80,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 16,
                  right: 12.0,
                  bottom: 12,
                ),
                decoration: BoxDecoration(
                  color: CustomColors.primaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                          onTap: () {
                            print('Pressed');
                            Navigator.pop(context);
                          },
                          child: Icon(FontAwesomeIcons.arrowLeft)),
                    ),
                    // ),
                    Expanded(
                      flex: 7,
                      child: TextFromFieldWithPrefixSuffix(
                        controller: adminVisitLogsProvider.searchController,
                        labelText: 'Search City',
                        applySuffixIcon: true,
                        suffixIcon: Icon(Icons.search),
                        validator: (value) {},
                        onChange: (value) =>
                            adminVisitLogsProvider.searchAddressResult(
                                adminVisitLogsProvider
                                    .searchController.value.text,
                                content),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: adminVisitLogsProvider.searchResult.length,
                  itemBuilder: (context, index) {
                    String cityName =
                        adminVisitLogsProvider.searchResult[index];
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        adminVisitLogsProvider.setSelectedCity(cityName);
                        print(adminVisitLogsProvider.searchResult[index]);
                      },
                      title: CustomText(
                        text: cityName,
                        isContent: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget districtBottomSheet(context, String type, List<dynamic> content) {
    return Consumer<MrAdminVisitLogProvider>(
      builder: (context, mrAdminVisitLogProvider, _) {
        return Container(
          color: CustomColors.primaryWhite,
          height: MediaQuery.of(context).size.height * 0.80,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 16,
                  right: 12.0,
                  bottom: 12,
                ),
                decoration: BoxDecoration(
                  color: CustomColors.primaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                          onTap: () {
                            print('Pressed');
                            Navigator.pop(context);
                          },
                          child: Icon(FontAwesomeIcons.arrowLeft)),
                    ),
                    // ),
                    Expanded(
                      flex: 7,
                      child: TextFromFieldWithPrefixSuffix(
                        controller: mrAdminVisitLogProvider.searchController,
                        labelText:
                            mrAdminVisitLogProvider.selectedCountry == 'Nepal'
                                ? 'Search District'
                                : 'Search State',
                        applySuffixIcon: true,
                        suffixIcon: Icon(Icons.search),
                        validator: (value) {},
                        onChange: (value) =>
                            mrAdminVisitLogProvider.searchAddressResult(
                                mrAdminVisitLogProvider
                                    .searchController.value.text,
                                content),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: mrAdminVisitLogProvider.searchResult.length,
                  itemBuilder: (context, index) {
                    String name =
                        mrAdminVisitLogProvider.searchResult[index]['$type'];
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        type == 'district'
                            ? mrAdminVisitLogProvider.setSelectedDistrict(name)
                            : mrAdminVisitLogProvider.setSelectedState(name);
                        mrAdminVisitLogProvider.getCities(
                            mrAdminVisitLogProvider.searchResult[index]
                                ['cities']);
                      },
                      title: CustomText(
                        text: name,
                        isContent: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
