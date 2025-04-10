import 'dart:convert';

import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/expansion_tile/custom_expansiontile.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../../routes/route_generator_constants.dart';
import '../../../../../themes/custom_colors.dart';
import '../../../../../widgets/app_bars/custom_app_bars.dart';
import '../../../../../widgets/buttons/elevated_button.dart';
import '../../../../../widgets/drop_downs/custom_dropdown.dart';
import '../../../../../widgets/text_fields/text_from_field.dart';
import '../../../mr_admin_providers/mr_admin_ambulancereport_provider.dart';

class MrAdminAmbulanceReportScreen extends StatefulWidget {
  const MrAdminAmbulanceReportScreen({super.key});

  @override
  State<MrAdminAmbulanceReportScreen> createState() =>
      _AmbulanceReportScreenState();
}

class _AmbulanceReportScreenState extends State<MrAdminAmbulanceReportScreen> {
  bool myAnimation = false;
  double width = 0;

  @override
  void initState() {
    MrAdminAmbulanceReportProvider mrAdminAmbulanceReportProvider =
        Provider.of<MrAdminAmbulanceReportProvider>(context, listen: false);
    mrAdminAmbulanceReportProvider.getAmbulanceLogList(context);
    mrAdminAmbulanceReportProvider.getDataForDistrict();
    mrAdminAmbulanceReportProvider.getDataForState();
    super.initState();
  }

  void _triggerAnimation() {
    setState(() {
      myAnimation = false;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        myAnimation = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryWhite,
      appBar: _appBar(context),
      body: _body(context),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        tabName: 'Ambulance Report',
        centerTitle: true,
        automaticallyImplyLeading: true,
        onTap: () {
          Navigator.of(context).pop(MarketingManagerConstants.homePage);
        },
      ),
    );
  }

  Widget _body(context) {
    return Consumer<MrAdminAmbulanceReportProvider>(
        builder: (context, mrAdminAmbulanceReportProvider, _) {
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
                    size: 20,
                    fontWeight: FontWeight.w600,
                    title: 'Select User',
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          CustomDropdown(
                            labelText: 'Select User',
                            items: mrAdminAmbulanceReportProvider
                                .ambulanceLogsUsersList,
                            value: mrAdminAmbulanceReportProvider.selectedUser,
                            onChanged: (value) {
                              mrAdminAmbulanceReportProvider
                                  .setSelectedUser(value);
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          CustomDropdown(
                            labelText: 'Select Date',
                            items: mrAdminAmbulanceReportProvider
                                .ambulanceReportDateTypeList,
                            value: mrAdminAmbulanceReportProvider
                                .selectedAmbulanceReportDateType,
                            onChanged: (value) {
                              mrAdminAmbulanceReportProvider
                                  .setSelectedAmbulanceVisitType(value);
                            },
                          ),
                          SizedBox(
                            height: mrAdminAmbulanceReportProvider
                                        .selectedAmbulanceReportDateType ==
                                    mrAdminAmbulanceReportProvider
                                        .ambulanceReportDateTypeList[2]
                                ? 16
                                : 0,
                          ),
                          if (mrAdminAmbulanceReportProvider
                                  .selectedAmbulanceReportDateType ==
                              'Custom')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextFromFieldWithPrefixSuffix(
                                    labelText: 'From',
                                    readOnly: true,
                                    controller: mrAdminAmbulanceReportProvider
                                        .fromTextEditingController,
                                    onTap: () {
                                      mrAdminAmbulanceReportProvider
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
                                    controller: mrAdminAmbulanceReportProvider
                                        .toTextEditingController,
                                    onTap: () {
                                      mrAdminAmbulanceReportProvider
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
                            labelText: 'Select Ambulance Referral Type',
                            items: mrAdminAmbulanceReportProvider
                                .ambulanceReferralType,
                            value: mrAdminAmbulanceReportProvider
                                .selectedAmbulanceReferralType,
                            onChanged: (value) {
                              mrAdminAmbulanceReportProvider
                                  .setSelectedAmbulanceReferralType(value);
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          if (mrAdminAmbulanceReportProvider
                                  .selectedAmbulanceReferralType ==
                              'Country')
                            Column(
                              children: [
                                CustomDropdown(
                                  labelText: 'Select Country',
                                  items: mrAdminAmbulanceReportProvider
                                      .countryList,
                                  value: mrAdminAmbulanceReportProvider
                                      .selectedCountry,
                                  applyCountryFlag: true,
                                  onChanged: (value) {
                                    mrAdminAmbulanceReportProvider
                                        .setSelectedCountry(value);
                                  },
                                ),
                              ],
                            ),
                          if (mrAdminAmbulanceReportProvider
                                  .selectedAmbulanceReferralType ==
                              'Region')
                            Column(
                              children: [
                                CustomDropdown(
                                  labelText: 'Country',
                                  items: mrAdminAmbulanceReportProvider
                                      .countryList,
                                  value: mrAdminAmbulanceReportProvider
                                      .selectedCountry,
                                  applyCountryFlag: true,
                                  onChanged: (newValue) {
                                    mrAdminAmbulanceReportProvider
                                        .setSelectedCountry(newValue);
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFromFieldWithPrefixSuffix(
                                  controller: mrAdminAmbulanceReportProvider
                                              .selectedCountry ==
                                          mrAdminAmbulanceReportProvider
                                              .countryList[0]
                                      ? mrAdminAmbulanceReportProvider
                                          .districtController
                                      : mrAdminAmbulanceReportProvider
                                          .stateController,
                                  readOnly: true,
                                  labelText: mrAdminAmbulanceReportProvider
                                              .selectedCountry ==
                                          mrAdminAmbulanceReportProvider
                                              .countryList[0]
                                      ? 'District *'
                                      : 'State *',
                                  validator: (newValue) {},
                                  onTap: () async {
                                    String fileName =
                                        mrAdminAmbulanceReportProvider
                                                    .selectedCountry ==
                                                mrAdminAmbulanceReportProvider
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
                                    mrAdminAmbulanceReportProvider
                                        .searchController.text = '';
                                    mrAdminAmbulanceReportProvider
                                        .searchAddressResult(
                                            mrAdminAmbulanceReportProvider
                                                .searchController.value.text,
                                            content);
                                  },
                                ),
                              ],
                            ),
                          if (mrAdminAmbulanceReportProvider
                                  .selectedAmbulanceReferralType ==
                              'City')
                            Column(
                              children: [
                                CustomDropdown(
                                  labelText: 'Country',
                                  items: mrAdminAmbulanceReportProvider
                                      .countryList,
                                  value: mrAdminAmbulanceReportProvider
                                      .selectedCountry,
                                  applyCountryFlag: true,
                                  onChanged: (newValue) {
                                    mrAdminAmbulanceReportProvider
                                        .setSelectedCountry(newValue);
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFromFieldWithPrefixSuffix(
                                  controller: mrAdminAmbulanceReportProvider
                                              .selectedCountry ==
                                          mrAdminAmbulanceReportProvider
                                              .countryList[0]
                                      ? mrAdminAmbulanceReportProvider
                                          .districtController
                                      : mrAdminAmbulanceReportProvider
                                          .stateController,
                                  readOnly: true,
                                  labelText: mrAdminAmbulanceReportProvider
                                              .selectedCountry ==
                                          mrAdminAmbulanceReportProvider
                                              .countryList[0]
                                      ? 'District *'
                                      : 'State *',
                                  validator: (newValue) {},
                                  onTap: () async {
                                    String fileName =
                                        mrAdminAmbulanceReportProvider
                                                    .selectedCountry ==
                                                mrAdminAmbulanceReportProvider
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
                                    mrAdminAmbulanceReportProvider
                                        .searchController.text = '';
                                    mrAdminAmbulanceReportProvider
                                        .searchAddressResult(
                                            mrAdminAmbulanceReportProvider
                                                .searchController.value.text,
                                            content);
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFromFieldWithPrefixSuffix(
                                  controller: mrAdminAmbulanceReportProvider
                                      .cityController,
                                  readOnly: true,
                                  labelText: 'City *',
                                  validator: (newValue) {},
                                  onTap: () async {
                                    mrAdminAmbulanceReportProvider
                                        .searchController.text = '';
                                    mrAdminAmbulanceReportProvider
                                        .searchAddressResult(
                                            mrAdminAmbulanceReportProvider
                                                .searchController.value.text,
                                            mrAdminAmbulanceReportProvider
                                                .cities);
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        useSafeArea: true,
                                        context: context,
                                        builder: (context) => citiesBottomSheet(
                                            context,
                                            mrAdminAmbulanceReportProvider
                                                .cities));
                                  },
                                ),
                              ],
                            ),
                          const SizedBox(
                            height: 16,
                          ),
                          CustomElevatedButton(
                            onPressed: () {
                              mrAdminAmbulanceReportProvider
                                  .getAmbulanceReport(context);
                              _triggerAnimation();
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
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ]),
              ),
              const SizedBox(
                height: 16,
              ),
              mrAdminAmbulanceReportProvider.foundAmbulanceList.isNotEmpty
                  ? CustomContainer(
                      horizontalPad: 0,
                      verticalPad: 0,
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          CustomExpansionTile(
                            applyAllBorderRadius: true,
                            size: 20,
                            fontWeight: FontWeight.w600,
                            title: 'Ambulance Report',
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: mrAdminAmbulanceReportProvider
                                        .selectedUser,
                                    isContent: true,
                                  ),
                                ],
                              ),
                              const Divider(),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                        text: 'Total Ambulance Visit',isContent: true,),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: CustomText(
                                      text: mrAdminAmbulanceReportProvider
                                          .foundAmbulanceList.length
                                          .toString(),
                                      isContent: true,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 64.0),
                        child: CustomText(
                          text: '',
                          isSubHeading: true,
                        ),
                      ),
                    ),
              const SizedBox(
                height: 16,
              ),
              mrAdminAmbulanceReportProvider.foundAmbulanceList.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true, // Shrink-wrap the ListView
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: mrAdminAmbulanceReportProvider
                          .foundAmbulanceList.length,
                      itemBuilder: (context, index) {

                        String pocName = mrAdminAmbulanceReportProvider.foundAmbulanceList[index]['pocName'];
                        String age = mrAdminAmbulanceReportProvider.foundAmbulanceList[index]['age'].toString();
                        String gender = mrAdminAmbulanceReportProvider.foundAmbulanceList[index]['gender'];
                        String number = mrAdminAmbulanceReportProvider.foundAmbulanceList[index]['number'];
                        String country = mrAdminAmbulanceReportProvider.foundAmbulanceList[index]['country'];
                        String region = mrAdminAmbulanceReportProvider.foundAmbulanceList[index]['region'];
                        String city = mrAdminAmbulanceReportProvider.foundAmbulanceList[index]['city'];
                        String address = mrAdminAmbulanceReportProvider.foundAmbulanceList[index]['address'];
                        String category = mrAdminAmbulanceReportProvider.foundAmbulanceList[index]['category'];
                        String specialization = mrAdminAmbulanceReportProvider.foundAmbulanceList[index]['specialization'];
                        String organization = mrAdminAmbulanceReportProvider.foundAmbulanceList[index]['organization'];
                        String ambNumber = mrAdminAmbulanceReportProvider.foundAmbulanceList[index]['ambNumber'];
                        String createdByName = mrAdminAmbulanceReportProvider.foundAmbulanceList[index]['createdByName'];
                        String visitCounter = mrAdminAmbulanceReportProvider.foundAmbulanceList[index]['visitCounter'].toString();
                        String referralCounter = mrAdminAmbulanceReportProvider.foundAmbulanceList[index]['referralCounter'].toString();
                        String createdAt = mrAdminAmbulanceReportProvider.foundAmbulanceList[index]['createdAt'];
                        String approvalStatus = mrAdminAmbulanceReportProvider.approvalType[1];

                        return AnimatedContainer(
                          duration: Duration(milliseconds: 400 + (index * 250)),
                          curve: Curves.easeInToLinear,
                          transform: Matrix4.translationValues(
                              myAnimation ? 0 : width, 0, 0),
                          child: Column(
                            children: [
                              CustomContainer(
                                horizontalMargin: 0,
                                verticalMargin: 4,
                                applyShadow: true,
                                child: Badge(
                                  label: CustomText(
                                    text: '${index + 1}',
                                    isContent: true,
                                  ),
                                  backgroundColor: approvalStatus == 'approved'
                                      ? CustomColors.primaryColor
                                      : approvalStatus == 'pending'
                                      ? CustomColors.lightYellow
                                      : CustomColors.lightRed,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: CustomText(
                                              text: 'Patient Name',
                                              isContent: true,
                                              size: 16,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: CustomText(
                                              text: pocName,
                                              isContent: true,
                                              size: 16,
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
                                              text: 'Age',
                                              isContent: true,
                                              size: 16,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: CustomText(
                                              text: age,
                                              isContent: true,
                                              size: 16,
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
                                              text: 'Gender',
                                              isContent: true,
                                              size: 16,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: CustomText(
                                              text: gender,
                                              isContent: true,
                                              size: 16,
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
                                              text: 'Number',
                                              isContent: true,
                                              size: 16,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: CustomText(
                                              text: number,
                                              isContent: true,
                                              size: 16,
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
                                              text: 'Country',
                                              isContent: true,
                                              size: 16,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: CustomText(
                                              text: country,
                                              isContent: true,
                                              size: 16,
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
                                              text: 'Region',
                                              isContent: true,
                                              size: 16,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: CustomText(
                                              text: region,
                                              isContent: true,
                                              size: 16,
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
                                              text: 'City',
                                              isContent: true,
                                              size: 16,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: CustomText(
                                              text: city,
                                              isContent: true,
                                              size: 16,
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
                                              text: 'Address',
                                              isContent: true,
                                              size: 16,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: CustomText(
                                              text: address,
                                              isContent: true,
                                              size: 16,
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
                                              text: 'Category',
                                              isContent: true,
                                              size: 16,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: CustomText(
                                              text: category,
                                              isContent: true,
                                              size: 16,
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
                                              text: 'Specialization',
                                              isContent: true,
                                              size: 16,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: CustomText(
                                              text: specialization,
                                              isContent: true,
                                              size: 16,
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
                                              text: 'Organization',
                                              isContent: true,
                                              size: 16,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: CustomText(
                                              text: organization,
                                              isContent: true,
                                              size: 16,
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
                                              text: 'Ambulance Number',
                                              isContent: true,
                                              size: 16,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: CustomText(
                                              text: ambNumber,
                                              isContent: true,
                                              size: 16,
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
                                              text: 'Created By',
                                              isContent: true,
                                              size: 16,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: CustomText(
                                              text: createdByName,
                                              isContent: true,
                                              size: 16,
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
                                              text: 'Number of Visit',
                                              isContent: true,
                                              size: 16,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: CustomText(
                                              text: visitCounter,
                                              isContent: true,
                                              size: 16,
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
                                              text: 'Referral Counter',
                                              isContent: true,
                                              size: 16,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: CustomText(
                                              text: referralCounter,
                                              isContent: true,
                                              size: 16,
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
                                              text: 'Created At',
                                              isContent: true,
                                              size: 16,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: CustomText(
                                              text: createdAt,
                                              isContent: true,
                                              size: 16,
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
                                              items:
                                              mrAdminAmbulanceReportProvider
                                                  .approvalType,
                                              value: approvalStatus,
                                              onChanged: (value) {
                                                mrAdminAmbulanceReportProvider
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
                            ],
                          ),
                        );
                      })
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 64.0),
                        child: CustomText(
                          text: 'No Report found',
                          isSubHeading: true,
                        ),
                      ),
                    ),
            ],
          ),
        ],
      );
    });
  }

  //----------------------------------------------------------------------------------District Bottom Sheet---------------------------------------------------------------------------------------------------------------------//

  Widget districtBottomSheet(context, String type, List<dynamic> content) {
    return Consumer<MrAdminAmbulanceReportProvider>(
        builder: (context, mrAdminAmbulanceReportProvider, _) {
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
                      controller:
                          mrAdminAmbulanceReportProvider.searchController,
                      labelText:
                          mrAdminAmbulanceReportProvider.selectedCountry ==
                                  'Nepal'
                              ? 'Search District'
                              : 'Search State',
                      applySuffixIcon: true,
                      suffixIcon: Icon(Icons.search),
                      validator: (value) {},
                      onChange: (value) =>
                          mrAdminAmbulanceReportProvider.searchAddressResult(
                              mrAdminAmbulanceReportProvider
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
                itemCount: mrAdminAmbulanceReportProvider.searchResult.length,
                itemBuilder: (context, index) {
                  String name = mrAdminAmbulanceReportProvider
                      .searchResult[index]['$type'];
                  return ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      type == 'district'
                          ? mrAdminAmbulanceReportProvider
                              .setSelectedDistrict(name)
                          : mrAdminAmbulanceReportProvider
                              .setSelectedState(name);
                      mrAdminAmbulanceReportProvider.getCities(
                          mrAdminAmbulanceReportProvider.searchResult[index]
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
    });
  }

//------------------------------------------------------------------------------------Cities Bottom Sheet-------------------------------------------------------------------------------------------------------------------------//

  Widget citiesBottomSheet(context, List<dynamic> content) {
    return Consumer<MrAdminAmbulanceReportProvider>(
        builder: (context, mrAdminAmbulanceReportProvider, _) {
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
                      controller:
                          mrAdminAmbulanceReportProvider.searchController,
                      labelText: 'Search City',
                      applySuffixIcon: true,
                      suffixIcon: Icon(Icons.search),
                      validator: (value) {},
                      onChange: (value) =>
                          mrAdminAmbulanceReportProvider.searchAddressResult(
                              mrAdminAmbulanceReportProvider
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
                itemCount: mrAdminAmbulanceReportProvider.searchResult.length,
                itemBuilder: (context, index) {
                  String cityName =
                      mrAdminAmbulanceReportProvider.searchResult[index];
                  return ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      mrAdminAmbulanceReportProvider.setSelectedCity(cityName);
                      print(mrAdminAmbulanceReportProvider.searchResult[index]);
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
    });
  }
}
