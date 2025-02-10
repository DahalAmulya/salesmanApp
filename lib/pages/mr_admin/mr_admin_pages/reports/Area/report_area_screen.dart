import 'dart:convert';

import 'package:deskgoo/widgets/containers/custom_container.dart';
import 'package:deskgoo/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      child: Column(
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
                            items: country,
                            value: defaultValue,
                            applyCountryFlag: true,
                            onChanged: (newValue) {
                              setState(() {
                                selectedCountry = newValue!;
                                if (selectedCountry == country[0]) {
                                  _isVisibleForDistrict = true;
                                  _isVisibleForState = false;
                                  _AddTaskBottomSheetForDistrict(context);
                                } else {
                                  _isVisibleForDistrict = false;
                                  _isVisibleForState = true;
                                  _AddTaskBottomSheetForStates(context);
                                  // print(country[1]);
                                }
                              });
                            }),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Visibility(
                    visible: _isVisibleForDistrict,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: CustomText(
                            text: 'District',
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextFromFieldWithPrefixSuffix(
                            controller: districtTextEditingController,
                            labelText: 'District',
                            readOnly: true,
                            onTap: () {
                              // weeklyPlanProvider.setStateList();
                              _AddTaskBottomSheetForDistrict(context);
                            },
                            onChange: (value) => () {},
                            validator: (Value) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Visibility(
                    visible: _isVisibleForState,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: CustomText(
                            text: 'States',
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextFromFieldWithPrefixSuffix(
                            controller: stateTextEditingController,
                            labelText: 'State',
                            readOnly: true,
                            onTap: () {
                              // weeklyPlanProvider.setStateList();
                              _AddTaskBottomSheetForStates(context);
                            },
                            onChange: (value) => () {},
                            validator: (Value) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
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
                          controller: cityTextEditingController,
                          labelText: 'City',
                          readOnly: true,
                          onTap: () {
                            // weeklyPlanProvider.setStateList();
                            _AddTaskBottomSheetForCities(context);
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
      ),
    );
  }
  //----------------------------------------------------------------Bottom Sheets----------------------------------------------------------------//

  Future<void> _AddTaskBottomSheetForDistrict(context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to take up more space
      builder: (context) => ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.90,
          child: Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: _AddTaskBottomSheetForDistrictAppBar(context),
            body: _AddTaskBottomSheetForDistrictBody(context),
          ),
        ),
      ),
    );
  }

  PreferredSize _AddTaskBottomSheetForDistrictAppBar(context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          showLeading: true,
          leadingIcon: FontAwesomeIcons.arrowLeft,
          backgroundColor: CustomColors.primaryColor,
          tabName: 'Select District',
          onTapLeadingIcon: () {
            Navigator.pop(context);
          },
        ));
  }

  Widget _AddTaskBottomSheetForDistrictBody(context) {
    return ListView(
      children: [
        SizedBox(
          height: 16,
        ),
        Container(
          child: ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: districtList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: CustomText(
                    text: districtList[index]['district'],
                  ),
                  onTap: () {
                    selectedDistrict = districtList[index]['district'];
                    citiesList = districtList[index]['cities'];
                    districtTextEditingController.text = selectedDistrict;
                    Navigator.pop(context);
                  },
                );
              }),
        ),
      ],
    );
  }

  //--------------------------------------------------------------------------------------------------------------------------------//
  Future<void> _AddTaskBottomSheetForStates(context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to take up more space
      builder: (context) => ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.90,
          child: Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: _AddTaskBottomSheetForStatesAppBar(context),
            body: _AddTaskBottomSheetForStatesBody(context),
          ),
        ),
      ),
    );
  }

  PreferredSize _AddTaskBottomSheetForStatesAppBar(context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          showLeading: true,
          leadingIcon: FontAwesomeIcons.arrowLeft,
          backgroundColor: CustomColors.primaryColor,
          tabName: 'Select State',
          onTapLeadingIcon: () {
            Navigator.pop(context);
          },
        ));
  }

  Widget _AddTaskBottomSheetForStatesBody(context) {
    return ListView(
      children: [
        SizedBox(
          height: 16,
        ),
        Container(
          child: ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: stateList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: CustomText(
                    text: stateList[index]['states'],
                  ),
                  onTap: () {
                    // print(districtList);
                    selectedState = stateList[index]['states'];
                    stateTextEditingController.text = selectedState;
                    Navigator.pop(context);
                  },
                );
              }),
        ),
      ],
    );
  }
  //--------------------------------------------------------------------------------------------------------------------------------//

  Future<void> _AddTaskBottomSheetForCities(context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to take up more space
      builder: (context) => ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.90,
          child: Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: _AddTaskBottomSheetForCitiesAppBar(context),
            body: _AddTaskBottomSheetForCitiesBody(context),
          ),
        ),
      ),
    );
  }

  PreferredSize _AddTaskBottomSheetForCitiesAppBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(
        showLeading: true,
        leadingIcon: FontAwesomeIcons.arrowLeft,
        backgroundColor: CustomColors.primaryColor,
        tabName: 'Select Cities',
        onTapLeadingIcon: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _AddTaskBottomSheetForCitiesBody(context) {
    return ListView(
      children: [
        SizedBox(
          height: 16,
        ),
        Container(
          child: ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: citiesList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: CustomText(
                    text: citiesList[index].toString(),
                  ),
                  onTap: () {
                    // print(districtList);
                    selectedCity = citiesList[index];
                    cityTextEditingController.text = selectedCity;
                    Navigator.pop(context);
                  },
                );
              }),
        ),
      ],
    );
  }
}
