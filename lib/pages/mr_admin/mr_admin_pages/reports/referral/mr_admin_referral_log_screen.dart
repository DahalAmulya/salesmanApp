import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../routes/route_generator_constants.dart';
import '../../../../../themes/custom_colors.dart';
import '../../../../../widgets/app_bars/custom_app_bars.dart';
import '../../../../../widgets/buttons/elevated_button.dart';
import '../../../../../widgets/containers/custom_container.dart';
import '../../../../../widgets/drop_downs/custom_dropdown.dart';
import '../../../../../widgets/expansion_tile/custom_expansiontile.dart';
import '../../../../../widgets/text_fields/text_from_field.dart';
import '../../../../../widgets/texts/custom_text.dart';
import '../../../mr_admin_providers/mr_admin_referral log_provider.dart';

class ReferralLogScreen extends StatefulWidget {
  const ReferralLogScreen({super.key});

  @override
  State<ReferralLogScreen> createState() => _ReferralLogScreenState();
}

class _ReferralLogScreenState extends State<ReferralLogScreen> {
  bool myAnimation = false;
  double width = 0;

  @override
  void initState() {
    super.initState();
    MrAdminReferralLogProvider mrAdminReferralLogProvider =
        Provider.of<MrAdminReferralLogProvider>(context, listen: false);
    mrAdminReferralLogProvider.getDataForDistrict();
    mrAdminReferralLogProvider.getDataForState();
    mrAdminReferralLogProvider.getVisitLogsList(context);
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
    width = MediaQuery.of(context).size.width;
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
          body: _body(context),
        ),
      ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        tabName: 'Referral Log Report',
        centerTitle: true,
        automaticallyImplyLeading: true,
        onTap: () {
          Navigator.of(context).pop(MarketingManagerConstants.homePage);
        },
      ),
    );
  }

  Widget _body(context) {
    return Consumer<MrAdminReferralLogProvider>(
      builder: (context, mrAdminReferralLogProvider, _) {
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
                    initiallyExpanded: mrAdminReferralLogProvider.isExpanded,
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
                            items: mrAdminReferralLogProvider.referralLogsUsersList,
                            value: mrAdminReferralLogProvider.selectedUser,
                            onChanged: (value) {
                              mrAdminReferralLogProvider.setSelectedUser(value);
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          CustomDropdown(
                            labelText: 'Select Date',
                            items:
                                mrAdminReferralLogProvider.referralDateTypeList,
                            value: mrAdminReferralLogProvider
                                .selectedDateReferralType,
                            onChanged: (value) {
                              mrAdminReferralLogProvider
                                  .setSelectedVisitType(value);
                            },
                          ),
                          SizedBox(
                            height: mrAdminReferralLogProvider
                                        .selectedDateReferralType ==
                                    mrAdminReferralLogProvider
                                        .referralDateTypeList[2]
                                ? 16
                                : 0,
                          ),
                          if (mrAdminReferralLogProvider
                                  .selectedDateReferralType ==
                              'Custom')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextFromFieldWithPrefixSuffix(
                                    labelText: 'From',
                                    readOnly: true,
                                    controller: mrAdminReferralLogProvider
                                        .fromTextEditingController,
                                    onTap: () {
                                      mrAdminReferralLogProvider
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
                                    controller: mrAdminReferralLogProvider
                                        .toTextEditingController,
                                    onTap: () {
                                      mrAdminReferralLogProvider
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
                            labelText: 'Select Referral Type',
                            items: mrAdminReferralLogProvider.referralType,
                            value:
                                mrAdminReferralLogProvider.selectedReferralType,
                            onChanged: (value) {
                              mrAdminReferralLogProvider
                                  .setSelectedReferralType(value);
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          if (mrAdminReferralLogProvider.selectedReferralType ==
                              'Country')
                            Column(
                              children: [
                                CustomDropdown(
                                  labelText: 'Select Country',
                                  items: mrAdminReferralLogProvider.countryList,
                                  value: mrAdminReferralLogProvider
                                      .selectedCountry,
                                  applyCountryFlag: true,
                                  onChanged: (value) {
                                    mrAdminReferralLogProvider
                                        .setSelectedCountry(value);
                                  },
                                ),
                              ],
                            ),
                          if (mrAdminReferralLogProvider.selectedReferralType ==
                              'Region')
                            Column(
                              children: [
                                CustomDropdown(
                                  labelText: 'Country',
                                  items: mrAdminReferralLogProvider.countryList,
                                  value: mrAdminReferralLogProvider
                                      .selectedCountry,
                                  applyCountryFlag: true,
                                  onChanged: (newValue) {
                                    mrAdminReferralLogProvider
                                        .setSelectedCountry(newValue);
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFromFieldWithPrefixSuffix(
                                  controller: mrAdminReferralLogProvider
                                              .selectedCountry ==
                                          mrAdminReferralLogProvider
                                              .countryList[0]
                                      ? mrAdminReferralLogProvider
                                          .districtController
                                      : mrAdminReferralLogProvider
                                          .stateController,
                                  readOnly: true,
                                  labelText: mrAdminReferralLogProvider
                                              .selectedCountry ==
                                          mrAdminReferralLogProvider
                                              .countryList[0]
                                      ? 'District *'
                                      : 'State *',
                                  validator: (newValue) {},
                                  onTap: () async {
                                    String fileName = mrAdminReferralLogProvider
                                                .selectedCountry ==
                                            mrAdminReferralLogProvider
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
                                    mrAdminReferralLogProvider
                                        .searchController.text = '';
                                    mrAdminReferralLogProvider
                                        .searchAddressResult(
                                            mrAdminReferralLogProvider
                                                .searchController.value.text,
                                            content);
                                  },
                                ),
                              ],
                            ),
                          // Condition for City
                          if (mrAdminReferralLogProvider.selectedReferralType ==
                              'City')
                            Column(
                              children: [
                                CustomDropdown(
                                  labelText: 'Country',
                                  items: mrAdminReferralLogProvider.countryList,
                                  value: mrAdminReferralLogProvider
                                      .selectedCountry,
                                  applyCountryFlag: true,
                                  onChanged: (newValue) {
                                    mrAdminReferralLogProvider
                                        .setSelectedCountry(newValue);
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFromFieldWithPrefixSuffix(
                                  controller: mrAdminReferralLogProvider
                                              .selectedCountry ==
                                          mrAdminReferralLogProvider
                                              .countryList[0]
                                      ? mrAdminReferralLogProvider
                                          .districtController
                                      : mrAdminReferralLogProvider
                                          .stateController,
                                  readOnly: true,
                                  labelText: mrAdminReferralLogProvider
                                              .selectedCountry ==
                                          mrAdminReferralLogProvider
                                              .countryList[0]
                                      ? 'District *'
                                      : 'State *',
                                  validator: (newValue) {},
                                  onTap: () async {
                                    String fileName = mrAdminReferralLogProvider
                                                .selectedCountry ==
                                            mrAdminReferralLogProvider
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
                                    mrAdminReferralLogProvider
                                        .searchController.text = '';
                                    mrAdminReferralLogProvider
                                        .searchAddressResult(
                                            mrAdminReferralLogProvider
                                                .searchController.value.text,
                                            content);
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFromFieldWithPrefixSuffix(
                                  controller:
                                      mrAdminReferralLogProvider.cityController,
                                  readOnly: true,
                                  labelText: 'City *',
                                  validator: (newValue) {},
                                  onTap: () async {
                                    mrAdminReferralLogProvider
                                        .searchController.text = '';
                                    mrAdminReferralLogProvider
                                        .searchAddressResult(
                                            mrAdminReferralLogProvider
                                                .searchController.value.text,
                                            mrAdminReferralLogProvider.cities);
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        useSafeArea: true,
                                        context: context,
                                        builder: (context) => citiesBottomSheet(
                                            context,
                                            mrAdminReferralLogProvider.cities));
                                  },
                                ),
                              ],
                            ),
                          const SizedBox(
                            height: 16,
                          ),
                          CustomElevatedButton(
                            onPressed: () {
                              if (mrAdminReferralLogProvider
                                      .selectedReferralType ==
                                  mrAdminReferralLogProvider.referralType[0]) {
                                mrAdminReferralLogProvider
                                    .getReferralByCountry(context);
                              } else if (mrAdminReferralLogProvider
                                      .selectedReferralType ==
                                  mrAdminReferralLogProvider.referralType[1]) {
                                mrAdminReferralLogProvider
                                    .getReferralLogsByRegion(context);
                              } else if (mrAdminReferralLogProvider
                                      .selectedReferralType ==
                                  mrAdminReferralLogProvider.referralType[2]) {
                                mrAdminReferralLogProvider
                                    .getReferralLogByCity(context);
                              }
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
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                mrAdminReferralLogProvider.foundReferral.isNotEmpty
                    ? CustomContainer(
                        horizontalPad: 0,
                        verticalPad: 0,
                        color: Colors.transparent,
                        child: CustomExpansionTile(
                          title: 'Referral Log',
                          applyAllBorderRadius: true,
                          size: 20,
                          fontWeight: FontWeight.w600,
                          children: [
                            Column(
                              children: [
                                // const Divider(),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: CustomText(
                                        text: mrAdminReferralLogProvider
                                            .selectedUser,
                                        isContent: true,
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(1000),
                                      child: SizedBox(
                                        height: 52,
                                        width: 52,
                                        child: Image.network(
                                          mrAdminReferralLogProvider
                                              .profileImage,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
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
                                        text: 'Total Referral',
                                        isContent: true,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      flex: 2,
                                      child: CustomText(
                                        text: mrAdminReferralLogProvider
                                            .foundReferral.length
                                            .toString(),
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
                                      flex: 2,
                                      child: CustomText(
                                        isContent: true,
                                        text: mrAdminReferralLogProvider
                                                    .selectedReferralType ==
                                                'Country'
                                            ? 'Country'
                                            : (mrAdminReferralLogProvider
                                                        .selectedReferralType ==
                                                    'Region'
                                                ? 'Region'
                                                : 'City'),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: CustomText(
                                        text: mrAdminReferralLogProvider
                                                    .selectedReferralType ==
                                                'Country'
                                            ? mrAdminReferralLogProvider
                                                .selectedCountry
                                            : (mrAdminReferralLogProvider
                                                        .selectedReferralType ==
                                                    'City'
                                                ? mrAdminReferralLogProvider
                                                    .selectedCities
                                                : (mrAdminReferralLogProvider
                                                            .selectedReferralType ==
                                                        'Region'
                                                    ? mrAdminReferralLogProvider
                                                        .selectedDistrict
                                                    : mrAdminReferralLogProvider
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
                                    Expanded(
                                      flex: 2,
                                      child: CustomText(
                                        text: mrAdminReferralLogProvider.from,
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
                                    Expanded(
                                      flex: 2,
                                      child: CustomText(
                                        text: mrAdminReferralLogProvider.to,
                                        isContent: true,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
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
                mrAdminReferralLogProvider.foundReferral.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true, // Shrink-wrap the ListView
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            mrAdminReferralLogProvider.foundReferral.length,
                        itemBuilder: (context, index) {
                          String patientName = mrAdminReferralLogProvider
                              .foundReferral[index]['patientName'];
                          String patientAge = mrAdminReferralLogProvider
                              .foundReferral[index]['patientAge']
                              .toString();
                          String provisionalDiagnosis =
                              mrAdminReferralLogProvider.foundReferral[index]
                                  ['provisionalDiagnosis'];
                          String country = mrAdminReferralLogProvider
                              .foundReferral[index]['country'];
                          String region = mrAdminReferralLogProvider
                              .foundReferral[index]['region'];
                          String city = mrAdminReferralLogProvider
                              .foundReferral[index]['city'];

                          String createdById = mrAdminReferralLogProvider
                              .foundReferral[index]['createdById']
                              .toString();
                          String createdByName = mrAdminReferralLogProvider
                              .foundReferral[index]['createdBy'];

                          String pocName = mrAdminReferralLogProvider
                              .foundReferral[index]['pocName'];
                          String pocNumber = mrAdminReferralLogProvider
                              .foundReferral[index]['pocNumber'];
                          String pocCategory = mrAdminReferralLogProvider
                              .foundReferral[index]['pocCategory'];

                          String ambId = mrAdminReferralLogProvider
                              .foundReferral[index]['ambId'];
                          String ambDriverName = mrAdminReferralLogProvider
                              .foundReferral[index]['ambName'];
                          String ambDriverNumber = mrAdminReferralLogProvider
                              .foundReferral[index]['ambNumber'];
                          String ambNumber = mrAdminReferralLogProvider
                              .foundReferral[index]['ambVehicleNumber'];
                          String mobileTime = mrAdminReferralLogProvider
                              .foundReferral[index]['mobileTime']
                              .toString()
                              .split(' ')[0];
                          String referralDate = mrAdminReferralLogProvider
                              .foundReferral[index]['referralDate']
                              .toString()
                              .split('T')[0];
                          String approvalStatus =
                              mrAdminReferralLogProvider.approvalType[1];

                          return AnimatedContainer(
                            duration:
                                Duration(milliseconds: 400 + (index * 250)),
                            curve: Curves.easeInToLinear,
                            transform: Matrix4.translationValues(
                                myAnimation ? 0 : width, 0, 0),
                            child: Column(
                              children: [
                                CustomContainer(
                                  horizontalMargin: 0,
                                  applyShadow: true,
                                  child: Badge(
                                    label: CustomText(
                                      text: '${index + 1}',
                                      isContent: true,
                                    ),
                                    backgroundColor: CustomColors.primaryColor,
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
                                                text: patientName,
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
                                                text: 'Patient Age',
                                                isContent: true,
                                                size: 16,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: CustomText(
                                                text: patientAge,
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
                                                text: 'Provisional Diagnosis ',
                                                isContent: true,
                                                size: 16,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: CustomText(
                                                text: provisionalDiagnosis,
                                                isContent: true,
                                                size: 16,
                                                maxLines: 2,
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
                                                text: 'POC Name',
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
                                                text: 'POC Number',
                                                isContent: true,
                                                size: 16,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: CustomText(
                                                text: pocNumber,
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
                                                text: 'POC Category',
                                                isContent: true,
                                                size: 16,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: CustomText(
                                                text: pocCategory,
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
                                                text: 'AMB Driver Name',
                                                isContent: true,
                                                size: 16,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: CustomText(
                                                text: ambDriverName,
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
                                                text: 'AMB Driver Number',
                                                isContent: true,
                                                size: 16,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: CustomText(
                                                text: ambDriverNumber,
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
                                                text: 'AMB Number',
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
                                                    mrAdminReferralLogProvider
                                                        .approvalType,
                                                value: approvalStatus,
                                                onChanged: (value) {
                                                  mrAdminReferralLogProvider
                                                      .approvalStatus(
                                                          index, value!);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Row(
                                        //   children: [
                                        //     Expanded(
                                        //       flex: 2,
                                        //       child: CustomText(
                                        //         text: 'Mobile Time',
                                        //         isContent: true,
                                        //         size: 16,
                                        //       ),
                                        //     ),
                                        //     Expanded(
                                        //       flex: 2,
                                        //       child: CustomText(
                                        //         text: mobileTime,
                                        //         isContent: true,
                                        //         size: 16,
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        // Row(
                                        //   children: [
                                        //     Expanded(
                                        //       flex: 2,
                                        //       child: CustomText(
                                        //         text: 'Referral Date',
                                        //         isContent: true,
                                        //         size: 16,
                                        //       ),
                                        //     ),
                                        //     Expanded(
                                        //       flex: 2,
                                        //       child: CustomText(
                                        //         text: referralDate,
                                        //         isContent: true,
                                        //         size: 16,
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                          );
                        })
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 64.0),
                          child: CustomText(
                            text: 'No Referral log found',
                            isSubHeading: true,
                          ),
                        ),
                      ),
              ],
            ),
          ],
        );
      },
    );
  }

  //----------------------------------------------------------------City Bottom Sheet-------------------------------------------------------------------------------------------------------------------------------------------------------//
  Widget citiesBottomSheet(context, List<dynamic> content) {
    return Consumer<MrAdminReferralLogProvider>(
      builder: (context, mrAdminReferralLogProvider, _) {
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
                        controller: mrAdminReferralLogProvider.searchController,
                        labelText: 'Search City',
                        applySuffixIcon: true,
                        suffixIcon: Icon(Icons.search),
                        validator: (value) {},
                        onChange: (value) =>
                            mrAdminReferralLogProvider.searchAddressResult(
                                mrAdminReferralLogProvider
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
                  itemCount: mrAdminReferralLogProvider.searchResult.length,
                  itemBuilder: (context, index) {
                    String cityName =
                        mrAdminReferralLogProvider.searchResult[index];
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        mrAdminReferralLogProvider.setSelectedCity(cityName);
                        print(mrAdminReferralLogProvider.searchResult[index]);
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
  //----------------------------------------------------------------District Bottom Sheet-------------------------------------------------------------------------------------------------------------------------------------------------------//

  Widget districtBottomSheet(context, String type, List<dynamic> content) {
    return Consumer<MrAdminReferralLogProvider>(
      builder: (context, mrAdminReferralLogProvider, _) {
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
                          child: const Icon(FontAwesomeIcons.arrowLeft)),
                    ),
                    // ),
                    Expanded(
                      flex: 7,
                      child: TextFromFieldWithPrefixSuffix(
                        controller: mrAdminReferralLogProvider.searchController,
                        labelText: mrAdminReferralLogProvider.selectedCountry ==
                                'Nepal'
                            ? 'Search District'
                            : 'Search State',
                        applySuffixIcon: true,
                        suffixIcon: const Icon(Icons.search),
                        validator: (value) {},
                        onChange: (value) =>
                            mrAdminReferralLogProvider.searchAddressResult(
                                mrAdminReferralLogProvider
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
                  itemCount: mrAdminReferralLogProvider.searchResult.length,
                  itemBuilder: (context, index) {
                    String name =
                        mrAdminReferralLogProvider.searchResult[index]['$type'];
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        type == 'district'
                            ? mrAdminReferralLogProvider
                                .setSelectedDistrict(name)
                            : mrAdminReferralLogProvider.setSelectedState(name);
                        mrAdminReferralLogProvider.getCities(
                            mrAdminReferralLogProvider.searchResult[index]
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
