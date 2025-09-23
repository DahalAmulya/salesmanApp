import 'dart:convert';

import 'package:deskgoo/widgets/buttons/elevated_button.dart';
import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/mr_admin_provider/mr_admin_area_reportProvider.dart';
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

  TextEditingController stateTextEditingController = TextEditingController();
  TextEditingController districtTextEditingController = TextEditingController();
  TextEditingController cityTextEditingController = TextEditingController();

  void getDataForDistrict() async {
    final response = await rootBundle.loadString('assets/district.json');
    print(response.runtimeType);
    List<dynamic> districtData = json.decode(response);
    districtList = districtData;
  }

  void getDataForState() async {
    final response = await rootBundle.loadString('assets/states.json');
    List<dynamic> stateData = json.decode(response);
    stateList = stateData;
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
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        tabName: 'Area Report',
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
        return Stack(
          children: [
            ListView(
              children: [
                mrAdminAreaReportProvider.showFilter
                    ? CustomContainer(
                        applyShadow: true,
                        verticalPad: 8,
                        horizontalPad: 18,
                        verticalMargin: 18,
                        horizontalMargin: 18,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: 'Apply Filter',
                                  fontWeight: FontWeight.w600,
                                  size: 20,
                                ),
                                InkWell(
                                  onTap: (){
                                    mrAdminAreaReportProvider.toggleFilter();
                                  },
                                  child: CircleAvatar(
                                    radius: 24,
                                      backgroundColor: CustomColors.primaryColor,
                                      child: Icon(FontAwesomeIcons.filterCircleXmark,color: Colors.black,)),
                                ),
                              ],
                            ),
                            const SizedBox(
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
                                    items:
                                        mrAdminAreaReportProvider.countryList,
                                    value: mrAdminAreaReportProvider
                                        .selectedCountry,
                                    applyCountryFlag: true,
                                    onChanged: (value) {
                                      mrAdminAreaReportProvider
                                          .setSelectedCountry(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: CustomText(
                                    text: mrAdminAreaReportProvider
                                                .selectedCountry ==
                                            mrAdminAreaReportProvider
                                                .countryList[0]
                                        ? 'District'
                                        : 'States',
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextFromFieldWithPrefixSuffix(
                                    controller: mrAdminAreaReportProvider
                                                .selectedCountry ==
                                            mrAdminAreaReportProvider
                                                .countryList[0]
                                        ? mrAdminAreaReportProvider
                                            .districtController
                                        : mrAdminAreaReportProvider
                                            .stateController,
                                    readOnly: true,
                                    labelText: mrAdminAreaReportProvider
                                                .selectedCountry ==
                                            mrAdminAreaReportProvider
                                                .countryList[0]
                                        ? 'Select District *'
                                        : 'Select State *',
                                    validator: (newValue) {},
                                    onTap: () async {
                                      String fileName =
                                          mrAdminAreaReportProvider
                                                      .selectedCountry ==
                                                  mrAdminAreaReportProvider
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
                                              districtBottomSheet(context,
                                                  '$fileName', content));
                                      mrAdminAreaReportProvider
                                          .searchController.text = '';
                                      mrAdminAreaReportProvider
                                          .searchAddressResult(
                                              mrAdminAreaReportProvider
                                                  .searchController.value.text,
                                              content);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
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
                                    controller: mrAdminAreaReportProvider
                                        .cityController,
                                    readOnly: true,
                                    labelText: 'City *',
                                    validator: (newValue) {},
                                    onTap: () async {
                                      mrAdminAreaReportProvider
                                          .searchController.text = '';
                                      mrAdminAreaReportProvider
                                          .searchAddressResult(
                                              mrAdminAreaReportProvider
                                                  .searchController.value.text,
                                              mrAdminAreaReportProvider.cities);
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          useSafeArea: true,
                                          context: context,
                                          builder: (context) =>
                                              citiesBottomSheet(
                                                  context,
                                                  mrAdminAreaReportProvider
                                                      .cities));
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            CustomElevatedButton(
                              onPressed: () {
                                print('Pressed');
                              },
                              backgroundColor: CustomColors.primaryColor,
                              width: 1,
                              widget: CustomText(
                                text: 'Submit',
                                isContent: true,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
                ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 36, horizontal: 12),
                    shrinkWrap: true, // Shrink-wrap the ListView
                    physics: const BouncingScrollPhysics(),
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white,
                        elevation: 5,
                        child: ListTile(
                          onTap: () {
                            print("Pressed");
                          },
                          title: CustomText(
                            text: 'Hello $index',
                            isContent: true,
                          ),
                        ),
                      );
                    }),
              ],
            ),
            !mrAdminAreaReportProvider.showFilter
                ? Positioned(
                    top: 16,
                    right: 16,
                    child: InkWell(
                      onTap: (){
                        mrAdminAreaReportProvider.toggleFilter();
                      },
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: CustomColors.primaryColor,
                        child: Icon(
                          FontAwesomeIcons.filter,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        );
      }),
    );
  }
  //----------------------------------------------------------------District BottomSheets----------------------------------------------------------------//

  Widget districtBottomSheet(context, String type, List<dynamic> content) {
    return Consumer<MrAdminAreaReportProvider>(
      builder: (context, mrAdminAreaReportProvider, _) {
        return Container(
          color: CustomColors.primaryWhite,
          height: MediaQuery.of(context).size.height * 0.80,
          child: Column(
            children: [
              // SizedBox(
              //   height: 16,
              // ),
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
                            Navigator.pop(context);
                          },
                          child: const Icon(FontAwesomeIcons.arrowLeft)),
                    ),
                    // ),
                    Expanded(
                      flex: 7,
                      child: TextFromFieldWithPrefixSuffix(
                        controller: mrAdminAreaReportProvider.searchController,
                        labelText:
                            mrAdminAreaReportProvider.selectedCountry == 'Nepal'
                                ? 'Search District'
                                : 'Search State',
                        applySuffixIcon: true,
                        suffixIcon: const Icon(Icons.search),
                        validator: (value) {},
                        onChange: (value) =>
                            mrAdminAreaReportProvider.searchAddressResult(
                                mrAdminAreaReportProvider
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
                  itemCount: mrAdminAreaReportProvider.searchResult.length,
                  itemBuilder: (context, index) {
                    String name =
                        mrAdminAreaReportProvider.searchResult[index]['$type'];
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        type == 'district'
                            ? mrAdminAreaReportProvider
                                .setSelectedDistrict(name)
                            : mrAdminAreaReportProvider.setSelectedState(name);
                        mrAdminAreaReportProvider.getCities(
                            mrAdminAreaReportProvider.searchResult[index]
                                ['cities']);
                        print(mrAdminAreaReportProvider.searchResult[index]);
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

  //--------------------------------------------------------------City BottomSheet------------------------------------------------------------------//
  Widget citiesBottomSheet(context, List<dynamic> content) {
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
                            Navigator.pop(context);
                          },
                          child: const Icon(FontAwesomeIcons.arrowLeft)),
                    ),
                    // ),
                    Expanded(
                      flex: 7,
                      child: TextFromFieldWithPrefixSuffix(
                        controller: mrAdminAreaReportProvider.searchController,
                        labelText: 'Search City',
                        applySuffixIcon: true,
                        suffixIcon: const Icon(Icons.search),
                        validator: (value) {},
                        onChange: (value) =>
                            mrAdminAreaReportProvider.searchAddressResult(
                                mrAdminAreaReportProvider
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
                  itemCount: mrAdminAreaReportProvider.searchResult.length,
                  itemBuilder: (context, index) {
                    String cityName =
                        mrAdminAreaReportProvider.searchResult[index];
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        mrAdminAreaReportProvider.setSelectedCity(cityName);
                        print(mrAdminAreaReportProvider.searchResult[index]);
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
}
