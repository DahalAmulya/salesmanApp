import 'dart:convert';

import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/mr_admin_provider/mr_admin_area_reportProvider.dart';
import '../../../../../routes/marketing_officer_consts.dart';
import '../../../../../routes/route_generator_constants.dart';
import '../../../../../themes/custom_colors.dart';
import '../../../../../widgets/app_bars/custom_app_bars.dart';
import '../../../../../widgets/drop_downs/custom_dropdown.dart';
import '../../../../../widgets/text_fields/text_from_field.dart';

class MrAdminAreaReportScreen extends StatefulWidget {
  const MrAdminAreaReportScreen({super.key});

  @override
  State<MrAdminAreaReportScreen> createState() =>
      _MrAdminAreaReportScreenState();
}

class _MrAdminAreaReportScreenState extends State<MrAdminAreaReportScreen> {
  List<String> country = ['Nepal', 'India'];
  String defaultValue = 'Nepal';
  String selectedCountry = '';
  String selectedCity = '';
  String selectedDistrict = 'Baglung';
  String selectedState = 'Achham';
  List<dynamic> districtList = [];
  List<dynamic> stateList = [];
  List<dynamic> citiesList = [];

  bool _isVisibleForState = false;
  bool _isVisibleForDistrict = true;

  TextEditingController stateTextEditingController = TextEditingController();
  TextEditingController districtTextEditingController = TextEditingController();
  TextEditingController cityTextEditingController = TextEditingController();

  void getDataForDistrict() async {
    final respose = await rootBundle.loadString('assets/district.json');
    print(respose.runtimeType);
    List<dynamic> districtData = json.decode(respose);
    // print(districtData);
    districtList = districtData;
  }

  void getDataForState() async {
    final respose = await rootBundle.loadString('assets/states.json');
    List<dynamic> stateData = json.decode(respose);
    stateList = stateData;
    // print(stateList);
  }

  @override
  void initState() {
    getDataForDistrict();
    getDataForState();
    super.initState();
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
          body: _body(context),
        ),
      ),
    );
  }

  PreferredSize _appBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        tabName: '',
        automaticallyImplyLeading: true,
        onTap: () {
          Navigator.of(context).pop(MarketingManagerConstants.homePage);
        },
      ),
    );
  }

  Widget _body(context) {
    return SafeArea(
      child: Consumer<MrAdminAreaReportProvider>(
          builder: (context, mrAdminAreaReportProvider, _) {
        return Column(
          children: [
            CustomContainer(
                applyShadow: true,
                verticalPad: 8,
                horizontalPad: 18,
                verticalMargin: 18,
                horizontalMargin: 18,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    CustomText(
                      text: 'Apply Filter',
                      fontWeight: FontWeight.w600,
                      size: 20,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: CustomText(
                            text: 'Country',
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: CustomDropdown(
                              labelText: 'Select Country',
                              items: mrAdminAreaReportProvider.country,
                              value: mrAdminAreaReportProvider.defaultValue,
                              applyCountryFlag: true,
                              onChanged: (newValue) {
                                mrAdminAreaReportProvider.setCountry(newValue);
                              }),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: CustomText(
                            text: mrAdminAreaReportProvider.defaultValue ==
                                    mrAdminAreaReportProvider.country[0]
                                ? 'District'
                                : 'States',
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextFromFieldWithPrefixSuffix(
                            controller:
                                mrAdminAreaReportProvider.defaultValue ==
                                        mrAdminAreaReportProvider.country[0]
                                    ? mrAdminAreaReportProvider
                                        .districtTextEditingController
                                    : mrAdminAreaReportProvider
                                        .stateTextEditingController,
                            labelText: mrAdminAreaReportProvider.defaultValue ==
                                    mrAdminAreaReportProvider.country[0]
                                ? 'District'
                                : 'States',
                            readOnly: true,
                            onTap: () async {
                              // weeklyPlanProvider.setStateList();
                              // _AddTaskBottomSheetForDistrict(context);
                              String fileName =
                                  mrAdminAreaReportProvider.defaultValue ==
                                          mrAdminAreaReportProvider.country[0]
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
                                      _DistrictBottomSheet(context, '$fileName', content));
                              mrAdminAreaReportProvider.searchController.text = '';
                              mrAdminAreaReportProvider.searchAddressResult(
                                  mrAdminAreaReportProvider.searchController.value.text,
                                  content);
                            },
                            onChange: (value) => () {},
                            validator: (Value) {},
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    // Visibility(
                    //   visible: _isVisibleForState,
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         flex: 1,
                    //         child: CustomText(
                    //           text: 'States',
                    //         ),
                    //       ),
                    //       Expanded(
                    //         flex: 2,
                    //         child: TextFromFieldWithPrefixSuffix(
                    //           controller: stateTextEditingController,
                    //           labelText: 'State',
                    //           readOnly: true,
                    //           onTap: () {
                    //             // weeklyPlanProvider.setStateList();
                    //             _AddTaskBottomSheetForStates(context);
                    //           },
                    //           onChange: (value) => () {},
                    //           validator: (Value) {},
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 16,
                    // ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: CustomText(
                            text: 'City',
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextFromFieldWithPrefixSuffix(
                            controller: mrAdminAreaReportProvider.cityTextEditingController,
                            labelText: 'City',
                            readOnly: true,
                            onTap: () async {
                              // weeklyPlanProvider.setStateList();
                              // _AddTaskBottomSheetForCities(context);
                              mrAdminAreaReportProvider.searchController.text = '';
                              mrAdminAreaReportProvider.searchAddressResult(
                                  mrAdminAreaReportProvider.searchController.value.text,
                                  mrAdminAreaReportProvider.cities);
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  useSafeArea: true,
                                  context: context,
                                  builder: (context) => citiesBottomSheet(
                                      context, mrAdminAreaReportProvider.cities));
                            },
                            onChange: (value) => () {},
                            validator: (Value) {},
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: CustomColors.primaryColor,
                      ),
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Center(child: CustomText(text: 'coming soon')),
                    )
                  ],
                ))
          ],
        );
      }),
    );
  }
  //----------------------------------------------------------------District BottomSheets----------------------------------------------------------------//

  Widget _DistrictBottomSheet(context, String type, List<dynamic> content) {
    return Consumer<MrAdminAreaReportProvider>(
        builder: (context, mrAdminAreaReportProvider, _) {
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
                  Expanded(
                    flex: 7,
                    child: TextFromFieldWithPrefixSuffix(
                      controller: mrAdminAreaReportProvider.searchController,
                      labelText: mrAdminAreaReportProvider.defaultValue == 'Nepal'
                          ? 'Search District'
                          : 'Search State',
                      applySuffixIcon: true,
                      suffixIcon: Icon(Icons.search),
                      validator: (value) {},
                      onChange: (value) =>
                          mrAdminAreaReportProvider.searchAddressResult(
                              mrAdminAreaReportProvider.searchController.value.text,
                              content),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: mrAdminAreaReportProvider.searchResult.length,
                  itemBuilder: (context, index) {
                    String name = mrAdminAreaReportProvider.searchResult[index]['$type'];
                    return ListTile(
                      title: CustomText(text: name, isContent: true,),
                      onTap: () {
                        // selectedDistrict = districtList[index]['district'];
                        // citiesList = districtList[index]['cities'];
                        // districtTextEditingController.text = selectedDistrict;
                        Navigator.pop(context);
                        type == 'district' ? mrAdminAreaReportProvider.setSelectedDistrict(name) : mrAdminAreaReportProvider.setSelectedState(name);
                        mrAdminAreaReportProvider.getCities(mrAdminAreaReportProvider.searchResult[index]['cities']);
                      },
                    );
                  }),
            ),
          ],
        ),
      );
    });
  }

  //--------------------------------------------------------------City BottomSheet------------------------------------------------------------------//
  Widget citiesBottomSheet(context,List<dynamic> content) {
    return Consumer<MrAdminAreaReportProvider>(
      builder: (context,mrAdminAreaReportProvider,_) {
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
                    Expanded(
                      flex: 7,
                      child: TextFromFieldWithPrefixSuffix(
                        controller: mrAdminAreaReportProvider.searchController,
                        labelText: 'Search City',
                        applySuffixIcon: true,
                        suffixIcon: Icon(Icons.search),
                        validator: (value) {},
                        onChange: (value) =>
                            mrAdminAreaReportProvider.searchAddressResult(
                                mrAdminAreaReportProvider.searchController.value.text,
                                content),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: mrAdminAreaReportProvider.searchResult.length,
                          itemBuilder: (context, index) {
                            String cityName = mrAdminAreaReportProvider.searchResult[index];
                            return ListTile(
                              title: CustomText(
                                text: cityName,
                                isContent: true,
                              ),
                              onTap: () {
                                // print(districtList);
                                // selectedCity = citiesList[index];
                                // cityTextEditingController.text = selectedCity;
                                Navigator.pop(context);
                                mrAdminAreaReportProvider.setSelectedCity(cityName);
                                print(mrAdminAreaReportProvider.searchResult[index]);
                              },
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
