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

  @override
  void initState() {
    MrAdminAmbulanceReportProvider mrAdminAmbulanceReportProvider = Provider.of<MrAdminAmbulanceReportProvider>(context,listen: false);
    mrAdminAmbulanceReportProvider.getAmbulanceLogList(context);
    super.initState();
  }
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
                            items: mrAdminAmbulanceReportProvider.ambulanceLogsUsersList,
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
                          if(mrAdminAmbulanceReportProvider.selectedAmbulanceReportDateType == 'Custom')
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
                            items: mrAdminAmbulanceReportProvider.ambulanceReferralType,
                            value:
                            mrAdminAmbulanceReportProvider.selectedAmbulanceReferralType,
                            onChanged: (value) {
                              mrAdminAmbulanceReportProvider
                                  .setSelectedAmbulanceReferralType(value);
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          if(mrAdminAmbulanceReportProvider.selectedAmbulanceReferralType == 'Country')
                            Column(
                              children: [
                                CustomDropdown(
                                  labelText: 'Select Country',
                                  items: mrAdminAmbulanceReportProvider.countryList,
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
                          if(mrAdminAmbulanceReportProvider.selectedAmbulanceReferralType == 'Region')
                            Column(
                              children: [
                                CustomDropdown(
                                  labelText: 'Country',
                                  items: mrAdminAmbulanceReportProvider.countryList,
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
                                    String fileName = mrAdminAmbulanceReportProvider
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
                          if(mrAdminAmbulanceReportProvider.selectedAmbulanceReferralType == 'City')
                            Column(
                              children: [
                                // CustomDropdown(
                                //   labelText: 'Country',
                                //   items: mrAdminAmbulanceReportProvider.countryList,
                                //   value: mrAdminAmbulanceReportProvider
                                //       .selectedCountry,
                                //   applyCountryFlag: true,
                                //   onChanged: (newValue) {
                                //     mrAdminAmbulanceReportProvider
                                //         .setSelectedCountry(newValue);
                                //   },
                                // ),
                                // const SizedBox(
                                //   height: 16,
                                // ),
                                // TextFromFieldWithPrefixSuffix(
                                //   controller: mrAdminAmbulanceReportProvider
                                //       .selectedCountry ==
                                //       mrAdminAmbulanceReportProvider
                                //           .countryList[0]
                                //       ? mrAdminAmbulanceReportProvider
                                //       .districtController
                                //       : mrAdminAmbulanceReportProvider
                                //       .stateController,
                                //   readOnly: true,
                                //   labelText: mrAdminAmbulanceReportProvider
                                //       .selectedCountry ==
                                //       mrAdminAmbulanceReportProvider
                                //           .countryList[0]
                                //       ? 'District *'
                                //       : 'State *',
                                //   validator: (newValue) {},
                                //   onTap: () async {
                                //     String fileName = mrAdminAmbulanceReportProvider
                                //         .selectedCountry ==
                                //         mrAdminAmbulanceReportProvider
                                //             .countryList[0]
                                //         ? 'district'
                                //         : 'states';
                                //     final file = await rootBundle
                                //         .loadString('assets/$fileName.json');
                                //     final content = await jsonDecode(file);
                                //     showModalBottomSheet(
                                //         isScrollControlled: true,
                                //         useSafeArea: true,
                                //         context: context,
                                //         builder: (context) =>
                                //             districtBottomSheet(
                                //                 context, '$fileName', content));
                                //     mrAdminAmbulanceReportProvider
                                //         .searchController.text = '';
                                //     mrAdminAmbulanceReportProvider
                                //         .searchAddressResult(
                                //         mrAdminAmbulanceReportProvider
                                //             .searchController.value.text,
                                //         content);
                                //   },
                                // ),
                                // const SizedBox(
                                //   height: 16,
                                // ),
                                // TextFromFieldWithPrefixSuffix(
                                //   controller:
                                //   mrAdminAmbulanceReportProvider.cityController,
                                //   readOnly: true,
                                //   labelText: 'City *',
                                //   validator: (newValue) {},
                                //   onTap: () async {
                                //     mrAdminAmbulanceReportProvider
                                //         .searchController.text = '';
                                //     mrAdminAmbulanceReportProvider
                                //         .searchAddressResult(
                                //         mrAdminAmbulanceReportProvider
                                //             .searchController.value.text,
                                //         mrAdminAmbulanceReportProvider.cities);
                                //     showModalBottomSheet(
                                //         isScrollControlled: true,
                                //         useSafeArea: true,
                                //         context: context,
                                //         builder: (context) => citiesBottomSheet(
                                //             context,
                                //             mrAdminAmbulanceReportProvider.cities));
                                //   },
                                // ),
                              ],
                            ),
                        ],
                      ),
                    ]),
              ),
            ],
          ),
        ],
      );
    });
  }

  //----------------------------------------------------------------------------------District Bottom Sheet---------------------------------------------------------------------------------------------------------------------//

Widget districtBottomSheet(context, String type, List<dynamic> content){
    return Consumer<MrAdminAmbulanceReportProvider>(
      builder: (context,mrAdminAmbulanceReportProvider,_) {
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
                        controller: mrAdminAmbulanceReportProvider.searchController,
                        labelText: mrAdminAmbulanceReportProvider.selectedCountry ==
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
                    String name =
                    mrAdminAmbulanceReportProvider.searchResult[index]['$type'];
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        type == 'district'
                            ? mrAdminAmbulanceReportProvider
                            .setSelectedDistrict(name)
                            : mrAdminAmbulanceReportProvider.setSelectedState(name);
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
      }
    );
}


}
